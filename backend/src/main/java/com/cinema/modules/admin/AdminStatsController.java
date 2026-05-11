package com.cinema.modules.admin;

import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/stats")
public class AdminStatsController {
    private final NamedParameterJdbcTemplate jdbc;

    public AdminStatsController(NamedParameterJdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/revenue")
    public Map<String, Object> revenue(
            @RequestParam(defaultValue = "day") String period,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to,
            @RequestParam(required = false) Long cinemaId
    ) {
        LocalDate start = from != null && !from.isBlank() ? LocalDate.parse(from) : LocalDate.now().minusDays(30);
        LocalDate end = to != null && !to.isBlank() ? LocalDate.parse(to) : LocalDate.now();

        String groupExpr = switch (period) {
            case "month" -> "DATE_FORMAT(i.created_datetime, '%Y-%m')";
            case "week" -> "DATE_FORMAT(i.created_datetime, '%x-W%v')";
            default -> "DATE(i.created_datetime)";
        };

        if (cinemaId == null) {
            return revenueFromDateView(period, start, end);
        }

        String cinemaFilter = cinemaId != null ? " AND c.cinemas_id = :cinemaId " : "";

        String sql = """
            SELECT %s AS label, COALESCE(SUM(i.total_price), 0) AS revenue
            FROM invoice i
            JOIN booking_seat bs ON bs.invoice_id = i.invoice_id
            JOIN showtime s ON s.showtime_id = bs.showtime_id
            JOIN room r ON r.room_id = s.room_id
            JOIN cinemas c ON c.cinemas_id = r.cinemas_id
            WHERE i.invoice_status = 'PAID'
              AND DATE(i.created_datetime) BETWEEN :fromDate AND :toDate
              %s
            GROUP BY label
            ORDER BY label
            """.formatted(groupExpr, cinemaFilter);

        MapSqlParameterSource params = baseParams(start, end, cinemaId);
        List<Map<String, Object>> chart = jdbc.queryForList(sql, params);

        BigDecimal total = chart.stream()
                .map(row -> toBigDecimal(row.get("revenue")))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long days = Math.max(1, java.time.temporal.ChronoUnit.DAYS.between(start, end) + 1);
        BigDecimal avgPerDay = total.divide(BigDecimal.valueOf(days), 0, RoundingMode.HALF_UP);

        Map<String, Object> maxDay = chart.stream()
                .max((a, b) -> toBigDecimal(a.get("revenue")).compareTo(toBigDecimal(b.get("revenue"))))
                .map(row -> Map.of("date", row.get("label"), "revenue", row.get("revenue")))
                .orElse(Map.of("date", "", "revenue", 0));

        return Map.of(
                "chart", chart,
                "total", total,
                "avgPerDay", avgPerDay,
                "maxDay", maxDay,
                "delta", 0
        );
    }

    @GetMapping("/revenue/by-cinema")
    public List<Map<String, Object>> revenueByCinema() {
        return jdbc.queryForList("""
            SELECT cinemas_id AS cinemaId,
                   cinema_name AS cinemaName,
                   province_name AS provinceName,
                   total_invoices AS totalInvoices,
                   total_tickets_sold AS totalTicketsSold,
                   total_revenue AS totalRevenue,
                   avg_invoice_value AS avgInvoiceValue
            FROM v_revenue_by_cinema
            ORDER BY total_revenue DESC, total_tickets_sold DESC
            """, new MapSqlParameterSource());
    }

    @GetMapping("/revenue/by-movie")
    public List<Map<String, Object>> revenueByMovie(@RequestParam(defaultValue = "20") int limit) {
        return jdbc.queryForList("""
            SELECT movie_id AS movieId,
                   title,
                   release_date AS releaseDate,
                   director_name AS directorName,
                   total_showtimes AS totalShowtimes,
                   total_tickets_sold AS totalTicketsSold,
                   total_revenue AS totalRevenue,
                   avg_rating AS avgRating
            FROM v_revenue_by_movie
            ORDER BY total_revenue DESC, total_tickets_sold DESC
            LIMIT :limit
            """, new MapSqlParameterSource("limit", limit));
    }

    @GetMapping("/revenue/by-date")
    public List<Map<String, Object>> revenueByDate(
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to
    ) {
        LocalDate start = from != null && !from.isBlank() ? LocalDate.parse(from) : LocalDate.now().minusDays(30);
        LocalDate end = to != null && !to.isBlank() ? LocalDate.parse(to) : LocalDate.now();

        return jdbc.queryForList("""
            SELECT report_date AS reportDate,
                   total_invoices AS totalInvoices,
                   total_tickets_sold AS totalTicketsSold,
                   total_revenue AS totalRevenue,
                   revenue_momo AS revenueMomo,
                   revenue_vnpay AS revenueVnpay,
                   revenue_zalopay AS revenueZalopay,
                   revenue_cash AS revenueCash
            FROM v_revenue_by_date
            WHERE report_date BETWEEN :fromDate AND :toDate
            ORDER BY report_date DESC
            """, baseParams(start, end, null));
    }

    @GetMapping("/tickets")
    public Map<String, Object> tickets(
            @RequestParam(defaultValue = "day") String period,
            @RequestParam(required = false) Long cinemaId
    ) {
        String groupExpr = switch (period) {
            case "month" -> "DATE_FORMAT(i.created_datetime, '%Y-%m')";
            case "week" -> "DATE_FORMAT(i.created_datetime, '%x-W%v')";
            default -> "DATE(i.created_datetime)";
        };

        String cinemaFilter = cinemaId != null ? " AND c.cinemas_id = :cinemaId " : "";
        MapSqlParameterSource params = new MapSqlParameterSource();
        if (cinemaId != null) params.addValue("cinemaId", cinemaId);

        List<Map<String, Object>> chart = jdbc.queryForList("""
            SELECT %s AS label, COUNT(bs.booking_seat_id) AS tickets
            FROM booking_seat bs
            JOIN invoice i ON i.invoice_id = bs.invoice_id
            JOIN showtime s ON s.showtime_id = bs.showtime_id
            JOIN room r ON r.room_id = s.room_id
            JOIN cinemas c ON c.cinemas_id = r.cinemas_id
            WHERE i.invoice_status = 'PAID'
            %s
            GROUP BY label
            ORDER BY label
            """.formatted(groupExpr, cinemaFilter), params);

        List<Map<String, Object>> byShowtime = jdbc.queryForList("""
            SELECT s.showtime_id AS showtimeId,
                   CONCAT(s.start_time, ' - ', s.end_time) AS showtimeLabel,
                   m.title AS movieTitle,
                   s.show_date AS date,
                   COUNT(bs.booking_seat_id) AS ticketsSold,
                   ROUND(COUNT(bs.booking_seat_id) * 100 / NULLIF((SELECT COUNT(*) FROM seat se WHERE se.room_id = r.room_id), 0), 0) AS fillRate
            FROM showtime s
            JOIN movie m ON m.movie_id = s.movie_id
            JOIN room r ON r.room_id = s.room_id
            JOIN cinemas c ON c.cinemas_id = r.cinemas_id
            LEFT JOIN booking_seat bs ON bs.showtime_id = s.showtime_id
            LEFT JOIN invoice i ON i.invoice_id = bs.invoice_id AND i.invoice_status = 'PAID'
            WHERE 1 = 1
            %s
            GROUP BY s.showtime_id, s.start_time, s.end_time, m.title, s.show_date, r.room_id
            ORDER BY s.show_date DESC, s.start_time DESC
            LIMIT 50
            """.formatted(cinemaFilter), params);

        Number total = jdbc.queryForObject("""
            SELECT COUNT(bs.booking_seat_id)
            FROM booking_seat bs
            JOIN invoice i ON i.invoice_id = bs.invoice_id
            JOIN showtime s ON s.showtime_id = bs.showtime_id
            JOIN room r ON r.room_id = s.room_id
            JOIN cinemas c ON c.cinemas_id = r.cinemas_id
            WHERE i.invoice_status = 'PAID'
            %s
            """.formatted(cinemaFilter), params, Number.class);

        return Map.of(
                "chart", chart,
                "total", total == null ? 0 : total,
                "avgFillRate", avgNumber(byShowtime, "fillRate"),
                "fullShowtimes", byShowtime.stream().filter(r -> toBigDecimal(r.get("fillRate")).compareTo(BigDecimal.valueOf(90)) >= 0).count(),
                "byShowtime", byShowtime,
                "byType", List.of()
        );
    }

    @GetMapping("/top-movies")
    public List<Map<String, Object>> topMovies(@RequestParam(defaultValue = "20") int limit) {
        MapSqlParameterSource params = new MapSqlParameterSource("limit", limit);

        return jdbc.queryForList("""
            SELECT v.movie_id AS movieId,
                   v.title,
                   m.poster_link AS posterLink,
                   v.director_name AS directorName,
                   v.total_tickets_sold AS ticketsSold,
                   v.total_revenue AS revenue
            FROM v_revenue_by_movie v
            JOIN movie m ON m.movie_id = v.movie_id
            ORDER BY revenue DESC, ticketsSold DESC
            LIMIT :limit
            """, params);
    }

    @GetMapping("/customers")
    public Map<String, Object> customers() {
        Number totalUsers = jdbc.queryForObject(
                "SELECT COUNT(*) FROM user WHERE role = 'customer'",
                new MapSqlParameterSource(),
                Number.class
        );

        Number returningUsers = jdbc.queryForObject("""
            SELECT COUNT(*) FROM (
                SELECT user_id
                FROM invoice
                WHERE invoice_status = 'PAID'
                GROUP BY user_id
                HAVING COUNT(*) >= 2
            ) x
            """, new MapSqlParameterSource(), Number.class);

        List<Map<String, Object>> activityByHour = jdbc.queryForList("""
            SELECT HOUR(created_datetime) AS hour, COUNT(*) AS bookings
            FROM invoice
            WHERE invoice_status = 'PAID'
            GROUP BY HOUR(created_datetime)
            ORDER BY hour
            """, new MapSqlParameterSource());

        double returningRate = totalUsers != null && totalUsers.longValue() > 0
                ? Math.round(returningUsers.doubleValue() * 100.0 / totalUsers.doubleValue())
                : 0;

        return Map.of(
                "totalUsers", totalUsers == null ? 0 : totalUsers,
                "newUsersMonth", 0,
                "returningRate", returningRate,
                "registrationChart", List.of(),
                "activityByHour", activityByHour
        );
    }

    private MapSqlParameterSource baseParams(LocalDate from, LocalDate to, Long cinemaId) {
        MapSqlParameterSource params = new MapSqlParameterSource();
        params.addValue("fromDate", from);
        params.addValue("toDate", to);
        if (cinemaId != null) params.addValue("cinemaId", cinemaId);
        return params;
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) return BigDecimal.ZERO;
        if (value instanceof BigDecimal bd) return bd;
        if (value instanceof Number n) return BigDecimal.valueOf(n.doubleValue());
        return new BigDecimal(value.toString());
    }

