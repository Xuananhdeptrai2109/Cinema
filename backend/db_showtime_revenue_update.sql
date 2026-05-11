USE cinemafinal;

DROP VIEW IF EXISTS v_revenue_by_cinema;
CREATE VIEW v_revenue_by_cinema AS
SELECT
    c.cinemas_id,
    c.cinema_name,
    p.province_name,
    COUNT(revenue.invoice_id) AS total_invoices,
    COALESCE(SUM(revenue.ticket_count), 0) AS total_tickets_sold,
    COALESCE(SUM(revenue.total_price), 0) AS total_revenue,
    COALESCE(AVG(revenue.total_price), 0) AS avg_invoice_value
FROM cinemas c
LEFT JOIN province_city p ON p.province_id = c.province_id
LEFT JOIN (
    SELECT
        r.cinemas_id,
        i.invoice_id,
        i.total_price,
        COUNT(bs.booking_seat_id) AS ticket_count
    FROM invoice i
    JOIN booking_seat bs ON bs.invoice_id = i.invoice_id
    JOIN showtime st ON st.showtime_id = bs.showtime_id
    JOIN room r ON r.room_id = st.room_id
    WHERE i.invoice_status = 'PAID'
    GROUP BY r.cinemas_id, i.invoice_id, i.total_price
) revenue ON revenue.cinemas_id = c.cinemas_id
GROUP BY c.cinemas_id, c.cinema_name, p.province_name;

DROP VIEW IF EXISTS v_revenue_by_movie;
CREATE VIEW v_revenue_by_movie AS
SELECT
    m.movie_id,
    m.title,
    m.release_date,
    d.director_name,
    COUNT(DISTINCT st.showtime_id) AS total_showtimes,
    COUNT(CASE WHEN i.invoice_status = 'PAID' THEN bs.booking_seat_id END) AS total_tickets_sold,
    COALESCE(SUM(CASE WHEN i.invoice_status = 'PAID' THEN bs.price_at_booking ELSE 0 END), 0) AS total_revenue,
    m.star AS avg_rating
FROM movie m
LEFT JOIN director d ON d.director_id = m.director_id
LEFT JOIN showtime st ON st.movie_id = m.movie_id
LEFT JOIN booking_seat bs ON bs.showtime_id = st.showtime_id
LEFT JOIN invoice i ON i.invoice_id = bs.invoice_id
GROUP BY m.movie_id, m.title, m.release_date, d.director_name, m.star;

DROP VIEW IF EXISTS v_revenue_by_date;
CREATE VIEW v_revenue_by_date AS
SELECT
    paid_invoice.report_date,
    COUNT(paid_invoice.invoice_id) AS total_invoices,
    COALESCE(SUM(paid_invoice.ticket_count), 0) AS total_tickets_sold,
    COALESCE(SUM(paid_invoice.total_price), 0) AS total_revenue,
    COALESCE(SUM(CASE WHEN paid_invoice.payment_method = 'momo' THEN paid_invoice.total_price ELSE 0 END), 0) AS revenue_momo,
    COALESCE(SUM(CASE WHEN paid_invoice.payment_method = 'vnpay' THEN paid_invoice.total_price ELSE 0 END), 0) AS revenue_vnpay,
    COALESCE(SUM(CASE WHEN paid_invoice.payment_method = 'zalopay' THEN paid_invoice.total_price ELSE 0 END), 0) AS revenue_zalopay,
    COALESCE(SUM(CASE WHEN paid_invoice.payment_method = 'cash' THEN paid_invoice.total_price ELSE 0 END), 0) AS revenue_cash
FROM (
    SELECT
        DATE(i.created_datetime) AS report_date,
        i.invoice_id,
        i.total_price,
        i.payment_method,
        COUNT(bs.booking_seat_id) AS ticket_count
    FROM invoice i
    LEFT JOIN booking_seat bs ON bs.invoice_id = i.invoice_id
    WHERE i.invoice_status = 'PAID'
    GROUP BY DATE(i.created_datetime), i.invoice_id, i.total_price, i.payment_method
) paid_invoice
GROUP BY paid_invoice.report_date;

