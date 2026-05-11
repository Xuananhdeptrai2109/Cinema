-- Seed du lieu mau cho man hinh Bao cao & Thong ke.
-- Chay file nay sau Dump20260428.sql va db_showtime_revenue_update.sql.
-- Du lieu duoc trai trong 30 ngay gan ngay 2026-05-11 de khop bo loc mac dinh tren admin.

SET @stats_user_id := (SELECT user_id FROM `user` ORDER BY user_id LIMIT 1);

DROP TEMPORARY TABLE IF EXISTS stats_seed_showtimes;
CREATE TEMPORARY TABLE stats_seed_showtimes AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ranked.cinema_rank, ranked.cinemas_id, ranked.showtime_id) AS rn,
    ranked.showtime_id
FROM (
    SELECT
        st.showtime_id,
        c.cinemas_id,
        ROW_NUMBER() OVER (PARTITION BY c.cinemas_id ORDER BY st.showtime_id) AS cinema_rank
    FROM showtime st
    JOIN room r ON r.room_id = st.room_id
    JOIN cinemas c ON c.cinemas_id = r.cinemas_id
    JOIN showtime_seat ss ON ss.showtime_id = st.showtime_id
    GROUP BY st.showtime_id, c.cinemas_id
    HAVING COUNT(ss.showtime_seat_id) >= 85
) ranked
WHERE ranked.cinema_rank <= 2
ORDER BY ranked.cinema_rank, ranked.cinemas_id, ranked.showtime_id
LIMIT 18;

DROP TEMPORARY TABLE IF EXISTS stats_seed_numbers;
CREATE TEMPORARY TABLE stats_seed_numbers (n INT PRIMARY KEY);
INSERT INTO stats_seed_numbers (n) VALUES (1),(2),(3),(4),(5);

DROP TEMPORARY TABLE IF EXISTS stats_seed_seats;
CREATE TEMPORARY TABLE stats_seed_seats AS
SELECT
    ss.showtime_id,
    ss.showtime_seat_id,
    ROW_NUMBER() OVER (PARTITION BY ss.showtime_id ORDER BY ss.showtime_seat_id) AS seat_rank
FROM showtime_seat ss
JOIN stats_seed_showtimes s ON s.showtime_id = ss.showtime_id;

DROP TEMPORARY TABLE IF EXISTS stats_seed_orders;
CREATE TEMPORARY TABLE stats_seed_orders (
    invoice_uuid CHAR(36) PRIMARY KEY,
    ticket_code VARCHAR(20) NOT NULL,
    days_ago INT NOT NULL,
    payment_method ENUM('momo','vnpay','zalopay','cash') NOT NULL,
    showtime_rank INT NOT NULL,
    seat_offset INT NOT NULL,
    ticket_count INT NOT NULL,
    price_per_ticket DECIMAL(10,2) NOT NULL
);

INSERT INTO stats_seed_orders
    (invoice_uuid, ticket_code, days_ago, payment_method, showtime_rank, seat_offset, ticket_count, price_per_ticket)