    private int avgNumber(List<Map<String, Object>> rows, String key) {
        if (rows.isEmpty()) return 0;
        BigDecimal total = rows.stream()
                .map(row -> toBigDecimal(row.get(key)))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        return total.divide(BigDecimal.valueOf(rows.size()), 0, RoundingMode.HALF_UP).intValue();
    }

    @GetMapping("/overview")
    public Map<String, Object> overview() {
        LocalDate today = LocalDate.now();
        LocalDate currentMonthStart = today.withDayOfMonth(1);
        LocalDate previousMonthStart = currentMonthStart.minusMonths(1);
        LocalDate previousMonthEnd = currentMonthStart.minusDays(1);
        LocalDate chartStart = today.minusDays(6);

        BigDecimal totalRevenue = jdbc.queryForObject("""
            SELECT COALESCE(SUM(total_price), 0)
            FROM invoice
            WHERE invoice_status = 'PAID'
              AND DATE(created_datetime) BETWEEN :fromDate AND :toDate
            """, baseParams(currentMonthStart, today, null), BigDecimal.class);

        BigDecimal previousRevenue = jdbc.queryForObject("""
            SELECT COALESCE(SUM(total_price), 0)
            FROM invoice
            WHERE invoice_status = 'PAID'
              AND DATE(created_datetime) BETWEEN :fromDate AND :toDate
            """, baseParams(previousMonthStart, previousMonthEnd, null), BigDecimal.class);

        Number totalTickets = jdbc.queryForObject("""
            SELECT COUNT(*)
            FROM booking_seat bs
            JOIN invoice i ON i.invoice_id = bs.invoice_id
            WHERE i.invoice_status = 'PAID'
              AND DATE(i.created_datetime) BETWEEN :fromDate AND :toDate
            """, baseParams(currentMonthStart, today, null), Number.class);

        Number previousTickets = jdbc.queryForObject("""
            SELECT COUNT(*)
            FROM booking_seat bs
            JOIN invoice i ON i.invoice_id = bs.invoice_id
            WHERE i.invoice_status = 'PAID'
              AND DATE(i.created_datetime) BETWEEN :fromDate AND :toDate
            """, baseParams(previousMonthStart, previousMonthEnd, null), Number.class);

        Number totalMovies = jdbc.queryForObject(
            "SELECT COUNT(*) FROM movie",
            new MapSqlParameterSource(),
            Number.class
        );

        Number totalUsers = jdbc.queryForObject(
            "SELECT COUNT(*) FROM user",
            new MapSqlParameterSource(),
            Number.class
        );

        Number previousTotalUsers = jdbc.queryForObject("""
            SELECT COUNT(*)
            FROM user
            WHERE created_at < :fromDate
            """, new MapSqlParameterSource("fromDate", currentMonthStart), Number.class);

        List<Map<String, Object>> revenueChart = jdbc.queryForList("""
            WITH RECURSIVE days AS (
                SELECT :fromDate AS report_date
                UNION ALL
                SELECT DATE_ADD(report_date, INTERVAL 1 DAY)
                FROM days
                WHERE report_date < :toDate
            )
            SELECT days.report_date AS date,
                   COALESCE(v.total_revenue, 0) AS revenue
            FROM days
            LEFT JOIN v_revenue_by_date v ON v.report_date = days.report_date
            ORDER BY days.report_date
            """, baseParams(chartStart, today, null));

        List<Map<String, Object>> ticketChart = jdbc.queryForList("""
            WITH RECURSIVE days AS (
                SELECT :fromDate AS report_date
                UNION ALL
                SELECT DATE_ADD(report_date, INTERVAL 1 DAY)
                FROM days
                WHERE report_date < :toDate
            )
            SELECT days.report_date AS date,
                   COALESCE(v.total_tickets_sold, 0) AS tickets
            FROM days
            LEFT JOIN v_revenue_by_date v ON v.report_date = days.report_date
            ORDER BY days.report_date
            """, baseParams(chartStart, today, null));

        return Map.of(
            "totalRevenue", totalRevenue == null ? 0 : totalRevenue,
            "revenueDelta", percentChange(totalRevenue, previousRevenue),
            "totalTickets", totalTickets == null ? 0 : totalTickets,
            "ticketDelta", percentChange(totalTickets, previousTickets),
            "totalMovies", totalMovies == null ? 0 : totalMovies,
            "totalUsers", totalUsers == null ? 0 : totalUsers,
            "userDelta", percentChange(totalUsers, previousTotalUsers),
            "revenueChart", revenueChart,
            "ticketChart", ticketChart
        );
    }