DROP TRIGGER IF EXISTS trg_showtime_no_past_insert;
DROP TRIGGER IF EXISTS trg_showtime_no_past_update;

DELIMITER //

CREATE TRIGGER trg_showtime_no_past_insert
BEFORE INSERT ON showtime
FOR EACH ROW
BEGIN
    IF TIMESTAMP(NEW.show_date, NEW.start_time) < NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Khong the tao suat chieu trong qua khu';
    END IF;
END//

CREATE TRIGGER trg_showtime_no_past_update
BEFORE UPDATE ON showtime
FOR EACH ROW
BEGIN
    IF TIMESTAMP(NEW.show_date, NEW.start_time) < NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Khong the cap nhat suat chieu ve qua khu';
    END IF;
END//

DROP PROCEDURE IF EXISTS sp_create_showtime//
CREATE PROCEDURE sp_create_showtime(
    IN p_movie_id INT UNSIGNED,
    IN p_room_id INT UNSIGNED,
    IN p_show_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME
)
BEGIN
    DECLARE v_showtime_id INT UNSIGNED;

    INSERT INTO showtime (movie_id, room_id, show_date, start_time, end_time)
    VALUES (p_movie_id, p_room_id, p_show_date, p_start_time, p_end_time);

    SET v_showtime_id = LAST_INSERT_ID();

    INSERT INTO showtime_seat (status_id, seat_id, showtime_id, user_id, hold_expired_at)
    SELECT 1, s.seat_id, v_showtime_id, NULL, NULL
    FROM seat s
    WHERE s.room_id = p_room_id;

    SELECT v_showtime_id AS showtime_id;
END//

DROP PROCEDURE IF EXISTS sp_update_showtime//
CREATE PROCEDURE sp_update_showtime(
    IN p_showtime_id INT UNSIGNED,
    IN p_movie_id INT UNSIGNED,
    IN p_room_id INT UNSIGNED,
    IN p_show_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME
)
BEGIN
    DECLARE v_old_room_id INT UNSIGNED;
    DECLARE v_booking_count INT DEFAULT 0;

    SELECT room_id INTO v_old_room_id
    FROM showtime
    WHERE showtime_id = p_showtime_id;

    IF v_old_room_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Suat chieu khong ton tai';
    END IF;

    SELECT COUNT(*) INTO v_booking_count
    FROM booking_seat
    WHERE showtime_id = p_showtime_id;

    IF v_booking_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong the cap nhat suat chieu da co ve dat';
    END IF;

    UPDATE showtime
    SET movie_id = p_movie_id,
        room_id = p_room_id,
        show_date = p_show_date,
        start_time = p_start_time,
        end_time = p_end_time
    WHERE showtime_id = p_showtime_id;

    IF v_old_room_id <> p_room_id THEN
        DELETE FROM showtime_seat
        WHERE showtime_id = p_showtime_id;

        INSERT INTO showtime_seat (status_id, seat_id, showtime_id, user_id, hold_expired_at)
        SELECT 1, s.seat_id, p_showtime_id, NULL, NULL
        FROM seat s
        WHERE s.room_id = p_room_id;
    END IF;
END//

DROP PROCEDURE IF EXISTS sp_delete_showtime//
CREATE PROCEDURE sp_delete_showtime(IN p_showtime_id INT UNSIGNED)
BEGIN
    DECLARE v_booking_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_booking_count
    FROM booking_seat
    WHERE showtime_id = p_showtime_id;

    IF v_booking_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong the xoa suat chieu da co ve dat';
    END IF;

    DELETE FROM showtime_seat
    WHERE showtime_id = p_showtime_id;

    DELETE FROM showtime
    WHERE showtime_id = p_showtime_id;
END//

DELIMITER ;