VALUES
    ('11111111-1111-4111-8111-111111111111', 'STATS001', 29, 'cash',   1,  0, 2,  90000.00),
    ('11111111-1111-4111-8111-111111111112', 'STATS002', 27, 'vnpay',  2,  3, 3,  95000.00),
    ('11111111-1111-4111-8111-111111111113', 'STATS003', 25, 'momo',   3,  7, 2, 110000.00),
    ('11111111-1111-4111-8111-111111111114', 'STATS004', 23, 'cash',   4, 10, 4,  85000.00),
    ('11111111-1111-4111-8111-111111111115', 'STATS005', 21, 'vnpay',  5, 15, 3, 120000.00),
    ('11111111-1111-4111-8111-111111111116', 'STATS006', 19, 'cash',   6, 20, 5,  90000.00),
    ('11111111-1111-4111-8111-111111111117', 'STATS007', 17, 'zalopay',7, 25, 2, 105000.00),
    ('11111111-1111-4111-8111-111111111118', 'STATS008', 15, 'vnpay',  8, 30, 4, 100000.00),
    ('11111111-1111-4111-8111-111111111119', 'STATS009', 13, 'cash',   9, 35, 3,  95000.00),
    ('11111111-1111-4111-8111-111111111120', 'STATS010', 11, 'momo',  10, 40, 5, 110000.00),
    ('11111111-1111-4111-8111-111111111121', 'STATS011',  9, 'vnpay', 11, 45, 2, 125000.00),
    ('11111111-1111-4111-8111-111111111122', 'STATS012',  7, 'cash',  12, 50, 4,  90000.00),
    ('11111111-1111-4111-8111-111111111123', 'STATS013',  5, 'vnpay', 13, 55, 5, 100000.00),
    ('11111111-1111-4111-8111-111111111124', 'STATS014',  4, 'momo',  14, 60, 3, 115000.00),
    ('11111111-1111-4111-8111-111111111125', 'STATS015',  3, 'cash',  15, 65, 4, 105000.00),
    ('11111111-1111-4111-8111-111111111126', 'STATS016',  2, 'vnpay', 16, 70, 5, 120000.00),
    ('11111111-1111-4111-8111-111111111127', 'STATS017',  1, 'cash',  17, 75, 3,  95000.00),
    ('11111111-1111-4111-8111-111111111128', 'STATS018',  0, 'vnpay', 18, 80, 4, 130000.00);

INSERT INTO invoice
    (invoice_id, ticket_code, user_id, total_price, invoice_status, payment_method, transaction_id, email_address, created_datetime)
SELECT
    UUID_TO_BIN(o.invoice_uuid),
    o.ticket_code,
    @stats_user_id,
    o.ticket_count * o.price_per_ticket,
    'PAID',
    o.payment_method,
    CONCAT('STATS-DEMO-', o.ticket_code),
    'stats-demo@example.com',
    TIMESTAMP(DATE_SUB('2026-05-11', INTERVAL o.days_ago DAY), '10:30:00')
FROM stats_seed_orders o
WHERE @stats_user_id IS NOT NULL
ON DUPLICATE KEY UPDATE
    total_price = VALUES(total_price),
    invoice_status = VALUES(invoice_status),
    payment_method = VALUES(payment_method),
    created_datetime = VALUES(created_datetime);

INSERT INTO booking_seat
    (invoice_id, showtime_id, showtime_seat_id, discount_id, price_at_booking)
SELECT
    UUID_TO_BIN(o.invoice_uuid),
    s.showtime_id,
    ss.showtime_seat_id,
    NULL,
    o.price_per_ticket
FROM stats_seed_orders o
JOIN stats_seed_showtimes s ON s.rn = o.showtime_rank
JOIN stats_seed_numbers n ON n.n <= o.ticket_count
JOIN stats_seed_seats ss
    ON ss.showtime_id = s.showtime_id
   AND ss.seat_rank = o.seat_offset + n.n
WHERE @stats_user_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM booking_seat bs
      WHERE bs.invoice_id = UUID_TO_BIN(o.invoice_uuid)
        AND bs.showtime_seat_id = ss.showtime_seat_id
  );

UPDATE showtime_seat ss
JOIN booking_seat bs ON bs.showtime_seat_id = ss.showtime_seat_id
JOIN stats_seed_orders o ON bs.invoice_id = UUID_TO_BIN(o.invoice_uuid)
SET ss.status_id = 3,
    ss.user_id = @stats_user_id,
    ss.hold_expired_at = NULL
WHERE @stats_user_id IS NOT NULL;

DROP TEMPORARY TABLE IF EXISTS stats_seed_orders;
DROP TEMPORARY TABLE IF EXISTS stats_seed_seats;
DROP TEMPORARY TABLE IF EXISTS stats_seed_numbers;
DROP TEMPORARY TABLE IF EXISTS stats_seed_showtimes;