    private int percentChange(Object currentValue, Object previousValue) {
        BigDecimal current = toBigDecimal(currentValue);
        BigDecimal previous = toBigDecimal(previousValue);
        if (previous.compareTo(BigDecimal.ZERO) == 0) {
            return current.compareTo(BigDecimal.ZERO) > 0 ? 100 : 0;
        }
        return current.subtract(previous)
                .multiply(BigDecimal.valueOf(100))
                .divide(previous, 0, RoundingMode.HALF_UP)
                .intValue();
    }

    private Map<String, Object> revenueFromDateView(String period, LocalDate start, LocalDate end) {
        String groupExpr = switch (period) {
            case "month" -> "DATE_FORMAT(report_date, '%Y-%m')";
            case "week" -> "DATE_FORMAT(report_date, '%x-W%v')";
            default -> "report_date";
        };

        List<Map<String, Object>> chart = jdbc.queryForList("""
            SELECT %s AS label, COALESCE(SUM(total_revenue), 0) AS revenue
            FROM v_revenue_by_date
            WHERE report_date BETWEEN :fromDate AND :toDate
            GROUP BY label
            ORDER BY label
            """.formatted(groupExpr), baseParams(start, end, null));

        BigDecimal total = chart.stream()
                .map(row -> toBigDecimal(row.get("revenue")))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long days = Math.max(1, java.time.temporal.ChronoUnit.DAYS.between(start, end) + 1);
        BigDecimal avgPerDay = total.divide(BigDecimal.valueOf(days), 0, RoundingMode.HALF_UP);

        Map<String, Object> maxDay = chart.stream()
                .max((a, b) -> toBigDecimal(a.get("revenue")).compareTo(toBigDecimal(b.get("revenue"))))
                .map(row -> Map.of("date", row.get("label"), "revenue", row.get("revenue")))
                .orElse(Map.of("date", "", "revenue", 0));

        return Map.of(
                "chart", chart,
                "total", total,
                "avgPerDay", avgPerDay,
                "maxDay", maxDay,
                "delta", 0
        );
    }


}
