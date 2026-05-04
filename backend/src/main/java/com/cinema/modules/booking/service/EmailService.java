package com.cinema.modules.booking.service;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.cinema.entity.Cinema;
import com.cinema.modules.movie.entity.Movie;
import com.cinema.modules.room.entity.Room;
import com.cinema.modules.showtime.entity.Showtime;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.stream.Collectors;

@Service
public class EmailService {
    @Autowired private JavaMailSender mailSender;

    public void sendTicketEmail(Invoice invoice) {
        try {
            // 1. Thu thập dữ liệu suất chiếu từ ghế đầu tiên
            var firstSeat = invoice.getBookingSeats().get(0).getShowtimeSeat();
            var showtime = firstSeat.getShowtime();
            var movie = showtime.getMovie();
            var room = showtime.getRoom();
            var cinema = room.getCinema();

            // 2. Định dạng danh sách ghế (D1, D2...)
            String seatsLabel = invoice.getBookingSeats().stream()
                    .map(bs -> bs.getShowtimeSeat().getSeat().getRowName() + bs.getShowtimeSeat().getSeat().getSeatNumber())
                    .collect(Collectors.joining(", "));

            // 3. Định dạng danh sách đồ ăn
            String productsLabel = invoice.getBookingProducts().stream()
                    .map(bp -> bp.getProduct().getProductName() + " (x" + bp.getProductQuantity() + ")")
                    .collect(Collectors.joining(", "));
            if (productsLabel.isEmpty()) productsLabel = "Không có";

            // 4. Định dạng thời gian
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

            // 5. Xây dựng nội dung HTML (Inline CSS để hiển thị tốt trên Mail)
            String htmlContent = buildHtmlTemplate(invoice, movie, cinema, room, showtime, seatsLabel, productsLabel, dateFormatter, timeFormatter);

            // 6. Gửi Mail
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setTo(invoice.getEmailAddress());
            helper.setSubject("Vé xem phim của bạn - " + movie.getTitle());
            helper.setText(htmlContent, true);
            mailSender.send(message);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private String buildHtmlTemplate(Invoice inv, Movie m, Cinema c, Room r, Showtime st, String seats, String foods, DateTimeFormatter dFmt, DateTimeFormatter tFmt) {
        return "<div style='font-family: Arial, sans-serif; background-color: #1a1a1a; color: #ffffff; padding: 20px;'>" +
                "<h2>Xin chào " + inv.getUser().getFullName() + " / Hello " + inv.getUser().getFullName() + "</h2>" +
        "<hr style='border: 0.5px solid #333;'>" +
                "<table style='width: 100%; color: #ffffff; line-height: 2;'>" +
                "<tr><td>Mã vé (Reservation code):</td><td style='text-align: right; font-weight: bold;'>" + inv.getTicketCode() + "</td></tr>" +
        "<tr><td>Phim (Movie):</td><td style='text-align: right; font-weight: bold;'>" + m.getTitle() + "</td></tr>" +
                "<tr><td>Rạp (Theater):</td><td style='text-align: right; font-weight: bold;'>" + c.getCinemaName() + "</td></tr>" +
                "<tr><td>Phòng chiếu (Hall):</td><td style='text-align: right; font-weight: bold;'>" + r.getRoomName() + "</td></tr>" +
                "<tr><td>Thời gian (Session):</td><td style='text-align: right; font-weight: bold;'>" + st.getShowDate().format(dFmt) + " " + st.getStartTime().format(tFmt) + "</td></tr>" +
                "<tr><td>Ghế (Seat):</td><td style='text-align: right; font-weight: bold;'>" + seats + "</td></tr>" +
                "<tr><td>Đồ ăn (Food):</td><td style='text-align: right; font-weight: bold;'>" + foods + "</td></tr>" +
                "<tr><td>Phương thức thanh toán:</td><td style='text-align: right;'>" + inv.getPaymentMethod() + "</td></tr>" +
        "<tr><td>Thời gian thanh toán:</td><td style='text-align: right;'>" + inv.getPaidAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) + "</td></tr>" +
        "<tr><td style='font-size: 1.2em;'>Tổng tiền (Total):</td><td style='text-align: right; font-size: 1.2em; font-weight: bold;'>" + inv.getFinalPrice() + " VND</td></tr>" +
        "</table>" +
                "<div style='text-align: center; margin-top: 20px; background: white; padding: 10px;'>" +
                "   <img src='https://barcodeapi.org/api/128/" + inv.getTicketCode() + "' alt='Barcode' style='width: 80%;'>" +
                "   <p style='color: black; margin: 5px 0 0 0;'>" + inv.getTicketCode() + "</p>" +
                "</div>" +
                "<p style='font-size: 0.8em; margin-top: 20px; color: #888;'>Lưu ý: Vé đã mua không thể hủy, đổi hoặc trả lại. Chúc bạn xem phim vui vẻ!</p>" +
                "</div>";
    }
}
