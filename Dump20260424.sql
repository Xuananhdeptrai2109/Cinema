CREATE DATABASE  IF NOT EXISTS `cinema_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `cinema_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: cinema_db
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '0f7f823a-fc4e-11f0-85be-005056c00001:1-1028';

--
-- Table structure for table `booking_products`
--

DROP TABLE IF EXISTS `booking_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_products` (
  `product_id` int unsigned NOT NULL,
  `invoice_id` binary(16) NOT NULL,
  `product_quantity` int unsigned NOT NULL,
  `price_at_booking` decimal(10,2) NOT NULL,
  PRIMARY KEY (`invoice_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `booking_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `fk_booking_products_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoice` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_products`
--

LOCK TABLES `booking_products` WRITE;
/*!40000 ALTER TABLE `booking_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_seat`
--

DROP TABLE IF EXISTS `booking_seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_seat` (
  `booking_seat_id` int unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` binary(16) NOT NULL,
  `showtime_id` int unsigned NOT NULL,
  `showtime_seat_id` int unsigned NOT NULL,
  `discount_id` int unsigned DEFAULT NULL,
  `price_at_booking` decimal(10,2) NOT NULL,
  PRIMARY KEY (`booking_seat_id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `showtime_seat_id` (`showtime_seat_id`),
  KEY `fk_booking_showtime` (`showtime_id`),
  KEY `fk_booking_discount` (`discount_id`),
  CONSTRAINT `booking_seat_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoice` (`invoice_id`),
  CONSTRAINT `booking_seat_ibfk_2` FOREIGN KEY (`showtime_seat_id`) REFERENCES `showtime_seat` (`showtime_seat_id`),
  CONSTRAINT `fk_booking_discount` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`discount_id`),
  CONSTRAINT `fk_booking_showtime` FOREIGN KEY (`showtime_id`) REFERENCES `showtime` (`showtime_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_seat`
--

LOCK TABLES `booking_seat` WRITE;
/*!40000 ALTER TABLE `booking_seat` DISABLE KEYS */;
INSERT INTO `booking_seat` VALUES (1,_binary '�5*�frG\�\�y��̖u',644,1347,NULL,70000.00),(2,_binary 'jZuD3�LU���\�Ĺ�',644,1318,NULL,70000.00),(3,_binary 'E�#\�J��\�\�Q���',644,1309,NULL,70000.00),(4,_binary 'N¨I4}Oy�\�b\�/[7',647,1698,NULL,70000.00),(5,_binary '��F_d	L.�ք\�08^',644,1319,NULL,70000.00),(6,_binary 'P��݌7Nq�\�\�\\wB\�',647,1739,NULL,120000.00),(7,_binary '����%zF-���h��',647,1700,NULL,70000.00),(8,_binary '\�\�\��aH\n��Hq\�߄,',644,1316,NULL,70000.00),(9,_binary '%\���\'@���b0�2P+',644,1327,NULL,70000.00),(10,_binary '�&&�7N��/�/�\n\Z\\',647,1707,NULL,70000.00),(11,_binary '���\��CZ�ٯ�\�\�g',644,1326,NULL,70000.00),(12,_binary '\�YN\�\�EX��\��3J\�',644,1326,NULL,70000.00),(13,_binary '=USxK�K����#�|p�',647,1708,NULL,70000.00),(14,_binary '\�\�c\�Oӎ\�fIyX\�s',647,1739,NULL,120000.00),(15,_binary '寱 DJ~�x�$[X\��',644,1336,NULL,70000.00),(16,_binary 'ڈ����B2�H��\�}\�',644,1327,NULL,70000.00),(17,_binary '���!�L\�1r\�+\��',647,1709,NULL,70000.00),(18,_binary 'vnJl\�\�D-�45:\�\�B\�',647,1718,NULL,70000.00);
/*!40000 ALTER TABLE `booking_seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cinemas`
--

DROP TABLE IF EXISTS `cinemas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cinemas` (
  `cinemas_id` int unsigned NOT NULL AUTO_INCREMENT,
  `province_id` int unsigned NOT NULL,
  `cinema_name` varchar(150) NOT NULL,
  `address` varchar(255) NOT NULL,
  `fax` varchar(20) DEFAULT NULL,
  `hotline` varchar(20) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `mapUrl` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`cinemas_id`),
  KEY `province_id` (`province_id`),
  CONSTRAINT `cinemas_ibfk_1` FOREIGN KEY (`province_id`) REFERENCES `province_city` (`province_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cinemas`
--

LOCK TABLES `cinemas` WRITE;
/*!40000 ALTER TABLE `cinemas` DISABLE KEYS */;
INSERT INTO `cinemas` VALUES (1,1,'CGV Vincom Bà Triệu','191 Bà Triệu, Hà Nội','024-123456','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(2,2,'Lotte Cinema Nowzone','235 Nguyễn Văn Cừ, TP.HCM','028-654321','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(3,1,'BHD Star Phạm Ngọc Thạch','2 Phạm Ngọc Thạch, Hà Nội','024-333345','19002099','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(4,1,'Lotte Cinema Landmark','Tòa nhà Keangnam, Hà Nội','024-333346','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(5,1,'Beta Cinemas Mỹ Đình','Tòa nhà Golden Field, Hà Nội','024-333347','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(6,1,'National Cinema Center','87 Láng Hạ, Hà Nội','024-333348','0243514111','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(7,1,'CGV Aeon Long Biên','Aeon Mall Long Biên, Hà Nội','024-333349','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(10,2,'CGV Crescent Mall','Đại lộ Nguyễn Văn Linh, Quận 7, HCM','028-111122','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(11,2,'Galaxy Nguyễn Du','116 Nguyễn Du, Quận 1, HCM','028-111123','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(12,2,'BHD Star Thảo Điền','Vincom Mega Mall Thảo Điền, Quận 2, HCM','028-111124','19002099','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(13,2,'Lotte Cinema Gò Vấp','242 Nguyễn Văn Lượng, Gò Vấp, HCM','028-111125','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(14,2,'CGV Hùng Vương Plaza','126 Hùng Vương, Quận 5, HCM','028-111126','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(17,5,'CGV Vincom Hải Phòng','1 Lê Thánh Tông, Hải Phòng','022-555566','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(18,5,'Lotte Cinema Hải Phòng','Tầng 5 Vincom Imperial, Hải Phòng','022-555567','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(19,5,'Galaxy Hải Phòng','Lương Khánh Thiện, Hải Phòng','022-555568','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(20,5,'Cinestar Hải Phòng','Hải Phòng City Center, Hải Phòng','022-555569','19002099','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(21,5,'CGV Aeon Mall Lê Chân','Kênh Dương, Lê Chân, Hải Phòng','022-555570','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(22,5,'Beta Cinemas Hải Phòng','Tòa nhà Cát Bi, Hải Phòng','022-555571','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(25,6,'CGV Vincom Đà Nẵng','910A Ngô Quyền, Đà Nẵng','023-666677','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(26,6,'Lotte Cinema Đà Nẵng','Lotte Mart Đà Nẵng, Hải Châu','023-666678','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(27,6,'Galaxy Đà Nẵng','Coop Mart Đà Nẵng, Thanh Khê','023-666679','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(28,6,'Starlight Đà Nẵng','Điện Biên Phủ, Đà Nẵng','023-666680','19002324','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(29,6,'Metiz Cinema','Đường 2/9, Hải Châu, Đà Nẵng','023-666681','0236363068','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(30,6,'CGV Vĩnh Trung Plaza','255-257 Hùng Vương, Đà Nẵng','023-666682','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(33,7,'CGV Vincom Hùng Vương','2 Hùng Vương, Cần Thơ','029-777788','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(34,7,'Lotte Cinema Cần Thơ','Lotte Mart Cần Thơ, Ninh Kiều','029-777789','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(35,7,'CGV Vincom Xuân Khánh','209 30/4, Xuân Khánh, Cần Thơ','029-777790','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(36,7,'Galaxy Cần Thơ','Phạm Ngọc Thạch, Cần Thơ','029-777791','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(37,7,'Beta Cinemas Cần Thơ','Ninh Kiều, Cần Thơ','029-777792','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(38,7,'Starlight Cần Thơ','Quận Cái Răng, Cần Thơ','029-777793','19002324','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(41,8,'CGV Aeon Canary','Đại lộ Bình Dương, Thuận An','027-888899','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(42,8,'Lotte Cinema Bình Dương','Lotte Mart Bình Dương, Thuận An','027-888900','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(43,8,'CGV Becamex Bình Dương','230 Đại lộ Bình Dương, Thủ Dầu Một','027-888901','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(44,8,'Empire Cinema','Thủ Dầu Một, Bình Dương','027-888902','19002099','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(45,8,'Beta Cinemas Tân Uyên','Tân Uyên, Bình Dương','027-888903','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(46,8,'CGV Bình Dương Square','Phú Lợi, Thủ Dầu Một','027-888904','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(49,9,'CGV Pegasus Biên Hòa','53-55 Võ Thị Sáu, Biên Hòa','025-999000','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(50,9,'Lotte Cinema Biên Hòa','Lotte Mart Biên Hòa','025-999001','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(51,9,'Galaxy Biên Hòa','121 Phạm Văn Thuận, Biên Hòa','025-999002','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(52,9,'Beta Cinemas Biên Hòa','Tòa nhà Pegasus, Biên Hòa','025-999003','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(53,9,'CGV Vincom Biên Hòa','1096 Phạm Văn Thuận, Biên Hòa','025-999004','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(54,9,'Lotte Cinema Nhơn Trạch','Hiệp Phước, Nhơn Trạch','025-999005','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(57,10,'CGV BigC Nha Trang','Lô số 4, đường 19/5, Nha Trang','025-000111','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(58,10,'Lotte Cinema Nha Trang','60 Thái Nguyên, Nha Trang','025-000112','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(59,10,'Lotte Cinema Maximark Nha Trang','60 Thái Nguyên, Phương Sài','025-000113','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(60,10,'Beta Cinemas Nha Trang','10 Hoàng Hoa Thám, Nha Trang','025-000114','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(61,10,'CGV Nha Trang Center','20 Trần Phú, Nha Trang','025-000115','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(62,10,'Galaxy Nha Trang','TTTM Nha Trang, Khánh Hòa','025-000116','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(65,11,'CGV Vinh Centre','69 Hồ Tùng Mậu, TP Vinh','023-111222','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(66,11,'Lotte Cinema Vinh','VRC Building, Phan Chu Trinh, TP Vinh','023-111223','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(67,11,'Galaxy Vinh','Số 1 Lê Hồng Phong, TP Vinh','023-111224','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(68,11,'Beta Cinemas Vinh','Lê Duẩn, TP Vinh','023-111225','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(69,11,'Cinestar Vinh','Trần Phú, TP Vinh','023-111226','0287300888','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(70,11,'Vinh Cinema','Quang Trung, TP Vinh','023-111227','02383844622','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(73,12,'Lotte Cinema Thanh Hóa','Vincom Plaza Thanh Hóa','023-222333','19006018','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(74,12,'CGV Vincom Thanh Hóa','Trần Phú, TP Thanh Hóa','023-222334','19006017','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(75,12,'Beta Cinemas Thanh Hóa','Tòa nhà Thanh Hoa, TP Thanh Hóa','023-222335','19006364','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(76,12,'Galaxy Thanh Hóa','Nguyễn Du, TP Thanh Hóa','023-222336','19002224','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(77,12,'Cinestar Thanh Hóa','Lê Lợi, TP Thanh Hóa','023-222337','0287300888','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL),(78,12,'Thanh Hoa Cinema','Phan Chu Trinh, TP Thanh Hóa','023-222338','02373852203','https://evgroup.vn/wp-content/uploads/2024/04/thiet_bi_rap_phim_06-1400x700.jpg',NULL);
/*!40000 ALTER TABLE `cinemas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `director`
--

DROP TABLE IF EXISTS `director`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `director` (
  `director_id` int unsigned NOT NULL AUTO_INCREMENT,
  `director_name` varchar(100) NOT NULL,
  PRIMARY KEY (`director_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `director`
--

LOCK TABLES `director` WRITE;
/*!40000 ALTER TABLE `director` DISABLE KEYS */;
INSERT INTO `director` VALUES (1,'Christopher Nolan'),(2,'James Cameron'),(3,'Steven Spielberg'),(4,'Christopher Nolan'),(5,'James Cameron'),(6,'Quentin Tarantino'),(7,'Martin Scorsese'),(8,'Ridley Scott'),(9,'Peter Jackson'),(10,'Tim Burton'),(11,'David Fincher'),(12,'Guy Ritchie'),(13,'Zack Snyder'),(14,'Joss Whedon'),(15,'Denis Villeneuve'),(16,'Michael Bay'),(17,'George Lucas'),(18,'Francis Ford Coppola'),(19,'Clint Eastwood'),(20,'Wes Anderson'),(21,'Taika Waititi'),(22,'Bong Joon-ho');
/*!40000 ALTER TABLE `director` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount` (
  `discount_id` int unsigned NOT NULL AUTO_INCREMENT,
  `discount_title` varchar(255) NOT NULL,
  `discount_description` text,
  `discount_code` varchar(50) NOT NULL,
  `discount_type` enum('percent','fixed') NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `min_order_amount` decimal(12,2) DEFAULT '0.00',
  `applicable_movie_id` int unsigned DEFAULT NULL,
  `applicable_days` set('Mon','Tue','Wed','Thu','Fri','Sat','Sun') DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `max_usage` int unsigned DEFAULT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `current_usage` int DEFAULT '0',
  PRIMARY KEY (`discount_id`),
  UNIQUE KEY `discount_code` (`discount_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount`
--

LOCK TABLES `discount` WRITE;
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
INSERT INTO `discount` VALUES (1,'Ưu đãi khách hàng mới','Giảm giá trực tiếp cho khách hàng đăng ký tài khoản lần đầu.','CODETANTHU','fixed',50000.00,0.00,NULL,NULL,NULL,NULL,100000,0,0),(2,'Chủ nhật vui vẻ','Giảm giá cho những ngày đặt vé là chủ nhật','CHUNHATVUIVE','fixed',30000.00,0.00,NULL,NULL,NULL,NULL,100000,0,0),(3,'Cuối tháng xả sì trét','Giảm giá cho những ngày đặt vé là cuối tháng','CUOITHANG','fixed',40000.00,0.00,NULL,NULL,NULL,NULL,100000,0,0);
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `genre_id` int unsigned NOT NULL AUTO_INCREMENT,
  `genre_name` varchar(50) NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE KEY `genre_name` (`genre_name`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Action'),(20,'Âm nhạc'),(16,'Chiến tranh'),(2,'Drama'),(18,'Gia đình'),(11,'Giả tưởng'),(13,'Giật gân'),(6,'Hài'),(4,'Hành động'),(12,'Hoạt hình'),(23,'Học đường'),(10,'Khoa học viễn tưởng'),(8,'Kinh dị'),(17,'Lịch sử'),(5,'Phiêu lưu'),(3,'Sci-Fi'),(22,'Siêu anh hùng'),(19,'Tài liệu'),(7,'Tâm lý'),(21,'Thể thao'),(9,'Tình cảm'),(15,'Tội phạm'),(14,'Trinh thám');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `invoice_id` binary(16) NOT NULL,
  `user_id` int unsigned NOT NULL,
  `total_price` decimal(10,2) DEFAULT '0.00',
  `subtotal` decimal(12,2) DEFAULT '0.00',
  `discount_amount` decimal(12,2) DEFAULT '0.00',
  `final_price` decimal(12,2) DEFAULT '0.00',
  `discount_id` int unsigned DEFAULT NULL,
  `invoice_status` enum('draft','holding','paying','paid','failed','expired','refunded') NOT NULL DEFAULT 'draft',
  `payment_method` enum('momo','vnpay','zalopay','cash') DEFAULT 'cash',
  `transaction_id` varchar(100) DEFAULT NULL,
  `failure_reason` varchar(255) DEFAULT NULL,
  `email_address` varchar(100) DEFAULT NULL,
  `created_datetime` datetime DEFAULT CURRENT_TIMESTAMP,
  `paid_at` datetime DEFAULT NULL,
  `expired_at` datetime DEFAULT NULL,
  `paying_at` datetime DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `fk_invoice_user` (`user_id`),
  KEY `fk_invoice_discount` (`discount_id`),
  KEY `idx_invoice_status` (`invoice_status`),
  KEY `idx_invoice_expired` (`expired_at`),
  CONSTRAINT `fk_invoice_discount` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`discount_id`),
  CONSTRAINT `fk_invoice_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (_binary 'E�#\�J��\�\�Q���',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512997',NULL,NULL,'2026-04-24 20:04:29','2026-04-24 20:04:29',NULL,NULL),(_binary '寱 DJ~�x�$[X\��',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512918',NULL,NULL,'2026-04-24 18:07:39','2026-04-24 18:07:39',NULL,NULL),(_binary '\�\�c\�Oӎ\�fIyX\�s',11,120000.00,0.00,0.00,120000.00,NULL,'paid','vnpay','15512908',NULL,NULL,'2026-04-24 17:54:44','2026-04-24 17:54:44',NULL,NULL),(_binary '%\���\'@���b0�2P+',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512875',NULL,NULL,'2026-04-24 17:31:47','2026-04-24 17:31:47',NULL,NULL),(_binary '=USxK�K����#�|p�',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512906',NULL,NULL,'2026-04-24 17:50:20','2026-04-24 17:50:20',NULL,NULL),(_binary '?e7c\�N7�\�b܌A\�X',11,0.00,0.00,0.00,0.00,NULL,'paying',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL),(_binary 'N¨I4}Oy�\�b\�/[7',11,70000.00,0.00,0.00,70000.00,NULL,'paying',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL),(_binary 'P��݌7Nq�\�\�\\wB\�',11,120000.00,0.00,0.00,120000.00,NULL,'paying',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL),(_binary 'jZuD3�LU���\�Ĺ�',11,70000.00,0.00,0.00,70000.00,NULL,'paying',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL),(_binary 'vnJl\�\�D-�45:\�\�B\�',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15513064',NULL,NULL,'2026-04-24 21:36:03','2026-04-24 21:37:08',NULL,'2026-04-24 21:36:03'),(_binary '�&&�7N��/�/�\n\Z\\',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512883',NULL,NULL,'2026-04-24 17:37:12','2026-04-24 17:37:12',NULL,NULL),(_binary '���!�L\�1r\�+\��',11,70000.00,0.00,0.00,70000.00,NULL,'paying',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL),(_binary '�5*�frG\�\�y��̖u',11,0.00,0.00,0.00,0.00,NULL,'draft',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL),(_binary '����%zF-���h��',11,70000.00,0.00,0.00,70000.00,NULL,'paying',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL),(_binary '���\��CZ�ٯ�\�\�g',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512885',NULL,NULL,'2026-04-24 17:38:14','2026-04-24 17:38:14',NULL,NULL),(_binary 'ڈ����B2�H��\�}\�',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512931',NULL,NULL,'2026-04-24 18:31:25','2026-04-24 18:31:25',NULL,NULL),(_binary '\�YN\�\�EX��\��3J\�',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512899',NULL,NULL,'2026-04-24 17:46:22','2026-04-24 17:46:22',NULL,NULL),(_binary '\�\�\��aH\n��Hq\�߄,',11,70000.00,0.00,0.00,70000.00,NULL,'paid','vnpay','15512867',NULL,NULL,'2026-04-24 17:30:59','2026-04-24 17:30:59',NULL,NULL),(_binary '��F_d	L.�ք\�08^',11,70000.00,0.00,0.00,70000.00,NULL,'paying',NULL,NULL,NULL,NULL,'2026-04-24 20:32:17',NULL,NULL,NULL);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie` (
  `movie_id` int unsigned NOT NULL AUTO_INCREMENT,
  `director_id` int unsigned NOT NULL,
  `title` varchar(200) NOT NULL,
  `release_date` date NOT NULL,
  `duration` int unsigned NOT NULL,
  `language` varchar(50) NOT NULL,
  `age_rating` varchar(10) NOT NULL,
  `trailer_link` varchar(255) DEFAULT NULL,
  `description` text,
  `status` enum('coming_soon','showing','stopped') NOT NULL,
  `poster_link` varchar(255) DEFAULT NULL,
  `star` float DEFAULT NULL,
  PRIMARY KEY (`movie_id`),
  KEY `fk_movie_director` (`director_id`),
  CONSTRAINT `fk_movie_director` FOREIGN KEY (`director_id`) REFERENCES `director` (`director_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES (3,1,'Chó Săn Công Lý','2023-06-09',120,'Hàn Quốc','C16','https://www.youtube.com/watch?v=kY67Z3U_V6o','Hai võ sĩ trẻ bắt tay với một người cho vay nhân từ để hạ bệ kẻ cho vay nặng lãi tàn nhẫn chuyên săn lùng những người túng quẫn tài chính.','showing','https://www.themoviedb.org/t/p/w1280/yLQQoseay2JXHZO9UVGA53i1HQ.jpg',NULL),(4,2,'Avatar: Lửa và Tro Tàn','2025-12-19',198,'Anh','C13','https://www.youtube.com/watch?v=2S_f2V_6Z8U','Sau cuộc chiến tàn khốc với RDA và nỗi mất mát to lớn khi đứa con trai cả hy sinh, Jake Sully và Neytiri phải đối mặt với một mối đe dọa mới trên Pandora: tộc Tro Tàn — một nhóm Navi hung bạo và khát khao quyền lực, do thủ lĩnh tàn nhẫn Varang dẫn dắt. Gia đình Jake buộc phải chiến đấu để sinh tồn và bảo vệ tương lai của Pandora, trong một cuộc xung đột đẩy họ đến giới hạn cuối cùng cả về thể xác lẫn tinh thần.','showing','https://www.themoviedb.org/t/p/w1280/w6DBmG260sCHBQdGzkBIVn9gAQZ.jpg',NULL),(5,3,'Tội Phạm 101','2026-03-13',140,'Mĩ','C15','https://www.youtube.com/watch?v=dQw4w9WgXcQ','Lấy bối cảnh thành phố Los Angeles đầy nắng và bụi đường, Tội Phạm 101 kể về một tên trộm nữ trang bí ẩn (Chris Hemsworth) với hàng loạt phi vụ táo bạo khiến cảnh sát phải đau đầu. Trong lúc chuẩn bị cho phi vụ lớn nhất của mình, hắn gặp gỡ một nữ nhân viên bảo hiểm (Halle Berry), người cũng đang vật lộn với những lựa chọn trong đời mình. Trong khi đó, một thanh tra (Mark Ruffalo) đã tìm ra quy luật trong chuỗi các vụ án và đang ráo riết truy đuổi tên trộm, khiến cuộc chơi trở nên căng thẳng hơn bao giờ hết. Khi phi vụ định mệnh đến gần, ranh giới giữa kẻ săn đuổi và con mồi dần trở nên mờ nhạt và cả ba buộc phải đối mặt với những lựa chọn khó khăn và không còn cơ hội để quay đầu lại. Bộ phim được chuyển thể từ tiểu thuyết ngắn nổi tiếng cùng tên của Don Winslow, do Bart Layton (tác giả của American Animals, The Imposter) viết kịch bản và đạo diễn. Dàn diễn viên có sự tham gia của Barry Keoghan, Monica Barbaro, Corey Hawkins, Jennifer Jason Leigh và Nick Nolte.','showing','https://www.themoviedb.org/t/p/w1280/n52s1yMoKAIBFGx7XclwsICfwYO.jpg',NULL),(6,4,'Phim Super Mario Thiên Hà','2026-03-04',140,'Anh','C10','https://www.youtube.com/watch?v=RjNcTB6Xl44','Having thwarted Bowsers previous plot to marry Princess Peach, Mario and Luigi now face a fresh threat in Bowser Jr., who is determined to liberate his father from captivity and restore the family legacy. Alongside companions new and old, the brothers travel across the stars to stop the young heirs crusade.','showing','https://www.themoviedb.org/t/p/w1280/h1FlxHYiVcZVkIE5XW599ZkV6Sr.jpg',NULL),(7,5,'Pizza Movie ','2026-03-13',140,'Anh','C10','https://www.youtube.com/watch?v=dQw4w9WgXcQ','Một sinh viên đại học nhút nhát và người bạn cùng phòng liều lĩnh của cậu ta bắt đầu một nhiệm vụ đơn giản là đi mua pizza, nhưng sau khi dùng một liều thuốc thử nghiệm gây ảo giác kỳ lạ, họ bị cuốn vào một đêm hỗn loạn với những cuộc gặp gỡ kỳ quặc, ảo giác hoang dã và những tiết lộ bất ngờ có thể thay đổi cuộc đời họ mãi mãi.','showing','https://www.themoviedb.org/t/p/w1280/2c2ib9pS3BTIoMnYHi4z6t9nxuA.jpg',NULL),(8,6,'Tiếng Hát Trong Thinh Lặng','2026-03-04',160,'Anh','C10','https://www.youtube.com/watch?v=nfK6UgLra7g','Là người duy nhất có thính giác trong gia đình khiếm thính, thiếu nữ nhút nhát nọ phát hiện năng khiếu ca hát, buộc cô phải chọn giữa trách nhiệm với gia đình và con đường riêng.','showing','https://www.themoviedb.org/t/p/w1280/4Tf0qTA73XLhBnfP6YgvqtLZBnt.jpg',NULL),(9,7,'Bạn Bè & Hàng Xóm - Your Friends & Neighbours','2026-03-04',120,'Anh','C10','https://www.youtube.com/watch?v=dQw4w9WgXcQ','Khi một đại gia tài chính đột ngột rơi vào cảnh ly hôn và mất việc, anh ta bắt đầu đi ăn trộm những nhà hàng xóm giàu có để trang trải cuộc sống. Ăn trộm của hội mình chơi cùng đem lại khoái cảm kỳ lạ, nhưng dần dần khiến anh ta sa vào hố sâu chết chóc.','showing','https://www.themoviedb.org/t/p/w1280/4e8Xq1gsbpkd2iCGMguKq7VGzRs.jpg',NULL),(10,8,'Tiếng Thét 7','2026-09-21',120,'Anh','C10','https://www.youtube.com/watch?v=dQw4w9WgXcQ','Sidney Evans (Neve Campbell), nạn nhân sống sót của một vụ thảm sát nhiều năm trước, giờ đang sống hạnh phúc cùng chồng và con gái ở một thị trấn khác thì tên sát nhân Ghostface mới lại xuất hiện. Những nỗi sợ hãi đen tối nhất của cô trở thành hiện thực khi con gái cô Tatum Evans (Isabel May) trở thành mục tiêu tiếp theo. Quyết tâm bảo vệ gia đình, Sidney buộc phải đối mặt với những kinh hoàng trong quá khứ để chấm dứt cuộc đổ máu một lần và mãi mãi.','coming_soon','https://www.themoviedb.org/t/p/w1280/nXXpliMy4Y0mwRa4OlhOb6GyOEE.jpg',NULL),(11,9,'Thoát Khỏi Tận Thế','2026-09-21',150,'Mĩ','C12','https://www.youtube.com/watch?v=cMVBe3OUN9A','Mất trí nhớ và lạc lõng trên một con tàu vũ trụ, một phi hành gia khám phá ra rằng anh là hy vọng duy nhất của nhân loại trước bờ vực tuyệt chủng. Một liên minh bất ngờ được hình thành, nắm giữ vận mệnh của tất cả.','coming_soon','https://www.themoviedb.org/t/p/w1280/srSLrD1GNocScXAfkdL4fJ89kph.jpg',NULL),(12,10,'Lúc Đó Tôi Đã Chuyển Sinh Thành Slime (Phần đặc biệt)','2026-09-21',130,'Nhật','C12','https://www.youtube.com/watch?v=dQw4w9WgXcQ','Chuyển thể từ light novel cùng tên của tác giả Fuse. Anh chàng Satoru Mikami, 37 tuổi, FA nhiều năm với sống cuộc sống chán chường và không mấy vui vẻ gì. Ngày kia vận số đen đủi bám lấy anh chàng, bị cướp tấn công, giết ngay tại chỗ, tưởng chừng tháng ngày chán ngắt ấy đã kết thúc. Nhưng không! Ấy lại chính là sự khởi đầu của một cuộc sống mới, Mikami tỉnh dậy, thấy mình đang ở trong một thế giới kì lạ.\nVà điều quái dị là anh ta không còn hình dạng người nữa mà đã trở thành quái vật slime dẻo quẹo và không có mắt. Khi dần quen với hình dáng mới này, anh chàng bắt đầu khám phá thế giới cùng với những quái vật khác. Và thế là, cuộc đời làm Slime ở một thế giới mới bắt đầu.','coming_soon','https://www.themoviedb.org/t/p/w1280/jQb1ztdko9qc4aCdnMXShcIHXRG.jpg',NULL),(13,11,'Thiên Sứ Nhà Bên','2026-09-21',130,'Nhật','C12','https://www.youtube.com/watch?v=dQw4w9WgXcQ','Sau khi bị cảm lạnh khi đưa chiếc ô duy nhất của mình cho một cô gái đang ngồi dưới mưa, Amane Fujimiya chỉ mong cô ấy cuối cùng sẽ trả lại nó. Tuy nhiên, Mahiru Shiina, \"Thiên thần\" của trường Amane và là hàng xóm của cậu, lại cho cậu nhiều hơn thế.\nTừ duy nhất Mahiru có thể mô tả sự hỗn loạn là \"khó coi\". Nhưng bất chấp sự miêu tả không thiện cảm của cô ấy, Mahiru vẫn tiếp tục giúp đỡ Amane đang vô vọng. Có điều gì mà Thiên sứ không làm được không?','coming_soon','https://www.themoviedb.org/t/p/w1280/twCEEzmZZkgQIPXzw0JF350GO0P.jpg',NULL),(14,12,'Frieren: Pháp Sư Tiễn Táng','2026-09-21',130,'Nhật','C12','https://www.youtube.com/watch?v=q6f-E68051E','Sau một thập kỷ phiêu lưu, Frieren cùng tổ đội của dũng sĩ Himmel đã đánh bại Ma vương và mang lại hòa bình cho thế giới. Thế rồi cô ấy, một Elf với thọ mệnh hơn cả ngàn năm tuổi, lập lời hứa sẽ tái ngộ cùng nhóm Himmel rồi lên đường đi phiêu lưu một mình. 50 năm sau, Frieren đến thăm Himmel, nhưng lúc này anh ta đã già và chỉ còn lại một chút thời gian ngắn ngủi. Chứng kiến cái chết của Himmel, Frieren hối hận vì đã không \"tìm hiểu nhiều hơn về con người\", và thế là một chuyến phiêu lưu mới của cô với mục đích trên đã bắt đầu. Trên chuyến phiêu lưu này, cô đã gặp gỡ rất nhiều người và trải qua rất nhiều sự kiện.','coming_soon','https://www.themoviedb.org/t/p/w1280/z2XQykA7GEoNnxm2cSAHs6EM4Nn.jpg',NULL),(15,13,'Cuộc Chiến Không Gian - For All Mankind','2026-09-21',120,'Nhật','C12','https://www.youtube.com/watch?v=NAsHIQNfWfI','Thế giới sẽ ra sao nếu cuộc chạy đua vào không gian chưa bao giờ kết thúc? Ronald D. Moore thử tìm lời đáp qua câu chuyện giả tưởng ly kỳ về các phi hành gia ngôi sao của NASA và gia đình họ.','coming_soon','https://www.themoviedb.org/t/p/w1280/zd0VAbB0gQXTjJNM2OWQgyRx2UQ.jpg',NULL),(16,14,'Kê Thân','2026-09-21',120,'Nhật','C12','https://www.youtube.com/watch?v=L2GjS93O36c','Thế lực tà ác. Những cuộc chạm trán siêu nhiên. Những cái chết bí ẩn. Đặc vụ thiên giới Hàn Kiệt đối mặt với cả quỷ dữ trong lòng lẫn ác quỷ thật sự khi chiến đấu bảo vệ nhân loại.','coming_soon','https://www.themoviedb.org/t/p/w1280/ShizRVGvyFCmGqv7tFA0hxzQ8E.jpg',NULL),(17,15,'Chú Thuật Hồi Chiến','2026-09-21',120,'Nhật','C12','https://www.youtube.com/watch?v=WGiWNzU_pIs','Vì một lý do kỳ lạ nào đó, Yuji Itadori, mặc dù với thể chất hoàn hảo nhưng anh lại đâm đầu vào tham gia CLB Huyền Bí. Tuy nhiên, họ đã sớm phát hiện ra là những câu chuyện huyền bí hoàn toàn có thật khi các thành viên trong CLB lần lượt bị tấn công! Trong khi đó, Megumi Fushiguro “bí ẩn” lại đang truy tìm một đối tượng bị nguyền rủa cấp đặc biệt và cuộc tìm kiếm này đã đưa nhóm bạn đến Itadori','coming_soon','https://www.themoviedb.org/t/p/w1280/9TCtCKTb03Lm4xzNq4bMenbKUfx.jpg',NULL);
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_cast`
--

DROP TABLE IF EXISTS `movie_cast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_cast` (
  `movie_id` int unsigned NOT NULL,
  `performer_id` int unsigned NOT NULL,
  PRIMARY KEY (`movie_id`,`performer_id`),
  KEY `performer_id` (`performer_id`),
  CONSTRAINT `movie_cast_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`),
  CONSTRAINT `movie_cast_ibfk_2` FOREIGN KEY (`performer_id`) REFERENCES `performer` (`performer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_cast`
--

LOCK TABLES `movie_cast` WRITE;
/*!40000 ALTER TABLE `movie_cast` DISABLE KEYS */;
INSERT INTO `movie_cast` VALUES (3,3),(3,4),(4,5),(4,6),(5,7),(6,8),(6,9),(10,10),(10,11),(12,12),(14,13),(17,14),(17,15),(13,16);
/*!40000 ALTER TABLE `movie_cast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_comment`
--

DROP TABLE IF EXISTS `movie_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_comment` (
  `comment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `movie_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `content` text,
  `image_url` varchar(500) DEFAULT NULL,
  `star_rating` tinyint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `movie_id` (`movie_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `movie_comment_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`),
  CONSTRAINT `movie_comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `movie_comment_chk_1` CHECK ((`star_rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_comment`
--

LOCK TABLES `movie_comment` WRITE;
/*!40000 ALTER TABLE `movie_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `movie_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_genre`
--

DROP TABLE IF EXISTS `movie_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_genre` (
  `movie_id` int unsigned NOT NULL,
  `genre_id` int unsigned NOT NULL,
  PRIMARY KEY (`movie_id`,`genre_id`),
  KEY `genre_id` (`genre_id`),
  CONSTRAINT `movie_genre_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`),
  CONSTRAINT `movie_genre_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_genre`
--

LOCK TABLES `movie_genre` WRITE;
/*!40000 ALTER TABLE `movie_genre` DISABLE KEYS */;
INSERT INTO `movie_genre` VALUES (3,1),(11,1),(15,1),(16,1),(17,1),(12,2),(14,2),(7,3),(9,3),(8,4),(9,4),(13,4),(10,5),(13,6),(4,7),(15,7),(4,8),(6,8),(10,8),(11,8),(12,8),(14,8),(6,9),(12,9),(13,9),(14,9),(17,9),(10,10),(5,11),(16,11),(3,12),(5,12),(11,13),(6,15),(8,17),(16,19),(17,19),(13,20),(17,20);
/*!40000 ALTER TABLE `movie_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performer`
--

DROP TABLE IF EXISTS `performer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performer` (
  `performer_id` int unsigned NOT NULL AUTO_INCREMENT,
  `performer_name` varchar(100) NOT NULL,
  PRIMARY KEY (`performer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performer`
--

LOCK TABLES `performer` WRITE;
/*!40000 ALTER TABLE `performer` DISABLE KEYS */;
INSERT INTO `performer` VALUES (1,'Leonardo DiCaprio'),(2,'Christian Bale'),(3,'Kate Winslet'),(4,'Woo Do-hwan'),(5,'Lee Sang-yi'),(6,'Sam Worthington'),(7,'Zoe Saldaña'),(8,'Chris Hemsworth'),(9,'Chris Pratt'),(10,'Jack Black'),(11,'Neve Campbell'),(12,'Courteney Cox'),(13,'Miho Okasaki'),(14,'Atsumi Tanezaki'),(15,'Junya Enoki'),(16,'Yuma Uchida'),(17,'Saori Hayami');
/*!40000 ALTER TABLE `performer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_type`
--

DROP TABLE IF EXISTS `product_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_type` (
  `product_type_id` int unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`product_type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_type`
--

LOCK TABLES `product_type` WRITE;
/*!40000 ALTER TABLE `product_type` DISABLE KEYS */;
INSERT INTO `product_type` VALUES (1,'Bắp rang'),(3,'Combo'),(4,'Đồ ăn vặt'),(2,'Nước uống'),(5,'Quà tặng/Lưu niệm');
/*!40000 ALTER TABLE `product_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_type_id` int unsigned NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `product_type_id` (`product_type_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`product_type_id`) REFERENCES `product_type` (`product_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Bắp rang bơ (L)',75000.00,'https://inthanhmy.com/wp-content/uploads/2018/02/in-hop-bap-rang-bo-4.jpg'),(2,2,'Pepsi (L)',50000.00,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4sMBhgyZIK9bEih2WTSPekSY1PGs5JFfakw&s'),(3,3,'Combo đôi (2 nước + 1 bắp) (L)',150000.00,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQREQrfingNJ4eKah4Uz7NpPx_C9lX_SzYnQ&s'),(4,4,'Snack khoai tây (L)',30000.00,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSol-zeRSNgfD6SIa6c77ba48cvCUxEKTIsaw&s'),(5,5,'Bình giữ nhiệt ahihi (L)',200000.00,'https://p16-oec-sg.ibyteimg.com/tos-alisg-i-aphluv4xwc-sg/50d48771308f4d6b9b09aad90e1ef1f4~tplv-aphluv4xwc-resize-webp:800:800.webp?dr=15592&t=555f072d&ps=933b5bde&shp=8dbd94bf&shcp=e1be8f53&idc=my&from=2378011839');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `province_city`
--

DROP TABLE IF EXISTS `province_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `province_city` (
  `province_id` int unsigned NOT NULL AUTO_INCREMENT,
  `province_name` varchar(100) NOT NULL,
  PRIMARY KEY (`province_id`),
  UNIQUE KEY `province_name` (`province_name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `province_city`
--

LOCK TABLES `province_city` WRITE;
/*!40000 ALTER TABLE `province_city` DISABLE KEYS */;
INSERT INTO `province_city` VALUES (8,'Bình Dương'),(7,'Cần Thơ'),(6,'Đà Nẵng'),(9,'Đồng Nai'),(1,'Hà Nội'),(5,'Hải Phòng'),(10,'Khánh Hòa'),(11,'Nghệ An'),(12,'Thanh Hóa'),(2,'TP Hồ Chí Minh');
/*!40000 ALTER TABLE `province_city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `room_id` int unsigned NOT NULL AUTO_INCREMENT,
  `cinemas_id` int unsigned NOT NULL,
  `screening_format_id` int unsigned NOT NULL,
  `room_name` varchar(50) NOT NULL,
  PRIMARY KEY (`room_id`),
  KEY `cinemas_id` (`cinemas_id`),
  KEY `screening_format_id` (`screening_format_id`),
  CONSTRAINT `room_ibfk_1` FOREIGN KEY (`cinemas_id`) REFERENCES `cinemas` (`cinemas_id`),
  CONSTRAINT `room_ibfk_2` FOREIGN KEY (`screening_format_id`) REFERENCES `screening_format` (`screening_format_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1265 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (1,1,1,'Room A'),(2,1,2,'Room B'),(3,1,3,'Room C'),(4,1,4,'Room D'),(5,1,5,'Room E'),(6,1,6,'Room F'),(7,1,7,'Room G'),(8,1,8,'Room H'),(9,2,1,'Room A'),(10,2,2,'Room B'),(11,2,3,'Room C'),(12,2,4,'Room D'),(13,2,5,'Room E'),(14,2,6,'Room F'),(15,2,7,'Room G'),(16,2,8,'Room H'),(33,5,1,'Room A'),(34,5,2,'Room B'),(35,5,3,'Room C'),(36,5,4,'Room D'),(37,5,5,'Room E'),(38,5,6,'Room F'),(39,5,7,'Room G'),(40,5,8,'Room H'),(41,6,1,'Room A'),(42,6,2,'Room B'),(43,6,3,'Room C'),(44,6,4,'Room D'),(45,6,5,'Room E'),(46,6,6,'Room F'),(47,6,7,'Room G'),(48,6,8,'Room H'),(49,7,1,'Room A'),(50,7,2,'Room B'),(51,7,3,'Room C'),(52,7,4,'Room D'),(53,7,5,'Room E'),(54,7,6,'Room F'),(55,7,7,'Room G'),(56,7,8,'Room H'),(57,8,1,'Room A'),(58,8,2,'Room B'),(59,8,3,'Room C'),(60,8,4,'Room D'),(61,8,5,'Room E'),(62,8,6,'Room F'),(63,8,7,'Room G'),(64,8,8,'Room H'),(65,9,1,'Room A'),(66,9,2,'Room B'),(67,9,3,'Room C'),(68,9,4,'Room D'),(69,9,5,'Room E'),(70,9,6,'Room F'),(71,9,7,'Room G'),(72,9,8,'Room H'),(73,10,1,'Room A'),(74,10,2,'Room B'),(75,10,3,'Room C'),(76,10,4,'Room D'),(77,10,5,'Room E'),(78,10,6,'Room F'),(79,10,7,'Room G'),(80,10,8,'Room H'),(81,11,1,'Room A'),(82,11,2,'Room B'),(83,11,3,'Room C'),(84,11,4,'Room D'),(85,11,5,'Room E'),(86,11,6,'Room F'),(87,11,7,'Room G'),(88,11,8,'Room H'),(89,12,1,'Room A'),(90,12,2,'Room B'),(91,12,3,'Room C'),(92,12,4,'Room D'),(93,12,5,'Room E'),(94,12,6,'Room F'),(95,12,7,'Room G'),(96,12,8,'Room H'),(97,13,1,'Room A'),(98,13,2,'Room B'),(99,13,3,'Room C'),(100,13,4,'Room D'),(101,13,5,'Room E'),(102,13,6,'Room F'),(103,13,7,'Room G'),(104,13,8,'Room H'),(105,14,1,'Room A'),(106,14,2,'Room B'),(107,14,3,'Room C'),(108,14,4,'Room D'),(109,14,5,'Room E'),(110,14,6,'Room F'),(111,14,7,'Room G'),(112,14,8,'Room H'),(113,15,1,'Room A'),(114,15,2,'Room B'),(115,15,3,'Room C'),(116,15,4,'Room D'),(117,15,5,'Room E'),(118,15,6,'Room F'),(119,15,7,'Room G'),(120,15,8,'Room H'),(121,16,1,'Room A'),(122,16,2,'Room B'),(123,16,3,'Room C'),(124,16,4,'Room D'),(125,16,5,'Room E'),(126,16,6,'Room F'),(127,16,7,'Room G'),(128,16,8,'Room H'),(129,17,1,'Room A'),(130,17,2,'Room B'),(131,17,3,'Room C'),(132,17,4,'Room D'),(133,17,5,'Room E'),(134,17,6,'Room F'),(135,17,7,'Room G'),(136,17,8,'Room H'),(137,18,1,'Room A'),(138,18,2,'Room B'),(139,18,3,'Room C'),(140,18,4,'Room D'),(141,18,5,'Room E'),(142,18,6,'Room F'),(143,18,7,'Room G'),(144,18,8,'Room H'),(145,19,1,'Room A'),(146,19,2,'Room B'),(147,19,3,'Room C'),(148,19,4,'Room D'),(149,19,5,'Room E'),(150,19,6,'Room F'),(151,19,7,'Room G'),(152,19,8,'Room H'),(153,20,1,'Room A'),(154,20,2,'Room B'),(155,20,3,'Room C'),(156,20,4,'Room D'),(157,20,5,'Room E'),(158,20,6,'Room F'),(159,20,7,'Room G'),(160,20,8,'Room H'),(161,21,1,'Room A'),(162,21,2,'Room B'),(163,21,3,'Room C'),(164,21,4,'Room D'),(165,21,5,'Room E'),(166,21,6,'Room F'),(167,21,7,'Room G'),(168,21,8,'Room H'),(169,22,1,'Room A'),(170,22,2,'Room B'),(171,22,3,'Room C'),(172,22,4,'Room D'),(173,22,5,'Room E'),(174,22,6,'Room F'),(175,22,7,'Room G'),(176,22,8,'Room H'),(177,23,1,'Room A'),(178,23,2,'Room B'),(179,23,3,'Room C'),(180,23,4,'Room D'),(181,23,5,'Room E'),(182,23,6,'Room F'),(183,23,7,'Room G'),(184,23,8,'Room H'),(185,24,1,'Room A'),(186,24,2,'Room B'),(187,24,3,'Room C'),(188,24,4,'Room D'),(189,24,5,'Room E'),(190,24,6,'Room F'),(191,24,7,'Room G'),(192,24,8,'Room H'),(193,25,1,'Room A'),(194,25,2,'Room B'),(195,25,3,'Room C'),(196,25,4,'Room D'),(197,25,5,'Room E'),(198,25,6,'Room F'),(199,25,7,'Room G'),(200,25,8,'Room H'),(201,26,1,'Room A'),(202,26,2,'Room B'),(203,26,3,'Room C'),(204,26,4,'Room D'),(205,26,5,'Room E'),(206,26,6,'Room F'),(207,26,7,'Room G'),(208,26,8,'Room H'),(209,27,1,'Room A'),(210,27,2,'Room B'),(211,27,3,'Room C'),(212,27,4,'Room D'),(213,27,5,'Room E'),(214,27,6,'Room F'),(215,27,7,'Room G'),(216,27,8,'Room H'),(217,28,1,'Room A'),(218,28,2,'Room B'),(219,28,3,'Room C'),(220,28,4,'Room D'),(221,28,5,'Room E'),(222,28,6,'Room F'),(223,28,7,'Room G'),(224,28,8,'Room H'),(225,29,1,'Room A'),(226,29,2,'Room B'),(227,29,3,'Room C'),(228,29,4,'Room D'),(229,29,5,'Room E'),(230,29,6,'Room F'),(231,29,7,'Room G'),(232,29,8,'Room H'),(233,30,1,'Room A'),(234,30,2,'Room B'),(235,30,3,'Room C'),(236,30,4,'Room D'),(237,30,5,'Room E'),(238,30,6,'Room F'),(239,30,7,'Room G'),(240,30,8,'Room H'),(241,31,1,'Room A'),(242,31,2,'Room B'),(243,31,3,'Room C'),(244,31,4,'Room D'),(245,31,5,'Room E'),(246,31,6,'Room F'),(247,31,7,'Room G'),(248,31,8,'Room H'),(249,32,1,'Room A'),(250,32,2,'Room B'),(251,32,3,'Room C'),(252,32,4,'Room D'),(253,32,5,'Room E'),(254,32,6,'Room F'),(255,32,7,'Room G'),(256,32,8,'Room H'),(257,33,1,'Room A'),(258,33,2,'Room B'),(259,33,3,'Room C'),(260,33,4,'Room D'),(261,33,5,'Room E'),(262,33,6,'Room F'),(263,33,7,'Room G'),(264,33,8,'Room H'),(265,34,1,'Room A'),(266,34,2,'Room B'),(267,34,3,'Room C'),(268,34,4,'Room D'),(269,34,5,'Room E'),(270,34,6,'Room F'),(271,34,7,'Room G'),(272,34,8,'Room H'),(273,35,1,'Room A'),(274,35,2,'Room B'),(275,35,3,'Room C'),(276,35,4,'Room D'),(277,35,5,'Room E'),(278,35,6,'Room F'),(279,35,7,'Room G'),(280,35,8,'Room H'),(281,36,1,'Room A'),(282,36,2,'Room B'),(283,36,3,'Room C'),(284,36,4,'Room D'),(285,36,5,'Room E'),(286,36,6,'Room F'),(287,36,7,'Room G'),(288,36,8,'Room H'),(289,37,1,'Room A'),(290,37,2,'Room B'),(291,37,3,'Room C'),(292,37,4,'Room D'),(293,37,5,'Room E'),(294,37,6,'Room F'),(295,37,7,'Room G'),(296,37,8,'Room H'),(297,38,1,'Room A'),(298,38,2,'Room B'),(299,38,3,'Room C'),(300,38,4,'Room D'),(301,38,5,'Room E'),(302,38,6,'Room F'),(303,38,7,'Room G'),(304,38,8,'Room H'),(305,39,1,'Room A'),(306,39,2,'Room B'),(307,39,3,'Room C'),(308,39,4,'Room D'),(309,39,5,'Room E'),(310,39,6,'Room F'),(311,39,7,'Room G'),(312,39,8,'Room H'),(313,40,1,'Room A'),(314,40,2,'Room B'),(315,40,3,'Room C'),(316,40,4,'Room D'),(317,40,5,'Room E'),(318,40,6,'Room F'),(319,40,7,'Room G'),(320,40,8,'Room H'),(321,41,1,'Room A'),(322,41,2,'Room B'),(323,41,3,'Room C'),(324,41,4,'Room D'),(325,41,5,'Room E'),(326,41,6,'Room F'),(327,41,7,'Room G'),(328,41,8,'Room H'),(329,42,1,'Room A'),(330,42,2,'Room B'),(331,42,3,'Room C'),(332,42,4,'Room D'),(333,42,5,'Room E'),(334,42,6,'Room F'),(335,42,7,'Room G'),(336,42,8,'Room H'),(337,43,1,'Room A'),(338,43,2,'Room B'),(339,43,3,'Room C'),(340,43,4,'Room D'),(341,43,5,'Room E'),(342,43,6,'Room F'),(343,43,7,'Room G'),(344,43,8,'Room H'),(345,44,1,'Room A'),(346,44,2,'Room B'),(347,44,3,'Room C'),(348,44,4,'Room D'),(349,44,5,'Room E'),(350,44,6,'Room F'),(351,44,7,'Room G'),(352,44,8,'Room H'),(353,45,1,'Room A'),(354,45,2,'Room B'),(355,45,3,'Room C'),(356,45,4,'Room D'),(357,45,5,'Room E'),(358,45,6,'Room F'),(359,45,7,'Room G'),(360,45,8,'Room H'),(361,46,1,'Room A'),(362,46,2,'Room B'),(363,46,3,'Room C'),(364,46,4,'Room D'),(365,46,5,'Room E'),(366,46,6,'Room F'),(367,46,7,'Room G'),(368,46,8,'Room H'),(369,47,1,'Room A'),(370,47,2,'Room B'),(371,47,3,'Room C'),(372,47,4,'Room D'),(373,47,5,'Room E'),(374,47,6,'Room F'),(375,47,7,'Room G'),(376,47,8,'Room H'),(377,48,1,'Room A'),(378,48,2,'Room B'),(379,48,3,'Room C'),(380,48,4,'Room D'),(381,48,5,'Room E'),(382,48,6,'Room F'),(383,48,7,'Room G'),(384,48,8,'Room H'),(385,49,1,'Room A'),(386,49,2,'Room B'),(387,49,3,'Room C'),(388,49,4,'Room D'),(389,49,5,'Room E'),(390,49,6,'Room F'),(391,49,7,'Room G'),(392,49,8,'Room H'),(393,50,1,'Room A'),(394,50,2,'Room B'),(395,50,3,'Room C'),(396,50,4,'Room D'),(397,50,5,'Room E'),(398,50,6,'Room F'),(399,50,7,'Room G'),(400,50,8,'Room H'),(401,51,1,'Room A'),(402,51,2,'Room B'),(403,51,3,'Room C'),(404,51,4,'Room D'),(405,51,5,'Room E'),(406,51,6,'Room F'),(407,51,7,'Room G'),(408,51,8,'Room H'),(409,52,1,'Room A'),(410,52,2,'Room B'),(411,52,3,'Room C'),(412,52,4,'Room D'),(413,52,5,'Room E'),(414,52,6,'Room F'),(415,52,7,'Room G'),(416,52,8,'Room H'),(417,53,1,'Room A'),(418,53,2,'Room B'),(419,53,3,'Room C'),(420,53,4,'Room D'),(421,53,5,'Room E'),(422,53,6,'Room F'),(423,53,7,'Room G'),(424,53,8,'Room H'),(425,54,1,'Room A'),(426,54,2,'Room B'),(427,54,3,'Room C'),(428,54,4,'Room D'),(429,54,5,'Room E'),(430,54,6,'Room F'),(431,54,7,'Room G'),(432,54,8,'Room H'),(433,55,1,'Room A'),(434,55,2,'Room B'),(435,55,3,'Room C'),(436,55,4,'Room D'),(437,55,5,'Room E'),(438,55,6,'Room F'),(439,55,7,'Room G'),(440,55,8,'Room H'),(441,56,1,'Room A'),(442,56,2,'Room B'),(443,56,3,'Room C'),(444,56,4,'Room D'),(445,56,5,'Room E'),(446,56,6,'Room F'),(447,56,7,'Room G'),(448,56,8,'Room H'),(449,57,1,'Room A'),(450,57,2,'Room B'),(451,57,3,'Room C'),(452,57,4,'Room D'),(453,57,5,'Room E'),(454,57,6,'Room F'),(455,57,7,'Room G'),(456,57,8,'Room H'),(457,58,1,'Room A'),(458,58,2,'Room B'),(459,58,3,'Room C'),(460,58,4,'Room D'),(461,58,5,'Room E'),(462,58,6,'Room F'),(463,58,7,'Room G'),(464,58,8,'Room H'),(465,59,1,'Room A'),(466,59,2,'Room B'),(467,59,3,'Room C'),(468,59,4,'Room D'),(469,59,5,'Room E'),(470,59,6,'Room F'),(471,59,7,'Room G'),(472,59,8,'Room H'),(473,60,1,'Room A'),(474,60,2,'Room B'),(475,60,3,'Room C'),(476,60,4,'Room D'),(477,60,5,'Room E'),(478,60,6,'Room F'),(479,60,7,'Room G'),(480,60,8,'Room H'),(481,61,1,'Room A'),(482,61,2,'Room B'),(483,61,3,'Room C'),(484,61,4,'Room D'),(485,61,5,'Room E'),(486,61,6,'Room F'),(487,61,7,'Room G'),(488,61,8,'Room H'),(489,62,1,'Room A'),(490,62,2,'Room B'),(491,62,3,'Room C'),(492,62,4,'Room D'),(493,62,5,'Room E'),(494,62,6,'Room F'),(495,62,7,'Room G'),(496,62,8,'Room H'),(497,63,1,'Room A'),(498,63,2,'Room B'),(499,63,3,'Room C'),(500,63,4,'Room D'),(501,63,5,'Room E'),(502,63,6,'Room F'),(503,63,7,'Room G'),(504,63,8,'Room H'),(505,64,1,'Room A'),(506,64,2,'Room B'),(507,64,3,'Room C'),(508,64,4,'Room D'),(509,64,5,'Room E'),(510,64,6,'Room F'),(511,64,7,'Room G'),(512,64,8,'Room H'),(513,65,1,'Room A'),(514,65,2,'Room B'),(515,65,3,'Room C'),(516,65,4,'Room D'),(517,65,5,'Room E'),(518,65,6,'Room F'),(519,65,7,'Room G'),(520,65,8,'Room H'),(521,66,1,'Room A'),(522,66,2,'Room B'),(523,66,3,'Room C'),(524,66,4,'Room D'),(525,66,5,'Room E'),(526,66,6,'Room F'),(527,66,7,'Room G'),(528,66,8,'Room H'),(529,67,1,'Room A'),(530,67,2,'Room B'),(531,67,3,'Room C'),(532,67,4,'Room D'),(533,67,5,'Room E'),(534,67,6,'Room F'),(535,67,7,'Room G'),(536,67,8,'Room H'),(537,68,1,'Room A'),(538,68,2,'Room B'),(539,68,3,'Room C'),(540,68,4,'Room D'),(541,68,5,'Room E'),(542,68,6,'Room F'),(543,68,7,'Room G'),(544,68,8,'Room H'),(545,69,1,'Room A'),(546,69,2,'Room B'),(547,69,3,'Room C'),(548,69,4,'Room D'),(549,69,5,'Room E'),(550,69,6,'Room F'),(551,69,7,'Room G'),(552,69,8,'Room H'),(553,70,1,'Room A'),(554,70,2,'Room B'),(555,70,3,'Room C'),(556,70,4,'Room D'),(557,70,5,'Room E'),(558,70,6,'Room F'),(559,70,7,'Room G'),(560,70,8,'Room H'),(561,71,1,'Room A'),(562,71,2,'Room B'),(563,71,3,'Room C'),(564,71,4,'Room D'),(565,71,5,'Room E'),(566,71,6,'Room F'),(567,71,7,'Room G'),(568,71,8,'Room H'),(569,72,1,'Room A'),(570,72,2,'Room B'),(571,72,3,'Room C'),(572,72,4,'Room D'),(573,72,5,'Room E'),(574,72,6,'Room F'),(575,72,7,'Room G'),(576,72,8,'Room H'),(577,73,1,'Room A'),(578,73,2,'Room B'),(579,73,3,'Room C'),(580,73,4,'Room D'),(581,73,5,'Room E'),(582,73,6,'Room F'),(583,73,7,'Room G'),(584,73,8,'Room H'),(585,74,1,'Room A'),(586,74,2,'Room B'),(587,74,3,'Room C'),(588,74,4,'Room D'),(589,74,5,'Room E'),(590,74,6,'Room F'),(591,74,7,'Room G'),(592,74,8,'Room H'),(593,75,1,'Room A'),(594,75,2,'Room B'),(595,75,3,'Room C'),(596,75,4,'Room D'),(597,75,5,'Room E'),(598,75,6,'Room F'),(599,75,7,'Room G'),(600,75,8,'Room H'),(601,76,1,'Room A'),(602,76,2,'Room B'),(603,76,3,'Room C'),(604,76,4,'Room D'),(605,76,5,'Room E'),(606,76,6,'Room F'),(607,76,7,'Room G'),(608,76,8,'Room H'),(609,77,1,'Room A'),(610,77,2,'Room B'),(611,77,3,'Room C'),(612,77,4,'Room D'),(613,77,5,'Room E'),(614,77,6,'Room F'),(615,77,7,'Room G'),(616,77,8,'Room H'),(617,78,1,'Room A'),(618,78,2,'Room B'),(619,78,3,'Room C'),(620,78,4,'Room D'),(621,78,5,'Room E'),(622,78,6,'Room F'),(623,78,7,'Room G'),(624,78,8,'Room H'),(625,79,1,'Room A'),(626,79,2,'Room B'),(627,79,3,'Room C'),(628,79,4,'Room D'),(629,79,5,'Room E'),(630,79,6,'Room F'),(631,79,7,'Room G'),(632,79,8,'Room H'),(633,80,1,'Room A'),(634,80,2,'Room B'),(635,80,3,'Room C'),(636,80,4,'Room D'),(637,80,5,'Room E'),(638,80,6,'Room F'),(639,80,7,'Room G'),(640,80,8,'Room H'),(657,5,1,'Room A'),(658,5,2,'Room B'),(659,5,3,'Room C'),(660,5,4,'Room D'),(661,5,5,'Room E'),(662,5,6,'Room F'),(663,5,7,'Room G'),(664,5,8,'Room H'),(665,6,1,'Room A'),(666,6,2,'Room B'),(667,6,3,'Room C'),(668,6,4,'Room D'),(669,6,5,'Room E'),(670,6,6,'Room F'),(671,6,7,'Room G'),(672,6,8,'Room H'),(673,7,1,'Room A'),(674,7,2,'Room B'),(675,7,3,'Room C'),(676,7,4,'Room D'),(677,7,5,'Room E'),(678,7,6,'Room F'),(679,7,7,'Room G'),(680,7,8,'Room H'),(681,8,1,'Room A'),(682,8,2,'Room B'),(683,8,3,'Room C'),(684,8,4,'Room D'),(685,8,5,'Room E'),(686,8,6,'Room F'),(687,8,7,'Room G'),(688,8,8,'Room H'),(689,9,1,'Room A'),(690,9,2,'Room B'),(691,9,3,'Room C'),(692,9,4,'Room D'),(693,9,5,'Room E'),(694,9,6,'Room F'),(695,9,7,'Room G'),(696,9,8,'Room H'),(697,10,1,'Room A'),(698,10,2,'Room B'),(699,10,3,'Room C'),(700,10,4,'Room D'),(701,10,5,'Room E'),(702,10,6,'Room F'),(703,10,7,'Room G'),(704,10,8,'Room H'),(705,11,1,'Room A'),(706,11,2,'Room B'),(707,11,3,'Room C'),(708,11,4,'Room D'),(709,11,5,'Room E'),(710,11,6,'Room F'),(711,11,7,'Room G'),(712,11,8,'Room H'),(713,12,1,'Room A'),(714,12,2,'Room B'),(715,12,3,'Room C'),(716,12,4,'Room D'),(717,12,5,'Room E'),(718,12,6,'Room F'),(719,12,7,'Room G'),(720,12,8,'Room H'),(721,13,1,'Room A'),(722,13,2,'Room B'),(723,13,3,'Room C'),(724,13,4,'Room D'),(725,13,5,'Room E'),(726,13,6,'Room F'),(727,13,7,'Room G'),(728,13,8,'Room H'),(729,14,1,'Room A'),(730,14,2,'Room B'),(731,14,3,'Room C'),(732,14,4,'Room D'),(733,14,5,'Room E'),(734,14,6,'Room F'),(735,14,7,'Room G'),(736,14,8,'Room H'),(737,15,1,'Room A'),(738,15,2,'Room B'),(739,15,3,'Room C'),(740,15,4,'Room D'),(741,15,5,'Room E'),(742,15,6,'Room F'),(743,15,7,'Room G'),(744,15,8,'Room H'),(745,16,1,'Room A'),(746,16,2,'Room B'),(747,16,3,'Room C'),(748,16,4,'Room D'),(749,16,5,'Room E'),(750,16,6,'Room F'),(751,16,7,'Room G'),(752,16,8,'Room H'),(753,17,1,'Room A'),(754,17,2,'Room B'),(755,17,3,'Room C'),(756,17,4,'Room D'),(757,17,5,'Room E'),(758,17,6,'Room F'),(759,17,7,'Room G'),(760,17,8,'Room H'),(761,18,1,'Room A'),(762,18,2,'Room B'),(763,18,3,'Room C'),(764,18,4,'Room D'),(765,18,5,'Room E'),(766,18,6,'Room F'),(767,18,7,'Room G'),(768,18,8,'Room H'),(769,19,1,'Room A'),(770,19,2,'Room B'),(771,19,3,'Room C'),(772,19,4,'Room D'),(773,19,5,'Room E'),(774,19,6,'Room F'),(775,19,7,'Room G'),(776,19,8,'Room H'),(777,20,1,'Room A'),(778,20,2,'Room B'),(779,20,3,'Room C'),(780,20,4,'Room D'),(781,20,5,'Room E'),(782,20,6,'Room F'),(783,20,7,'Room G'),(784,20,8,'Room H'),(785,21,1,'Room A'),(786,21,2,'Room B'),(787,21,3,'Room C'),(788,21,4,'Room D'),(789,21,5,'Room E'),(790,21,6,'Room F'),(791,21,7,'Room G'),(792,21,8,'Room H'),(793,22,1,'Room A'),(794,22,2,'Room B'),(795,22,3,'Room C'),(796,22,4,'Room D'),(797,22,5,'Room E'),(798,22,6,'Room F'),(799,22,7,'Room G'),(800,22,8,'Room H'),(801,23,1,'Room A'),(802,23,2,'Room B'),(803,23,3,'Room C'),(804,23,4,'Room D'),(805,23,5,'Room E'),(806,23,6,'Room F'),(807,23,7,'Room G'),(808,23,8,'Room H'),(809,24,1,'Room A'),(810,24,2,'Room B'),(811,24,3,'Room C'),(812,24,4,'Room D'),(813,24,5,'Room E'),(814,24,6,'Room F'),(815,24,7,'Room G'),(816,24,8,'Room H'),(817,25,1,'Room A'),(818,25,2,'Room B'),(819,25,3,'Room C'),(820,25,4,'Room D'),(821,25,5,'Room E'),(822,25,6,'Room F'),(823,25,7,'Room G'),(824,25,8,'Room H'),(825,26,1,'Room A'),(826,26,2,'Room B'),(827,26,3,'Room C'),(828,26,4,'Room D'),(829,26,5,'Room E'),(830,26,6,'Room F'),(831,26,7,'Room G'),(832,26,8,'Room H'),(833,27,1,'Room A'),(834,27,2,'Room B'),(835,27,3,'Room C'),(836,27,4,'Room D'),(837,27,5,'Room E'),(838,27,6,'Room F'),(839,27,7,'Room G'),(840,27,8,'Room H'),(841,28,1,'Room A'),(842,28,2,'Room B'),(843,28,3,'Room C'),(844,28,4,'Room D'),(845,28,5,'Room E'),(846,28,6,'Room F'),(847,28,7,'Room G'),(848,28,8,'Room H'),(849,29,1,'Room A'),(850,29,2,'Room B'),(851,29,3,'Room C'),(852,29,4,'Room D'),(853,29,5,'Room E'),(854,29,6,'Room F'),(855,29,7,'Room G'),(856,29,8,'Room H'),(857,30,1,'Room A'),(858,30,2,'Room B'),(859,30,3,'Room C'),(860,30,4,'Room D'),(861,30,5,'Room E'),(862,30,6,'Room F'),(863,30,7,'Room G'),(864,30,8,'Room H'),(865,31,1,'Room A'),(866,31,2,'Room B'),(867,31,3,'Room C'),(868,31,4,'Room D'),(869,31,5,'Room E'),(870,31,6,'Room F'),(871,31,7,'Room G'),(872,31,8,'Room H'),(873,32,1,'Room A'),(874,32,2,'Room B'),(875,32,3,'Room C'),(876,32,4,'Room D'),(877,32,5,'Room E'),(878,32,6,'Room F'),(879,32,7,'Room G'),(880,32,8,'Room H'),(881,33,1,'Room A'),(882,33,2,'Room B'),(883,33,3,'Room C'),(884,33,4,'Room D'),(885,33,5,'Room E'),(886,33,6,'Room F'),(887,33,7,'Room G'),(888,33,8,'Room H'),(889,34,1,'Room A'),(890,34,2,'Room B'),(891,34,3,'Room C'),(892,34,4,'Room D'),(893,34,5,'Room E'),(894,34,6,'Room F'),(895,34,7,'Room G'),(896,34,8,'Room H'),(897,35,1,'Room A'),(898,35,2,'Room B'),(899,35,3,'Room C'),(900,35,4,'Room D'),(901,35,5,'Room E'),(902,35,6,'Room F'),(903,35,7,'Room G'),(904,35,8,'Room H'),(905,36,1,'Room A'),(906,36,2,'Room B'),(907,36,3,'Room C'),(908,36,4,'Room D'),(909,36,5,'Room E'),(910,36,6,'Room F'),(911,36,7,'Room G'),(912,36,8,'Room H'),(913,37,1,'Room A'),(914,37,2,'Room B'),(915,37,3,'Room C'),(916,37,4,'Room D'),(917,37,5,'Room E'),(918,37,6,'Room F'),(919,37,7,'Room G'),(920,37,8,'Room H'),(921,38,1,'Room A'),(922,38,2,'Room B'),(923,38,3,'Room C'),(924,38,4,'Room D'),(925,38,5,'Room E'),(926,38,6,'Room F'),(927,38,7,'Room G'),(928,38,8,'Room H'),(929,39,1,'Room A'),(930,39,2,'Room B'),(931,39,3,'Room C'),(932,39,4,'Room D'),(933,39,5,'Room E'),(934,39,6,'Room F'),(935,39,7,'Room G'),(936,39,8,'Room H'),(937,40,1,'Room A'),(938,40,2,'Room B'),(939,40,3,'Room C'),(940,40,4,'Room D'),(941,40,5,'Room E'),(942,40,6,'Room F'),(943,40,7,'Room G'),(944,40,8,'Room H'),(945,41,1,'Room A'),(946,41,2,'Room B'),(947,41,3,'Room C'),(948,41,4,'Room D'),(949,41,5,'Room E'),(950,41,6,'Room F'),(951,41,7,'Room G'),(952,41,8,'Room H'),(953,42,1,'Room A'),(954,42,2,'Room B'),(955,42,3,'Room C'),(956,42,4,'Room D'),(957,42,5,'Room E'),(958,42,6,'Room F'),(959,42,7,'Room G'),(960,42,8,'Room H'),(961,43,1,'Room A'),(962,43,2,'Room B'),(963,43,3,'Room C'),(964,43,4,'Room D'),(965,43,5,'Room E'),(966,43,6,'Room F'),(967,43,7,'Room G'),(968,43,8,'Room H'),(969,44,1,'Room A'),(970,44,2,'Room B'),(971,44,3,'Room C'),(972,44,4,'Room D'),(973,44,5,'Room E'),(974,44,6,'Room F'),(975,44,7,'Room G'),(976,44,8,'Room H'),(977,45,1,'Room A'),(978,45,2,'Room B'),(979,45,3,'Room C'),(980,45,4,'Room D'),(981,45,5,'Room E'),(982,45,6,'Room F'),(983,45,7,'Room G'),(984,45,8,'Room H'),(985,46,1,'Room A'),(986,46,2,'Room B'),(987,46,3,'Room C'),(988,46,4,'Room D'),(989,46,5,'Room E'),(990,46,6,'Room F'),(991,46,7,'Room G'),(992,46,8,'Room H'),(993,47,1,'Room A'),(994,47,2,'Room B'),(995,47,3,'Room C'),(996,47,4,'Room D'),(997,47,5,'Room E'),(998,47,6,'Room F'),(999,47,7,'Room G'),(1000,47,8,'Room H'),(1001,48,1,'Room A'),(1002,48,2,'Room B'),(1003,48,3,'Room C'),(1004,48,4,'Room D'),(1005,48,5,'Room E'),(1006,48,6,'Room F'),(1007,48,7,'Room G'),(1008,48,8,'Room H'),(1009,49,1,'Room A'),(1010,49,2,'Room B'),(1011,49,3,'Room C'),(1012,49,4,'Room D'),(1013,49,5,'Room E'),(1014,49,6,'Room F'),(1015,49,7,'Room G'),(1016,49,8,'Room H'),(1017,50,1,'Room A'),(1018,50,2,'Room B'),(1019,50,3,'Room C'),(1020,50,4,'Room D'),(1021,50,5,'Room E'),(1022,50,6,'Room F'),(1023,50,7,'Room G'),(1024,50,8,'Room H'),(1025,51,1,'Room A'),(1026,51,2,'Room B'),(1027,51,3,'Room C'),(1028,51,4,'Room D'),(1029,51,5,'Room E'),(1030,51,6,'Room F'),(1031,51,7,'Room G'),(1032,51,8,'Room H'),(1033,52,1,'Room A'),(1034,52,2,'Room B'),(1035,52,3,'Room C'),(1036,52,4,'Room D'),(1037,52,5,'Room E'),(1038,52,6,'Room F'),(1039,52,7,'Room G'),(1040,52,8,'Room H'),(1041,53,1,'Room A'),(1042,53,2,'Room B'),(1043,53,3,'Room C'),(1044,53,4,'Room D'),(1045,53,5,'Room E'),(1046,53,6,'Room F'),(1047,53,7,'Room G'),(1048,53,8,'Room H'),(1049,54,1,'Room A'),(1050,54,2,'Room B'),(1051,54,3,'Room C'),(1052,54,4,'Room D'),(1053,54,5,'Room E'),(1054,54,6,'Room F'),(1055,54,7,'Room G'),(1056,54,8,'Room H'),(1057,55,1,'Room A'),(1058,55,2,'Room B'),(1059,55,3,'Room C'),(1060,55,4,'Room D'),(1061,55,5,'Room E'),(1062,55,6,'Room F'),(1063,55,7,'Room G'),(1064,55,8,'Room H'),(1065,56,1,'Room A'),(1066,56,2,'Room B'),(1067,56,3,'Room C'),(1068,56,4,'Room D'),(1069,56,5,'Room E'),(1070,56,6,'Room F'),(1071,56,7,'Room G'),(1072,56,8,'Room H'),(1073,57,1,'Room A'),(1074,57,2,'Room B'),(1075,57,3,'Room C'),(1076,57,4,'Room D'),(1077,57,5,'Room E'),(1078,57,6,'Room F'),(1079,57,7,'Room G'),(1080,57,8,'Room H'),(1081,58,1,'Room A'),(1082,58,2,'Room B'),(1083,58,3,'Room C'),(1084,58,4,'Room D'),(1085,58,5,'Room E'),(1086,58,6,'Room F'),(1087,58,7,'Room G'),(1088,58,8,'Room H'),(1089,59,1,'Room A'),(1090,59,2,'Room B'),(1091,59,3,'Room C'),(1092,59,4,'Room D'),(1093,59,5,'Room E'),(1094,59,6,'Room F'),(1095,59,7,'Room G'),(1096,59,8,'Room H'),(1097,60,1,'Room A'),(1098,60,2,'Room B'),(1099,60,3,'Room C'),(1100,60,4,'Room D'),(1101,60,5,'Room E'),(1102,60,6,'Room F'),(1103,60,7,'Room G'),(1104,60,8,'Room H'),(1105,61,1,'Room A'),(1106,61,2,'Room B'),(1107,61,3,'Room C'),(1108,61,4,'Room D'),(1109,61,5,'Room E'),(1110,61,6,'Room F'),(1111,61,7,'Room G'),(1112,61,8,'Room H'),(1113,62,1,'Room A'),(1114,62,2,'Room B'),(1115,62,3,'Room C'),(1116,62,4,'Room D'),(1117,62,5,'Room E'),(1118,62,6,'Room F'),(1119,62,7,'Room G'),(1120,62,8,'Room H'),(1121,63,1,'Room A'),(1122,63,2,'Room B'),(1123,63,3,'Room C'),(1124,63,4,'Room D'),(1125,63,5,'Room E'),(1126,63,6,'Room F'),(1127,63,7,'Room G'),(1128,63,8,'Room H'),(1129,64,1,'Room A'),(1130,64,2,'Room B'),(1131,64,3,'Room C'),(1132,64,4,'Room D'),(1133,64,5,'Room E'),(1134,64,6,'Room F'),(1135,64,7,'Room G'),(1136,64,8,'Room H'),(1137,65,1,'Room A'),(1138,65,2,'Room B'),(1139,65,3,'Room C'),(1140,65,4,'Room D'),(1141,65,5,'Room E'),(1142,65,6,'Room F'),(1143,65,7,'Room G'),(1144,65,8,'Room H'),(1145,66,1,'Room A'),(1146,66,2,'Room B'),(1147,66,3,'Room C'),(1148,66,4,'Room D'),(1149,66,5,'Room E'),(1150,66,6,'Room F'),(1151,66,7,'Room G'),(1152,66,8,'Room H'),(1153,67,1,'Room A'),(1154,67,2,'Room B'),(1155,67,3,'Room C'),(1156,67,4,'Room D'),(1157,67,5,'Room E'),(1158,67,6,'Room F'),(1159,67,7,'Room G'),(1160,67,8,'Room H'),(1161,68,1,'Room A'),(1162,68,2,'Room B'),(1163,68,3,'Room C'),(1164,68,4,'Room D'),(1165,68,5,'Room E'),(1166,68,6,'Room F'),(1167,68,7,'Room G'),(1168,68,8,'Room H'),(1169,69,1,'Room A'),(1170,69,2,'Room B'),(1171,69,3,'Room C'),(1172,69,4,'Room D'),(1173,69,5,'Room E'),(1174,69,6,'Room F'),(1175,69,7,'Room G'),(1176,69,8,'Room H'),(1177,70,1,'Room A'),(1178,70,2,'Room B'),(1179,70,3,'Room C'),(1180,70,4,'Room D'),(1181,70,5,'Room E'),(1182,70,6,'Room F'),(1183,70,7,'Room G'),(1184,70,8,'Room H'),(1185,71,1,'Room A'),(1186,71,2,'Room B'),(1187,71,3,'Room C'),(1188,71,4,'Room D'),(1189,71,5,'Room E'),(1190,71,6,'Room F'),(1191,71,7,'Room G'),(1192,71,8,'Room H'),(1193,72,1,'Room A'),(1194,72,2,'Room B'),(1195,72,3,'Room C'),(1196,72,4,'Room D'),(1197,72,5,'Room E'),(1198,72,6,'Room F'),(1199,72,7,'Room G'),(1200,72,8,'Room H'),(1201,73,1,'Room A'),(1202,73,2,'Room B'),(1203,73,3,'Room C'),(1204,73,4,'Room D'),(1205,73,5,'Room E'),(1206,73,6,'Room F'),(1207,73,7,'Room G'),(1208,73,8,'Room H'),(1209,74,1,'Room A'),(1210,74,2,'Room B'),(1211,74,3,'Room C'),(1212,74,4,'Room D'),(1213,74,5,'Room E'),(1214,74,6,'Room F'),(1215,74,7,'Room G'),(1216,74,8,'Room H'),(1217,75,1,'Room A'),(1218,75,2,'Room B'),(1219,75,3,'Room C'),(1220,75,4,'Room D'),(1221,75,5,'Room E'),(1222,75,6,'Room F'),(1223,75,7,'Room G'),(1224,75,8,'Room H'),(1225,76,1,'Room A'),(1226,76,2,'Room B'),(1227,76,3,'Room C'),(1228,76,4,'Room D'),(1229,76,5,'Room E'),(1230,76,6,'Room F'),(1231,76,7,'Room G'),(1232,76,8,'Room H'),(1233,77,1,'Room A'),(1234,77,2,'Room B'),(1235,77,3,'Room C'),(1236,77,4,'Room D'),(1237,77,5,'Room E'),(1238,77,6,'Room F'),(1239,77,7,'Room G'),(1240,77,8,'Room H'),(1241,78,1,'Room A'),(1242,78,2,'Room B'),(1243,78,3,'Room C'),(1244,78,4,'Room D'),(1245,78,5,'Room E'),(1246,78,6,'Room F'),(1247,78,7,'Room G'),(1248,78,8,'Room H'),(1249,79,1,'Room A'),(1250,79,2,'Room B'),(1251,79,3,'Room C'),(1252,79,4,'Room D'),(1253,79,5,'Room E'),(1254,79,6,'Room F'),(1255,79,7,'Room G'),(1256,79,8,'Room H'),(1257,80,1,'Room A'),(1258,80,2,'Room B'),(1259,80,3,'Room C'),(1260,80,4,'Room D'),(1261,80,5,'Room E'),(1262,80,6,'Room F'),(1263,80,7,'Room G'),(1264,80,8,'Room H');
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screening_format`
--

DROP TABLE IF EXISTS `screening_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screening_format` (
  `screening_format_id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`screening_format_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screening_format`
--

LOCK TABLES `screening_format` WRITE;
/*!40000 ALTER TABLE `screening_format` DISABLE KEYS */;
INSERT INTO `screening_format` VALUES (1,'2D','Phim 2D tiêu chuẩn',50000.00),(2,'3D','Phim 3D',80000.00),(3,'IMAX','Phim IMAX',120000.00),(4,'4DX','Ghế chuyển động, hiệu ứng gió, nước, mùi hương',150000.00),(5,'GOLD CLASS','Ghế sofa đơn sang trọng, phục vụ trà/café tại chỗ',300000.00),(6,'BED-CINEMA','Phòng chiếu giường nằm cao cấp cho cặp đôi',500000.00),(7,'SWEETBOX','Ghế đôi có vách ngăn riêng tư ở cuối phòng',200000.00),(8,'KIDS','Phòng chiếu thiết kế riêng cho trẻ em với màu sắc sinh động',70000.00);
/*!40000 ALTER TABLE `screening_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat`
--

DROP TABLE IF EXISTS `seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat` (
  `seat_id` int unsigned NOT NULL AUTO_INCREMENT,
  `seat_type_id` int unsigned NOT NULL,
  `room_id` int unsigned NOT NULL,
  `row_name` varchar(5) NOT NULL,
  `seat_number` int NOT NULL,
  PRIMARY KEY (`seat_id`),
  UNIQUE KEY `uk_room_row_number` (`room_id`,`row_name`,`seat_number`),
  KEY `fk_seat_type` (`seat_type_id`),
  CONSTRAINT `fk_seat_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`),
  CONSTRAINT `fk_seat_type` FOREIGN KEY (`seat_type_id`) REFERENCES `seat_type` (`seat_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8204 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat`
--

LOCK TABLES `seat` WRITE;
/*!40000 ALTER TABLE `seat` DISABLE KEYS */;
INSERT INTO `seat` VALUES (1,1,1,'A',1),(2,1,1,'A',2),(3,1,1,'A',3),(4,1,1,'A',4),(5,1,1,'A',5),(6,1,1,'A',6),(7,1,1,'A',7),(8,1,1,'A',8),(9,1,1,'A',9),(10,1,1,'A',10),(11,1,1,'B',1),(12,1,1,'B',2),(13,1,1,'B',3),(14,1,1,'B',4),(15,1,1,'B',5),(16,1,1,'B',6),(17,1,1,'B',7),(18,1,1,'B',8),(19,1,1,'B',9),(20,1,1,'B',10),(21,1,1,'C',1),(22,1,1,'C',2),(23,1,1,'C',3),(24,1,1,'C',4),(25,1,1,'C',5),(26,1,1,'C',6),(27,1,1,'C',7),(28,1,1,'C',8),(29,1,1,'C',9),(30,1,1,'C',10),(31,1,1,'D',1),(32,1,1,'D',2),(33,1,1,'D',3),(34,1,1,'D',4),(35,1,1,'D',5),(36,1,1,'D',6),(37,1,1,'D',7),(38,1,1,'D',8),(39,1,1,'D',9),(40,1,1,'D',10),(41,1,1,'E',1),(42,1,1,'E',2),(43,1,1,'E',3),(44,1,1,'E',4),(45,1,1,'E',5),(46,1,1,'E',6),(47,1,1,'E',7),(48,1,1,'E',8),(49,1,1,'E',9),(50,1,1,'E',10),(51,2,1,'F',1),(52,2,1,'F',2),(53,2,1,'F',3),(54,2,1,'F',4),(55,2,1,'F',5),(56,2,1,'F',6),(57,2,1,'F',7),(58,2,1,'F',8),(59,2,1,'F',9),(60,2,1,'F',10),(61,2,1,'G',1),(62,2,1,'G',2),(63,2,1,'G',3),(64,2,1,'G',4),(65,2,1,'G',5),(66,2,1,'G',6),(67,2,1,'G',7),(68,2,1,'G',8),(69,2,1,'G',9),(70,2,1,'G',10),(71,5,1,'H',1),(72,5,1,'H',2),(73,5,1,'H',3),(74,5,1,'H',4),(75,5,1,'H',5),(76,5,1,'H',6),(77,5,1,'H',7),(78,5,1,'H',8),(79,5,1,'H',9),(80,5,1,'H',10),(81,4,1,'I',1),(82,4,1,'I',2),(83,4,1,'I',3),(84,4,1,'I',4),(85,4,1,'I',5),(86,4,1,'I',6),(87,4,1,'I',7),(88,4,1,'I',8),(89,4,1,'I',9),(90,4,1,'I',10),(91,3,1,'J',1),(92,3,1,'J',2),(93,3,1,'J',3),(94,3,1,'J',4),(95,3,1,'J',5),(96,3,1,'J',6),(97,3,1,'J',7),(98,3,1,'J',8),(99,3,1,'J',9),(100,3,1,'J',10),(101,1,9,'A',1),(102,1,9,'A',2),(103,1,9,'A',3),(104,1,9,'A',4),(105,1,9,'A',5),(106,1,9,'A',6),(107,1,9,'A',7),(108,1,9,'A',8),(109,1,9,'A',9),(110,1,9,'A',10),(111,1,9,'B',1),(112,1,9,'B',2),(113,1,9,'B',3),(114,1,9,'B',4),(115,1,9,'B',5),(116,1,9,'B',6),(117,1,9,'B',7),(118,1,9,'B',8),(119,1,9,'B',9),(120,1,9,'B',10),(121,1,9,'C',1),(122,1,9,'C',2),(123,1,9,'C',3),(124,1,9,'C',4),(125,1,9,'C',5),(126,1,9,'C',6),(127,1,9,'C',7),(128,1,9,'C',8),(129,1,9,'C',9),(130,1,9,'C',10),(131,1,9,'D',1),(132,1,9,'D',2),(133,1,9,'D',3),(134,1,9,'D',4),(135,1,9,'D',5),(136,1,9,'D',6),(137,1,9,'D',7),(138,1,9,'D',8),(139,1,9,'D',9),(140,1,9,'D',10),(141,1,9,'E',1),(142,1,9,'E',2),(143,1,9,'E',3),(144,1,9,'E',4),(145,1,9,'E',5),(146,1,9,'E',6),(147,1,9,'E',7),(148,1,9,'E',8),(149,1,9,'E',9),(150,1,9,'E',10),(151,2,9,'F',1),(152,2,9,'F',2),(153,2,9,'F',3),(154,2,9,'F',4),(155,2,9,'F',5),(156,2,9,'F',6),(157,2,9,'F',7),(158,2,9,'F',8),(159,2,9,'F',9),(160,2,9,'F',10),(161,2,9,'G',1),(162,2,9,'G',2),(163,2,9,'G',3),(164,2,9,'G',4),(165,2,9,'G',5),(166,2,9,'G',6),(167,2,9,'G',7),(168,2,9,'G',8),(169,2,9,'G',9),(170,2,9,'G',10),(171,5,9,'H',1),(172,5,9,'H',2),(173,5,9,'H',3),(174,5,9,'H',4),(175,5,9,'H',5),(176,5,9,'H',6),(177,5,9,'H',7),(178,5,9,'H',8),(179,5,9,'H',9),(180,5,9,'H',10),(181,4,9,'I',1),(182,4,9,'I',2),(183,4,9,'I',3),(184,4,9,'I',4),(185,4,9,'I',5),(186,4,9,'I',6),(187,4,9,'I',7),(188,4,9,'I',8),(189,4,9,'I',9),(190,4,9,'I',10),(191,3,9,'J',1),(192,3,9,'J',2),(193,3,9,'J',3),(194,3,9,'J',4),(195,3,9,'J',5),(196,3,9,'J',6),(197,3,9,'J',7),(198,3,9,'J',8),(199,3,9,'J',9),(200,3,9,'J',10),(401,1,33,'A',1),(402,1,33,'A',2),(403,1,33,'A',3),(404,1,33,'A',4),(405,1,33,'A',5),(406,1,33,'A',6),(407,1,33,'A',7),(408,1,33,'A',8),(409,1,33,'A',9),(410,1,33,'A',10),(411,1,33,'B',1),(412,1,33,'B',2),(413,1,33,'B',3),(414,1,33,'B',4),(415,1,33,'B',5),(416,1,33,'B',6),(417,1,33,'B',7),(418,1,33,'B',8),(419,1,33,'B',9),(420,1,33,'B',10),(421,1,33,'C',1),(422,1,33,'C',2),(423,1,33,'C',3),(424,1,33,'C',4),(425,1,33,'C',5),(426,1,33,'C',6),(427,1,33,'C',7),(428,1,33,'C',8),(429,1,33,'C',9),(430,1,33,'C',10),(431,1,33,'D',1),(432,1,33,'D',2),(433,1,33,'D',3),(434,1,33,'D',4),(435,1,33,'D',5),(436,1,33,'D',6),(437,1,33,'D',7),(438,1,33,'D',8),(439,1,33,'D',9),(440,1,33,'D',10),(441,1,33,'E',1),(442,1,33,'E',2),(443,1,33,'E',3),(444,1,33,'E',4),(445,1,33,'E',5),(446,1,33,'E',6),(447,1,33,'E',7),(448,1,33,'E',8),(449,1,33,'E',9),(450,1,33,'E',10),(451,2,33,'F',1),(452,2,33,'F',2),(453,2,33,'F',3),(454,2,33,'F',4),(455,2,33,'F',5),(456,2,33,'F',6),(457,2,33,'F',7),(458,2,33,'F',8),(459,2,33,'F',9),(460,2,33,'F',10),(461,2,33,'G',1),(462,2,33,'G',2),(463,2,33,'G',3),(464,2,33,'G',4),(465,2,33,'G',5),(466,2,33,'G',6),(467,2,33,'G',7),(468,2,33,'G',8),(469,2,33,'G',9),(470,2,33,'G',10),(471,5,33,'H',1),(472,5,33,'H',2),(473,5,33,'H',3),(474,5,33,'H',4),(475,5,33,'H',5),(476,5,33,'H',6),(477,5,33,'H',7),(478,5,33,'H',8),(479,5,33,'H',9),(480,5,33,'H',10),(481,4,33,'I',1),(482,4,33,'I',2),(483,4,33,'I',3),(484,4,33,'I',4),(485,4,33,'I',5),(486,4,33,'I',6),(487,4,33,'I',7),(488,4,33,'I',8),(489,4,33,'I',9),(490,4,33,'I',10),(491,3,33,'J',1),(492,3,33,'J',2),(493,3,33,'J',3),(494,3,33,'J',4),(495,3,33,'J',5),(496,3,33,'J',6),(497,3,33,'J',7),(498,3,33,'J',8),(499,3,33,'J',9),(500,3,33,'J',10),(501,1,41,'A',1),(502,1,41,'A',2),(503,1,41,'A',3),(504,1,41,'A',4),(505,1,41,'A',5),(506,1,41,'A',6),(507,1,41,'A',7),(508,1,41,'A',8),(509,1,41,'A',9),(510,1,41,'A',10),(511,1,41,'B',1),(512,1,41,'B',2),(513,1,41,'B',3),(514,1,41,'B',4),(515,1,41,'B',5),(516,1,41,'B',6),(517,1,41,'B',7),(518,1,41,'B',8),(519,1,41,'B',9),(520,1,41,'B',10),(521,1,41,'C',1),(522,1,41,'C',2),(523,1,41,'C',3),(524,1,41,'C',4),(525,1,41,'C',5),(526,1,41,'C',6),(527,1,41,'C',7),(528,1,41,'C',8),(529,1,41,'C',9),(530,1,41,'C',10),(531,1,41,'D',1),(532,1,41,'D',2),(533,1,41,'D',3),(534,1,41,'D',4),(535,1,41,'D',5),(536,1,41,'D',6),(537,1,41,'D',7),(538,1,41,'D',8),(539,1,41,'D',9),(540,1,41,'D',10),(541,1,41,'E',1),(542,1,41,'E',2),(543,1,41,'E',3),(544,1,41,'E',4),(545,1,41,'E',5),(546,1,41,'E',6),(547,1,41,'E',7),(548,1,41,'E',8),(549,1,41,'E',9),(550,1,41,'E',10),(551,2,41,'F',1),(552,2,41,'F',2),(553,2,41,'F',3),(554,2,41,'F',4),(555,2,41,'F',5),(556,2,41,'F',6),(557,2,41,'F',7),(558,2,41,'F',8),(559,2,41,'F',9),(560,2,41,'F',10),(561,2,41,'G',1),(562,2,41,'G',2),(563,2,41,'G',3),(564,2,41,'G',4),(565,2,41,'G',5),(566,2,41,'G',6),(567,2,41,'G',7),(568,2,41,'G',8),(569,2,41,'G',9),(570,2,41,'G',10),(571,5,41,'H',1),(572,5,41,'H',2),(573,5,41,'H',3),(574,5,41,'H',4),(575,5,41,'H',5),(576,5,41,'H',6),(577,5,41,'H',7),(578,5,41,'H',8),(579,5,41,'H',9),(580,5,41,'H',10),(581,4,41,'I',1),(582,4,41,'I',2),(583,4,41,'I',3),(584,4,41,'I',4),(585,4,41,'I',5),(586,4,41,'I',6),(587,4,41,'I',7),(588,4,41,'I',8),(589,4,41,'I',9),(590,4,41,'I',10),(591,3,41,'J',1),(592,3,41,'J',2),(593,3,41,'J',3),(594,3,41,'J',4),(595,3,41,'J',5),(596,3,41,'J',6),(597,3,41,'J',7),(598,3,41,'J',8),(599,3,41,'J',9),(600,3,41,'J',10),(601,1,49,'A',1),(602,1,49,'A',2),(603,1,49,'A',3),(604,1,49,'A',4),(605,1,49,'A',5),(606,1,49,'A',6),(607,1,49,'A',7),(608,1,49,'A',8),(609,1,49,'A',9),(610,1,49,'A',10),(611,1,49,'B',1),(612,1,49,'B',2),(613,1,49,'B',3),(614,1,49,'B',4),(615,1,49,'B',5),(616,1,49,'B',6),(617,1,49,'B',7),(618,1,49,'B',8),(619,1,49,'B',9),(620,1,49,'B',10),(621,1,49,'C',1),(622,1,49,'C',2),(623,1,49,'C',3),(624,1,49,'C',4),(625,1,49,'C',5),(626,1,49,'C',6),(627,1,49,'C',7),(628,1,49,'C',8),(629,1,49,'C',9),(630,1,49,'C',10),(631,1,49,'D',1),(632,1,49,'D',2),(633,1,49,'D',3),(634,1,49,'D',4),(635,1,49,'D',5),(636,1,49,'D',6),(637,1,49,'D',7),(638,1,49,'D',8),(639,1,49,'D',9),(640,1,49,'D',10),(641,1,49,'E',1),(642,1,49,'E',2),(643,1,49,'E',3),(644,1,49,'E',4),(645,1,49,'E',5),(646,1,49,'E',6),(647,1,49,'E',7),(648,1,49,'E',8),(649,1,49,'E',9),(650,1,49,'E',10),(651,2,49,'F',1),(652,2,49,'F',2),(653,2,49,'F',3),(654,2,49,'F',4),(655,2,49,'F',5),(656,2,49,'F',6),(657,2,49,'F',7),(658,2,49,'F',8),(659,2,49,'F',9),(660,2,49,'F',10),(661,2,49,'G',1),(662,2,49,'G',2),(663,2,49,'G',3),(664,2,49,'G',4),(665,2,49,'G',5),(666,2,49,'G',6),(667,2,49,'G',7),(668,2,49,'G',8),(669,2,49,'G',9),(670,2,49,'G',10),(671,5,49,'H',1),(672,5,49,'H',2),(673,5,49,'H',3),(674,5,49,'H',4),(675,5,49,'H',5),(676,5,49,'H',6),(677,5,49,'H',7),(678,5,49,'H',8),(679,5,49,'H',9),(680,5,49,'H',10),(681,4,49,'I',1),(682,4,49,'I',2),(683,4,49,'I',3),(684,4,49,'I',4),(685,4,49,'I',5),(686,4,49,'I',6),(687,4,49,'I',7),(688,4,49,'I',8),(689,4,49,'I',9),(690,4,49,'I',10),(691,3,49,'J',1),(692,3,49,'J',2),(693,3,49,'J',3),(694,3,49,'J',4),(695,3,49,'J',5),(696,3,49,'J',6),(697,3,49,'J',7),(698,3,49,'J',8),(699,3,49,'J',9),(700,3,49,'J',10),(701,1,57,'A',1),(702,1,57,'A',2),(703,1,57,'A',3),(704,1,57,'A',4),(705,1,57,'A',5),(706,1,57,'A',6),(707,1,57,'A',7),(708,1,57,'A',8),(709,1,57,'A',9),(710,1,57,'A',10),(711,1,57,'B',1),(712,1,57,'B',2),(713,1,57,'B',3),(714,1,57,'B',4),(715,1,57,'B',5),(716,1,57,'B',6),(717,1,57,'B',7),(718,1,57,'B',8),(719,1,57,'B',9),(720,1,57,'B',10),(721,1,57,'C',1),(722,1,57,'C',2),(723,1,57,'C',3),(724,1,57,'C',4),(725,1,57,'C',5),(726,1,57,'C',6),(727,1,57,'C',7),(728,1,57,'C',8),(729,1,57,'C',9),(730,1,57,'C',10),(731,1,57,'D',1),(732,1,57,'D',2),(733,1,57,'D',3),(734,1,57,'D',4),(735,1,57,'D',5),(736,1,57,'D',6),(737,1,57,'D',7),(738,1,57,'D',8),(739,1,57,'D',9),(740,1,57,'D',10),(741,1,57,'E',1),(742,1,57,'E',2),(743,1,57,'E',3),(744,1,57,'E',4),(745,1,57,'E',5),(746,1,57,'E',6),(747,1,57,'E',7),(748,1,57,'E',8),(749,1,57,'E',9),(750,1,57,'E',10),(751,2,57,'F',1),(752,2,57,'F',2),(753,2,57,'F',3),(754,2,57,'F',4),(755,2,57,'F',5),(756,2,57,'F',6),(757,2,57,'F',7),(758,2,57,'F',8),(759,2,57,'F',9),(760,2,57,'F',10),(761,2,57,'G',1),(762,2,57,'G',2),(763,2,57,'G',3),(764,2,57,'G',4),(765,2,57,'G',5),(766,2,57,'G',6),(767,2,57,'G',7),(768,2,57,'G',8),(769,2,57,'G',9),(770,2,57,'G',10),(771,5,57,'H',1),(772,5,57,'H',2),(773,5,57,'H',3),(774,5,57,'H',4),(775,5,57,'H',5),(776,5,57,'H',6),(777,5,57,'H',7),(778,5,57,'H',8),(779,5,57,'H',9),(780,5,57,'H',10),(781,4,57,'I',1),(782,4,57,'I',2),(783,4,57,'I',3),(784,4,57,'I',4),(785,4,57,'I',5),(786,4,57,'I',6),(787,4,57,'I',7),(788,4,57,'I',8),(789,4,57,'I',9),(790,4,57,'I',10),(791,3,57,'J',1),(792,3,57,'J',2),(793,3,57,'J',3),(794,3,57,'J',4),(795,3,57,'J',5),(796,3,57,'J',6),(797,3,57,'J',7),(798,3,57,'J',8),(799,3,57,'J',9),(800,3,57,'J',10),(801,1,65,'A',1),(802,1,65,'A',2),(803,1,65,'A',3),(804,1,65,'A',4),(805,1,65,'A',5),(806,1,65,'A',6),(807,1,65,'A',7),(808,1,65,'A',8),(809,1,65,'A',9),(810,1,65,'A',10),(811,1,65,'B',1),(812,1,65,'B',2),(813,1,65,'B',3),(814,1,65,'B',4),(815,1,65,'B',5),(816,1,65,'B',6),(817,1,65,'B',7),(818,1,65,'B',8),(819,1,65,'B',9),(820,1,65,'B',10),(821,1,65,'C',1),(822,1,65,'C',2),(823,1,65,'C',3),(824,1,65,'C',4),(825,1,65,'C',5),(826,1,65,'C',6),(827,1,65,'C',7),(828,1,65,'C',8),(829,1,65,'C',9),(830,1,65,'C',10),(831,1,65,'D',1),(832,1,65,'D',2),(833,1,65,'D',3),(834,1,65,'D',4),(835,1,65,'D',5),(836,1,65,'D',6),(837,1,65,'D',7),(838,1,65,'D',8),(839,1,65,'D',9),(840,1,65,'D',10),(841,1,65,'E',1),(842,1,65,'E',2),(843,1,65,'E',3),(844,1,65,'E',4),(845,1,65,'E',5),(846,1,65,'E',6),(847,1,65,'E',7),(848,1,65,'E',8),(849,1,65,'E',9),(850,1,65,'E',10),(851,2,65,'F',1),(852,2,65,'F',2),(853,2,65,'F',3),(854,2,65,'F',4),(855,2,65,'F',5),(856,2,65,'F',6),(857,2,65,'F',7),(858,2,65,'F',8),(859,2,65,'F',9),(860,2,65,'F',10),(861,2,65,'G',1),(862,2,65,'G',2),(863,2,65,'G',3),(864,2,65,'G',4),(865,2,65,'G',5),(866,2,65,'G',6),(867,2,65,'G',7),(868,2,65,'G',8),(869,2,65,'G',9),(870,2,65,'G',10),(871,5,65,'H',1),(872,5,65,'H',2),(873,5,65,'H',3),(874,5,65,'H',4),(875,5,65,'H',5),(876,5,65,'H',6),(877,5,65,'H',7),(878,5,65,'H',8),(879,5,65,'H',9),(880,5,65,'H',10),(881,4,65,'I',1),(882,4,65,'I',2),(883,4,65,'I',3),(884,4,65,'I',4),(885,4,65,'I',5),(886,4,65,'I',6),(887,4,65,'I',7),(888,4,65,'I',8),(889,4,65,'I',9),(890,4,65,'I',10),(891,3,65,'J',1),(892,3,65,'J',2),(893,3,65,'J',3),(894,3,65,'J',4),(895,3,65,'J',5),(896,3,65,'J',6),(897,3,65,'J',7),(898,3,65,'J',8),(899,3,65,'J',9),(900,3,65,'J',10),(901,1,73,'A',1),(902,1,73,'A',2),(903,1,73,'A',3),(904,1,73,'A',4),(905,1,73,'A',5),(906,1,73,'A',6),(907,1,73,'A',7),(908,1,73,'A',8),(909,1,73,'A',9),(910,1,73,'A',10),(911,1,73,'B',1),(912,1,73,'B',2),(913,1,73,'B',3),(914,1,73,'B',4),(915,1,73,'B',5),(916,1,73,'B',6),(917,1,73,'B',7),(918,1,73,'B',8),(919,1,73,'B',9),(920,1,73,'B',10),(921,1,73,'C',1),(922,1,73,'C',2),(923,1,73,'C',3),(924,1,73,'C',4),(925,1,73,'C',5),(926,1,73,'C',6),(927,1,73,'C',7),(928,1,73,'C',8),(929,1,73,'C',9),(930,1,73,'C',10),(931,1,73,'D',1),(932,1,73,'D',2),(933,1,73,'D',3),(934,1,73,'D',4),(935,1,73,'D',5),(936,1,73,'D',6),(937,1,73,'D',7),(938,1,73,'D',8),(939,1,73,'D',9),(940,1,73,'D',10),(941,1,73,'E',1),(942,1,73,'E',2),(943,1,73,'E',3),(944,1,73,'E',4),(945,1,73,'E',5),(946,1,73,'E',6),(947,1,73,'E',7),(948,1,73,'E',8),(949,1,73,'E',9),(950,1,73,'E',10),(951,2,73,'F',1),(952,2,73,'F',2),(953,2,73,'F',3),(954,2,73,'F',4),(955,2,73,'F',5),(956,2,73,'F',6),(957,2,73,'F',7),(958,2,73,'F',8),(959,2,73,'F',9),(960,2,73,'F',10),(961,2,73,'G',1),(962,2,73,'G',2),(963,2,73,'G',3),(964,2,73,'G',4),(965,2,73,'G',5),(966,2,73,'G',6),(967,2,73,'G',7),(968,2,73,'G',8),(969,2,73,'G',9),(970,2,73,'G',10),(971,5,73,'H',1),(972,5,73,'H',2),(973,5,73,'H',3),(974,5,73,'H',4),(975,5,73,'H',5),(976,5,73,'H',6),(977,5,73,'H',7),(978,5,73,'H',8),(979,5,73,'H',9),(980,5,73,'H',10),(981,4,73,'I',1),(982,4,73,'I',2),(983,4,73,'I',3),(984,4,73,'I',4),(985,4,73,'I',5),(986,4,73,'I',6),(987,4,73,'I',7),(988,4,73,'I',8),(989,4,73,'I',9),(990,4,73,'I',10),(991,3,73,'J',1),(992,3,73,'J',2),(993,3,73,'J',3),(994,3,73,'J',4),(995,3,73,'J',5),(996,3,73,'J',6),(997,3,73,'J',7),(998,3,73,'J',8),(999,3,73,'J',9),(1000,3,73,'J',10),(1001,1,81,'A',1),(1002,1,81,'A',2),(1003,1,81,'A',3),(1004,1,81,'A',4),(1005,1,81,'A',5),(1006,1,81,'A',6),(1007,1,81,'A',7),(1008,1,81,'A',8),(1009,1,81,'A',9),(1010,1,81,'A',10),(1011,1,81,'B',1),(1012,1,81,'B',2),(1013,1,81,'B',3),(1014,1,81,'B',4),(1015,1,81,'B',5),(1016,1,81,'B',6),(1017,1,81,'B',7),(1018,1,81,'B',8),(1019,1,81,'B',9),(1020,1,81,'B',10),(1021,1,81,'C',1),(1022,1,81,'C',2),(1023,1,81,'C',3),(1024,1,81,'C',4),(1025,1,81,'C',5),(1026,1,81,'C',6),(1027,1,81,'C',7),(1028,1,81,'C',8),(1029,1,81,'C',9),(1030,1,81,'C',10),(1031,1,81,'D',1),(1032,1,81,'D',2),(1033,1,81,'D',3),(1034,1,81,'D',4),(1035,1,81,'D',5),(1036,1,81,'D',6),(1037,1,81,'D',7),(1038,1,81,'D',8),(1039,1,81,'D',9),(1040,1,81,'D',10),(1041,1,81,'E',1),(1042,1,81,'E',2),(1043,1,81,'E',3),(1044,1,81,'E',4),(1045,1,81,'E',5),(1046,1,81,'E',6),(1047,1,81,'E',7),(1048,1,81,'E',8),(1049,1,81,'E',9),(1050,1,81,'E',10),(1051,2,81,'F',1),(1052,2,81,'F',2),(1053,2,81,'F',3),(1054,2,81,'F',4),(1055,2,81,'F',5),(1056,2,81,'F',6),(1057,2,81,'F',7),(1058,2,81,'F',8),(1059,2,81,'F',9),(1060,2,81,'F',10),(1061,2,81,'G',1),(1062,2,81,'G',2),(1063,2,81,'G',3),(1064,2,81,'G',4),(1065,2,81,'G',5),(1066,2,81,'G',6),(1067,2,81,'G',7),(1068,2,81,'G',8),(1069,2,81,'G',9),(1070,2,81,'G',10),(1071,5,81,'H',1),(1072,5,81,'H',2),(1073,5,81,'H',3),(1074,5,81,'H',4),(1075,5,81,'H',5),(1076,5,81,'H',6),(1077,5,81,'H',7),(1078,5,81,'H',8),(1079,5,81,'H',9),(1080,5,81,'H',10),(1081,4,81,'I',1),(1082,4,81,'I',2),(1083,4,81,'I',3),(1084,4,81,'I',4),(1085,4,81,'I',5),(1086,4,81,'I',6),(1087,4,81,'I',7),(1088,4,81,'I',8),(1089,4,81,'I',9),(1090,4,81,'I',10),(1091,3,81,'J',1),(1092,3,81,'J',2),(1093,3,81,'J',3),(1094,3,81,'J',4),(1095,3,81,'J',5),(1096,3,81,'J',6),(1097,3,81,'J',7),(1098,3,81,'J',8),(1099,3,81,'J',9),(1100,3,81,'J',10),(1101,1,89,'A',1),(1102,1,89,'A',2),(1103,1,89,'A',3),(1104,1,89,'A',4),(1105,1,89,'A',5),(1106,1,89,'A',6),(1107,1,89,'A',7),(1108,1,89,'A',8),(1109,1,89,'A',9),(1110,1,89,'A',10),(1111,1,89,'B',1),(1112,1,89,'B',2),(1113,1,89,'B',3),(1114,1,89,'B',4),(1115,1,89,'B',5),(1116,1,89,'B',6),(1117,1,89,'B',7),(1118,1,89,'B',8),(1119,1,89,'B',9),(1120,1,89,'B',10),(1121,1,89,'C',1),(1122,1,89,'C',2),(1123,1,89,'C',3),(1124,1,89,'C',4),(1125,1,89,'C',5),(1126,1,89,'C',6),(1127,1,89,'C',7),(1128,1,89,'C',8),(1129,1,89,'C',9),(1130,1,89,'C',10),(1131,1,89,'D',1),(1132,1,89,'D',2),(1133,1,89,'D',3),(1134,1,89,'D',4),(1135,1,89,'D',5),(1136,1,89,'D',6),(1137,1,89,'D',7),(1138,1,89,'D',8),(1139,1,89,'D',9),(1140,1,89,'D',10),(1141,1,89,'E',1),(1142,1,89,'E',2),(1143,1,89,'E',3),(1144,1,89,'E',4),(1145,1,89,'E',5),(1146,1,89,'E',6),(1147,1,89,'E',7),(1148,1,89,'E',8),(1149,1,89,'E',9),(1150,1,89,'E',10),(1151,2,89,'F',1),(1152,2,89,'F',2),(1153,2,89,'F',3),(1154,2,89,'F',4),(1155,2,89,'F',5),(1156,2,89,'F',6),(1157,2,89,'F',7),(1158,2,89,'F',8),(1159,2,89,'F',9),(1160,2,89,'F',10),(1161,2,89,'G',1),(1162,2,89,'G',2),(1163,2,89,'G',3),(1164,2,89,'G',4),(1165,2,89,'G',5),(1166,2,89,'G',6),(1167,2,89,'G',7),(1168,2,89,'G',8),(1169,2,89,'G',9),(1170,2,89,'G',10),(1171,5,89,'H',1),(1172,5,89,'H',2),(1173,5,89,'H',3),(1174,5,89,'H',4),(1175,5,89,'H',5),(1176,5,89,'H',6),(1177,5,89,'H',7),(1178,5,89,'H',8),(1179,5,89,'H',9),(1180,5,89,'H',10),(1181,4,89,'I',1),(1182,4,89,'I',2),(1183,4,89,'I',3),(1184,4,89,'I',4),(1185,4,89,'I',5),(1186,4,89,'I',6),(1187,4,89,'I',7),(1188,4,89,'I',8),(1189,4,89,'I',9),(1190,4,89,'I',10),(1191,3,89,'J',1),(1192,3,89,'J',2),(1193,3,89,'J',3),(1194,3,89,'J',4),(1195,3,89,'J',5),(1196,3,89,'J',6),(1197,3,89,'J',7),(1198,3,89,'J',8),(1199,3,89,'J',9),(1200,3,89,'J',10),(1201,1,97,'A',1),(1202,1,97,'A',2),(1203,1,97,'A',3),(1204,1,97,'A',4),(1205,1,97,'A',5),(1206,1,97,'A',6),(1207,1,97,'A',7),(1208,1,97,'A',8),(1209,1,97,'A',9),(1210,1,97,'A',10),(1211,1,97,'B',1),(1212,1,97,'B',2),(1213,1,97,'B',3),(1214,1,97,'B',4),(1215,1,97,'B',5),(1216,1,97,'B',6),(1217,1,97,'B',7),(1218,1,97,'B',8),(1219,1,97,'B',9),(1220,1,97,'B',10),(1221,1,97,'C',1),(1222,1,97,'C',2),(1223,1,97,'C',3),(1224,1,97,'C',4),(1225,1,97,'C',5),(1226,1,97,'C',6),(1227,1,97,'C',7),(1228,1,97,'C',8),(1229,1,97,'C',9),(1230,1,97,'C',10),(1231,1,97,'D',1),(1232,1,97,'D',2),(1233,1,97,'D',3),(1234,1,97,'D',4),(1235,1,97,'D',5),(1236,1,97,'D',6),(1237,1,97,'D',7),(1238,1,97,'D',8),(1239,1,97,'D',9),(1240,1,97,'D',10),(1241,1,97,'E',1),(1242,1,97,'E',2),(1243,1,97,'E',3),(1244,1,97,'E',4),(1245,1,97,'E',5),(1246,1,97,'E',6),(1247,1,97,'E',7),(1248,1,97,'E',8),(1249,1,97,'E',9),(1250,1,97,'E',10),(1251,2,97,'F',1),(1252,2,97,'F',2),(1253,2,97,'F',3),(1254,2,97,'F',4),(1255,2,97,'F',5),(1256,2,97,'F',6),(1257,2,97,'F',7),(1258,2,97,'F',8),(1259,2,97,'F',9),(1260,2,97,'F',10),(1261,2,97,'G',1),(1262,2,97,'G',2),(1263,2,97,'G',3),(1264,2,97,'G',4),(1265,2,97,'G',5),(1266,2,97,'G',6),(1267,2,97,'G',7),(1268,2,97,'G',8),(1269,2,97,'G',9),(1270,2,97,'G',10),(1271,5,97,'H',1),(1272,5,97,'H',2),(1273,5,97,'H',3),(1274,5,97,'H',4),(1275,5,97,'H',5),(1276,5,97,'H',6),(1277,5,97,'H',7),(1278,5,97,'H',8),(1279,5,97,'H',9),(1280,5,97,'H',10),(1281,4,97,'I',1),(1282,4,97,'I',2),(1283,4,97,'I',3),(1284,4,97,'I',4),(1285,4,97,'I',5),(1286,4,97,'I',6),(1287,4,97,'I',7),(1288,4,97,'I',8),(1289,4,97,'I',9),(1290,4,97,'I',10),(1291,3,97,'J',1),(1292,3,97,'J',2),(1293,3,97,'J',3),(1294,3,97,'J',4),(1295,3,97,'J',5),(1296,3,97,'J',6),(1297,3,97,'J',7),(1298,3,97,'J',8),(1299,3,97,'J',9),(1300,3,97,'J',10),(1301,1,105,'A',1),(1302,1,105,'A',2),(1303,1,105,'A',3),(1304,1,105,'A',4),(1305,1,105,'A',5),(1306,1,105,'A',6),(1307,1,105,'A',7),(1308,1,105,'A',8),(1309,1,105,'A',9),(1310,1,105,'A',10),(1311,1,105,'B',1),(1312,1,105,'B',2),(1313,1,105,'B',3),(1314,1,105,'B',4),(1315,1,105,'B',5),(1316,1,105,'B',6),(1317,1,105,'B',7),(1318,1,105,'B',8),(1319,1,105,'B',9),(1320,1,105,'B',10),(1321,1,105,'C',1),(1322,1,105,'C',2),(1323,1,105,'C',3),(1324,1,105,'C',4),(1325,1,105,'C',5),(1326,1,105,'C',6),(1327,1,105,'C',7),(1328,1,105,'C',8),(1329,1,105,'C',9),(1330,1,105,'C',10),(1331,1,105,'D',1),(1332,1,105,'D',2),(1333,1,105,'D',3),(1334,1,105,'D',4),(1335,1,105,'D',5),(1336,1,105,'D',6),(1337,1,105,'D',7),(1338,1,105,'D',8),(1339,1,105,'D',9),(1340,1,105,'D',10),(1341,1,105,'E',1),(1342,1,105,'E',2),(1343,1,105,'E',3),(1344,1,105,'E',4),(1345,1,105,'E',5),(1346,1,105,'E',6),(1347,1,105,'E',7),(1348,1,105,'E',8),(1349,1,105,'E',9),(1350,1,105,'E',10),(1351,2,105,'F',1),(1352,2,105,'F',2),(1353,2,105,'F',3),(1354,2,105,'F',4),(1355,2,105,'F',5),(1356,2,105,'F',6),(1357,2,105,'F',7),(1358,2,105,'F',8),(1359,2,105,'F',9),(1360,2,105,'F',10),(1361,2,105,'G',1),(1362,2,105,'G',2),(1363,2,105,'G',3),(1364,2,105,'G',4),(1365,2,105,'G',5),(1366,2,105,'G',6),(1367,2,105,'G',7),(1368,2,105,'G',8),(1369,2,105,'G',9),(1370,2,105,'G',10),(1371,5,105,'H',1),(1372,5,105,'H',2),(1373,5,105,'H',3),(1374,5,105,'H',4),(1375,5,105,'H',5),(1376,5,105,'H',6),(1377,5,105,'H',7),(1378,5,105,'H',8),(1379,5,105,'H',9),(1380,5,105,'H',10),(1381,4,105,'I',1),(1382,4,105,'I',2),(1383,4,105,'I',3),(1384,4,105,'I',4),(1385,4,105,'I',5),(1386,4,105,'I',6),(1387,4,105,'I',7),(1388,4,105,'I',8),(1389,4,105,'I',9),(1390,4,105,'I',10),(1391,3,105,'J',1),(1392,3,105,'J',2),(1393,3,105,'J',3),(1394,3,105,'J',4),(1395,3,105,'J',5),(1396,3,105,'J',6),(1397,3,105,'J',7),(1398,3,105,'J',8),(1399,3,105,'J',9),(1400,3,105,'J',10),(1401,1,113,'A',1),(1402,1,113,'A',2),(1403,1,113,'A',3),(1404,1,113,'A',4),(1405,1,113,'A',5),(1406,1,113,'A',6),(1407,1,113,'A',7),(1408,1,113,'A',8),(1409,1,113,'A',9),(1410,1,113,'A',10),(1411,1,113,'B',1),(1412,1,113,'B',2),(1413,1,113,'B',3),(1414,1,113,'B',4),(1415,1,113,'B',5),(1416,1,113,'B',6),(1417,1,113,'B',7),(1418,1,113,'B',8),(1419,1,113,'B',9),(1420,1,113,'B',10),(1421,1,113,'C',1),(1422,1,113,'C',2),(1423,1,113,'C',3),(1424,1,113,'C',4),(1425,1,113,'C',5),(1426,1,113,'C',6),(1427,1,113,'C',7),(1428,1,113,'C',8),(1429,1,113,'C',9),(1430,1,113,'C',10),(1431,1,113,'D',1),(1432,1,113,'D',2),(1433,1,113,'D',3),(1434,1,113,'D',4),(1435,1,113,'D',5),(1436,1,113,'D',6),(1437,1,113,'D',7),(1438,1,113,'D',8),(1439,1,113,'D',9),(1440,1,113,'D',10),(1441,1,113,'E',1),(1442,1,113,'E',2),(1443,1,113,'E',3),(1444,1,113,'E',4),(1445,1,113,'E',5),(1446,1,113,'E',6),(1447,1,113,'E',7),(1448,1,113,'E',8),(1449,1,113,'E',9),(1450,1,113,'E',10),(1451,2,113,'F',1),(1452,2,113,'F',2),(1453,2,113,'F',3),(1454,2,113,'F',4),(1455,2,113,'F',5),(1456,2,113,'F',6),(1457,2,113,'F',7),(1458,2,113,'F',8),(1459,2,113,'F',9),(1460,2,113,'F',10),(1461,2,113,'G',1),(1462,2,113,'G',2),(1463,2,113,'G',3),(1464,2,113,'G',4),(1465,2,113,'G',5),(1466,2,113,'G',6),(1467,2,113,'G',7),(1468,2,113,'G',8),(1469,2,113,'G',9),(1470,2,113,'G',10),(1471,5,113,'H',1),(1472,5,113,'H',2),(1473,5,113,'H',3),(1474,5,113,'H',4),(1475,5,113,'H',5),(1476,5,113,'H',6),(1477,5,113,'H',7),(1478,5,113,'H',8),(1479,5,113,'H',9),(1480,5,113,'H',10),(1481,4,113,'I',1),(1482,4,113,'I',2),(1483,4,113,'I',3),(1484,4,113,'I',4),(1485,4,113,'I',5),(1486,4,113,'I',6),(1487,4,113,'I',7),(1488,4,113,'I',8),(1489,4,113,'I',9),(1490,4,113,'I',10),(1491,3,113,'J',1),(1492,3,113,'J',2),(1493,3,113,'J',3),(1494,3,113,'J',4),(1495,3,113,'J',5),(1496,3,113,'J',6),(1497,3,113,'J',7),(1498,3,113,'J',8),(1499,3,113,'J',9),(1500,3,113,'J',10),(1501,1,121,'A',1),(1502,1,121,'A',2),(1503,1,121,'A',3),(1504,1,121,'A',4),(1505,1,121,'A',5),(1506,1,121,'A',6),(1507,1,121,'A',7),(1508,1,121,'A',8),(1509,1,121,'A',9),(1510,1,121,'A',10),(1511,1,121,'B',1),(1512,1,121,'B',2),(1513,1,121,'B',3),(1514,1,121,'B',4),(1515,1,121,'B',5),(1516,1,121,'B',6),(1517,1,121,'B',7),(1518,1,121,'B',8),(1519,1,121,'B',9),(1520,1,121,'B',10),(1521,1,121,'C',1),(1522,1,121,'C',2),(1523,1,121,'C',3),(1524,1,121,'C',4),(1525,1,121,'C',5),(1526,1,121,'C',6),(1527,1,121,'C',7),(1528,1,121,'C',8),(1529,1,121,'C',9),(1530,1,121,'C',10),(1531,1,121,'D',1),(1532,1,121,'D',2),(1533,1,121,'D',3),(1534,1,121,'D',4),(1535,1,121,'D',5),(1536,1,121,'D',6),(1537,1,121,'D',7),(1538,1,121,'D',8),(1539,1,121,'D',9),(1540,1,121,'D',10),(1541,1,121,'E',1),(1542,1,121,'E',2),(1543,1,121,'E',3),(1544,1,121,'E',4),(1545,1,121,'E',5),(1546,1,121,'E',6),(1547,1,121,'E',7),(1548,1,121,'E',8),(1549,1,121,'E',9),(1550,1,121,'E',10),(1551,2,121,'F',1),(1552,2,121,'F',2),(1553,2,121,'F',3),(1554,2,121,'F',4),(1555,2,121,'F',5),(1556,2,121,'F',6),(1557,2,121,'F',7),(1558,2,121,'F',8),(1559,2,121,'F',9),(1560,2,121,'F',10),(1561,2,121,'G',1),(1562,2,121,'G',2),(1563,2,121,'G',3),(1564,2,121,'G',4),(1565,2,121,'G',5),(1566,2,121,'G',6),(1567,2,121,'G',7),(1568,2,121,'G',8),(1569,2,121,'G',9),(1570,2,121,'G',10),(1571,5,121,'H',1),(1572,5,121,'H',2),(1573,5,121,'H',3),(1574,5,121,'H',4),(1575,5,121,'H',5),(1576,5,121,'H',6),(1577,5,121,'H',7),(1578,5,121,'H',8),(1579,5,121,'H',9),(1580,5,121,'H',10),(1581,4,121,'I',1),(1582,4,121,'I',2),(1583,4,121,'I',3),(1584,4,121,'I',4),(1585,4,121,'I',5),(1586,4,121,'I',6),(1587,4,121,'I',7),(1588,4,121,'I',8),(1589,4,121,'I',9),(1590,4,121,'I',10),(1591,3,121,'J',1),(1592,3,121,'J',2),(1593,3,121,'J',3),(1594,3,121,'J',4),(1595,3,121,'J',5),(1596,3,121,'J',6),(1597,3,121,'J',7),(1598,3,121,'J',8),(1599,3,121,'J',9),(1600,3,121,'J',10),(1601,1,129,'A',1),(1602,1,129,'A',2),(1603,1,129,'A',3),(1604,1,129,'A',4),(1605,1,129,'A',5),(1606,1,129,'A',6),(1607,1,129,'A',7),(1608,1,129,'A',8),(1609,1,129,'A',9),(1610,1,129,'A',10),(1611,1,129,'B',1),(1612,1,129,'B',2),(1613,1,129,'B',3),(1614,1,129,'B',4),(1615,1,129,'B',5),(1616,1,129,'B',6),(1617,1,129,'B',7),(1618,1,129,'B',8),(1619,1,129,'B',9),(1620,1,129,'B',10),(1621,1,129,'C',1),(1622,1,129,'C',2),(1623,1,129,'C',3),(1624,1,129,'C',4),(1625,1,129,'C',5),(1626,1,129,'C',6),(1627,1,129,'C',7),(1628,1,129,'C',8),(1629,1,129,'C',9),(1630,1,129,'C',10),(1631,1,129,'D',1),(1632,1,129,'D',2),(1633,1,129,'D',3),(1634,1,129,'D',4),(1635,1,129,'D',5),(1636,1,129,'D',6),(1637,1,129,'D',7),(1638,1,129,'D',8),(1639,1,129,'D',9),(1640,1,129,'D',10),(1641,1,129,'E',1),(1642,1,129,'E',2),(1643,1,129,'E',3),(1644,1,129,'E',4),(1645,1,129,'E',5),(1646,1,129,'E',6),(1647,1,129,'E',7),(1648,1,129,'E',8),(1649,1,129,'E',9),(1650,1,129,'E',10),(1651,2,129,'F',1),(1652,2,129,'F',2),(1653,2,129,'F',3),(1654,2,129,'F',4),(1655,2,129,'F',5),(1656,2,129,'F',6),(1657,2,129,'F',7),(1658,2,129,'F',8),(1659,2,129,'F',9),(1660,2,129,'F',10),(1661,2,129,'G',1),(1662,2,129,'G',2),(1663,2,129,'G',3),(1664,2,129,'G',4),(1665,2,129,'G',5),(1666,2,129,'G',6),(1667,2,129,'G',7),(1668,2,129,'G',8),(1669,2,129,'G',9),(1670,2,129,'G',10),(1671,5,129,'H',1),(1672,5,129,'H',2),(1673,5,129,'H',3),(1674,5,129,'H',4),(1675,5,129,'H',5),(1676,5,129,'H',6),(1677,5,129,'H',7),(1678,5,129,'H',8),(1679,5,129,'H',9),(1680,5,129,'H',10),(1681,4,129,'I',1),(1682,4,129,'I',2),(1683,4,129,'I',3),(1684,4,129,'I',4),(1685,4,129,'I',5),(1686,4,129,'I',6),(1687,4,129,'I',7),(1688,4,129,'I',8),(1689,4,129,'I',9),(1690,4,129,'I',10),(1691,3,129,'J',1),(1692,3,129,'J',2),(1693,3,129,'J',3),(1694,3,129,'J',4),(1695,3,129,'J',5),(1696,3,129,'J',6),(1697,3,129,'J',7),(1698,3,129,'J',8),(1699,3,129,'J',9),(1700,3,129,'J',10),(1701,1,137,'A',1),(1702,1,137,'A',2),(1703,1,137,'A',3),(1704,1,137,'A',4),(1705,1,137,'A',5),(1706,1,137,'A',6),(1707,1,137,'A',7),(1708,1,137,'A',8),(1709,1,137,'A',9),(1710,1,137,'A',10),(1711,1,137,'B',1),(1712,1,137,'B',2),(1713,1,137,'B',3),(1714,1,137,'B',4),(1715,1,137,'B',5),(1716,1,137,'B',6),(1717,1,137,'B',7),(1718,1,137,'B',8),(1719,1,137,'B',9),(1720,1,137,'B',10),(1721,1,137,'C',1),(1722,1,137,'C',2),(1723,1,137,'C',3),(1724,1,137,'C',4),(1725,1,137,'C',5),(1726,1,137,'C',6),(1727,1,137,'C',7),(1728,1,137,'C',8),(1729,1,137,'C',9),(1730,1,137,'C',10),(1731,1,137,'D',1),(1732,1,137,'D',2),(1733,1,137,'D',3),(1734,1,137,'D',4),(1735,1,137,'D',5),(1736,1,137,'D',6),(1737,1,137,'D',7),(1738,1,137,'D',8),(1739,1,137,'D',9),(1740,1,137,'D',10),(1741,1,137,'E',1),(1742,1,137,'E',2),(1743,1,137,'E',3),(1744,1,137,'E',4),(1745,1,137,'E',5),(1746,1,137,'E',6),(1747,1,137,'E',7),(1748,1,137,'E',8),(1749,1,137,'E',9),(1750,1,137,'E',10),(1751,2,137,'F',1),(1752,2,137,'F',2),(1753,2,137,'F',3),(1754,2,137,'F',4),(1755,2,137,'F',5),(1756,2,137,'F',6),(1757,2,137,'F',7),(1758,2,137,'F',8),(1759,2,137,'F',9),(1760,2,137,'F',10),(1761,2,137,'G',1),(1762,2,137,'G',2),(1763,2,137,'G',3),(1764,2,137,'G',4),(1765,2,137,'G',5),(1766,2,137,'G',6),(1767,2,137,'G',7),(1768,2,137,'G',8),(1769,2,137,'G',9),(1770,2,137,'G',10),(1771,5,137,'H',1),(1772,5,137,'H',2),(1773,5,137,'H',3),(1774,5,137,'H',4),(1775,5,137,'H',5),(1776,5,137,'H',6),(1777,5,137,'H',7),(1778,5,137,'H',8),(1779,5,137,'H',9),(1780,5,137,'H',10),(1781,4,137,'I',1),(1782,4,137,'I',2),(1783,4,137,'I',3),(1784,4,137,'I',4),(1785,4,137,'I',5),(1786,4,137,'I',6),(1787,4,137,'I',7),(1788,4,137,'I',8),(1789,4,137,'I',9),(1790,4,137,'I',10),(1791,3,137,'J',1),(1792,3,137,'J',2),(1793,3,137,'J',3),(1794,3,137,'J',4),(1795,3,137,'J',5),(1796,3,137,'J',6),(1797,3,137,'J',7),(1798,3,137,'J',8),(1799,3,137,'J',9),(1800,3,137,'J',10),(1801,1,145,'A',1),(1802,1,145,'A',2),(1803,1,145,'A',3),(1804,1,145,'A',4),(1805,1,145,'A',5),(1806,1,145,'A',6),(1807,1,145,'A',7),(1808,1,145,'A',8),(1809,1,145,'A',9),(1810,1,145,'A',10),(1811,1,145,'B',1),(1812,1,145,'B',2),(1813,1,145,'B',3),(1814,1,145,'B',4),(1815,1,145,'B',5),(1816,1,145,'B',6),(1817,1,145,'B',7),(1818,1,145,'B',8),(1819,1,145,'B',9),(1820,1,145,'B',10),(1821,1,145,'C',1),(1822,1,145,'C',2),(1823,1,145,'C',3),(1824,1,145,'C',4),(1825,1,145,'C',5),(1826,1,145,'C',6),(1827,1,145,'C',7),(1828,1,145,'C',8),(1829,1,145,'C',9),(1830,1,145,'C',10),(1831,1,145,'D',1),(1832,1,145,'D',2),(1833,1,145,'D',3),(1834,1,145,'D',4),(1835,1,145,'D',5),(1836,1,145,'D',6),(1837,1,145,'D',7),(1838,1,145,'D',8),(1839,1,145,'D',9),(1840,1,145,'D',10),(1841,1,145,'E',1),(1842,1,145,'E',2),(1843,1,145,'E',3),(1844,1,145,'E',4),(1845,1,145,'E',5),(1846,1,145,'E',6),(1847,1,145,'E',7),(1848,1,145,'E',8),(1849,1,145,'E',9),(1850,1,145,'E',10),(1851,2,145,'F',1),(1852,2,145,'F',2),(1853,2,145,'F',3),(1854,2,145,'F',4),(1855,2,145,'F',5),(1856,2,145,'F',6),(1857,2,145,'F',7),(1858,2,145,'F',8),(1859,2,145,'F',9),(1860,2,145,'F',10),(1861,2,145,'G',1),(1862,2,145,'G',2),(1863,2,145,'G',3),(1864,2,145,'G',4),(1865,2,145,'G',5),(1866,2,145,'G',6),(1867,2,145,'G',7),(1868,2,145,'G',8),(1869,2,145,'G',9),(1870,2,145,'G',10),(1871,5,145,'H',1),(1872,5,145,'H',2),(1873,5,145,'H',3),(1874,5,145,'H',4),(1875,5,145,'H',5),(1876,5,145,'H',6),(1877,5,145,'H',7),(1878,5,145,'H',8),(1879,5,145,'H',9),(1880,5,145,'H',10),(1881,4,145,'I',1),(1882,4,145,'I',2),(1883,4,145,'I',3),(1884,4,145,'I',4),(1885,4,145,'I',5),(1886,4,145,'I',6),(1887,4,145,'I',7),(1888,4,145,'I',8),(1889,4,145,'I',9),(1890,4,145,'I',10),(1891,3,145,'J',1),(1892,3,145,'J',2),(1893,3,145,'J',3),(1894,3,145,'J',4),(1895,3,145,'J',5),(1896,3,145,'J',6),(1897,3,145,'J',7),(1898,3,145,'J',8),(1899,3,145,'J',9),(1900,3,145,'J',10),(1901,1,153,'A',1),(1902,1,153,'A',2),(1903,1,153,'A',3),(1904,1,153,'A',4),(1905,1,153,'A',5),(1906,1,153,'A',6),(1907,1,153,'A',7),(1908,1,153,'A',8),(1909,1,153,'A',9),(1910,1,153,'A',10),(1911,1,153,'B',1),(1912,1,153,'B',2),(1913,1,153,'B',3),(1914,1,153,'B',4),(1915,1,153,'B',5),(1916,1,153,'B',6),(1917,1,153,'B',7),(1918,1,153,'B',8),(1919,1,153,'B',9),(1920,1,153,'B',10),(1921,1,153,'C',1),(1922,1,153,'C',2),(1923,1,153,'C',3),(1924,1,153,'C',4),(1925,1,153,'C',5),(1926,1,153,'C',6),(1927,1,153,'C',7),(1928,1,153,'C',8),(1929,1,153,'C',9),(1930,1,153,'C',10),(1931,1,153,'D',1),(1932,1,153,'D',2),(1933,1,153,'D',3),(1934,1,153,'D',4),(1935,1,153,'D',5),(1936,1,153,'D',6),(1937,1,153,'D',7),(1938,1,153,'D',8),(1939,1,153,'D',9),(1940,1,153,'D',10),(1941,1,153,'E',1),(1942,1,153,'E',2),(1943,1,153,'E',3),(1944,1,153,'E',4),(1945,1,153,'E',5),(1946,1,153,'E',6),(1947,1,153,'E',7),(1948,1,153,'E',8),(1949,1,153,'E',9),(1950,1,153,'E',10),(1951,2,153,'F',1),(1952,2,153,'F',2),(1953,2,153,'F',3),(1954,2,153,'F',4),(1955,2,153,'F',5),(1956,2,153,'F',6),(1957,2,153,'F',7),(1958,2,153,'F',8),(1959,2,153,'F',9),(1960,2,153,'F',10),(1961,2,153,'G',1),(1962,2,153,'G',2),(1963,2,153,'G',3),(1964,2,153,'G',4),(1965,2,153,'G',5),(1966,2,153,'G',6),(1967,2,153,'G',7),(1968,2,153,'G',8),(1969,2,153,'G',9),(1970,2,153,'G',10),(1971,5,153,'H',1),(1972,5,153,'H',2),(1973,5,153,'H',3),(1974,5,153,'H',4),(1975,5,153,'H',5),(1976,5,153,'H',6),(1977,5,153,'H',7),(1978,5,153,'H',8),(1979,5,153,'H',9),(1980,5,153,'H',10),(1981,4,153,'I',1),(1982,4,153,'I',2),(1983,4,153,'I',3),(1984,4,153,'I',4),(1985,4,153,'I',5),(1986,4,153,'I',6),(1987,4,153,'I',7),(1988,4,153,'I',8),(1989,4,153,'I',9),(1990,4,153,'I',10),(1991,3,153,'J',1),(1992,3,153,'J',2),(1993,3,153,'J',3),(1994,3,153,'J',4),(1995,3,153,'J',5),(1996,3,153,'J',6),(1997,3,153,'J',7),(1998,3,153,'J',8),(1999,3,153,'J',9),(2000,3,153,'J',10),(2001,1,161,'A',1),(2002,1,161,'A',2),(2003,1,161,'A',3),(2004,1,161,'A',4),(2005,1,161,'A',5),(2006,1,161,'A',6),(2007,1,161,'A',7),(2008,1,161,'A',8),(2009,1,161,'A',9),(2010,1,161,'A',10),(2011,1,161,'B',1),(2012,1,161,'B',2),(2013,1,161,'B',3),(2014,1,161,'B',4),(2015,1,161,'B',5),(2016,1,161,'B',6),(2017,1,161,'B',7),(2018,1,161,'B',8),(2019,1,161,'B',9),(2020,1,161,'B',10),(2021,1,161,'C',1),(2022,1,161,'C',2),(2023,1,161,'C',3),(2024,1,161,'C',4),(2025,1,161,'C',5),(2026,1,161,'C',6),(2027,1,161,'C',7),(2028,1,161,'C',8),(2029,1,161,'C',9),(2030,1,161,'C',10),(2031,1,161,'D',1),(2032,1,161,'D',2),(2033,1,161,'D',3),(2034,1,161,'D',4),(2035,1,161,'D',5),(2036,1,161,'D',6),(2037,1,161,'D',7),(2038,1,161,'D',8),(2039,1,161,'D',9),(2040,1,161,'D',10),(2041,1,161,'E',1),(2042,1,161,'E',2),(2043,1,161,'E',3),(2044,1,161,'E',4),(2045,1,161,'E',5),(2046,1,161,'E',6),(2047,1,161,'E',7),(2048,1,161,'E',8),(2049,1,161,'E',9),(2050,1,161,'E',10),(2051,2,161,'F',1),(2052,2,161,'F',2),(2053,2,161,'F',3),(2054,2,161,'F',4),(2055,2,161,'F',5),(2056,2,161,'F',6),(2057,2,161,'F',7),(2058,2,161,'F',8),(2059,2,161,'F',9),(2060,2,161,'F',10),(2061,2,161,'G',1),(2062,2,161,'G',2),(2063,2,161,'G',3),(2064,2,161,'G',4),(2065,2,161,'G',5),(2066,2,161,'G',6),(2067,2,161,'G',7),(2068,2,161,'G',8),(2069,2,161,'G',9),(2070,2,161,'G',10),(2071,5,161,'H',1),(2072,5,161,'H',2),(2073,5,161,'H',3),(2074,5,161,'H',4),(2075,5,161,'H',5),(2076,5,161,'H',6),(2077,5,161,'H',7),(2078,5,161,'H',8),(2079,5,161,'H',9),(2080,5,161,'H',10),(2081,4,161,'I',1),(2082,4,161,'I',2),(2083,4,161,'I',3),(2084,4,161,'I',4),(2085,4,161,'I',5),(2086,4,161,'I',6),(2087,4,161,'I',7),(2088,4,161,'I',8),(2089,4,161,'I',9),(2090,4,161,'I',10),(2091,3,161,'J',1),(2092,3,161,'J',2),(2093,3,161,'J',3),(2094,3,161,'J',4),(2095,3,161,'J',5),(2096,3,161,'J',6),(2097,3,161,'J',7),(2098,3,161,'J',8),(2099,3,161,'J',9),(2100,3,161,'J',10),(2101,1,169,'A',1),(2102,1,169,'A',2),(2103,1,169,'A',3),(2104,1,169,'A',4),(2105,1,169,'A',5),(2106,1,169,'A',6),(2107,1,169,'A',7),(2108,1,169,'A',8),(2109,1,169,'A',9),(2110,1,169,'A',10),(2111,1,169,'B',1),(2112,1,169,'B',2),(2113,1,169,'B',3),(2114,1,169,'B',4),(2115,1,169,'B',5),(2116,1,169,'B',6),(2117,1,169,'B',7),(2118,1,169,'B',8),(2119,1,169,'B',9),(2120,1,169,'B',10),(2121,1,169,'C',1),(2122,1,169,'C',2),(2123,1,169,'C',3),(2124,1,169,'C',4),(2125,1,169,'C',5),(2126,1,169,'C',6),(2127,1,169,'C',7),(2128,1,169,'C',8),(2129,1,169,'C',9),(2130,1,169,'C',10),(2131,1,169,'D',1),(2132,1,169,'D',2),(2133,1,169,'D',3),(2134,1,169,'D',4),(2135,1,169,'D',5),(2136,1,169,'D',6),(2137,1,169,'D',7),(2138,1,169,'D',8),(2139,1,169,'D',9),(2140,1,169,'D',10),(2141,1,169,'E',1),(2142,1,169,'E',2),(2143,1,169,'E',3),(2144,1,169,'E',4),(2145,1,169,'E',5),(2146,1,169,'E',6),(2147,1,169,'E',7),(2148,1,169,'E',8),(2149,1,169,'E',9),(2150,1,169,'E',10),(2151,2,169,'F',1),(2152,2,169,'F',2),(2153,2,169,'F',3),(2154,2,169,'F',4),(2155,2,169,'F',5),(2156,2,169,'F',6),(2157,2,169,'F',7),(2158,2,169,'F',8),(2159,2,169,'F',9),(2160,2,169,'F',10),(2161,2,169,'G',1),(2162,2,169,'G',2),(2163,2,169,'G',3),(2164,2,169,'G',4),(2165,2,169,'G',5),(2166,2,169,'G',6),(2167,2,169,'G',7),(2168,2,169,'G',8),(2169,2,169,'G',9),(2170,2,169,'G',10),(2171,5,169,'H',1),(2172,5,169,'H',2),(2173,5,169,'H',3),(2174,5,169,'H',4),(2175,5,169,'H',5),(2176,5,169,'H',6),(2177,5,169,'H',7),(2178,5,169,'H',8),(2179,5,169,'H',9),(2180,5,169,'H',10),(2181,4,169,'I',1),(2182,4,169,'I',2),(2183,4,169,'I',3),(2184,4,169,'I',4),(2185,4,169,'I',5),(2186,4,169,'I',6),(2187,4,169,'I',7),(2188,4,169,'I',8),(2189,4,169,'I',9),(2190,4,169,'I',10),(2191,3,169,'J',1),(2192,3,169,'J',2),(2193,3,169,'J',3),(2194,3,169,'J',4),(2195,3,169,'J',5),(2196,3,169,'J',6),(2197,3,169,'J',7),(2198,3,169,'J',8),(2199,3,169,'J',9),(2200,3,169,'J',10),(2201,1,177,'A',1),(2202,1,177,'A',2),(2203,1,177,'A',3),(2204,1,177,'A',4),(2205,1,177,'A',5),(2206,1,177,'A',6),(2207,1,177,'A',7),(2208,1,177,'A',8),(2209,1,177,'A',9),(2210,1,177,'A',10),(2211,1,177,'B',1),(2212,1,177,'B',2),(2213,1,177,'B',3),(2214,1,177,'B',4),(2215,1,177,'B',5),(2216,1,177,'B',6),(2217,1,177,'B',7),(2218,1,177,'B',8),(2219,1,177,'B',9),(2220,1,177,'B',10),(2221,1,177,'C',1),(2222,1,177,'C',2),(2223,1,177,'C',3),(2224,1,177,'C',4),(2225,1,177,'C',5),(2226,1,177,'C',6),(2227,1,177,'C',7),(2228,1,177,'C',8),(2229,1,177,'C',9),(2230,1,177,'C',10),(2231,1,177,'D',1),(2232,1,177,'D',2),(2233,1,177,'D',3),(2234,1,177,'D',4),(2235,1,177,'D',5),(2236,1,177,'D',6),(2237,1,177,'D',7),(2238,1,177,'D',8),(2239,1,177,'D',9),(2240,1,177,'D',10),(2241,1,177,'E',1),(2242,1,177,'E',2),(2243,1,177,'E',3),(2244,1,177,'E',4),(2245,1,177,'E',5),(2246,1,177,'E',6),(2247,1,177,'E',7),(2248,1,177,'E',8),(2249,1,177,'E',9),(2250,1,177,'E',10),(2251,2,177,'F',1),(2252,2,177,'F',2),(2253,2,177,'F',3),(2254,2,177,'F',4),(2255,2,177,'F',5),(2256,2,177,'F',6),(2257,2,177,'F',7),(2258,2,177,'F',8),(2259,2,177,'F',9),(2260,2,177,'F',10),(2261,2,177,'G',1),(2262,2,177,'G',2),(2263,2,177,'G',3),(2264,2,177,'G',4),(2265,2,177,'G',5),(2266,2,177,'G',6),(2267,2,177,'G',7),(2268,2,177,'G',8),(2269,2,177,'G',9),(2270,2,177,'G',10),(2271,5,177,'H',1),(2272,5,177,'H',2),(2273,5,177,'H',3),(2274,5,177,'H',4),(2275,5,177,'H',5),(2276,5,177,'H',6),(2277,5,177,'H',7),(2278,5,177,'H',8),(2279,5,177,'H',9),(2280,5,177,'H',10),(2281,4,177,'I',1),(2282,4,177,'I',2),(2283,4,177,'I',3),(2284,4,177,'I',4),(2285,4,177,'I',5),(2286,4,177,'I',6),(2287,4,177,'I',7),(2288,4,177,'I',8),(2289,4,177,'I',9),(2290,4,177,'I',10),(2291,3,177,'J',1),(2292,3,177,'J',2),(2293,3,177,'J',3),(2294,3,177,'J',4),(2295,3,177,'J',5),(2296,3,177,'J',6),(2297,3,177,'J',7),(2298,3,177,'J',8),(2299,3,177,'J',9),(2300,3,177,'J',10),(2301,1,185,'A',1),(2302,1,185,'A',2),(2303,1,185,'A',3),(2304,1,185,'A',4),(2305,1,185,'A',5),(2306,1,185,'A',6),(2307,1,185,'A',7),(2308,1,185,'A',8),(2309,1,185,'A',9),(2310,1,185,'A',10),(2311,1,185,'B',1),(2312,1,185,'B',2),(2313,1,185,'B',3),(2314,1,185,'B',4),(2315,1,185,'B',5),(2316,1,185,'B',6),(2317,1,185,'B',7),(2318,1,185,'B',8),(2319,1,185,'B',9),(2320,1,185,'B',10),(2321,1,185,'C',1),(2322,1,185,'C',2),(2323,1,185,'C',3),(2324,1,185,'C',4),(2325,1,185,'C',5),(2326,1,185,'C',6),(2327,1,185,'C',7),(2328,1,185,'C',8),(2329,1,185,'C',9),(2330,1,185,'C',10),(2331,1,185,'D',1),(2332,1,185,'D',2),(2333,1,185,'D',3),(2334,1,185,'D',4),(2335,1,185,'D',5),(2336,1,185,'D',6),(2337,1,185,'D',7),(2338,1,185,'D',8),(2339,1,185,'D',9),(2340,1,185,'D',10),(2341,1,185,'E',1),(2342,1,185,'E',2),(2343,1,185,'E',3),(2344,1,185,'E',4),(2345,1,185,'E',5),(2346,1,185,'E',6),(2347,1,185,'E',7),(2348,1,185,'E',8),(2349,1,185,'E',9),(2350,1,185,'E',10),(2351,2,185,'F',1),(2352,2,185,'F',2),(2353,2,185,'F',3),(2354,2,185,'F',4),(2355,2,185,'F',5),(2356,2,185,'F',6),(2357,2,185,'F',7),(2358,2,185,'F',8),(2359,2,185,'F',9),(2360,2,185,'F',10),(2361,2,185,'G',1),(2362,2,185,'G',2),(2363,2,185,'G',3),(2364,2,185,'G',4),(2365,2,185,'G',5),(2366,2,185,'G',6),(2367,2,185,'G',7),(2368,2,185,'G',8),(2369,2,185,'G',9),(2370,2,185,'G',10),(2371,5,185,'H',1),(2372,5,185,'H',2),(2373,5,185,'H',3),(2374,5,185,'H',4),(2375,5,185,'H',5),(2376,5,185,'H',6),(2377,5,185,'H',7),(2378,5,185,'H',8),(2379,5,185,'H',9),(2380,5,185,'H',10),(2381,4,185,'I',1),(2382,4,185,'I',2),(2383,4,185,'I',3),(2384,4,185,'I',4),(2385,4,185,'I',5),(2386,4,185,'I',6),(2387,4,185,'I',7),(2388,4,185,'I',8),(2389,4,185,'I',9),(2390,4,185,'I',10),(2391,3,185,'J',1),(2392,3,185,'J',2),(2393,3,185,'J',3),(2394,3,185,'J',4),(2395,3,185,'J',5),(2396,3,185,'J',6),(2397,3,185,'J',7),(2398,3,185,'J',8),(2399,3,185,'J',9),(2400,3,185,'J',10),(2401,1,193,'A',1),(2402,1,193,'A',2),(2403,1,193,'A',3),(2404,1,193,'A',4),(2405,1,193,'A',5),(2406,1,193,'A',6),(2407,1,193,'A',7),(2408,1,193,'A',8),(2409,1,193,'A',9),(2410,1,193,'A',10),(2411,1,193,'B',1),(2412,1,193,'B',2),(2413,1,193,'B',3),(2414,1,193,'B',4),(2415,1,193,'B',5),(2416,1,193,'B',6),(2417,1,193,'B',7),(2418,1,193,'B',8),(2419,1,193,'B',9),(2420,1,193,'B',10),(2421,1,193,'C',1),(2422,1,193,'C',2),(2423,1,193,'C',3),(2424,1,193,'C',4),(2425,1,193,'C',5),(2426,1,193,'C',6),(2427,1,193,'C',7),(2428,1,193,'C',8),(2429,1,193,'C',9),(2430,1,193,'C',10),(2431,1,193,'D',1),(2432,1,193,'D',2),(2433,1,193,'D',3),(2434,1,193,'D',4),(2435,1,193,'D',5),(2436,1,193,'D',6),(2437,1,193,'D',7),(2438,1,193,'D',8),(2439,1,193,'D',9),(2440,1,193,'D',10),(2441,1,193,'E',1),(2442,1,193,'E',2),(2443,1,193,'E',3),(2444,1,193,'E',4),(2445,1,193,'E',5),(2446,1,193,'E',6),(2447,1,193,'E',7),(2448,1,193,'E',8),(2449,1,193,'E',9),(2450,1,193,'E',10),(2451,2,193,'F',1),(2452,2,193,'F',2),(2453,2,193,'F',3),(2454,2,193,'F',4),(2455,2,193,'F',5),(2456,2,193,'F',6),(2457,2,193,'F',7),(2458,2,193,'F',8),(2459,2,193,'F',9),(2460,2,193,'F',10),(2461,2,193,'G',1),(2462,2,193,'G',2),(2463,2,193,'G',3),(2464,2,193,'G',4),(2465,2,193,'G',5),(2466,2,193,'G',6),(2467,2,193,'G',7),(2468,2,193,'G',8),(2469,2,193,'G',9),(2470,2,193,'G',10),(2471,5,193,'H',1),(2472,5,193,'H',2),(2473,5,193,'H',3),(2474,5,193,'H',4),(2475,5,193,'H',5),(2476,5,193,'H',6),(2477,5,193,'H',7),(2478,5,193,'H',8),(2479,5,193,'H',9),(2480,5,193,'H',10),(2481,4,193,'I',1),(2482,4,193,'I',2),(2483,4,193,'I',3),(2484,4,193,'I',4),(2485,4,193,'I',5),(2486,4,193,'I',6),(2487,4,193,'I',7),(2488,4,193,'I',8),(2489,4,193,'I',9),(2490,4,193,'I',10),(2491,3,193,'J',1),(2492,3,193,'J',2),(2493,3,193,'J',3),(2494,3,193,'J',4),(2495,3,193,'J',5),(2496,3,193,'J',6),(2497,3,193,'J',7),(2498,3,193,'J',8),(2499,3,193,'J',9),(2500,3,193,'J',10),(2501,1,201,'A',1),(2502,1,201,'A',2),(2503,1,201,'A',3),(2504,1,201,'A',4),(2505,1,201,'A',5),(2506,1,201,'A',6),(2507,1,201,'A',7),(2508,1,201,'A',8),(2509,1,201,'A',9),(2510,1,201,'A',10),(2511,1,201,'B',1),(2512,1,201,'B',2),(2513,1,201,'B',3),(2514,1,201,'B',4),(2515,1,201,'B',5),(2516,1,201,'B',6),(2517,1,201,'B',7),(2518,1,201,'B',8),(2519,1,201,'B',9),(2520,1,201,'B',10),(2521,1,201,'C',1),(2522,1,201,'C',2),(2523,1,201,'C',3),(2524,1,201,'C',4),(2525,1,201,'C',5),(2526,1,201,'C',6),(2527,1,201,'C',7),(2528,1,201,'C',8),(2529,1,201,'C',9),(2530,1,201,'C',10),(2531,1,201,'D',1),(2532,1,201,'D',2),(2533,1,201,'D',3),(2534,1,201,'D',4),(2535,1,201,'D',5),(2536,1,201,'D',6),(2537,1,201,'D',7),(2538,1,201,'D',8),(2539,1,201,'D',9),(2540,1,201,'D',10),(2541,1,201,'E',1),(2542,1,201,'E',2),(2543,1,201,'E',3),(2544,1,201,'E',4),(2545,1,201,'E',5),(2546,1,201,'E',6),(2547,1,201,'E',7),(2548,1,201,'E',8),(2549,1,201,'E',9),(2550,1,201,'E',10),(2551,2,201,'F',1),(2552,2,201,'F',2),(2553,2,201,'F',3),(2554,2,201,'F',4),(2555,2,201,'F',5),(2556,2,201,'F',6),(2557,2,201,'F',7),(2558,2,201,'F',8),(2559,2,201,'F',9),(2560,2,201,'F',10),(2561,2,201,'G',1),(2562,2,201,'G',2),(2563,2,201,'G',3),(2564,2,201,'G',4),(2565,2,201,'G',5),(2566,2,201,'G',6),(2567,2,201,'G',7),(2568,2,201,'G',8),(2569,2,201,'G',9),(2570,2,201,'G',10),(2571,5,201,'H',1),(2572,5,201,'H',2),(2573,5,201,'H',3),(2574,5,201,'H',4),(2575,5,201,'H',5),(2576,5,201,'H',6),(2577,5,201,'H',7),(2578,5,201,'H',8),(2579,5,201,'H',9),(2580,5,201,'H',10),(2581,4,201,'I',1),(2582,4,201,'I',2),(2583,4,201,'I',3),(2584,4,201,'I',4),(2585,4,201,'I',5),(2586,4,201,'I',6),(2587,4,201,'I',7),(2588,4,201,'I',8),(2589,4,201,'I',9),(2590,4,201,'I',10),(2591,3,201,'J',1),(2592,3,201,'J',2),(2593,3,201,'J',3),(2594,3,201,'J',4),(2595,3,201,'J',5),(2596,3,201,'J',6),(2597,3,201,'J',7),(2598,3,201,'J',8),(2599,3,201,'J',9),(2600,3,201,'J',10),(2601,1,209,'A',1),(2602,1,209,'A',2),(2603,1,209,'A',3),(2604,1,209,'A',4),(2605,1,209,'A',5),(2606,1,209,'A',6),(2607,1,209,'A',7),(2608,1,209,'A',8),(2609,1,209,'A',9),(2610,1,209,'A',10),(2611,1,209,'B',1),(2612,1,209,'B',2),(2613,1,209,'B',3),(2614,1,209,'B',4),(2615,1,209,'B',5),(2616,1,209,'B',6),(2617,1,209,'B',7),(2618,1,209,'B',8),(2619,1,209,'B',9),(2620,1,209,'B',10),(2621,1,209,'C',1),(2622,1,209,'C',2),(2623,1,209,'C',3),(2624,1,209,'C',4),(2625,1,209,'C',5),(2626,1,209,'C',6),(2627,1,209,'C',7),(2628,1,209,'C',8),(2629,1,209,'C',9),(2630,1,209,'C',10),(2631,1,209,'D',1),(2632,1,209,'D',2),(2633,1,209,'D',3),(2634,1,209,'D',4),(2635,1,209,'D',5),(2636,1,209,'D',6),(2637,1,209,'D',7),(2638,1,209,'D',8),(2639,1,209,'D',9),(2640,1,209,'D',10),(2641,1,209,'E',1),(2642,1,209,'E',2),(2643,1,209,'E',3),(2644,1,209,'E',4),(2645,1,209,'E',5),(2646,1,209,'E',6),(2647,1,209,'E',7),(2648,1,209,'E',8),(2649,1,209,'E',9),(2650,1,209,'E',10),(2651,2,209,'F',1),(2652,2,209,'F',2),(2653,2,209,'F',3),(2654,2,209,'F',4),(2655,2,209,'F',5),(2656,2,209,'F',6),(2657,2,209,'F',7),(2658,2,209,'F',8),(2659,2,209,'F',9),(2660,2,209,'F',10),(2661,2,209,'G',1),(2662,2,209,'G',2),(2663,2,209,'G',3),(2664,2,209,'G',4),(2665,2,209,'G',5),(2666,2,209,'G',6),(2667,2,209,'G',7),(2668,2,209,'G',8),(2669,2,209,'G',9),(2670,2,209,'G',10),(2671,5,209,'H',1),(2672,5,209,'H',2),(2673,5,209,'H',3),(2674,5,209,'H',4),(2675,5,209,'H',5),(2676,5,209,'H',6),(2677,5,209,'H',7),(2678,5,209,'H',8),(2679,5,209,'H',9),(2680,5,209,'H',10),(2681,4,209,'I',1),(2682,4,209,'I',2),(2683,4,209,'I',3),(2684,4,209,'I',4),(2685,4,209,'I',5),(2686,4,209,'I',6),(2687,4,209,'I',7),(2688,4,209,'I',8),(2689,4,209,'I',9),(2690,4,209,'I',10),(2691,3,209,'J',1),(2692,3,209,'J',2),(2693,3,209,'J',3),(2694,3,209,'J',4),(2695,3,209,'J',5),(2696,3,209,'J',6),(2697,3,209,'J',7),(2698,3,209,'J',8),(2699,3,209,'J',9),(2700,3,209,'J',10),(2701,1,217,'A',1),(2702,1,217,'A',2),(2703,1,217,'A',3),(2704,1,217,'A',4),(2705,1,217,'A',5),(2706,1,217,'A',6),(2707,1,217,'A',7),(2708,1,217,'A',8),(2709,1,217,'A',9),(2710,1,217,'A',10),(2711,1,217,'B',1),(2712,1,217,'B',2),(2713,1,217,'B',3),(2714,1,217,'B',4),(2715,1,217,'B',5),(2716,1,217,'B',6),(2717,1,217,'B',7),(2718,1,217,'B',8),(2719,1,217,'B',9),(2720,1,217,'B',10),(2721,1,217,'C',1),(2722,1,217,'C',2),(2723,1,217,'C',3),(2724,1,217,'C',4),(2725,1,217,'C',5),(2726,1,217,'C',6),(2727,1,217,'C',7),(2728,1,217,'C',8),(2729,1,217,'C',9),(2730,1,217,'C',10),(2731,1,217,'D',1),(2732,1,217,'D',2),(2733,1,217,'D',3),(2734,1,217,'D',4),(2735,1,217,'D',5),(2736,1,217,'D',6),(2737,1,217,'D',7),(2738,1,217,'D',8),(2739,1,217,'D',9),(2740,1,217,'D',10),(2741,1,217,'E',1),(2742,1,217,'E',2),(2743,1,217,'E',3),(2744,1,217,'E',4),(2745,1,217,'E',5),(2746,1,217,'E',6),(2747,1,217,'E',7),(2748,1,217,'E',8),(2749,1,217,'E',9),(2750,1,217,'E',10),(2751,2,217,'F',1),(2752,2,217,'F',2),(2753,2,217,'F',3),(2754,2,217,'F',4),(2755,2,217,'F',5),(2756,2,217,'F',6),(2757,2,217,'F',7),(2758,2,217,'F',8),(2759,2,217,'F',9),(2760,2,217,'F',10),(2761,2,217,'G',1),(2762,2,217,'G',2),(2763,2,217,'G',3),(2764,2,217,'G',4),(2765,2,217,'G',5),(2766,2,217,'G',6),(2767,2,217,'G',7),(2768,2,217,'G',8),(2769,2,217,'G',9),(2770,2,217,'G',10),(2771,5,217,'H',1),(2772,5,217,'H',2),(2773,5,217,'H',3),(2774,5,217,'H',4),(2775,5,217,'H',5),(2776,5,217,'H',6),(2777,5,217,'H',7),(2778,5,217,'H',8),(2779,5,217,'H',9),(2780,5,217,'H',10),(2781,4,217,'I',1),(2782,4,217,'I',2),(2783,4,217,'I',3),(2784,4,217,'I',4),(2785,4,217,'I',5),(2786,4,217,'I',6),(2787,4,217,'I',7),(2788,4,217,'I',8),(2789,4,217,'I',9),(2790,4,217,'I',10),(2791,3,217,'J',1),(2792,3,217,'J',2),(2793,3,217,'J',3),(2794,3,217,'J',4),(2795,3,217,'J',5),(2796,3,217,'J',6),(2797,3,217,'J',7),(2798,3,217,'J',8),(2799,3,217,'J',9),(2800,3,217,'J',10),(2801,1,225,'A',1),(2802,1,225,'A',2),(2803,1,225,'A',3),(2804,1,225,'A',4),(2805,1,225,'A',5),(2806,1,225,'A',6),(2807,1,225,'A',7),(2808,1,225,'A',8),(2809,1,225,'A',9),(2810,1,225,'A',10),(2811,1,225,'B',1),(2812,1,225,'B',2),(2813,1,225,'B',3),(2814,1,225,'B',4),(2815,1,225,'B',5),(2816,1,225,'B',6),(2817,1,225,'B',7),(2818,1,225,'B',8),(2819,1,225,'B',9),(2820,1,225,'B',10),(2821,1,225,'C',1),(2822,1,225,'C',2),(2823,1,225,'C',3),(2824,1,225,'C',4),(2825,1,225,'C',5),(2826,1,225,'C',6),(2827,1,225,'C',7),(2828,1,225,'C',8),(2829,1,225,'C',9),(2830,1,225,'C',10),(2831,1,225,'D',1),(2832,1,225,'D',2),(2833,1,225,'D',3),(2834,1,225,'D',4),(2835,1,225,'D',5),(2836,1,225,'D',6),(2837,1,225,'D',7),(2838,1,225,'D',8),(2839,1,225,'D',9),(2840,1,225,'D',10),(2841,1,225,'E',1),(2842,1,225,'E',2),(2843,1,225,'E',3),(2844,1,225,'E',4),(2845,1,225,'E',5),(2846,1,225,'E',6),(2847,1,225,'E',7),(2848,1,225,'E',8),(2849,1,225,'E',9),(2850,1,225,'E',10),(2851,2,225,'F',1),(2852,2,225,'F',2),(2853,2,225,'F',3),(2854,2,225,'F',4),(2855,2,225,'F',5),(2856,2,225,'F',6),(2857,2,225,'F',7),(2858,2,225,'F',8),(2859,2,225,'F',9),(2860,2,225,'F',10),(2861,2,225,'G',1),(2862,2,225,'G',2),(2863,2,225,'G',3),(2864,2,225,'G',4),(2865,2,225,'G',5),(2866,2,225,'G',6),(2867,2,225,'G',7),(2868,2,225,'G',8),(2869,2,225,'G',9),(2870,2,225,'G',10),(2871,5,225,'H',1),(2872,5,225,'H',2),(2873,5,225,'H',3),(2874,5,225,'H',4),(2875,5,225,'H',5),(2876,5,225,'H',6),(2877,5,225,'H',7),(2878,5,225,'H',8),(2879,5,225,'H',9),(2880,5,225,'H',10),(2881,4,225,'I',1),(2882,4,225,'I',2),(2883,4,225,'I',3),(2884,4,225,'I',4),(2885,4,225,'I',5),(2886,4,225,'I',6),(2887,4,225,'I',7),(2888,4,225,'I',8),(2889,4,225,'I',9),(2890,4,225,'I',10),(2891,3,225,'J',1),(2892,3,225,'J',2),(2893,3,225,'J',3),(2894,3,225,'J',4),(2895,3,225,'J',5),(2896,3,225,'J',6),(2897,3,225,'J',7),(2898,3,225,'J',8),(2899,3,225,'J',9),(2900,3,225,'J',10),(2901,1,233,'A',1),(2902,1,233,'A',2),(2903,1,233,'A',3),(2904,1,233,'A',4),(2905,1,233,'A',5),(2906,1,233,'A',6),(2907,1,233,'A',7),(2908,1,233,'A',8),(2909,1,233,'A',9),(2910,1,233,'A',10),(2911,1,233,'B',1),(2912,1,233,'B',2),(2913,1,233,'B',3),(2914,1,233,'B',4),(2915,1,233,'B',5),(2916,1,233,'B',6),(2917,1,233,'B',7),(2918,1,233,'B',8),(2919,1,233,'B',9),(2920,1,233,'B',10),(2921,1,233,'C',1),(2922,1,233,'C',2),(2923,1,233,'C',3),(2924,1,233,'C',4),(2925,1,233,'C',5),(2926,1,233,'C',6),(2927,1,233,'C',7),(2928,1,233,'C',8),(2929,1,233,'C',9),(2930,1,233,'C',10),(2931,1,233,'D',1),(2932,1,233,'D',2),(2933,1,233,'D',3),(2934,1,233,'D',4),(2935,1,233,'D',5),(2936,1,233,'D',6),(2937,1,233,'D',7),(2938,1,233,'D',8),(2939,1,233,'D',9),(2940,1,233,'D',10),(2941,1,233,'E',1),(2942,1,233,'E',2),(2943,1,233,'E',3),(2944,1,233,'E',4),(2945,1,233,'E',5),(2946,1,233,'E',6),(2947,1,233,'E',7),(2948,1,233,'E',8),(2949,1,233,'E',9),(2950,1,233,'E',10),(2951,2,233,'F',1),(2952,2,233,'F',2),(2953,2,233,'F',3),(2954,2,233,'F',4),(2955,2,233,'F',5),(2956,2,233,'F',6),(2957,2,233,'F',7),(2958,2,233,'F',8),(2959,2,233,'F',9),(2960,2,233,'F',10),(2961,2,233,'G',1),(2962,2,233,'G',2),(2963,2,233,'G',3),(2964,2,233,'G',4),(2965,2,233,'G',5),(2966,2,233,'G',6),(2967,2,233,'G',7),(2968,2,233,'G',8),(2969,2,233,'G',9),(2970,2,233,'G',10),(2971,5,233,'H',1),(2972,5,233,'H',2),(2973,5,233,'H',3),(2974,5,233,'H',4),(2975,5,233,'H',5),(2976,5,233,'H',6),(2977,5,233,'H',7),(2978,5,233,'H',8),(2979,5,233,'H',9),(2980,5,233,'H',10),(2981,4,233,'I',1),(2982,4,233,'I',2),(2983,4,233,'I',3),(2984,4,233,'I',4),(2985,4,233,'I',5),(2986,4,233,'I',6),(2987,4,233,'I',7),(2988,4,233,'I',8),(2989,4,233,'I',9),(2990,4,233,'I',10),(2991,3,233,'J',1),(2992,3,233,'J',2),(2993,3,233,'J',3),(2994,3,233,'J',4),(2995,3,233,'J',5),(2996,3,233,'J',6),(2997,3,233,'J',7),(2998,3,233,'J',8),(2999,3,233,'J',9),(3000,3,233,'J',10),(3001,1,241,'A',1),(3002,1,241,'A',2),(3003,1,241,'A',3),(3004,1,241,'A',4),(3005,1,241,'A',5),(3006,1,241,'A',6),(3007,1,241,'A',7),(3008,1,241,'A',8),(3009,1,241,'A',9),(3010,1,241,'A',10),(3011,1,241,'B',1),(3012,1,241,'B',2),(3013,1,241,'B',3),(3014,1,241,'B',4),(3015,1,241,'B',5),(3016,1,241,'B',6),(3017,1,241,'B',7),(3018,1,241,'B',8),(3019,1,241,'B',9),(3020,1,241,'B',10),(3021,1,241,'C',1),(3022,1,241,'C',2),(3023,1,241,'C',3),(3024,1,241,'C',4),(3025,1,241,'C',5),(3026,1,241,'C',6),(3027,1,241,'C',7),(3028,1,241,'C',8),(3029,1,241,'C',9),(3030,1,241,'C',10),(3031,1,241,'D',1),(3032,1,241,'D',2),(3033,1,241,'D',3),(3034,1,241,'D',4),(3035,1,241,'D',5),(3036,1,241,'D',6),(3037,1,241,'D',7),(3038,1,241,'D',8),(3039,1,241,'D',9),(3040,1,241,'D',10),(3041,1,241,'E',1),(3042,1,241,'E',2),(3043,1,241,'E',3),(3044,1,241,'E',4),(3045,1,241,'E',5),(3046,1,241,'E',6),(3047,1,241,'E',7),(3048,1,241,'E',8),(3049,1,241,'E',9),(3050,1,241,'E',10),(3051,2,241,'F',1),(3052,2,241,'F',2),(3053,2,241,'F',3),(3054,2,241,'F',4),(3055,2,241,'F',5),(3056,2,241,'F',6),(3057,2,241,'F',7),(3058,2,241,'F',8),(3059,2,241,'F',9),(3060,2,241,'F',10),(3061,2,241,'G',1),(3062,2,241,'G',2),(3063,2,241,'G',3),(3064,2,241,'G',4),(3065,2,241,'G',5),(3066,2,241,'G',6),(3067,2,241,'G',7),(3068,2,241,'G',8),(3069,2,241,'G',9),(3070,2,241,'G',10),(3071,5,241,'H',1),(3072,5,241,'H',2),(3073,5,241,'H',3),(3074,5,241,'H',4),(3075,5,241,'H',5),(3076,5,241,'H',6),(3077,5,241,'H',7),(3078,5,241,'H',8),(3079,5,241,'H',9),(3080,5,241,'H',10),(3081,4,241,'I',1),(3082,4,241,'I',2),(3083,4,241,'I',3),(3084,4,241,'I',4),(3085,4,241,'I',5),(3086,4,241,'I',6),(3087,4,241,'I',7),(3088,4,241,'I',8),(3089,4,241,'I',9),(3090,4,241,'I',10),(3091,3,241,'J',1),(3092,3,241,'J',2),(3093,3,241,'J',3),(3094,3,241,'J',4),(3095,3,241,'J',5),(3096,3,241,'J',6),(3097,3,241,'J',7),(3098,3,241,'J',8),(3099,3,241,'J',9),(3100,3,241,'J',10),(3101,1,249,'A',1),(3102,1,249,'A',2),(3103,1,249,'A',3),(3104,1,249,'A',4),(3105,1,249,'A',5),(3106,1,249,'A',6),(3107,1,249,'A',7),(3108,1,249,'A',8),(3109,1,249,'A',9),(3110,1,249,'A',10),(3111,1,249,'B',1),(3112,1,249,'B',2),(3113,1,249,'B',3),(3114,1,249,'B',4),(3115,1,249,'B',5),(3116,1,249,'B',6),(3117,1,249,'B',7),(3118,1,249,'B',8),(3119,1,249,'B',9),(3120,1,249,'B',10),(3121,1,249,'C',1),(3122,1,249,'C',2),(3123,1,249,'C',3),(3124,1,249,'C',4),(3125,1,249,'C',5),(3126,1,249,'C',6),(3127,1,249,'C',7),(3128,1,249,'C',8),(3129,1,249,'C',9),(3130,1,249,'C',10),(3131,1,249,'D',1),(3132,1,249,'D',2),(3133,1,249,'D',3),(3134,1,249,'D',4),(3135,1,249,'D',5),(3136,1,249,'D',6),(3137,1,249,'D',7),(3138,1,249,'D',8),(3139,1,249,'D',9),(3140,1,249,'D',10),(3141,1,249,'E',1),(3142,1,249,'E',2),(3143,1,249,'E',3),(3144,1,249,'E',4),(3145,1,249,'E',5),(3146,1,249,'E',6),(3147,1,249,'E',7),(3148,1,249,'E',8),(3149,1,249,'E',9),(3150,1,249,'E',10),(3151,2,249,'F',1),(3152,2,249,'F',2),(3153,2,249,'F',3),(3154,2,249,'F',4),(3155,2,249,'F',5),(3156,2,249,'F',6),(3157,2,249,'F',7),(3158,2,249,'F',8),(3159,2,249,'F',9),(3160,2,249,'F',10),(3161,2,249,'G',1),(3162,2,249,'G',2),(3163,2,249,'G',3),(3164,2,249,'G',4),(3165,2,249,'G',5),(3166,2,249,'G',6),(3167,2,249,'G',7),(3168,2,249,'G',8),(3169,2,249,'G',9),(3170,2,249,'G',10),(3171,5,249,'H',1),(3172,5,249,'H',2),(3173,5,249,'H',3),(3174,5,249,'H',4),(3175,5,249,'H',5),(3176,5,249,'H',6),(3177,5,249,'H',7),(3178,5,249,'H',8),(3179,5,249,'H',9),(3180,5,249,'H',10),(3181,4,249,'I',1),(3182,4,249,'I',2),(3183,4,249,'I',3),(3184,4,249,'I',4),(3185,4,249,'I',5),(3186,4,249,'I',6),(3187,4,249,'I',7),(3188,4,249,'I',8),(3189,4,249,'I',9),(3190,4,249,'I',10),(3191,3,249,'J',1),(3192,3,249,'J',2),(3193,3,249,'J',3),(3194,3,249,'J',4),(3195,3,249,'J',5),(3196,3,249,'J',6),(3197,3,249,'J',7),(3198,3,249,'J',8),(3199,3,249,'J',9),(3200,3,249,'J',10),(3201,1,257,'A',1),(3202,1,257,'A',2),(3203,1,257,'A',3),(3204,1,257,'A',4),(3205,1,257,'A',5),(3206,1,257,'A',6),(3207,1,257,'A',7),(3208,1,257,'A',8),(3209,1,257,'A',9),(3210,1,257,'A',10),(3211,1,257,'B',1),(3212,1,257,'B',2),(3213,1,257,'B',3),(3214,1,257,'B',4),(3215,1,257,'B',5),(3216,1,257,'B',6),(3217,1,257,'B',7),(3218,1,257,'B',8),(3219,1,257,'B',9),(3220,1,257,'B',10),(3221,1,257,'C',1),(3222,1,257,'C',2),(3223,1,257,'C',3),(3224,1,257,'C',4),(3225,1,257,'C',5),(3226,1,257,'C',6),(3227,1,257,'C',7),(3228,1,257,'C',8),(3229,1,257,'C',9),(3230,1,257,'C',10),(3231,1,257,'D',1),(3232,1,257,'D',2),(3233,1,257,'D',3),(3234,1,257,'D',4),(3235,1,257,'D',5),(3236,1,257,'D',6),(3237,1,257,'D',7),(3238,1,257,'D',8),(3239,1,257,'D',9),(3240,1,257,'D',10),(3241,1,257,'E',1),(3242,1,257,'E',2),(3243,1,257,'E',3),(3244,1,257,'E',4),(3245,1,257,'E',5),(3246,1,257,'E',6),(3247,1,257,'E',7),(3248,1,257,'E',8),(3249,1,257,'E',9),(3250,1,257,'E',10),(3251,2,257,'F',1),(3252,2,257,'F',2),(3253,2,257,'F',3),(3254,2,257,'F',4),(3255,2,257,'F',5),(3256,2,257,'F',6),(3257,2,257,'F',7),(3258,2,257,'F',8),(3259,2,257,'F',9),(3260,2,257,'F',10),(3261,2,257,'G',1),(3262,2,257,'G',2),(3263,2,257,'G',3),(3264,2,257,'G',4),(3265,2,257,'G',5),(3266,2,257,'G',6),(3267,2,257,'G',7),(3268,2,257,'G',8),(3269,2,257,'G',9),(3270,2,257,'G',10),(3271,5,257,'H',1),(3272,5,257,'H',2),(3273,5,257,'H',3),(3274,5,257,'H',4),(3275,5,257,'H',5),(3276,5,257,'H',6),(3277,5,257,'H',7),(3278,5,257,'H',8),(3279,5,257,'H',9),(3280,5,257,'H',10),(3281,4,257,'I',1),(3282,4,257,'I',2),(3283,4,257,'I',3),(3284,4,257,'I',4),(3285,4,257,'I',5),(3286,4,257,'I',6),(3287,4,257,'I',7),(3288,4,257,'I',8),(3289,4,257,'I',9),(3290,4,257,'I',10),(3291,3,257,'J',1),(3292,3,257,'J',2),(3293,3,257,'J',3),(3294,3,257,'J',4),(3295,3,257,'J',5),(3296,3,257,'J',6),(3297,3,257,'J',7),(3298,3,257,'J',8),(3299,3,257,'J',9),(3300,3,257,'J',10),(3301,1,265,'A',1),(3302,1,265,'A',2),(3303,1,265,'A',3),(3304,1,265,'A',4),(3305,1,265,'A',5),(3306,1,265,'A',6),(3307,1,265,'A',7),(3308,1,265,'A',8),(3309,1,265,'A',9),(3310,1,265,'A',10),(3311,1,265,'B',1),(3312,1,265,'B',2),(3313,1,265,'B',3),(3314,1,265,'B',4),(3315,1,265,'B',5),(3316,1,265,'B',6),(3317,1,265,'B',7),(3318,1,265,'B',8),(3319,1,265,'B',9),(3320,1,265,'B',10),(3321,1,265,'C',1),(3322,1,265,'C',2),(3323,1,265,'C',3),(3324,1,265,'C',4),(3325,1,265,'C',5),(3326,1,265,'C',6),(3327,1,265,'C',7),(3328,1,265,'C',8),(3329,1,265,'C',9),(3330,1,265,'C',10),(3331,1,265,'D',1),(3332,1,265,'D',2),(3333,1,265,'D',3),(3334,1,265,'D',4),(3335,1,265,'D',5),(3336,1,265,'D',6),(3337,1,265,'D',7),(3338,1,265,'D',8),(3339,1,265,'D',9),(3340,1,265,'D',10),(3341,1,265,'E',1),(3342,1,265,'E',2),(3343,1,265,'E',3),(3344,1,265,'E',4),(3345,1,265,'E',5),(3346,1,265,'E',6),(3347,1,265,'E',7),(3348,1,265,'E',8),(3349,1,265,'E',9),(3350,1,265,'E',10),(3351,2,265,'F',1),(3352,2,265,'F',2),(3353,2,265,'F',3),(3354,2,265,'F',4),(3355,2,265,'F',5),(3356,2,265,'F',6),(3357,2,265,'F',7),(3358,2,265,'F',8),(3359,2,265,'F',9),(3360,2,265,'F',10),(3361,2,265,'G',1),(3362,2,265,'G',2),(3363,2,265,'G',3),(3364,2,265,'G',4),(3365,2,265,'G',5),(3366,2,265,'G',6),(3367,2,265,'G',7),(3368,2,265,'G',8),(3369,2,265,'G',9),(3370,2,265,'G',10),(3371,5,265,'H',1),(3372,5,265,'H',2),(3373,5,265,'H',3),(3374,5,265,'H',4),(3375,5,265,'H',5),(3376,5,265,'H',6),(3377,5,265,'H',7),(3378,5,265,'H',8),(3379,5,265,'H',9),(3380,5,265,'H',10),(3381,4,265,'I',1),(3382,4,265,'I',2),(3383,4,265,'I',3),(3384,4,265,'I',4),(3385,4,265,'I',5),(3386,4,265,'I',6),(3387,4,265,'I',7),(3388,4,265,'I',8),(3389,4,265,'I',9),(3390,4,265,'I',10),(3391,3,265,'J',1),(3392,3,265,'J',2),(3393,3,265,'J',3),(3394,3,265,'J',4),(3395,3,265,'J',5),(3396,3,265,'J',6),(3397,3,265,'J',7),(3398,3,265,'J',8),(3399,3,265,'J',9),(3400,3,265,'J',10),(3401,1,273,'A',1),(3402,1,273,'A',2),(3403,1,273,'A',3),(3404,1,273,'A',4),(3405,1,273,'A',5),(3406,1,273,'A',6),(3407,1,273,'A',7),(3408,1,273,'A',8),(3409,1,273,'A',9),(3410,1,273,'A',10),(3411,1,273,'B',1),(3412,1,273,'B',2),(3413,1,273,'B',3),(3414,1,273,'B',4),(3415,1,273,'B',5),(3416,1,273,'B',6),(3417,1,273,'B',7),(3418,1,273,'B',8),(3419,1,273,'B',9),(3420,1,273,'B',10),(3421,1,273,'C',1),(3422,1,273,'C',2),(3423,1,273,'C',3),(3424,1,273,'C',4),(3425,1,273,'C',5),(3426,1,273,'C',6),(3427,1,273,'C',7),(3428,1,273,'C',8),(3429,1,273,'C',9),(3430,1,273,'C',10),(3431,1,273,'D',1),(3432,1,273,'D',2),(3433,1,273,'D',3),(3434,1,273,'D',4),(3435,1,273,'D',5),(3436,1,273,'D',6),(3437,1,273,'D',7),(3438,1,273,'D',8),(3439,1,273,'D',9),(3440,1,273,'D',10),(3441,1,273,'E',1),(3442,1,273,'E',2),(3443,1,273,'E',3),(3444,1,273,'E',4),(3445,1,273,'E',5),(3446,1,273,'E',6),(3447,1,273,'E',7),(3448,1,273,'E',8),(3449,1,273,'E',9),(3450,1,273,'E',10),(3451,2,273,'F',1),(3452,2,273,'F',2),(3453,2,273,'F',3),(3454,2,273,'F',4),(3455,2,273,'F',5),(3456,2,273,'F',6),(3457,2,273,'F',7),(3458,2,273,'F',8),(3459,2,273,'F',9),(3460,2,273,'F',10),(3461,2,273,'G',1),(3462,2,273,'G',2),(3463,2,273,'G',3),(3464,2,273,'G',4),(3465,2,273,'G',5),(3466,2,273,'G',6),(3467,2,273,'G',7),(3468,2,273,'G',8),(3469,2,273,'G',9),(3470,2,273,'G',10),(3471,5,273,'H',1),(3472,5,273,'H',2),(3473,5,273,'H',3),(3474,5,273,'H',4),(3475,5,273,'H',5),(3476,5,273,'H',6),(3477,5,273,'H',7),(3478,5,273,'H',8),(3479,5,273,'H',9),(3480,5,273,'H',10),(3481,4,273,'I',1),(3482,4,273,'I',2),(3483,4,273,'I',3),(3484,4,273,'I',4),(3485,4,273,'I',5),(3486,4,273,'I',6),(3487,4,273,'I',7),(3488,4,273,'I',8),(3489,4,273,'I',9),(3490,4,273,'I',10),(3491,3,273,'J',1),(3492,3,273,'J',2),(3493,3,273,'J',3),(3494,3,273,'J',4),(3495,3,273,'J',5),(3496,3,273,'J',6),(3497,3,273,'J',7),(3498,3,273,'J',8),(3499,3,273,'J',9),(3500,3,273,'J',10),(3501,1,281,'A',1),(3502,1,281,'A',2),(3503,1,281,'A',3),(3504,1,281,'A',4),(3505,1,281,'A',5),(3506,1,281,'A',6),(3507,1,281,'A',7),(3508,1,281,'A',8),(3509,1,281,'A',9),(3510,1,281,'A',10),(3511,1,281,'B',1),(3512,1,281,'B',2),(3513,1,281,'B',3),(3514,1,281,'B',4),(3515,1,281,'B',5),(3516,1,281,'B',6),(3517,1,281,'B',7),(3518,1,281,'B',8),(3519,1,281,'B',9),(3520,1,281,'B',10),(3521,1,281,'C',1),(3522,1,281,'C',2),(3523,1,281,'C',3),(3524,1,281,'C',4),(3525,1,281,'C',5),(3526,1,281,'C',6),(3527,1,281,'C',7),(3528,1,281,'C',8),(3529,1,281,'C',9),(3530,1,281,'C',10),(3531,1,281,'D',1),(3532,1,281,'D',2),(3533,1,281,'D',3),(3534,1,281,'D',4),(3535,1,281,'D',5),(3536,1,281,'D',6),(3537,1,281,'D',7),(3538,1,281,'D',8),(3539,1,281,'D',9),(3540,1,281,'D',10),(3541,1,281,'E',1),(3542,1,281,'E',2),(3543,1,281,'E',3),(3544,1,281,'E',4),(3545,1,281,'E',5),(3546,1,281,'E',6),(3547,1,281,'E',7),(3548,1,281,'E',8),(3549,1,281,'E',9),(3550,1,281,'E',10),(3551,2,281,'F',1),(3552,2,281,'F',2),(3553,2,281,'F',3),(3554,2,281,'F',4),(3555,2,281,'F',5),(3556,2,281,'F',6),(3557,2,281,'F',7),(3558,2,281,'F',8),(3559,2,281,'F',9),(3560,2,281,'F',10),(3561,2,281,'G',1),(3562,2,281,'G',2),(3563,2,281,'G',3),(3564,2,281,'G',4),(3565,2,281,'G',5),(3566,2,281,'G',6),(3567,2,281,'G',7),(3568,2,281,'G',8),(3569,2,281,'G',9),(3570,2,281,'G',10),(3571,5,281,'H',1),(3572,5,281,'H',2),(3573,5,281,'H',3),(3574,5,281,'H',4),(3575,5,281,'H',5),(3576,5,281,'H',6),(3577,5,281,'H',7),(3578,5,281,'H',8),(3579,5,281,'H',9),(3580,5,281,'H',10),(3581,4,281,'I',1),(3582,4,281,'I',2),(3583,4,281,'I',3),(3584,4,281,'I',4),(3585,4,281,'I',5),(3586,4,281,'I',6),(3587,4,281,'I',7),(3588,4,281,'I',8),(3589,4,281,'I',9),(3590,4,281,'I',10),(3591,3,281,'J',1),(3592,3,281,'J',2),(3593,3,281,'J',3),(3594,3,281,'J',4),(3595,3,281,'J',5),(3596,3,281,'J',6),(3597,3,281,'J',7),(3598,3,281,'J',8),(3599,3,281,'J',9),(3600,3,281,'J',10),(3601,1,289,'A',1),(3602,1,289,'A',2),(3603,1,289,'A',3),(3604,1,289,'A',4),(3605,1,289,'A',5),(3606,1,289,'A',6),(3607,1,289,'A',7),(3608,1,289,'A',8),(3609,1,289,'A',9),(3610,1,289,'A',10),(3611,1,289,'B',1),(3612,1,289,'B',2),(3613,1,289,'B',3),(3614,1,289,'B',4),(3615,1,289,'B',5),(3616,1,289,'B',6),(3617,1,289,'B',7),(3618,1,289,'B',8),(3619,1,289,'B',9),(3620,1,289,'B',10),(3621,1,289,'C',1),(3622,1,289,'C',2),(3623,1,289,'C',3),(3624,1,289,'C',4),(3625,1,289,'C',5),(3626,1,289,'C',6),(3627,1,289,'C',7),(3628,1,289,'C',8),(3629,1,289,'C',9),(3630,1,289,'C',10),(3631,1,289,'D',1),(3632,1,289,'D',2),(3633,1,289,'D',3),(3634,1,289,'D',4),(3635,1,289,'D',5),(3636,1,289,'D',6),(3637,1,289,'D',7),(3638,1,289,'D',8),(3639,1,289,'D',9),(3640,1,289,'D',10),(3641,1,289,'E',1),(3642,1,289,'E',2),(3643,1,289,'E',3),(3644,1,289,'E',4),(3645,1,289,'E',5),(3646,1,289,'E',6),(3647,1,289,'E',7),(3648,1,289,'E',8),(3649,1,289,'E',9),(3650,1,289,'E',10),(3651,2,289,'F',1),(3652,2,289,'F',2),(3653,2,289,'F',3),(3654,2,289,'F',4),(3655,2,289,'F',5),(3656,2,289,'F',6),(3657,2,289,'F',7),(3658,2,289,'F',8),(3659,2,289,'F',9),(3660,2,289,'F',10),(3661,2,289,'G',1),(3662,2,289,'G',2),(3663,2,289,'G',3),(3664,2,289,'G',4),(3665,2,289,'G',5),(3666,2,289,'G',6),(3667,2,289,'G',7),(3668,2,289,'G',8),(3669,2,289,'G',9),(3670,2,289,'G',10),(3671,5,289,'H',1),(3672,5,289,'H',2),(3673,5,289,'H',3),(3674,5,289,'H',4),(3675,5,289,'H',5),(3676,5,289,'H',6),(3677,5,289,'H',7),(3678,5,289,'H',8),(3679,5,289,'H',9),(3680,5,289,'H',10),(3681,4,289,'I',1),(3682,4,289,'I',2),(3683,4,289,'I',3),(3684,4,289,'I',4),(3685,4,289,'I',5),(3686,4,289,'I',6),(3687,4,289,'I',7),(3688,4,289,'I',8),(3689,4,289,'I',9),(3690,4,289,'I',10),(3691,3,289,'J',1),(3692,3,289,'J',2),(3693,3,289,'J',3),(3694,3,289,'J',4),(3695,3,289,'J',5),(3696,3,289,'J',6),(3697,3,289,'J',7),(3698,3,289,'J',8),(3699,3,289,'J',9),(3700,3,289,'J',10),(3701,1,297,'A',1),(3702,1,297,'A',2),(3703,1,297,'A',3),(3704,1,297,'A',4),(3705,1,297,'A',5),(3706,1,297,'A',6),(3707,1,297,'A',7),(3708,1,297,'A',8),(3709,1,297,'A',9),(3710,1,297,'A',10),(3711,1,297,'B',1),(3712,1,297,'B',2),(3713,1,297,'B',3),(3714,1,297,'B',4),(3715,1,297,'B',5),(3716,1,297,'B',6),(3717,1,297,'B',7),(3718,1,297,'B',8),(3719,1,297,'B',9),(3720,1,297,'B',10),(3721,1,297,'C',1),(3722,1,297,'C',2),(3723,1,297,'C',3),(3724,1,297,'C',4),(3725,1,297,'C',5),(3726,1,297,'C',6),(3727,1,297,'C',7),(3728,1,297,'C',8),(3729,1,297,'C',9),(3730,1,297,'C',10),(3731,1,297,'D',1),(3732,1,297,'D',2),(3733,1,297,'D',3),(3734,1,297,'D',4),(3735,1,297,'D',5),(3736,1,297,'D',6),(3737,1,297,'D',7),(3738,1,297,'D',8),(3739,1,297,'D',9),(3740,1,297,'D',10),(3741,1,297,'E',1),(3742,1,297,'E',2),(3743,1,297,'E',3),(3744,1,297,'E',4),(3745,1,297,'E',5),(3746,1,297,'E',6),(3747,1,297,'E',7),(3748,1,297,'E',8),(3749,1,297,'E',9),(3750,1,297,'E',10),(3751,2,297,'F',1),(3752,2,297,'F',2),(3753,2,297,'F',3),(3754,2,297,'F',4),(3755,2,297,'F',5),(3756,2,297,'F',6),(3757,2,297,'F',7),(3758,2,297,'F',8),(3759,2,297,'F',9),(3760,2,297,'F',10),(3761,2,297,'G',1),(3762,2,297,'G',2),(3763,2,297,'G',3),(3764,2,297,'G',4),(3765,2,297,'G',5),(3766,2,297,'G',6),(3767,2,297,'G',7),(3768,2,297,'G',8),(3769,2,297,'G',9),(3770,2,297,'G',10),(3771,5,297,'H',1),(3772,5,297,'H',2),(3773,5,297,'H',3),(3774,5,297,'H',4),(3775,5,297,'H',5),(3776,5,297,'H',6),(3777,5,297,'H',7),(3778,5,297,'H',8),(3779,5,297,'H',9),(3780,5,297,'H',10),(3781,4,297,'I',1),(3782,4,297,'I',2),(3783,4,297,'I',3),(3784,4,297,'I',4),(3785,4,297,'I',5),(3786,4,297,'I',6),(3787,4,297,'I',7),(3788,4,297,'I',8),(3789,4,297,'I',9),(3790,4,297,'I',10),(3791,3,297,'J',1),(3792,3,297,'J',2),(3793,3,297,'J',3),(3794,3,297,'J',4),(3795,3,297,'J',5),(3796,3,297,'J',6),(3797,3,297,'J',7),(3798,3,297,'J',8),(3799,3,297,'J',9),(3800,3,297,'J',10),(3801,1,305,'A',1),(3802,1,305,'A',2),(3803,1,305,'A',3),(3804,1,305,'A',4),(3805,1,305,'A',5),(3806,1,305,'A',6),(3807,1,305,'A',7),(3808,1,305,'A',8),(3809,1,305,'A',9),(3810,1,305,'A',10),(3811,1,305,'B',1),(3812,1,305,'B',2),(3813,1,305,'B',3),(3814,1,305,'B',4),(3815,1,305,'B',5),(3816,1,305,'B',6),(3817,1,305,'B',7),(3818,1,305,'B',8),(3819,1,305,'B',9),(3820,1,305,'B',10),(3821,1,305,'C',1),(3822,1,305,'C',2),(3823,1,305,'C',3),(3824,1,305,'C',4),(3825,1,305,'C',5),(3826,1,305,'C',6),(3827,1,305,'C',7),(3828,1,305,'C',8),(3829,1,305,'C',9),(3830,1,305,'C',10),(3831,1,305,'D',1),(3832,1,305,'D',2),(3833,1,305,'D',3),(3834,1,305,'D',4),(3835,1,305,'D',5),(3836,1,305,'D',6),(3837,1,305,'D',7),(3838,1,305,'D',8),(3839,1,305,'D',9),(3840,1,305,'D',10),(3841,1,305,'E',1),(3842,1,305,'E',2),(3843,1,305,'E',3),(3844,1,305,'E',4),(3845,1,305,'E',5),(3846,1,305,'E',6),(3847,1,305,'E',7),(3848,1,305,'E',8),(3849,1,305,'E',9),(3850,1,305,'E',10),(3851,2,305,'F',1),(3852,2,305,'F',2),(3853,2,305,'F',3),(3854,2,305,'F',4),(3855,2,305,'F',5),(3856,2,305,'F',6),(3857,2,305,'F',7),(3858,2,305,'F',8),(3859,2,305,'F',9),(3860,2,305,'F',10),(3861,2,305,'G',1),(3862,2,305,'G',2),(3863,2,305,'G',3),(3864,2,305,'G',4),(3865,2,305,'G',5),(3866,2,305,'G',6),(3867,2,305,'G',7),(3868,2,305,'G',8),(3869,2,305,'G',9),(3870,2,305,'G',10),(3871,5,305,'H',1),(3872,5,305,'H',2),(3873,5,305,'H',3),(3874,5,305,'H',4),(3875,5,305,'H',5),(3876,5,305,'H',6),(3877,5,305,'H',7),(3878,5,305,'H',8),(3879,5,305,'H',9),(3880,5,305,'H',10),(3881,4,305,'I',1),(3882,4,305,'I',2),(3883,4,305,'I',3),(3884,4,305,'I',4),(3885,4,305,'I',5),(3886,4,305,'I',6),(3887,4,305,'I',7),(3888,4,305,'I',8),(3889,4,305,'I',9),(3890,4,305,'I',10),(3891,3,305,'J',1),(3892,3,305,'J',2),(3893,3,305,'J',3),(3894,3,305,'J',4),(3895,3,305,'J',5),(3896,3,305,'J',6),(3897,3,305,'J',7),(3898,3,305,'J',8),(3899,3,305,'J',9),(3900,3,305,'J',10),(3901,1,313,'A',1),(3902,1,313,'A',2),(3903,1,313,'A',3),(3904,1,313,'A',4),(3905,1,313,'A',5),(3906,1,313,'A',6),(3907,1,313,'A',7),(3908,1,313,'A',8),(3909,1,313,'A',9),(3910,1,313,'A',10),(3911,1,313,'B',1),(3912,1,313,'B',2),(3913,1,313,'B',3),(3914,1,313,'B',4),(3915,1,313,'B',5),(3916,1,313,'B',6),(3917,1,313,'B',7),(3918,1,313,'B',8),(3919,1,313,'B',9),(3920,1,313,'B',10),(3921,1,313,'C',1),(3922,1,313,'C',2),(3923,1,313,'C',3),(3924,1,313,'C',4),(3925,1,313,'C',5),(3926,1,313,'C',6),(3927,1,313,'C',7),(3928,1,313,'C',8),(3929,1,313,'C',9),(3930,1,313,'C',10),(3931,1,313,'D',1),(3932,1,313,'D',2),(3933,1,313,'D',3),(3934,1,313,'D',4),(3935,1,313,'D',5),(3936,1,313,'D',6),(3937,1,313,'D',7),(3938,1,313,'D',8),(3939,1,313,'D',9),(3940,1,313,'D',10),(3941,1,313,'E',1),(3942,1,313,'E',2),(3943,1,313,'E',3),(3944,1,313,'E',4),(3945,1,313,'E',5),(3946,1,313,'E',6),(3947,1,313,'E',7),(3948,1,313,'E',8),(3949,1,313,'E',9),(3950,1,313,'E',10),(3951,2,313,'F',1),(3952,2,313,'F',2),(3953,2,313,'F',3),(3954,2,313,'F',4),(3955,2,313,'F',5),(3956,2,313,'F',6),(3957,2,313,'F',7),(3958,2,313,'F',8),(3959,2,313,'F',9),(3960,2,313,'F',10),(3961,2,313,'G',1),(3962,2,313,'G',2),(3963,2,313,'G',3),(3964,2,313,'G',4),(3965,2,313,'G',5),(3966,2,313,'G',6),(3967,2,313,'G',7),(3968,2,313,'G',8),(3969,2,313,'G',9),(3970,2,313,'G',10),(3971,5,313,'H',1),(3972,5,313,'H',2),(3973,5,313,'H',3),(3974,5,313,'H',4),(3975,5,313,'H',5),(3976,5,313,'H',6),(3977,5,313,'H',7),(3978,5,313,'H',8),(3979,5,313,'H',9),(3980,5,313,'H',10),(3981,4,313,'I',1),(3982,4,313,'I',2),(3983,4,313,'I',3),(3984,4,313,'I',4),(3985,4,313,'I',5),(3986,4,313,'I',6),(3987,4,313,'I',7),(3988,4,313,'I',8),(3989,4,313,'I',9),(3990,4,313,'I',10),(3991,3,313,'J',1),(3992,3,313,'J',2),(3993,3,313,'J',3),(3994,3,313,'J',4),(3995,3,313,'J',5),(3996,3,313,'J',6),(3997,3,313,'J',7),(3998,3,313,'J',8),(3999,3,313,'J',9),(4000,3,313,'J',10),(4001,1,321,'A',1),(4002,1,321,'A',2),(4003,1,321,'A',3),(4004,1,321,'A',4),(4005,1,321,'A',5),(4006,1,321,'A',6),(4007,1,321,'A',7),(4008,1,321,'A',8),(4009,1,321,'A',9),(4010,1,321,'A',10),(4011,1,321,'B',1),(4012,1,321,'B',2),(4013,1,321,'B',3),(4014,1,321,'B',4),(4015,1,321,'B',5),(4016,1,321,'B',6),(4017,1,321,'B',7),(4018,1,321,'B',8),(4019,1,321,'B',9),(4020,1,321,'B',10),(4021,1,321,'C',1),(4022,1,321,'C',2),(4023,1,321,'C',3),(4024,1,321,'C',4),(4025,1,321,'C',5),(4026,1,321,'C',6),(4027,1,321,'C',7),(4028,1,321,'C',8),(4029,1,321,'C',9),(4030,1,321,'C',10),(4031,1,321,'D',1),(4032,1,321,'D',2),(4033,1,321,'D',3),(4034,1,321,'D',4),(4035,1,321,'D',5),(4036,1,321,'D',6),(4037,1,321,'D',7),(4038,1,321,'D',8),(4039,1,321,'D',9),(4040,1,321,'D',10),(4041,1,321,'E',1),(4042,1,321,'E',2),(4043,1,321,'E',3),(4044,1,321,'E',4),(4045,1,321,'E',5),(4046,1,321,'E',6),(4047,1,321,'E',7),(4048,1,321,'E',8),(4049,1,321,'E',9),(4050,1,321,'E',10),(4051,2,321,'F',1),(4052,2,321,'F',2),(4053,2,321,'F',3),(4054,2,321,'F',4),(4055,2,321,'F',5),(4056,2,321,'F',6),(4057,2,321,'F',7),(4058,2,321,'F',8),(4059,2,321,'F',9),(4060,2,321,'F',10),(4061,2,321,'G',1),(4062,2,321,'G',2),(4063,2,321,'G',3),(4064,2,321,'G',4),(4065,2,321,'G',5),(4066,2,321,'G',6),(4067,2,321,'G',7),(4068,2,321,'G',8),(4069,2,321,'G',9),(4070,2,321,'G',10),(4071,5,321,'H',1),(4072,5,321,'H',2),(4073,5,321,'H',3),(4074,5,321,'H',4),(4075,5,321,'H',5),(4076,5,321,'H',6),(4077,5,321,'H',7),(4078,5,321,'H',8),(4079,5,321,'H',9),(4080,5,321,'H',10),(4081,4,321,'I',1),(4082,4,321,'I',2),(4083,4,321,'I',3),(4084,4,321,'I',4),(4085,4,321,'I',5),(4086,4,321,'I',6),(4087,4,321,'I',7),(4088,4,321,'I',8),(4089,4,321,'I',9),(4090,4,321,'I',10),(4091,3,321,'J',1),(4092,3,321,'J',2),(4093,3,321,'J',3),(4094,3,321,'J',4),(4095,3,321,'J',5),(4096,3,321,'J',6),(4097,3,321,'J',7),(4098,3,321,'J',8),(4099,3,321,'J',9),(4100,3,321,'J',10),(4101,1,329,'A',1),(4102,1,329,'A',2),(4103,1,329,'A',3),(4104,1,329,'A',4),(4105,1,329,'A',5),(4106,1,329,'A',6),(4107,1,329,'A',7),(4108,1,329,'A',8),(4109,1,329,'A',9),(4110,1,329,'A',10),(4111,1,329,'B',1),(4112,1,329,'B',2),(4113,1,329,'B',3),(4114,1,329,'B',4),(4115,1,329,'B',5),(4116,1,329,'B',6),(4117,1,329,'B',7),(4118,1,329,'B',8),(4119,1,329,'B',9),(4120,1,329,'B',10),(4121,1,329,'C',1),(4122,1,329,'C',2),(4123,1,329,'C',3),(4124,1,329,'C',4),(4125,1,329,'C',5),(4126,1,329,'C',6),(4127,1,329,'C',7),(4128,1,329,'C',8),(4129,1,329,'C',9),(4130,1,329,'C',10),(4131,1,329,'D',1),(4132,1,329,'D',2),(4133,1,329,'D',3),(4134,1,329,'D',4),(4135,1,329,'D',5),(4136,1,329,'D',6),(4137,1,329,'D',7),(4138,1,329,'D',8),(4139,1,329,'D',9),(4140,1,329,'D',10),(4141,1,329,'E',1),(4142,1,329,'E',2),(4143,1,329,'E',3),(4144,1,329,'E',4),(4145,1,329,'E',5),(4146,1,329,'E',6),(4147,1,329,'E',7),(4148,1,329,'E',8),(4149,1,329,'E',9),(4150,1,329,'E',10),(4151,2,329,'F',1),(4152,2,329,'F',2),(4153,2,329,'F',3),(4154,2,329,'F',4),(4155,2,329,'F',5),(4156,2,329,'F',6),(4157,2,329,'F',7),(4158,2,329,'F',8),(4159,2,329,'F',9),(4160,2,329,'F',10),(4161,2,329,'G',1),(4162,2,329,'G',2),(4163,2,329,'G',3),(4164,2,329,'G',4),(4165,2,329,'G',5),(4166,2,329,'G',6),(4167,2,329,'G',7),(4168,2,329,'G',8),(4169,2,329,'G',9),(4170,2,329,'G',10),(4171,5,329,'H',1),(4172,5,329,'H',2),(4173,5,329,'H',3),(4174,5,329,'H',4),(4175,5,329,'H',5),(4176,5,329,'H',6),(4177,5,329,'H',7),(4178,5,329,'H',8),(4179,5,329,'H',9),(4180,5,329,'H',10),(4181,4,329,'I',1),(4182,4,329,'I',2),(4183,4,329,'I',3),(4184,4,329,'I',4),(4185,4,329,'I',5),(4186,4,329,'I',6),(4187,4,329,'I',7),(4188,4,329,'I',8),(4189,4,329,'I',9),(4190,4,329,'I',10),(4191,3,329,'J',1),(4192,3,329,'J',2),(4193,3,329,'J',3),(4194,3,329,'J',4),(4195,3,329,'J',5),(4196,3,329,'J',6),(4197,3,329,'J',7),(4198,3,329,'J',8),(4199,3,329,'J',9),(4200,3,329,'J',10),(4201,1,337,'A',1),(4202,1,337,'A',2),(4203,1,337,'A',3),(4204,1,337,'A',4),(4205,1,337,'A',5),(4206,1,337,'A',6),(4207,1,337,'A',7),(4208,1,337,'A',8),(4209,1,337,'A',9),(4210,1,337,'A',10),(4211,1,337,'B',1),(4212,1,337,'B',2),(4213,1,337,'B',3),(4214,1,337,'B',4),(4215,1,337,'B',5),(4216,1,337,'B',6),(4217,1,337,'B',7),(4218,1,337,'B',8),(4219,1,337,'B',9),(4220,1,337,'B',10),(4221,1,337,'C',1),(4222,1,337,'C',2),(4223,1,337,'C',3),(4224,1,337,'C',4),(4225,1,337,'C',5),(4226,1,337,'C',6),(4227,1,337,'C',7),(4228,1,337,'C',8),(4229,1,337,'C',9),(4230,1,337,'C',10),(4231,1,337,'D',1),(4232,1,337,'D',2),(4233,1,337,'D',3),(4234,1,337,'D',4),(4235,1,337,'D',5),(4236,1,337,'D',6),(4237,1,337,'D',7),(4238,1,337,'D',8),(4239,1,337,'D',9),(4240,1,337,'D',10),(4241,1,337,'E',1),(4242,1,337,'E',2),(4243,1,337,'E',3),(4244,1,337,'E',4),(4245,1,337,'E',5),(4246,1,337,'E',6),(4247,1,337,'E',7),(4248,1,337,'E',8),(4249,1,337,'E',9),(4250,1,337,'E',10),(4251,2,337,'F',1),(4252,2,337,'F',2),(4253,2,337,'F',3),(4254,2,337,'F',4),(4255,2,337,'F',5),(4256,2,337,'F',6),(4257,2,337,'F',7),(4258,2,337,'F',8),(4259,2,337,'F',9),(4260,2,337,'F',10),(4261,2,337,'G',1),(4262,2,337,'G',2),(4263,2,337,'G',3),(4264,2,337,'G',4),(4265,2,337,'G',5),(4266,2,337,'G',6),(4267,2,337,'G',7),(4268,2,337,'G',8),(4269,2,337,'G',9),(4270,2,337,'G',10),(4271,5,337,'H',1),(4272,5,337,'H',2),(4273,5,337,'H',3),(4274,5,337,'H',4),(4275,5,337,'H',5),(4276,5,337,'H',6),(4277,5,337,'H',7),(4278,5,337,'H',8),(4279,5,337,'H',9),(4280,5,337,'H',10),(4281,4,337,'I',1),(4282,4,337,'I',2),(4283,4,337,'I',3),(4284,4,337,'I',4),(4285,4,337,'I',5),(4286,4,337,'I',6),(4287,4,337,'I',7),(4288,4,337,'I',8),(4289,4,337,'I',9),(4290,4,337,'I',10),(4291,3,337,'J',1),(4292,3,337,'J',2),(4293,3,337,'J',3),(4294,3,337,'J',4),(4295,3,337,'J',5),(4296,3,337,'J',6),(4297,3,337,'J',7),(4298,3,337,'J',8),(4299,3,337,'J',9),(4300,3,337,'J',10),(4301,1,345,'A',1),(4302,1,345,'A',2),(4303,1,345,'A',3),(4304,1,345,'A',4),(4305,1,345,'A',5),(4306,1,345,'A',6),(4307,1,345,'A',7),(4308,1,345,'A',8),(4309,1,345,'A',9),(4310,1,345,'A',10),(4311,1,345,'B',1),(4312,1,345,'B',2),(4313,1,345,'B',3),(4314,1,345,'B',4),(4315,1,345,'B',5),(4316,1,345,'B',6),(4317,1,345,'B',7),(4318,1,345,'B',8),(4319,1,345,'B',9),(4320,1,345,'B',10),(4321,1,345,'C',1),(4322,1,345,'C',2),(4323,1,345,'C',3),(4324,1,345,'C',4),(4325,1,345,'C',5),(4326,1,345,'C',6),(4327,1,345,'C',7),(4328,1,345,'C',8),(4329,1,345,'C',9),(4330,1,345,'C',10),(4331,1,345,'D',1),(4332,1,345,'D',2),(4333,1,345,'D',3),(4334,1,345,'D',4),(4335,1,345,'D',5),(4336,1,345,'D',6),(4337,1,345,'D',7),(4338,1,345,'D',8),(4339,1,345,'D',9),(4340,1,345,'D',10),(4341,1,345,'E',1),(4342,1,345,'E',2),(4343,1,345,'E',3),(4344,1,345,'E',4),(4345,1,345,'E',5),(4346,1,345,'E',6),(4347,1,345,'E',7),(4348,1,345,'E',8),(4349,1,345,'E',9),(4350,1,345,'E',10),(4351,2,345,'F',1),(4352,2,345,'F',2),(4353,2,345,'F',3),(4354,2,345,'F',4),(4355,2,345,'F',5),(4356,2,345,'F',6),(4357,2,345,'F',7),(4358,2,345,'F',8),(4359,2,345,'F',9),(4360,2,345,'F',10),(4361,2,345,'G',1),(4362,2,345,'G',2),(4363,2,345,'G',3),(4364,2,345,'G',4),(4365,2,345,'G',5),(4366,2,345,'G',6),(4367,2,345,'G',7),(4368,2,345,'G',8),(4369,2,345,'G',9),(4370,2,345,'G',10),(4371,5,345,'H',1),(4372,5,345,'H',2),(4373,5,345,'H',3),(4374,5,345,'H',4),(4375,5,345,'H',5),(4376,5,345,'H',6),(4377,5,345,'H',7),(4378,5,345,'H',8),(4379,5,345,'H',9),(4380,5,345,'H',10),(4381,4,345,'I',1),(4382,4,345,'I',2),(4383,4,345,'I',3),(4384,4,345,'I',4),(4385,4,345,'I',5),(4386,4,345,'I',6),(4387,4,345,'I',7),(4388,4,345,'I',8),(4389,4,345,'I',9),(4390,4,345,'I',10),(4391,3,345,'J',1),(4392,3,345,'J',2),(4393,3,345,'J',3),(4394,3,345,'J',4),(4395,3,345,'J',5),(4396,3,345,'J',6),(4397,3,345,'J',7),(4398,3,345,'J',8),(4399,3,345,'J',9),(4400,3,345,'J',10),(4401,1,353,'A',1),(4402,1,353,'A',2),(4403,1,353,'A',3),(4404,1,353,'A',4),(4405,1,353,'A',5),(4406,1,353,'A',6),(4407,1,353,'A',7),(4408,1,353,'A',8),(4409,1,353,'A',9),(4410,1,353,'A',10),(4411,1,353,'B',1),(4412,1,353,'B',2),(4413,1,353,'B',3),(4414,1,353,'B',4),(4415,1,353,'B',5),(4416,1,353,'B',6),(4417,1,353,'B',7),(4418,1,353,'B',8),(4419,1,353,'B',9),(4420,1,353,'B',10),(4421,1,353,'C',1),(4422,1,353,'C',2),(4423,1,353,'C',3),(4424,1,353,'C',4),(4425,1,353,'C',5),(4426,1,353,'C',6),(4427,1,353,'C',7),(4428,1,353,'C',8),(4429,1,353,'C',9),(4430,1,353,'C',10),(4431,1,353,'D',1),(4432,1,353,'D',2),(4433,1,353,'D',3),(4434,1,353,'D',4),(4435,1,353,'D',5),(4436,1,353,'D',6),(4437,1,353,'D',7),(4438,1,353,'D',8),(4439,1,353,'D',9),(4440,1,353,'D',10),(4441,1,353,'E',1),(4442,1,353,'E',2),(4443,1,353,'E',3),(4444,1,353,'E',4),(4445,1,353,'E',5),(4446,1,353,'E',6),(4447,1,353,'E',7),(4448,1,353,'E',8),(4449,1,353,'E',9),(4450,1,353,'E',10),(4451,2,353,'F',1),(4452,2,353,'F',2),(4453,2,353,'F',3),(4454,2,353,'F',4),(4455,2,353,'F',5),(4456,2,353,'F',6),(4457,2,353,'F',7),(4458,2,353,'F',8),(4459,2,353,'F',9),(4460,2,353,'F',10),(4461,2,353,'G',1),(4462,2,353,'G',2),(4463,2,353,'G',3),(4464,2,353,'G',4),(4465,2,353,'G',5),(4466,2,353,'G',6),(4467,2,353,'G',7),(4468,2,353,'G',8),(4469,2,353,'G',9),(4470,2,353,'G',10),(4471,5,353,'H',1),(4472,5,353,'H',2),(4473,5,353,'H',3),(4474,5,353,'H',4),(4475,5,353,'H',5),(4476,5,353,'H',6),(4477,5,353,'H',7),(4478,5,353,'H',8),(4479,5,353,'H',9),(4480,5,353,'H',10),(4481,4,353,'I',1),(4482,4,353,'I',2),(4483,4,353,'I',3),(4484,4,353,'I',4),(4485,4,353,'I',5),(4486,4,353,'I',6),(4487,4,353,'I',7),(4488,4,353,'I',8),(4489,4,353,'I',9),(4490,4,353,'I',10),(4491,3,353,'J',1),(4492,3,353,'J',2),(4493,3,353,'J',3),(4494,3,353,'J',4),(4495,3,353,'J',5),(4496,3,353,'J',6),(4497,3,353,'J',7),(4498,3,353,'J',8),(4499,3,353,'J',9),(4500,3,353,'J',10),(4501,1,361,'A',1),(4502,1,361,'A',2),(4503,1,361,'A',3),(4504,1,361,'A',4),(4505,1,361,'A',5),(4506,1,361,'A',6),(4507,1,361,'A',7),(4508,1,361,'A',8),(4509,1,361,'A',9),(4510,1,361,'A',10),(4511,1,361,'B',1),(4512,1,361,'B',2),(4513,1,361,'B',3),(4514,1,361,'B',4),(4515,1,361,'B',5),(4516,1,361,'B',6),(4517,1,361,'B',7),(4518,1,361,'B',8),(4519,1,361,'B',9),(4520,1,361,'B',10),(4521,1,361,'C',1),(4522,1,361,'C',2),(4523,1,361,'C',3),(4524,1,361,'C',4),(4525,1,361,'C',5),(4526,1,361,'C',6),(4527,1,361,'C',7),(4528,1,361,'C',8),(4529,1,361,'C',9),(4530,1,361,'C',10),(4531,1,361,'D',1),(4532,1,361,'D',2),(4533,1,361,'D',3),(4534,1,361,'D',4),(4535,1,361,'D',5),(4536,1,361,'D',6),(4537,1,361,'D',7),(4538,1,361,'D',8),(4539,1,361,'D',9),(4540,1,361,'D',10),(4541,1,361,'E',1),(4542,1,361,'E',2),(4543,1,361,'E',3),(4544,1,361,'E',4),(4545,1,361,'E',5),(4546,1,361,'E',6),(4547,1,361,'E',7),(4548,1,361,'E',8),(4549,1,361,'E',9),(4550,1,361,'E',10),(4551,2,361,'F',1),(4552,2,361,'F',2),(4553,2,361,'F',3),(4554,2,361,'F',4),(4555,2,361,'F',5),(4556,2,361,'F',6),(4557,2,361,'F',7),(4558,2,361,'F',8),(4559,2,361,'F',9),(4560,2,361,'F',10),(4561,2,361,'G',1),(4562,2,361,'G',2),(4563,2,361,'G',3),(4564,2,361,'G',4),(4565,2,361,'G',5),(4566,2,361,'G',6),(4567,2,361,'G',7),(4568,2,361,'G',8),(4569,2,361,'G',9),(4570,2,361,'G',10),(4571,5,361,'H',1),(4572,5,361,'H',2),(4573,5,361,'H',3),(4574,5,361,'H',4),(4575,5,361,'H',5),(4576,5,361,'H',6),(4577,5,361,'H',7),(4578,5,361,'H',8),(4579,5,361,'H',9),(4580,5,361,'H',10),(4581,4,361,'I',1),(4582,4,361,'I',2),(4583,4,361,'I',3),(4584,4,361,'I',4),(4585,4,361,'I',5),(4586,4,361,'I',6),(4587,4,361,'I',7),(4588,4,361,'I',8),(4589,4,361,'I',9),(4590,4,361,'I',10),(4591,3,361,'J',1),(4592,3,361,'J',2),(4593,3,361,'J',3),(4594,3,361,'J',4),(4595,3,361,'J',5),(4596,3,361,'J',6),(4597,3,361,'J',7),(4598,3,361,'J',8),(4599,3,361,'J',9),(4600,3,361,'J',10),(4601,1,369,'A',1),(4602,1,369,'A',2),(4603,1,369,'A',3),(4604,1,369,'A',4),(4605,1,369,'A',5),(4606,1,369,'A',6),(4607,1,369,'A',7),(4608,1,369,'A',8),(4609,1,369,'A',9),(4610,1,369,'A',10),(4611,1,369,'B',1),(4612,1,369,'B',2),(4613,1,369,'B',3),(4614,1,369,'B',4),(4615,1,369,'B',5),(4616,1,369,'B',6),(4617,1,369,'B',7),(4618,1,369,'B',8),(4619,1,369,'B',9),(4620,1,369,'B',10),(4621,1,369,'C',1),(4622,1,369,'C',2),(4623,1,369,'C',3),(4624,1,369,'C',4),(4625,1,369,'C',5),(4626,1,369,'C',6),(4627,1,369,'C',7),(4628,1,369,'C',8),(4629,1,369,'C',9),(4630,1,369,'C',10),(4631,1,369,'D',1),(4632,1,369,'D',2),(4633,1,369,'D',3),(4634,1,369,'D',4),(4635,1,369,'D',5),(4636,1,369,'D',6),(4637,1,369,'D',7),(4638,1,369,'D',8),(4639,1,369,'D',9),(4640,1,369,'D',10),(4641,1,369,'E',1),(4642,1,369,'E',2),(4643,1,369,'E',3),(4644,1,369,'E',4),(4645,1,369,'E',5),(4646,1,369,'E',6),(4647,1,369,'E',7),(4648,1,369,'E',8),(4649,1,369,'E',9),(4650,1,369,'E',10),(4651,2,369,'F',1),(4652,2,369,'F',2),(4653,2,369,'F',3),(4654,2,369,'F',4),(4655,2,369,'F',5),(4656,2,369,'F',6),(4657,2,369,'F',7),(4658,2,369,'F',8),(4659,2,369,'F',9),(4660,2,369,'F',10),(4661,2,369,'G',1),(4662,2,369,'G',2),(4663,2,369,'G',3),(4664,2,369,'G',4),(4665,2,369,'G',5),(4666,2,369,'G',6),(4667,2,369,'G',7),(4668,2,369,'G',8),(4669,2,369,'G',9),(4670,2,369,'G',10),(4671,5,369,'H',1),(4672,5,369,'H',2),(4673,5,369,'H',3),(4674,5,369,'H',4),(4675,5,369,'H',5),(4676,5,369,'H',6),(4677,5,369,'H',7),(4678,5,369,'H',8),(4679,5,369,'H',9),(4680,5,369,'H',10),(4681,4,369,'I',1),(4682,4,369,'I',2),(4683,4,369,'I',3),(4684,4,369,'I',4),(4685,4,369,'I',5),(4686,4,369,'I',6),(4687,4,369,'I',7),(4688,4,369,'I',8),(4689,4,369,'I',9),(4690,4,369,'I',10),(4691,3,369,'J',1),(4692,3,369,'J',2),(4693,3,369,'J',3),(4694,3,369,'J',4),(4695,3,369,'J',5),(4696,3,369,'J',6),(4697,3,369,'J',7),(4698,3,369,'J',8),(4699,3,369,'J',9),(4700,3,369,'J',10),(4701,1,377,'A',1),(4702,1,377,'A',2),(4703,1,377,'A',3),(4704,1,377,'A',4),(4705,1,377,'A',5),(4706,1,377,'A',6),(4707,1,377,'A',7),(4708,1,377,'A',8),(4709,1,377,'A',9),(4710,1,377,'A',10),(4711,1,377,'B',1),(4712,1,377,'B',2),(4713,1,377,'B',3),(4714,1,377,'B',4),(4715,1,377,'B',5),(4716,1,377,'B',6),(4717,1,377,'B',7),(4718,1,377,'B',8),(4719,1,377,'B',9),(4720,1,377,'B',10),(4721,1,377,'C',1),(4722,1,377,'C',2),(4723,1,377,'C',3),(4724,1,377,'C',4),(4725,1,377,'C',5),(4726,1,377,'C',6),(4727,1,377,'C',7),(4728,1,377,'C',8),(4729,1,377,'C',9),(4730,1,377,'C',10),(4731,1,377,'D',1),(4732,1,377,'D',2),(4733,1,377,'D',3),(4734,1,377,'D',4),(4735,1,377,'D',5),(4736,1,377,'D',6),(4737,1,377,'D',7),(4738,1,377,'D',8),(4739,1,377,'D',9),(4740,1,377,'D',10),(4741,1,377,'E',1),(4742,1,377,'E',2),(4743,1,377,'E',3),(4744,1,377,'E',4),(4745,1,377,'E',5),(4746,1,377,'E',6),(4747,1,377,'E',7),(4748,1,377,'E',8),(4749,1,377,'E',9),(4750,1,377,'E',10),(4751,2,377,'F',1),(4752,2,377,'F',2),(4753,2,377,'F',3),(4754,2,377,'F',4),(4755,2,377,'F',5),(4756,2,377,'F',6),(4757,2,377,'F',7),(4758,2,377,'F',8),(4759,2,377,'F',9),(4760,2,377,'F',10),(4761,2,377,'G',1),(4762,2,377,'G',2),(4763,2,377,'G',3),(4764,2,377,'G',4),(4765,2,377,'G',5),(4766,2,377,'G',6),(4767,2,377,'G',7),(4768,2,377,'G',8),(4769,2,377,'G',9),(4770,2,377,'G',10),(4771,5,377,'H',1),(4772,5,377,'H',2),(4773,5,377,'H',3),(4774,5,377,'H',4),(4775,5,377,'H',5),(4776,5,377,'H',6),(4777,5,377,'H',7),(4778,5,377,'H',8),(4779,5,377,'H',9),(4780,5,377,'H',10),(4781,4,377,'I',1),(4782,4,377,'I',2),(4783,4,377,'I',3),(4784,4,377,'I',4),(4785,4,377,'I',5),(4786,4,377,'I',6),(4787,4,377,'I',7),(4788,4,377,'I',8),(4789,4,377,'I',9),(4790,4,377,'I',10),(4791,3,377,'J',1),(4792,3,377,'J',2),(4793,3,377,'J',3),(4794,3,377,'J',4),(4795,3,377,'J',5),(4796,3,377,'J',6),(4797,3,377,'J',7),(4798,3,377,'J',8),(4799,3,377,'J',9),(4800,3,377,'J',10),(4801,1,385,'A',1),(4802,1,385,'A',2),(4803,1,385,'A',3),(4804,1,385,'A',4),(4805,1,385,'A',5),(4806,1,385,'A',6),(4807,1,385,'A',7),(4808,1,385,'A',8),(4809,1,385,'A',9),(4810,1,385,'A',10),(4811,1,385,'B',1),(4812,1,385,'B',2),(4813,1,385,'B',3),(4814,1,385,'B',4),(4815,1,385,'B',5),(4816,1,385,'B',6),(4817,1,385,'B',7),(4818,1,385,'B',8),(4819,1,385,'B',9),(4820,1,385,'B',10),(4821,1,385,'C',1),(4822,1,385,'C',2),(4823,1,385,'C',3),(4824,1,385,'C',4),(4825,1,385,'C',5),(4826,1,385,'C',6),(4827,1,385,'C',7),(4828,1,385,'C',8),(4829,1,385,'C',9),(4830,1,385,'C',10),(4831,1,385,'D',1),(4832,1,385,'D',2),(4833,1,385,'D',3),(4834,1,385,'D',4),(4835,1,385,'D',5),(4836,1,385,'D',6),(4837,1,385,'D',7),(4838,1,385,'D',8),(4839,1,385,'D',9),(4840,1,385,'D',10),(4841,1,385,'E',1),(4842,1,385,'E',2),(4843,1,385,'E',3),(4844,1,385,'E',4),(4845,1,385,'E',5),(4846,1,385,'E',6),(4847,1,385,'E',7),(4848,1,385,'E',8),(4849,1,385,'E',9),(4850,1,385,'E',10),(4851,2,385,'F',1),(4852,2,385,'F',2),(4853,2,385,'F',3),(4854,2,385,'F',4),(4855,2,385,'F',5),(4856,2,385,'F',6),(4857,2,385,'F',7),(4858,2,385,'F',8),(4859,2,385,'F',9),(4860,2,385,'F',10),(4861,2,385,'G',1),(4862,2,385,'G',2),(4863,2,385,'G',3),(4864,2,385,'G',4),(4865,2,385,'G',5),(4866,2,385,'G',6),(4867,2,385,'G',7),(4868,2,385,'G',8),(4869,2,385,'G',9),(4870,2,385,'G',10),(4871,5,385,'H',1),(4872,5,385,'H',2),(4873,5,385,'H',3),(4874,5,385,'H',4),(4875,5,385,'H',5),(4876,5,385,'H',6),(4877,5,385,'H',7),(4878,5,385,'H',8),(4879,5,385,'H',9),(4880,5,385,'H',10),(4881,4,385,'I',1),(4882,4,385,'I',2),(4883,4,385,'I',3),(4884,4,385,'I',4),(4885,4,385,'I',5),(4886,4,385,'I',6),(4887,4,385,'I',7),(4888,4,385,'I',8),(4889,4,385,'I',9),(4890,4,385,'I',10),(4891,3,385,'J',1),(4892,3,385,'J',2),(4893,3,385,'J',3),(4894,3,385,'J',4),(4895,3,385,'J',5),(4896,3,385,'J',6),(4897,3,385,'J',7),(4898,3,385,'J',8),(4899,3,385,'J',9),(4900,3,385,'J',10),(4901,1,393,'A',1),(4902,1,393,'A',2),(4903,1,393,'A',3),(4904,1,393,'A',4),(4905,1,393,'A',5),(4906,1,393,'A',6),(4907,1,393,'A',7),(4908,1,393,'A',8),(4909,1,393,'A',9),(4910,1,393,'A',10),(4911,1,393,'B',1),(4912,1,393,'B',2),(4913,1,393,'B',3),(4914,1,393,'B',4),(4915,1,393,'B',5),(4916,1,393,'B',6),(4917,1,393,'B',7),(4918,1,393,'B',8),(4919,1,393,'B',9),(4920,1,393,'B',10),(4921,1,393,'C',1),(4922,1,393,'C',2),(4923,1,393,'C',3),(4924,1,393,'C',4),(4925,1,393,'C',5),(4926,1,393,'C',6),(4927,1,393,'C',7),(4928,1,393,'C',8),(4929,1,393,'C',9),(4930,1,393,'C',10),(4931,1,393,'D',1),(4932,1,393,'D',2),(4933,1,393,'D',3),(4934,1,393,'D',4),(4935,1,393,'D',5),(4936,1,393,'D',6),(4937,1,393,'D',7),(4938,1,393,'D',8),(4939,1,393,'D',9),(4940,1,393,'D',10),(4941,1,393,'E',1),(4942,1,393,'E',2),(4943,1,393,'E',3),(4944,1,393,'E',4),(4945,1,393,'E',5),(4946,1,393,'E',6),(4947,1,393,'E',7),(4948,1,393,'E',8),(4949,1,393,'E',9),(4950,1,393,'E',10),(4951,2,393,'F',1),(4952,2,393,'F',2),(4953,2,393,'F',3),(4954,2,393,'F',4),(4955,2,393,'F',5),(4956,2,393,'F',6),(4957,2,393,'F',7),(4958,2,393,'F',8),(4959,2,393,'F',9),(4960,2,393,'F',10),(4961,2,393,'G',1),(4962,2,393,'G',2),(4963,2,393,'G',3),(4964,2,393,'G',4),(4965,2,393,'G',5),(4966,2,393,'G',6),(4967,2,393,'G',7),(4968,2,393,'G',8),(4969,2,393,'G',9),(4970,2,393,'G',10),(4971,5,393,'H',1),(4972,5,393,'H',2),(4973,5,393,'H',3),(4974,5,393,'H',4),(4975,5,393,'H',5),(4976,5,393,'H',6),(4977,5,393,'H',7),(4978,5,393,'H',8),(4979,5,393,'H',9),(4980,5,393,'H',10),(4981,4,393,'I',1),(4982,4,393,'I',2),(4983,4,393,'I',3),(4984,4,393,'I',4),(4985,4,393,'I',5),(4986,4,393,'I',6),(4987,4,393,'I',7),(4988,4,393,'I',8),(4989,4,393,'I',9),(4990,4,393,'I',10),(4991,3,393,'J',1),(4992,3,393,'J',2),(4993,3,393,'J',3),(4994,3,393,'J',4),(4995,3,393,'J',5),(4996,3,393,'J',6),(4997,3,393,'J',7),(4998,3,393,'J',8),(4999,3,393,'J',9),(5000,3,393,'J',10),(5001,1,401,'A',1),(5002,1,401,'A',2),(5003,1,401,'A',3),(5004,1,401,'A',4),(5005,1,401,'A',5),(5006,1,401,'A',6),(5007,1,401,'A',7),(5008,1,401,'A',8),(5009,1,401,'A',9),(5010,1,401,'A',10),(5011,1,401,'B',1),(5012,1,401,'B',2),(5013,1,401,'B',3),(5014,1,401,'B',4),(5015,1,401,'B',5),(5016,1,401,'B',6),(5017,1,401,'B',7),(5018,1,401,'B',8),(5019,1,401,'B',9),(5020,1,401,'B',10),(5021,1,401,'C',1),(5022,1,401,'C',2),(5023,1,401,'C',3),(5024,1,401,'C',4),(5025,1,401,'C',5),(5026,1,401,'C',6),(5027,1,401,'C',7),(5028,1,401,'C',8),(5029,1,401,'C',9),(5030,1,401,'C',10),(5031,1,401,'D',1),(5032,1,401,'D',2),(5033,1,401,'D',3),(5034,1,401,'D',4),(5035,1,401,'D',5),(5036,1,401,'D',6),(5037,1,401,'D',7),(5038,1,401,'D',8),(5039,1,401,'D',9),(5040,1,401,'D',10),(5041,1,401,'E',1),(5042,1,401,'E',2),(5043,1,401,'E',3),(5044,1,401,'E',4),(5045,1,401,'E',5),(5046,1,401,'E',6),(5047,1,401,'E',7),(5048,1,401,'E',8),(5049,1,401,'E',9),(5050,1,401,'E',10),(5051,2,401,'F',1),(5052,2,401,'F',2),(5053,2,401,'F',3),(5054,2,401,'F',4),(5055,2,401,'F',5),(5056,2,401,'F',6),(5057,2,401,'F',7),(5058,2,401,'F',8),(5059,2,401,'F',9),(5060,2,401,'F',10),(5061,2,401,'G',1),(5062,2,401,'G',2),(5063,2,401,'G',3),(5064,2,401,'G',4),(5065,2,401,'G',5),(5066,2,401,'G',6),(5067,2,401,'G',7),(5068,2,401,'G',8),(5069,2,401,'G',9),(5070,2,401,'G',10),(5071,5,401,'H',1),(5072,5,401,'H',2),(5073,5,401,'H',3),(5074,5,401,'H',4),(5075,5,401,'H',5),(5076,5,401,'H',6),(5077,5,401,'H',7),(5078,5,401,'H',8),(5079,5,401,'H',9),(5080,5,401,'H',10),(5081,4,401,'I',1),(5082,4,401,'I',2),(5083,4,401,'I',3),(5084,4,401,'I',4),(5085,4,401,'I',5),(5086,4,401,'I',6),(5087,4,401,'I',7),(5088,4,401,'I',8),(5089,4,401,'I',9),(5090,4,401,'I',10),(5091,3,401,'J',1),(5092,3,401,'J',2),(5093,3,401,'J',3),(5094,3,401,'J',4),(5095,3,401,'J',5),(5096,3,401,'J',6),(5097,3,401,'J',7),(5098,3,401,'J',8),(5099,3,401,'J',9),(5100,3,401,'J',10),(5101,1,409,'A',1),(5102,1,409,'A',2),(5103,1,409,'A',3),(5104,1,409,'A',4),(5105,1,409,'A',5),(5106,1,409,'A',6),(5107,1,409,'A',7),(5108,1,409,'A',8),(5109,1,409,'A',9),(5110,1,409,'A',10),(5111,1,409,'B',1),(5112,1,409,'B',2),(5113,1,409,'B',3),(5114,1,409,'B',4),(5115,1,409,'B',5),(5116,1,409,'B',6),(5117,1,409,'B',7),(5118,1,409,'B',8),(5119,1,409,'B',9),(5120,1,409,'B',10),(5121,1,409,'C',1),(5122,1,409,'C',2),(5123,1,409,'C',3),(5124,1,409,'C',4),(5125,1,409,'C',5),(5126,1,409,'C',6),(5127,1,409,'C',7),(5128,1,409,'C',8),(5129,1,409,'C',9),(5130,1,409,'C',10),(5131,1,409,'D',1),(5132,1,409,'D',2),(5133,1,409,'D',3),(5134,1,409,'D',4),(5135,1,409,'D',5),(5136,1,409,'D',6),(5137,1,409,'D',7),(5138,1,409,'D',8),(5139,1,409,'D',9),(5140,1,409,'D',10),(5141,1,409,'E',1),(5142,1,409,'E',2),(5143,1,409,'E',3),(5144,1,409,'E',4),(5145,1,409,'E',5),(5146,1,409,'E',6),(5147,1,409,'E',7),(5148,1,409,'E',8),(5149,1,409,'E',9),(5150,1,409,'E',10),(5151,2,409,'F',1),(5152,2,409,'F',2),(5153,2,409,'F',3),(5154,2,409,'F',4),(5155,2,409,'F',5),(5156,2,409,'F',6),(5157,2,409,'F',7),(5158,2,409,'F',8),(5159,2,409,'F',9),(5160,2,409,'F',10),(5161,2,409,'G',1),(5162,2,409,'G',2),(5163,2,409,'G',3),(5164,2,409,'G',4),(5165,2,409,'G',5),(5166,2,409,'G',6),(5167,2,409,'G',7),(5168,2,409,'G',8),(5169,2,409,'G',9),(5170,2,409,'G',10),(5171,5,409,'H',1),(5172,5,409,'H',2),(5173,5,409,'H',3),(5174,5,409,'H',4),(5175,5,409,'H',5),(5176,5,409,'H',6),(5177,5,409,'H',7),(5178,5,409,'H',8),(5179,5,409,'H',9),(5180,5,409,'H',10),(5181,4,409,'I',1),(5182,4,409,'I',2),(5183,4,409,'I',3),(5184,4,409,'I',4),(5185,4,409,'I',5),(5186,4,409,'I',6),(5187,4,409,'I',7),(5188,4,409,'I',8),(5189,4,409,'I',9),(5190,4,409,'I',10),(5191,3,409,'J',1),(5192,3,409,'J',2),(5193,3,409,'J',3),(5194,3,409,'J',4),(5195,3,409,'J',5),(5196,3,409,'J',6),(5197,3,409,'J',7),(5198,3,409,'J',8),(5199,3,409,'J',9),(5200,3,409,'J',10),(5201,1,417,'A',1),(5202,1,417,'A',2),(5203,1,417,'A',3),(5204,1,417,'A',4),(5205,1,417,'A',5),(5206,1,417,'A',6),(5207,1,417,'A',7),(5208,1,417,'A',8),(5209,1,417,'A',9),(5210,1,417,'A',10),(5211,1,417,'B',1),(5212,1,417,'B',2),(5213,1,417,'B',3),(5214,1,417,'B',4),(5215,1,417,'B',5),(5216,1,417,'B',6),(5217,1,417,'B',7),(5218,1,417,'B',8),(5219,1,417,'B',9),(5220,1,417,'B',10),(5221,1,417,'C',1),(5222,1,417,'C',2),(5223,1,417,'C',3),(5224,1,417,'C',4),(5225,1,417,'C',5),(5226,1,417,'C',6),(5227,1,417,'C',7),(5228,1,417,'C',8),(5229,1,417,'C',9),(5230,1,417,'C',10),(5231,1,417,'D',1),(5232,1,417,'D',2),(5233,1,417,'D',3),(5234,1,417,'D',4),(5235,1,417,'D',5),(5236,1,417,'D',6),(5237,1,417,'D',7),(5238,1,417,'D',8),(5239,1,417,'D',9),(5240,1,417,'D',10),(5241,1,417,'E',1),(5242,1,417,'E',2),(5243,1,417,'E',3),(5244,1,417,'E',4),(5245,1,417,'E',5),(5246,1,417,'E',6),(5247,1,417,'E',7),(5248,1,417,'E',8),(5249,1,417,'E',9),(5250,1,417,'E',10),(5251,2,417,'F',1),(5252,2,417,'F',2),(5253,2,417,'F',3),(5254,2,417,'F',4),(5255,2,417,'F',5),(5256,2,417,'F',6),(5257,2,417,'F',7),(5258,2,417,'F',8),(5259,2,417,'F',9),(5260,2,417,'F',10),(5261,2,417,'G',1),(5262,2,417,'G',2),(5263,2,417,'G',3),(5264,2,417,'G',4),(5265,2,417,'G',5),(5266,2,417,'G',6),(5267,2,417,'G',7),(5268,2,417,'G',8),(5269,2,417,'G',9),(5270,2,417,'G',10),(5271,5,417,'H',1),(5272,5,417,'H',2),(5273,5,417,'H',3),(5274,5,417,'H',4),(5275,5,417,'H',5),(5276,5,417,'H',6),(5277,5,417,'H',7),(5278,5,417,'H',8),(5279,5,417,'H',9),(5280,5,417,'H',10),(5281,4,417,'I',1),(5282,4,417,'I',2),(5283,4,417,'I',3),(5284,4,417,'I',4),(5285,4,417,'I',5),(5286,4,417,'I',6),(5287,4,417,'I',7),(5288,4,417,'I',8),(5289,4,417,'I',9),(5290,4,417,'I',10),(5291,3,417,'J',1),(5292,3,417,'J',2),(5293,3,417,'J',3),(5294,3,417,'J',4),(5295,3,417,'J',5),(5296,3,417,'J',6),(5297,3,417,'J',7),(5298,3,417,'J',8),(5299,3,417,'J',9),(5300,3,417,'J',10),(5301,1,425,'A',1),(5302,1,425,'A',2),(5303,1,425,'A',3),(5304,1,425,'A',4),(5305,1,425,'A',5),(5306,1,425,'A',6),(5307,1,425,'A',7),(5308,1,425,'A',8),(5309,1,425,'A',9),(5310,1,425,'A',10),(5311,1,425,'B',1),(5312,1,425,'B',2),(5313,1,425,'B',3),(5314,1,425,'B',4),(5315,1,425,'B',5),(5316,1,425,'B',6),(5317,1,425,'B',7),(5318,1,425,'B',8),(5319,1,425,'B',9),(5320,1,425,'B',10),(5321,1,425,'C',1),(5322,1,425,'C',2),(5323,1,425,'C',3),(5324,1,425,'C',4),(5325,1,425,'C',5),(5326,1,425,'C',6),(5327,1,425,'C',7),(5328,1,425,'C',8),(5329,1,425,'C',9),(5330,1,425,'C',10),(5331,1,425,'D',1),(5332,1,425,'D',2),(5333,1,425,'D',3),(5334,1,425,'D',4),(5335,1,425,'D',5),(5336,1,425,'D',6),(5337,1,425,'D',7),(5338,1,425,'D',8),(5339,1,425,'D',9),(5340,1,425,'D',10),(5341,1,425,'E',1),(5342,1,425,'E',2),(5343,1,425,'E',3),(5344,1,425,'E',4),(5345,1,425,'E',5),(5346,1,425,'E',6),(5347,1,425,'E',7),(5348,1,425,'E',8),(5349,1,425,'E',9),(5350,1,425,'E',10),(5351,2,425,'F',1),(5352,2,425,'F',2),(5353,2,425,'F',3),(5354,2,425,'F',4),(5355,2,425,'F',5),(5356,2,425,'F',6),(5357,2,425,'F',7),(5358,2,425,'F',8),(5359,2,425,'F',9),(5360,2,425,'F',10),(5361,2,425,'G',1),(5362,2,425,'G',2),(5363,2,425,'G',3),(5364,2,425,'G',4),(5365,2,425,'G',5),(5366,2,425,'G',6),(5367,2,425,'G',7),(5368,2,425,'G',8),(5369,2,425,'G',9),(5370,2,425,'G',10),(5371,5,425,'H',1),(5372,5,425,'H',2),(5373,5,425,'H',3),(5374,5,425,'H',4),(5375,5,425,'H',5),(5376,5,425,'H',6),(5377,5,425,'H',7),(5378,5,425,'H',8),(5379,5,425,'H',9),(5380,5,425,'H',10),(5381,4,425,'I',1),(5382,4,425,'I',2),(5383,4,425,'I',3),(5384,4,425,'I',4),(5385,4,425,'I',5),(5386,4,425,'I',6),(5387,4,425,'I',7),(5388,4,425,'I',8),(5389,4,425,'I',9),(5390,4,425,'I',10),(5391,3,425,'J',1),(5392,3,425,'J',2),(5393,3,425,'J',3),(5394,3,425,'J',4),(5395,3,425,'J',5),(5396,3,425,'J',6),(5397,3,425,'J',7),(5398,3,425,'J',8),(5399,3,425,'J',9),(5400,3,425,'J',10),(5401,1,433,'A',1),(5402,1,433,'A',2),(5403,1,433,'A',3),(5404,1,433,'A',4),(5405,1,433,'A',5),(5406,1,433,'A',6),(5407,1,433,'A',7),(5408,1,433,'A',8),(5409,1,433,'A',9),(5410,1,433,'A',10),(5411,1,433,'B',1),(5412,1,433,'B',2),(5413,1,433,'B',3),(5414,1,433,'B',4),(5415,1,433,'B',5),(5416,1,433,'B',6),(5417,1,433,'B',7),(5418,1,433,'B',8),(5419,1,433,'B',9),(5420,1,433,'B',10),(5421,1,433,'C',1),(5422,1,433,'C',2),(5423,1,433,'C',3),(5424,1,433,'C',4),(5425,1,433,'C',5),(5426,1,433,'C',6),(5427,1,433,'C',7),(5428,1,433,'C',8),(5429,1,433,'C',9),(5430,1,433,'C',10),(5431,1,433,'D',1),(5432,1,433,'D',2),(5433,1,433,'D',3),(5434,1,433,'D',4),(5435,1,433,'D',5),(5436,1,433,'D',6),(5437,1,433,'D',7),(5438,1,433,'D',8),(5439,1,433,'D',9),(5440,1,433,'D',10),(5441,1,433,'E',1),(5442,1,433,'E',2),(5443,1,433,'E',3),(5444,1,433,'E',4),(5445,1,433,'E',5),(5446,1,433,'E',6),(5447,1,433,'E',7),(5448,1,433,'E',8),(5449,1,433,'E',9),(5450,1,433,'E',10),(5451,2,433,'F',1),(5452,2,433,'F',2),(5453,2,433,'F',3),(5454,2,433,'F',4),(5455,2,433,'F',5),(5456,2,433,'F',6),(5457,2,433,'F',7),(5458,2,433,'F',8),(5459,2,433,'F',9),(5460,2,433,'F',10),(5461,2,433,'G',1),(5462,2,433,'G',2),(5463,2,433,'G',3),(5464,2,433,'G',4),(5465,2,433,'G',5),(5466,2,433,'G',6),(5467,2,433,'G',7),(5468,2,433,'G',8),(5469,2,433,'G',9),(5470,2,433,'G',10),(5471,5,433,'H',1),(5472,5,433,'H',2),(5473,5,433,'H',3),(5474,5,433,'H',4),(5475,5,433,'H',5),(5476,5,433,'H',6),(5477,5,433,'H',7),(5478,5,433,'H',8),(5479,5,433,'H',9),(5480,5,433,'H',10),(5481,4,433,'I',1),(5482,4,433,'I',2),(5483,4,433,'I',3),(5484,4,433,'I',4),(5485,4,433,'I',5),(5486,4,433,'I',6),(5487,4,433,'I',7),(5488,4,433,'I',8),(5489,4,433,'I',9),(5490,4,433,'I',10),(5491,3,433,'J',1),(5492,3,433,'J',2),(5493,3,433,'J',3),(5494,3,433,'J',4),(5495,3,433,'J',5),(5496,3,433,'J',6),(5497,3,433,'J',7),(5498,3,433,'J',8),(5499,3,433,'J',9),(5500,3,433,'J',10),(5501,1,441,'A',1),(5502,1,441,'A',2),(5503,1,441,'A',3),(5504,1,441,'A',4),(5505,1,441,'A',5),(5506,1,441,'A',6),(5507,1,441,'A',7),(5508,1,441,'A',8),(5509,1,441,'A',9),(5510,1,441,'A',10),(5511,1,441,'B',1),(5512,1,441,'B',2),(5513,1,441,'B',3),(5514,1,441,'B',4),(5515,1,441,'B',5),(5516,1,441,'B',6),(5517,1,441,'B',7),(5518,1,441,'B',8),(5519,1,441,'B',9),(5520,1,441,'B',10),(5521,1,441,'C',1),(5522,1,441,'C',2),(5523,1,441,'C',3),(5524,1,441,'C',4),(5525,1,441,'C',5),(5526,1,441,'C',6),(5527,1,441,'C',7),(5528,1,441,'C',8),(5529,1,441,'C',9),(5530,1,441,'C',10),(5531,1,441,'D',1),(5532,1,441,'D',2),(5533,1,441,'D',3),(5534,1,441,'D',4),(5535,1,441,'D',5),(5536,1,441,'D',6),(5537,1,441,'D',7),(5538,1,441,'D',8),(5539,1,441,'D',9),(5540,1,441,'D',10),(5541,1,441,'E',1),(5542,1,441,'E',2),(5543,1,441,'E',3),(5544,1,441,'E',4),(5545,1,441,'E',5),(5546,1,441,'E',6),(5547,1,441,'E',7),(5548,1,441,'E',8),(5549,1,441,'E',9),(5550,1,441,'E',10),(5551,2,441,'F',1),(5552,2,441,'F',2),(5553,2,441,'F',3),(5554,2,441,'F',4),(5555,2,441,'F',5),(5556,2,441,'F',6),(5557,2,441,'F',7),(5558,2,441,'F',8),(5559,2,441,'F',9),(5560,2,441,'F',10),(5561,2,441,'G',1),(5562,2,441,'G',2),(5563,2,441,'G',3),(5564,2,441,'G',4),(5565,2,441,'G',5),(5566,2,441,'G',6),(5567,2,441,'G',7),(5568,2,441,'G',8),(5569,2,441,'G',9),(5570,2,441,'G',10),(5571,5,441,'H',1),(5572,5,441,'H',2),(5573,5,441,'H',3),(5574,5,441,'H',4),(5575,5,441,'H',5),(5576,5,441,'H',6),(5577,5,441,'H',7),(5578,5,441,'H',8),(5579,5,441,'H',9),(5580,5,441,'H',10),(5581,4,441,'I',1),(5582,4,441,'I',2),(5583,4,441,'I',3),(5584,4,441,'I',4),(5585,4,441,'I',5),(5586,4,441,'I',6),(5587,4,441,'I',7),(5588,4,441,'I',8),(5589,4,441,'I',9),(5590,4,441,'I',10),(5591,3,441,'J',1),(5592,3,441,'J',2),(5593,3,441,'J',3),(5594,3,441,'J',4),(5595,3,441,'J',5),(5596,3,441,'J',6),(5597,3,441,'J',7),(5598,3,441,'J',8),(5599,3,441,'J',9),(5600,3,441,'J',10),(5601,1,449,'A',1),(5602,1,449,'A',2),(5603,1,449,'A',3),(5604,1,449,'A',4),(5605,1,449,'A',5),(5606,1,449,'A',6),(5607,1,449,'A',7),(5608,1,449,'A',8),(5609,1,449,'A',9),(5610,1,449,'A',10),(5611,1,449,'B',1),(5612,1,449,'B',2),(5613,1,449,'B',3),(5614,1,449,'B',4),(5615,1,449,'B',5),(5616,1,449,'B',6),(5617,1,449,'B',7),(5618,1,449,'B',8),(5619,1,449,'B',9),(5620,1,449,'B',10),(5621,1,449,'C',1),(5622,1,449,'C',2),(5623,1,449,'C',3),(5624,1,449,'C',4),(5625,1,449,'C',5),(5626,1,449,'C',6),(5627,1,449,'C',7),(5628,1,449,'C',8),(5629,1,449,'C',9),(5630,1,449,'C',10),(5631,1,449,'D',1),(5632,1,449,'D',2),(5633,1,449,'D',3),(5634,1,449,'D',4),(5635,1,449,'D',5),(5636,1,449,'D',6),(5637,1,449,'D',7),(5638,1,449,'D',8),(5639,1,449,'D',9),(5640,1,449,'D',10),(5641,1,449,'E',1),(5642,1,449,'E',2),(5643,1,449,'E',3),(5644,1,449,'E',4),(5645,1,449,'E',5),(5646,1,449,'E',6),(5647,1,449,'E',7),(5648,1,449,'E',8),(5649,1,449,'E',9),(5650,1,449,'E',10),(5651,2,449,'F',1),(5652,2,449,'F',2),(5653,2,449,'F',3),(5654,2,449,'F',4),(5655,2,449,'F',5),(5656,2,449,'F',6),(5657,2,449,'F',7),(5658,2,449,'F',8),(5659,2,449,'F',9),(5660,2,449,'F',10),(5661,2,449,'G',1),(5662,2,449,'G',2),(5663,2,449,'G',3),(5664,2,449,'G',4),(5665,2,449,'G',5),(5666,2,449,'G',6),(5667,2,449,'G',7),(5668,2,449,'G',8),(5669,2,449,'G',9),(5670,2,449,'G',10),(5671,5,449,'H',1),(5672,5,449,'H',2),(5673,5,449,'H',3),(5674,5,449,'H',4),(5675,5,449,'H',5),(5676,5,449,'H',6),(5677,5,449,'H',7),(5678,5,449,'H',8),(5679,5,449,'H',9),(5680,5,449,'H',10),(5681,4,449,'I',1),(5682,4,449,'I',2),(5683,4,449,'I',3),(5684,4,449,'I',4),(5685,4,449,'I',5),(5686,4,449,'I',6),(5687,4,449,'I',7),(5688,4,449,'I',8),(5689,4,449,'I',9),(5690,4,449,'I',10),(5691,3,449,'J',1),(5692,3,449,'J',2),(5693,3,449,'J',3),(5694,3,449,'J',4),(5695,3,449,'J',5),(5696,3,449,'J',6),(5697,3,449,'J',7),(5698,3,449,'J',8),(5699,3,449,'J',9),(5700,3,449,'J',10),(5701,1,457,'A',1),(5702,1,457,'A',2),(5703,1,457,'A',3),(5704,1,457,'A',4),(5705,1,457,'A',5),(5706,1,457,'A',6),(5707,1,457,'A',7),(5708,1,457,'A',8),(5709,1,457,'A',9),(5710,1,457,'A',10),(5711,1,457,'B',1),(5712,1,457,'B',2),(5713,1,457,'B',3),(5714,1,457,'B',4),(5715,1,457,'B',5),(5716,1,457,'B',6),(5717,1,457,'B',7),(5718,1,457,'B',8),(5719,1,457,'B',9),(5720,1,457,'B',10),(5721,1,457,'C',1),(5722,1,457,'C',2),(5723,1,457,'C',3),(5724,1,457,'C',4),(5725,1,457,'C',5),(5726,1,457,'C',6),(5727,1,457,'C',7),(5728,1,457,'C',8),(5729,1,457,'C',9),(5730,1,457,'C',10),(5731,1,457,'D',1),(5732,1,457,'D',2),(5733,1,457,'D',3),(5734,1,457,'D',4),(5735,1,457,'D',5),(5736,1,457,'D',6),(5737,1,457,'D',7),(5738,1,457,'D',8),(5739,1,457,'D',9),(5740,1,457,'D',10),(5741,1,457,'E',1),(5742,1,457,'E',2),(5743,1,457,'E',3),(5744,1,457,'E',4),(5745,1,457,'E',5),(5746,1,457,'E',6),(5747,1,457,'E',7),(5748,1,457,'E',8),(5749,1,457,'E',9),(5750,1,457,'E',10),(5751,2,457,'F',1),(5752,2,457,'F',2),(5753,2,457,'F',3),(5754,2,457,'F',4),(5755,2,457,'F',5),(5756,2,457,'F',6),(5757,2,457,'F',7),(5758,2,457,'F',8),(5759,2,457,'F',9),(5760,2,457,'F',10),(5761,2,457,'G',1),(5762,2,457,'G',2),(5763,2,457,'G',3),(5764,2,457,'G',4),(5765,2,457,'G',5),(5766,2,457,'G',6),(5767,2,457,'G',7),(5768,2,457,'G',8),(5769,2,457,'G',9),(5770,2,457,'G',10),(5771,5,457,'H',1),(5772,5,457,'H',2),(5773,5,457,'H',3),(5774,5,457,'H',4),(5775,5,457,'H',5),(5776,5,457,'H',6),(5777,5,457,'H',7),(5778,5,457,'H',8),(5779,5,457,'H',9),(5780,5,457,'H',10),(5781,4,457,'I',1),(5782,4,457,'I',2),(5783,4,457,'I',3),(5784,4,457,'I',4),(5785,4,457,'I',5),(5786,4,457,'I',6),(5787,4,457,'I',7),(5788,4,457,'I',8),(5789,4,457,'I',9),(5790,4,457,'I',10),(5791,3,457,'J',1),(5792,3,457,'J',2),(5793,3,457,'J',3),(5794,3,457,'J',4),(5795,3,457,'J',5),(5796,3,457,'J',6),(5797,3,457,'J',7),(5798,3,457,'J',8),(5799,3,457,'J',9),(5800,3,457,'J',10),(5801,1,465,'A',1),(5802,1,465,'A',2),(5803,1,465,'A',3),(5804,1,465,'A',4),(5805,1,465,'A',5),(5806,1,465,'A',6),(5807,1,465,'A',7),(5808,1,465,'A',8),(5809,1,465,'A',9),(5810,1,465,'A',10),(5811,1,465,'B',1),(5812,1,465,'B',2),(5813,1,465,'B',3),(5814,1,465,'B',4),(5815,1,465,'B',5),(5816,1,465,'B',6),(5817,1,465,'B',7),(5818,1,465,'B',8),(5819,1,465,'B',9),(5820,1,465,'B',10),(5821,1,465,'C',1),(5822,1,465,'C',2),(5823,1,465,'C',3),(5824,1,465,'C',4),(5825,1,465,'C',5),(5826,1,465,'C',6),(5827,1,465,'C',7),(5828,1,465,'C',8),(5829,1,465,'C',9),(5830,1,465,'C',10),(5831,1,465,'D',1),(5832,1,465,'D',2),(5833,1,465,'D',3),(5834,1,465,'D',4),(5835,1,465,'D',5),(5836,1,465,'D',6),(5837,1,465,'D',7),(5838,1,465,'D',8),(5839,1,465,'D',9),(5840,1,465,'D',10),(5841,1,465,'E',1),(5842,1,465,'E',2),(5843,1,465,'E',3),(5844,1,465,'E',4),(5845,1,465,'E',5),(5846,1,465,'E',6),(5847,1,465,'E',7),(5848,1,465,'E',8),(5849,1,465,'E',9),(5850,1,465,'E',10),(5851,2,465,'F',1),(5852,2,465,'F',2),(5853,2,465,'F',3),(5854,2,465,'F',4),(5855,2,465,'F',5),(5856,2,465,'F',6),(5857,2,465,'F',7),(5858,2,465,'F',8),(5859,2,465,'F',9),(5860,2,465,'F',10),(5861,2,465,'G',1),(5862,2,465,'G',2),(5863,2,465,'G',3),(5864,2,465,'G',4),(5865,2,465,'G',5),(5866,2,465,'G',6),(5867,2,465,'G',7),(5868,2,465,'G',8),(5869,2,465,'G',9),(5870,2,465,'G',10),(5871,5,465,'H',1),(5872,5,465,'H',2),(5873,5,465,'H',3),(5874,5,465,'H',4),(5875,5,465,'H',5),(5876,5,465,'H',6),(5877,5,465,'H',7),(5878,5,465,'H',8),(5879,5,465,'H',9),(5880,5,465,'H',10),(5881,4,465,'I',1),(5882,4,465,'I',2),(5883,4,465,'I',3),(5884,4,465,'I',4),(5885,4,465,'I',5),(5886,4,465,'I',6),(5887,4,465,'I',7),(5888,4,465,'I',8),(5889,4,465,'I',9),(5890,4,465,'I',10),(5891,3,465,'J',1),(5892,3,465,'J',2),(5893,3,465,'J',3),(5894,3,465,'J',4),(5895,3,465,'J',5),(5896,3,465,'J',6),(5897,3,465,'J',7),(5898,3,465,'J',8),(5899,3,465,'J',9),(5900,3,465,'J',10),(5901,1,473,'A',1),(5902,1,473,'A',2),(5903,1,473,'A',3),(5904,1,473,'A',4),(5905,1,473,'A',5),(5906,1,473,'A',6),(5907,1,473,'A',7),(5908,1,473,'A',8),(5909,1,473,'A',9),(5910,1,473,'A',10),(5911,1,473,'B',1),(5912,1,473,'B',2),(5913,1,473,'B',3),(5914,1,473,'B',4),(5915,1,473,'B',5),(5916,1,473,'B',6),(5917,1,473,'B',7),(5918,1,473,'B',8),(5919,1,473,'B',9),(5920,1,473,'B',10),(5921,1,473,'C',1),(5922,1,473,'C',2),(5923,1,473,'C',3),(5924,1,473,'C',4),(5925,1,473,'C',5),(5926,1,473,'C',6),(5927,1,473,'C',7),(5928,1,473,'C',8),(5929,1,473,'C',9),(5930,1,473,'C',10),(5931,1,473,'D',1),(5932,1,473,'D',2),(5933,1,473,'D',3),(5934,1,473,'D',4),(5935,1,473,'D',5),(5936,1,473,'D',6),(5937,1,473,'D',7),(5938,1,473,'D',8),(5939,1,473,'D',9),(5940,1,473,'D',10),(5941,1,473,'E',1),(5942,1,473,'E',2),(5943,1,473,'E',3),(5944,1,473,'E',4),(5945,1,473,'E',5),(5946,1,473,'E',6),(5947,1,473,'E',7),(5948,1,473,'E',8),(5949,1,473,'E',9),(5950,1,473,'E',10),(5951,2,473,'F',1),(5952,2,473,'F',2),(5953,2,473,'F',3),(5954,2,473,'F',4),(5955,2,473,'F',5),(5956,2,473,'F',6),(5957,2,473,'F',7),(5958,2,473,'F',8),(5959,2,473,'F',9),(5960,2,473,'F',10),(5961,2,473,'G',1),(5962,2,473,'G',2),(5963,2,473,'G',3),(5964,2,473,'G',4),(5965,2,473,'G',5),(5966,2,473,'G',6),(5967,2,473,'G',7),(5968,2,473,'G',8),(5969,2,473,'G',9),(5970,2,473,'G',10),(5971,5,473,'H',1),(5972,5,473,'H',2),(5973,5,473,'H',3),(5974,5,473,'H',4),(5975,5,473,'H',5),(5976,5,473,'H',6),(5977,5,473,'H',7),(5978,5,473,'H',8),(5979,5,473,'H',9),(5980,5,473,'H',10),(5981,4,473,'I',1),(5982,4,473,'I',2),(5983,4,473,'I',3),(5984,4,473,'I',4),(5985,4,473,'I',5),(5986,4,473,'I',6),(5987,4,473,'I',7),(5988,4,473,'I',8),(5989,4,473,'I',9),(5990,4,473,'I',10),(5991,3,473,'J',1),(5992,3,473,'J',2),(5993,3,473,'J',3),(5994,3,473,'J',4),(5995,3,473,'J',5),(5996,3,473,'J',6),(5997,3,473,'J',7),(5998,3,473,'J',8),(5999,3,473,'J',9),(6000,3,473,'J',10),(6001,1,481,'A',1),(6002,1,481,'A',2),(6003,1,481,'A',3),(6004,1,481,'A',4),(6005,1,481,'A',5),(6006,1,481,'A',6),(6007,1,481,'A',7),(6008,1,481,'A',8),(6009,1,481,'A',9),(6010,1,481,'A',10),(6011,1,481,'B',1),(6012,1,481,'B',2),(6013,1,481,'B',3),(6014,1,481,'B',4),(6015,1,481,'B',5),(6016,1,481,'B',6),(6017,1,481,'B',7),(6018,1,481,'B',8),(6019,1,481,'B',9),(6020,1,481,'B',10),(6021,1,481,'C',1),(6022,1,481,'C',2),(6023,1,481,'C',3),(6024,1,481,'C',4),(6025,1,481,'C',5),(6026,1,481,'C',6),(6027,1,481,'C',7),(6028,1,481,'C',8),(6029,1,481,'C',9),(6030,1,481,'C',10),(6031,1,481,'D',1),(6032,1,481,'D',2),(6033,1,481,'D',3),(6034,1,481,'D',4),(6035,1,481,'D',5),(6036,1,481,'D',6),(6037,1,481,'D',7),(6038,1,481,'D',8),(6039,1,481,'D',9),(6040,1,481,'D',10),(6041,1,481,'E',1),(6042,1,481,'E',2),(6043,1,481,'E',3),(6044,1,481,'E',4),(6045,1,481,'E',5),(6046,1,481,'E',6),(6047,1,481,'E',7),(6048,1,481,'E',8),(6049,1,481,'E',9),(6050,1,481,'E',10),(6051,2,481,'F',1),(6052,2,481,'F',2),(6053,2,481,'F',3),(6054,2,481,'F',4),(6055,2,481,'F',5),(6056,2,481,'F',6),(6057,2,481,'F',7),(6058,2,481,'F',8),(6059,2,481,'F',9),(6060,2,481,'F',10),(6061,2,481,'G',1),(6062,2,481,'G',2),(6063,2,481,'G',3),(6064,2,481,'G',4),(6065,2,481,'G',5),(6066,2,481,'G',6),(6067,2,481,'G',7),(6068,2,481,'G',8),(6069,2,481,'G',9),(6070,2,481,'G',10),(6071,5,481,'H',1),(6072,5,481,'H',2),(6073,5,481,'H',3),(6074,5,481,'H',4),(6075,5,481,'H',5),(6076,5,481,'H',6),(6077,5,481,'H',7),(6078,5,481,'H',8),(6079,5,481,'H',9),(6080,5,481,'H',10),(6081,4,481,'I',1),(6082,4,481,'I',2),(6083,4,481,'I',3),(6084,4,481,'I',4),(6085,4,481,'I',5),(6086,4,481,'I',6),(6087,4,481,'I',7),(6088,4,481,'I',8),(6089,4,481,'I',9),(6090,4,481,'I',10),(6091,3,481,'J',1),(6092,3,481,'J',2),(6093,3,481,'J',3),(6094,3,481,'J',4),(6095,3,481,'J',5),(6096,3,481,'J',6),(6097,3,481,'J',7),(6098,3,481,'J',8),(6099,3,481,'J',9),(6100,3,481,'J',10),(6101,1,489,'A',1),(6102,1,489,'A',2),(6103,1,489,'A',3),(6104,1,489,'A',4),(6105,1,489,'A',5),(6106,1,489,'A',6),(6107,1,489,'A',7),(6108,1,489,'A',8),(6109,1,489,'A',9),(6110,1,489,'A',10),(6111,1,489,'B',1),(6112,1,489,'B',2),(6113,1,489,'B',3),(6114,1,489,'B',4),(6115,1,489,'B',5),(6116,1,489,'B',6),(6117,1,489,'B',7),(6118,1,489,'B',8),(6119,1,489,'B',9),(6120,1,489,'B',10),(6121,1,489,'C',1),(6122,1,489,'C',2),(6123,1,489,'C',3),(6124,1,489,'C',4),(6125,1,489,'C',5),(6126,1,489,'C',6),(6127,1,489,'C',7),(6128,1,489,'C',8),(6129,1,489,'C',9),(6130,1,489,'C',10),(6131,1,489,'D',1),(6132,1,489,'D',2),(6133,1,489,'D',3),(6134,1,489,'D',4),(6135,1,489,'D',5),(6136,1,489,'D',6),(6137,1,489,'D',7),(6138,1,489,'D',8),(6139,1,489,'D',9),(6140,1,489,'D',10),(6141,1,489,'E',1),(6142,1,489,'E',2),(6143,1,489,'E',3),(6144,1,489,'E',4),(6145,1,489,'E',5),(6146,1,489,'E',6),(6147,1,489,'E',7),(6148,1,489,'E',8),(6149,1,489,'E',9),(6150,1,489,'E',10),(6151,2,489,'F',1),(6152,2,489,'F',2),(6153,2,489,'F',3),(6154,2,489,'F',4),(6155,2,489,'F',5),(6156,2,489,'F',6),(6157,2,489,'F',7),(6158,2,489,'F',8),(6159,2,489,'F',9),(6160,2,489,'F',10),(6161,2,489,'G',1),(6162,2,489,'G',2),(6163,2,489,'G',3),(6164,2,489,'G',4),(6165,2,489,'G',5),(6166,2,489,'G',6),(6167,2,489,'G',7),(6168,2,489,'G',8),(6169,2,489,'G',9),(6170,2,489,'G',10),(6171,5,489,'H',1),(6172,5,489,'H',2),(6173,5,489,'H',3),(6174,5,489,'H',4),(6175,5,489,'H',5),(6176,5,489,'H',6),(6177,5,489,'H',7),(6178,5,489,'H',8),(6179,5,489,'H',9),(6180,5,489,'H',10),(6181,4,489,'I',1),(6182,4,489,'I',2),(6183,4,489,'I',3),(6184,4,489,'I',4),(6185,4,489,'I',5),(6186,4,489,'I',6),(6187,4,489,'I',7),(6188,4,489,'I',8),(6189,4,489,'I',9),(6190,4,489,'I',10),(6191,3,489,'J',1),(6192,3,489,'J',2),(6193,3,489,'J',3),(6194,3,489,'J',4),(6195,3,489,'J',5),(6196,3,489,'J',6),(6197,3,489,'J',7),(6198,3,489,'J',8),(6199,3,489,'J',9),(6200,3,489,'J',10),(6201,1,497,'A',1),(6202,1,497,'A',2),(6203,1,497,'A',3),(6204,1,497,'A',4),(6205,1,497,'A',5),(6206,1,497,'A',6),(6207,1,497,'A',7),(6208,1,497,'A',8),(6209,1,497,'A',9),(6210,1,497,'A',10),(6211,1,497,'B',1),(6212,1,497,'B',2),(6213,1,497,'B',3),(6214,1,497,'B',4),(6215,1,497,'B',5),(6216,1,497,'B',6),(6217,1,497,'B',7),(6218,1,497,'B',8),(6219,1,497,'B',9),(6220,1,497,'B',10),(6221,1,497,'C',1),(6222,1,497,'C',2),(6223,1,497,'C',3),(6224,1,497,'C',4),(6225,1,497,'C',5),(6226,1,497,'C',6),(6227,1,497,'C',7),(6228,1,497,'C',8),(6229,1,497,'C',9),(6230,1,497,'C',10),(6231,1,497,'D',1),(6232,1,497,'D',2),(6233,1,497,'D',3),(6234,1,497,'D',4),(6235,1,497,'D',5),(6236,1,497,'D',6),(6237,1,497,'D',7),(6238,1,497,'D',8),(6239,1,497,'D',9),(6240,1,497,'D',10),(6241,1,497,'E',1),(6242,1,497,'E',2),(6243,1,497,'E',3),(6244,1,497,'E',4),(6245,1,497,'E',5),(6246,1,497,'E',6),(6247,1,497,'E',7),(6248,1,497,'E',8),(6249,1,497,'E',9),(6250,1,497,'E',10),(6251,2,497,'F',1),(6252,2,497,'F',2),(6253,2,497,'F',3),(6254,2,497,'F',4),(6255,2,497,'F',5),(6256,2,497,'F',6),(6257,2,497,'F',7),(6258,2,497,'F',8),(6259,2,497,'F',9),(6260,2,497,'F',10),(6261,2,497,'G',1),(6262,2,497,'G',2),(6263,2,497,'G',3),(6264,2,497,'G',4),(6265,2,497,'G',5),(6266,2,497,'G',6),(6267,2,497,'G',7),(6268,2,497,'G',8),(6269,2,497,'G',9),(6270,2,497,'G',10),(6271,5,497,'H',1),(6272,5,497,'H',2),(6273,5,497,'H',3),(6274,5,497,'H',4),(6275,5,497,'H',5),(6276,5,497,'H',6),(6277,5,497,'H',7),(6278,5,497,'H',8),(6279,5,497,'H',9),(6280,5,497,'H',10),(6281,4,497,'I',1),(6282,4,497,'I',2),(6283,4,497,'I',3),(6284,4,497,'I',4),(6285,4,497,'I',5),(6286,4,497,'I',6),(6287,4,497,'I',7),(6288,4,497,'I',8),(6289,4,497,'I',9),(6290,4,497,'I',10),(6291,3,497,'J',1),(6292,3,497,'J',2),(6293,3,497,'J',3),(6294,3,497,'J',4),(6295,3,497,'J',5),(6296,3,497,'J',6),(6297,3,497,'J',7),(6298,3,497,'J',8),(6299,3,497,'J',9),(6300,3,497,'J',10),(6301,1,505,'A',1),(6302,1,505,'A',2),(6303,1,505,'A',3),(6304,1,505,'A',4),(6305,1,505,'A',5),(6306,1,505,'A',6),(6307,1,505,'A',7),(6308,1,505,'A',8),(6309,1,505,'A',9),(6310,1,505,'A',10),(6311,1,505,'B',1),(6312,1,505,'B',2),(6313,1,505,'B',3),(6314,1,505,'B',4),(6315,1,505,'B',5),(6316,1,505,'B',6),(6317,1,505,'B',7),(6318,1,505,'B',8),(6319,1,505,'B',9),(6320,1,505,'B',10),(6321,1,505,'C',1),(6322,1,505,'C',2),(6323,1,505,'C',3),(6324,1,505,'C',4),(6325,1,505,'C',5),(6326,1,505,'C',6),(6327,1,505,'C',7),(6328,1,505,'C',8),(6329,1,505,'C',9),(6330,1,505,'C',10),(6331,1,505,'D',1),(6332,1,505,'D',2),(6333,1,505,'D',3),(6334,1,505,'D',4),(6335,1,505,'D',5),(6336,1,505,'D',6),(6337,1,505,'D',7),(6338,1,505,'D',8),(6339,1,505,'D',9),(6340,1,505,'D',10),(6341,1,505,'E',1),(6342,1,505,'E',2),(6343,1,505,'E',3),(6344,1,505,'E',4),(6345,1,505,'E',5),(6346,1,505,'E',6),(6347,1,505,'E',7),(6348,1,505,'E',8),(6349,1,505,'E',9),(6350,1,505,'E',10),(6351,2,505,'F',1),(6352,2,505,'F',2),(6353,2,505,'F',3),(6354,2,505,'F',4),(6355,2,505,'F',5),(6356,2,505,'F',6),(6357,2,505,'F',7),(6358,2,505,'F',8),(6359,2,505,'F',9),(6360,2,505,'F',10),(6361,2,505,'G',1),(6362,2,505,'G',2),(6363,2,505,'G',3),(6364,2,505,'G',4),(6365,2,505,'G',5),(6366,2,505,'G',6),(6367,2,505,'G',7),(6368,2,505,'G',8),(6369,2,505,'G',9),(6370,2,505,'G',10),(6371,5,505,'H',1),(6372,5,505,'H',2),(6373,5,505,'H',3),(6374,5,505,'H',4),(6375,5,505,'H',5),(6376,5,505,'H',6),(6377,5,505,'H',7),(6378,5,505,'H',8),(6379,5,505,'H',9),(6380,5,505,'H',10),(6381,4,505,'I',1),(6382,4,505,'I',2),(6383,4,505,'I',3),(6384,4,505,'I',4),(6385,4,505,'I',5),(6386,4,505,'I',6),(6387,4,505,'I',7),(6388,4,505,'I',8),(6389,4,505,'I',9),(6390,4,505,'I',10),(6391,3,505,'J',1),(6392,3,505,'J',2),(6393,3,505,'J',3),(6394,3,505,'J',4),(6395,3,505,'J',5),(6396,3,505,'J',6),(6397,3,505,'J',7),(6398,3,505,'J',8),(6399,3,505,'J',9),(6400,3,505,'J',10),(6401,1,513,'A',1),(6402,1,513,'A',2),(6403,1,513,'A',3),(6404,1,513,'A',4),(6405,1,513,'A',5),(6406,1,513,'A',6),(6407,1,513,'A',7),(6408,1,513,'A',8),(6409,1,513,'A',9),(6410,1,513,'A',10),(6411,1,513,'B',1),(6412,1,513,'B',2),(6413,1,513,'B',3),(6414,1,513,'B',4),(6415,1,513,'B',5),(6416,1,513,'B',6),(6417,1,513,'B',7),(6418,1,513,'B',8),(6419,1,513,'B',9),(6420,1,513,'B',10),(6421,1,513,'C',1),(6422,1,513,'C',2),(6423,1,513,'C',3),(6424,1,513,'C',4),(6425,1,513,'C',5),(6426,1,513,'C',6),(6427,1,513,'C',7),(6428,1,513,'C',8),(6429,1,513,'C',9),(6430,1,513,'C',10),(6431,1,513,'D',1),(6432,1,513,'D',2),(6433,1,513,'D',3),(6434,1,513,'D',4),(6435,1,513,'D',5),(6436,1,513,'D',6),(6437,1,513,'D',7),(6438,1,513,'D',8),(6439,1,513,'D',9),(6440,1,513,'D',10),(6441,1,513,'E',1),(6442,1,513,'E',2),(6443,1,513,'E',3),(6444,1,513,'E',4),(6445,1,513,'E',5),(6446,1,513,'E',6),(6447,1,513,'E',7),(6448,1,513,'E',8),(6449,1,513,'E',9),(6450,1,513,'E',10),(6451,2,513,'F',1),(6452,2,513,'F',2),(6453,2,513,'F',3),(6454,2,513,'F',4),(6455,2,513,'F',5),(6456,2,513,'F',6),(6457,2,513,'F',7),(6458,2,513,'F',8),(6459,2,513,'F',9),(6460,2,513,'F',10),(6461,2,513,'G',1),(6462,2,513,'G',2),(6463,2,513,'G',3),(6464,2,513,'G',4),(6465,2,513,'G',5),(6466,2,513,'G',6),(6467,2,513,'G',7),(6468,2,513,'G',8),(6469,2,513,'G',9),(6470,2,513,'G',10),(6471,5,513,'H',1),(6472,5,513,'H',2),(6473,5,513,'H',3),(6474,5,513,'H',4),(6475,5,513,'H',5),(6476,5,513,'H',6),(6477,5,513,'H',7),(6478,5,513,'H',8),(6479,5,513,'H',9),(6480,5,513,'H',10),(6481,4,513,'I',1),(6482,4,513,'I',2),(6483,4,513,'I',3),(6484,4,513,'I',4),(6485,4,513,'I',5),(6486,4,513,'I',6),(6487,4,513,'I',7),(6488,4,513,'I',8),(6489,4,513,'I',9),(6490,4,513,'I',10),(6491,3,513,'J',1),(6492,3,513,'J',2),(6493,3,513,'J',3),(6494,3,513,'J',4),(6495,3,513,'J',5),(6496,3,513,'J',6),(6497,3,513,'J',7),(6498,3,513,'J',8),(6499,3,513,'J',9),(6500,3,513,'J',10),(6501,1,521,'A',1),(6502,1,521,'A',2),(6503,1,521,'A',3),(6504,1,521,'A',4),(6505,1,521,'A',5),(6506,1,521,'A',6),(6507,1,521,'A',7),(6508,1,521,'A',8),(6509,1,521,'A',9),(6510,1,521,'A',10),(6511,1,521,'B',1),(6512,1,521,'B',2),(6513,1,521,'B',3),(6514,1,521,'B',4),(6515,1,521,'B',5),(6516,1,521,'B',6),(6517,1,521,'B',7),(6518,1,521,'B',8),(6519,1,521,'B',9),(6520,1,521,'B',10),(6521,1,521,'C',1),(6522,1,521,'C',2),(6523,1,521,'C',3),(6524,1,521,'C',4),(6525,1,521,'C',5),(6526,1,521,'C',6),(6527,1,521,'C',7),(6528,1,521,'C',8),(6529,1,521,'C',9),(6530,1,521,'C',10),(6531,1,521,'D',1),(6532,1,521,'D',2),(6533,1,521,'D',3),(6534,1,521,'D',4),(6535,1,521,'D',5),(6536,1,521,'D',6),(6537,1,521,'D',7),(6538,1,521,'D',8),(6539,1,521,'D',9),(6540,1,521,'D',10),(6541,1,521,'E',1),(6542,1,521,'E',2),(6543,1,521,'E',3),(6544,1,521,'E',4),(6545,1,521,'E',5),(6546,1,521,'E',6),(6547,1,521,'E',7),(6548,1,521,'E',8),(6549,1,521,'E',9),(6550,1,521,'E',10),(6551,2,521,'F',1),(6552,2,521,'F',2),(6553,2,521,'F',3),(6554,2,521,'F',4),(6555,2,521,'F',5),(6556,2,521,'F',6),(6557,2,521,'F',7),(6558,2,521,'F',8),(6559,2,521,'F',9),(6560,2,521,'F',10),(6561,2,521,'G',1),(6562,2,521,'G',2),(6563,2,521,'G',3),(6564,2,521,'G',4),(6565,2,521,'G',5),(6566,2,521,'G',6),(6567,2,521,'G',7),(6568,2,521,'G',8),(6569,2,521,'G',9),(6570,2,521,'G',10),(6571,5,521,'H',1),(6572,5,521,'H',2),(6573,5,521,'H',3),(6574,5,521,'H',4),(6575,5,521,'H',5),(6576,5,521,'H',6),(6577,5,521,'H',7),(6578,5,521,'H',8),(6579,5,521,'H',9),(6580,5,521,'H',10),(6581,4,521,'I',1),(6582,4,521,'I',2),(6583,4,521,'I',3),(6584,4,521,'I',4),(6585,4,521,'I',5),(6586,4,521,'I',6),(6587,4,521,'I',7),(6588,4,521,'I',8),(6589,4,521,'I',9),(6590,4,521,'I',10),(6591,3,521,'J',1),(6592,3,521,'J',2),(6593,3,521,'J',3),(6594,3,521,'J',4),(6595,3,521,'J',5),(6596,3,521,'J',6),(6597,3,521,'J',7),(6598,3,521,'J',8),(6599,3,521,'J',9),(6600,3,521,'J',10),(6601,1,529,'A',1),(6602,1,529,'A',2),(6603,1,529,'A',3),(6604,1,529,'A',4),(6605,1,529,'A',5),(6606,1,529,'A',6),(6607,1,529,'A',7),(6608,1,529,'A',8),(6609,1,529,'A',9),(6610,1,529,'A',10),(6611,1,529,'B',1),(6612,1,529,'B',2),(6613,1,529,'B',3),(6614,1,529,'B',4),(6615,1,529,'B',5),(6616,1,529,'B',6),(6617,1,529,'B',7),(6618,1,529,'B',8),(6619,1,529,'B',9),(6620,1,529,'B',10),(6621,1,529,'C',1),(6622,1,529,'C',2),(6623,1,529,'C',3),(6624,1,529,'C',4),(6625,1,529,'C',5),(6626,1,529,'C',6),(6627,1,529,'C',7),(6628,1,529,'C',8),(6629,1,529,'C',9),(6630,1,529,'C',10),(6631,1,529,'D',1),(6632,1,529,'D',2),(6633,1,529,'D',3),(6634,1,529,'D',4),(6635,1,529,'D',5),(6636,1,529,'D',6),(6637,1,529,'D',7),(6638,1,529,'D',8),(6639,1,529,'D',9),(6640,1,529,'D',10),(6641,1,529,'E',1),(6642,1,529,'E',2),(6643,1,529,'E',3),(6644,1,529,'E',4),(6645,1,529,'E',5),(6646,1,529,'E',6),(6647,1,529,'E',7),(6648,1,529,'E',8),(6649,1,529,'E',9),(6650,1,529,'E',10),(6651,2,529,'F',1),(6652,2,529,'F',2),(6653,2,529,'F',3),(6654,2,529,'F',4),(6655,2,529,'F',5),(6656,2,529,'F',6),(6657,2,529,'F',7),(6658,2,529,'F',8),(6659,2,529,'F',9),(6660,2,529,'F',10),(6661,2,529,'G',1),(6662,2,529,'G',2),(6663,2,529,'G',3),(6664,2,529,'G',4),(6665,2,529,'G',5),(6666,2,529,'G',6),(6667,2,529,'G',7),(6668,2,529,'G',8),(6669,2,529,'G',9),(6670,2,529,'G',10),(6671,5,529,'H',1),(6672,5,529,'H',2),(6673,5,529,'H',3),(6674,5,529,'H',4),(6675,5,529,'H',5),(6676,5,529,'H',6),(6677,5,529,'H',7),(6678,5,529,'H',8),(6679,5,529,'H',9),(6680,5,529,'H',10),(6681,4,529,'I',1),(6682,4,529,'I',2),(6683,4,529,'I',3),(6684,4,529,'I',4),(6685,4,529,'I',5),(6686,4,529,'I',6),(6687,4,529,'I',7),(6688,4,529,'I',8),(6689,4,529,'I',9),(6690,4,529,'I',10),(6691,3,529,'J',1),(6692,3,529,'J',2),(6693,3,529,'J',3),(6694,3,529,'J',4),(6695,3,529,'J',5),(6696,3,529,'J',6),(6697,3,529,'J',7),(6698,3,529,'J',8),(6699,3,529,'J',9),(6700,3,529,'J',10),(6701,1,537,'A',1),(6702,1,537,'A',2),(6703,1,537,'A',3),(6704,1,537,'A',4),(6705,1,537,'A',5),(6706,1,537,'A',6),(6707,1,537,'A',7),(6708,1,537,'A',8),(6709,1,537,'A',9),(6710,1,537,'A',10),(6711,1,537,'B',1),(6712,1,537,'B',2),(6713,1,537,'B',3),(6714,1,537,'B',4),(6715,1,537,'B',5),(6716,1,537,'B',6),(6717,1,537,'B',7),(6718,1,537,'B',8),(6719,1,537,'B',9),(6720,1,537,'B',10),(6721,1,537,'C',1),(6722,1,537,'C',2),(6723,1,537,'C',3),(6724,1,537,'C',4),(6725,1,537,'C',5),(6726,1,537,'C',6),(6727,1,537,'C',7),(6728,1,537,'C',8),(6729,1,537,'C',9),(6730,1,537,'C',10),(6731,1,537,'D',1),(6732,1,537,'D',2),(6733,1,537,'D',3),(6734,1,537,'D',4),(6735,1,537,'D',5),(6736,1,537,'D',6),(6737,1,537,'D',7),(6738,1,537,'D',8),(6739,1,537,'D',9),(6740,1,537,'D',10),(6741,1,537,'E',1),(6742,1,537,'E',2),(6743,1,537,'E',3),(6744,1,537,'E',4),(6745,1,537,'E',5),(6746,1,537,'E',6),(6747,1,537,'E',7),(6748,1,537,'E',8),(6749,1,537,'E',9),(6750,1,537,'E',10),(6751,2,537,'F',1),(6752,2,537,'F',2),(6753,2,537,'F',3),(6754,2,537,'F',4),(6755,2,537,'F',5),(6756,2,537,'F',6),(6757,2,537,'F',7),(6758,2,537,'F',8),(6759,2,537,'F',9),(6760,2,537,'F',10),(6761,2,537,'G',1),(6762,2,537,'G',2),(6763,2,537,'G',3),(6764,2,537,'G',4),(6765,2,537,'G',5),(6766,2,537,'G',6),(6767,2,537,'G',7),(6768,2,537,'G',8),(6769,2,537,'G',9),(6770,2,537,'G',10),(6771,5,537,'H',1),(6772,5,537,'H',2),(6773,5,537,'H',3),(6774,5,537,'H',4),(6775,5,537,'H',5),(6776,5,537,'H',6),(6777,5,537,'H',7),(6778,5,537,'H',8),(6779,5,537,'H',9),(6780,5,537,'H',10),(6781,4,537,'I',1),(6782,4,537,'I',2),(6783,4,537,'I',3),(6784,4,537,'I',4),(6785,4,537,'I',5),(6786,4,537,'I',6),(6787,4,537,'I',7),(6788,4,537,'I',8),(6789,4,537,'I',9),(6790,4,537,'I',10),(6791,3,537,'J',1),(6792,3,537,'J',2),(6793,3,537,'J',3),(6794,3,537,'J',4),(6795,3,537,'J',5),(6796,3,537,'J',6),(6797,3,537,'J',7),(6798,3,537,'J',8),(6799,3,537,'J',9),(6800,3,537,'J',10),(6801,1,545,'A',1),(6802,1,545,'A',2),(6803,1,545,'A',3),(6804,1,545,'A',4),(6805,1,545,'A',5),(6806,1,545,'A',6),(6807,1,545,'A',7),(6808,1,545,'A',8),(6809,1,545,'A',9),(6810,1,545,'A',10),(6811,1,545,'B',1),(6812,1,545,'B',2),(6813,1,545,'B',3),(6814,1,545,'B',4),(6815,1,545,'B',5),(6816,1,545,'B',6),(6817,1,545,'B',7),(6818,1,545,'B',8),(6819,1,545,'B',9),(6820,1,545,'B',10),(6821,1,545,'C',1),(6822,1,545,'C',2),(6823,1,545,'C',3),(6824,1,545,'C',4),(6825,1,545,'C',5),(6826,1,545,'C',6),(6827,1,545,'C',7),(6828,1,545,'C',8),(6829,1,545,'C',9),(6830,1,545,'C',10),(6831,1,545,'D',1),(6832,1,545,'D',2),(6833,1,545,'D',3),(6834,1,545,'D',4),(6835,1,545,'D',5),(6836,1,545,'D',6),(6837,1,545,'D',7),(6838,1,545,'D',8),(6839,1,545,'D',9),(6840,1,545,'D',10),(6841,1,545,'E',1),(6842,1,545,'E',2),(6843,1,545,'E',3),(6844,1,545,'E',4),(6845,1,545,'E',5),(6846,1,545,'E',6),(6847,1,545,'E',7),(6848,1,545,'E',8),(6849,1,545,'E',9),(6850,1,545,'E',10),(6851,2,545,'F',1),(6852,2,545,'F',2),(6853,2,545,'F',3),(6854,2,545,'F',4),(6855,2,545,'F',5),(6856,2,545,'F',6),(6857,2,545,'F',7),(6858,2,545,'F',8),(6859,2,545,'F',9),(6860,2,545,'F',10),(6861,2,545,'G',1),(6862,2,545,'G',2),(6863,2,545,'G',3),(6864,2,545,'G',4),(6865,2,545,'G',5),(6866,2,545,'G',6),(6867,2,545,'G',7),(6868,2,545,'G',8),(6869,2,545,'G',9),(6870,2,545,'G',10),(6871,5,545,'H',1),(6872,5,545,'H',2),(6873,5,545,'H',3),(6874,5,545,'H',4),(6875,5,545,'H',5),(6876,5,545,'H',6),(6877,5,545,'H',7),(6878,5,545,'H',8),(6879,5,545,'H',9),(6880,5,545,'H',10),(6881,4,545,'I',1),(6882,4,545,'I',2),(6883,4,545,'I',3),(6884,4,545,'I',4),(6885,4,545,'I',5),(6886,4,545,'I',6),(6887,4,545,'I',7),(6888,4,545,'I',8),(6889,4,545,'I',9),(6890,4,545,'I',10),(6891,3,545,'J',1),(6892,3,545,'J',2),(6893,3,545,'J',3),(6894,3,545,'J',4),(6895,3,545,'J',5),(6896,3,545,'J',6),(6897,3,545,'J',7),(6898,3,545,'J',8),(6899,3,545,'J',9),(6900,3,545,'J',10),(6901,1,553,'A',1),(6902,1,553,'A',2),(6903,1,553,'A',3),(6904,1,553,'A',4),(6905,1,553,'A',5),(6906,1,553,'A',6),(6907,1,553,'A',7),(6908,1,553,'A',8),(6909,1,553,'A',9),(6910,1,553,'A',10),(6911,1,553,'B',1),(6912,1,553,'B',2),(6913,1,553,'B',3),(6914,1,553,'B',4),(6915,1,553,'B',5),(6916,1,553,'B',6),(6917,1,553,'B',7),(6918,1,553,'B',8),(6919,1,553,'B',9),(6920,1,553,'B',10),(6921,1,553,'C',1),(6922,1,553,'C',2),(6923,1,553,'C',3),(6924,1,553,'C',4),(6925,1,553,'C',5),(6926,1,553,'C',6),(6927,1,553,'C',7),(6928,1,553,'C',8),(6929,1,553,'C',9),(6930,1,553,'C',10),(6931,1,553,'D',1),(6932,1,553,'D',2),(6933,1,553,'D',3),(6934,1,553,'D',4),(6935,1,553,'D',5),(6936,1,553,'D',6),(6937,1,553,'D',7),(6938,1,553,'D',8),(6939,1,553,'D',9),(6940,1,553,'D',10),(6941,1,553,'E',1),(6942,1,553,'E',2),(6943,1,553,'E',3),(6944,1,553,'E',4),(6945,1,553,'E',5),(6946,1,553,'E',6),(6947,1,553,'E',7),(6948,1,553,'E',8),(6949,1,553,'E',9),(6950,1,553,'E',10),(6951,2,553,'F',1),(6952,2,553,'F',2),(6953,2,553,'F',3),(6954,2,553,'F',4),(6955,2,553,'F',5),(6956,2,553,'F',6),(6957,2,553,'F',7),(6958,2,553,'F',8),(6959,2,553,'F',9),(6960,2,553,'F',10),(6961,2,553,'G',1),(6962,2,553,'G',2),(6963,2,553,'G',3),(6964,2,553,'G',4),(6965,2,553,'G',5),(6966,2,553,'G',6),(6967,2,553,'G',7),(6968,2,553,'G',8),(6969,2,553,'G',9),(6970,2,553,'G',10),(6971,5,553,'H',1),(6972,5,553,'H',2),(6973,5,553,'H',3),(6974,5,553,'H',4),(6975,5,553,'H',5),(6976,5,553,'H',6),(6977,5,553,'H',7),(6978,5,553,'H',8),(6979,5,553,'H',9),(6980,5,553,'H',10),(6981,4,553,'I',1),(6982,4,553,'I',2),(6983,4,553,'I',3),(6984,4,553,'I',4),(6985,4,553,'I',5),(6986,4,553,'I',6),(6987,4,553,'I',7),(6988,4,553,'I',8),(6989,4,553,'I',9),(6990,4,553,'I',10),(6991,3,553,'J',1),(6992,3,553,'J',2),(6993,3,553,'J',3),(6994,3,553,'J',4),(6995,3,553,'J',5),(6996,3,553,'J',6),(6997,3,553,'J',7),(6998,3,553,'J',8),(6999,3,553,'J',9),(7000,3,553,'J',10),(7001,1,561,'A',1),(7002,1,561,'A',2),(7003,1,561,'A',3),(7004,1,561,'A',4),(7005,1,561,'A',5),(7006,1,561,'A',6),(7007,1,561,'A',7),(7008,1,561,'A',8),(7009,1,561,'A',9),(7010,1,561,'A',10),(7011,1,561,'B',1),(7012,1,561,'B',2),(7013,1,561,'B',3),(7014,1,561,'B',4),(7015,1,561,'B',5),(7016,1,561,'B',6),(7017,1,561,'B',7),(7018,1,561,'B',8),(7019,1,561,'B',9),(7020,1,561,'B',10),(7021,1,561,'C',1),(7022,1,561,'C',2),(7023,1,561,'C',3),(7024,1,561,'C',4),(7025,1,561,'C',5),(7026,1,561,'C',6),(7027,1,561,'C',7),(7028,1,561,'C',8),(7029,1,561,'C',9),(7030,1,561,'C',10),(7031,1,561,'D',1),(7032,1,561,'D',2),(7033,1,561,'D',3),(7034,1,561,'D',4),(7035,1,561,'D',5),(7036,1,561,'D',6),(7037,1,561,'D',7),(7038,1,561,'D',8),(7039,1,561,'D',9),(7040,1,561,'D',10),(7041,1,561,'E',1),(7042,1,561,'E',2),(7043,1,561,'E',3),(7044,1,561,'E',4),(7045,1,561,'E',5),(7046,1,561,'E',6),(7047,1,561,'E',7),(7048,1,561,'E',8),(7049,1,561,'E',9),(7050,1,561,'E',10),(7051,2,561,'F',1),(7052,2,561,'F',2),(7053,2,561,'F',3),(7054,2,561,'F',4),(7055,2,561,'F',5),(7056,2,561,'F',6),(7057,2,561,'F',7),(7058,2,561,'F',8),(7059,2,561,'F',9),(7060,2,561,'F',10),(7061,2,561,'G',1),(7062,2,561,'G',2),(7063,2,561,'G',3),(7064,2,561,'G',4),(7065,2,561,'G',5),(7066,2,561,'G',6),(7067,2,561,'G',7),(7068,2,561,'G',8),(7069,2,561,'G',9),(7070,2,561,'G',10),(7071,5,561,'H',1),(7072,5,561,'H',2),(7073,5,561,'H',3),(7074,5,561,'H',4),(7075,5,561,'H',5),(7076,5,561,'H',6),(7077,5,561,'H',7),(7078,5,561,'H',8),(7079,5,561,'H',9),(7080,5,561,'H',10),(7081,4,561,'I',1),(7082,4,561,'I',2),(7083,4,561,'I',3),(7084,4,561,'I',4),(7085,4,561,'I',5),(7086,4,561,'I',6),(7087,4,561,'I',7),(7088,4,561,'I',8),(7089,4,561,'I',9),(7090,4,561,'I',10),(7091,3,561,'J',1),(7092,3,561,'J',2),(7093,3,561,'J',3),(7094,3,561,'J',4),(7095,3,561,'J',5),(7096,3,561,'J',6),(7097,3,561,'J',7),(7098,3,561,'J',8),(7099,3,561,'J',9),(7100,3,561,'J',10),(7101,1,569,'A',1),(7102,1,569,'A',2),(7103,1,569,'A',3),(7104,1,569,'A',4),(7105,1,569,'A',5),(7106,1,569,'A',6),(7107,1,569,'A',7),(7108,1,569,'A',8),(7109,1,569,'A',9),(7110,1,569,'A',10),(7111,1,569,'B',1),(7112,1,569,'B',2),(7113,1,569,'B',3),(7114,1,569,'B',4),(7115,1,569,'B',5),(7116,1,569,'B',6),(7117,1,569,'B',7),(7118,1,569,'B',8),(7119,1,569,'B',9),(7120,1,569,'B',10),(7121,1,569,'C',1),(7122,1,569,'C',2),(7123,1,569,'C',3),(7124,1,569,'C',4),(7125,1,569,'C',5),(7126,1,569,'C',6),(7127,1,569,'C',7),(7128,1,569,'C',8),(7129,1,569,'C',9),(7130,1,569,'C',10),(7131,1,569,'D',1),(7132,1,569,'D',2),(7133,1,569,'D',3),(7134,1,569,'D',4),(7135,1,569,'D',5),(7136,1,569,'D',6),(7137,1,569,'D',7),(7138,1,569,'D',8),(7139,1,569,'D',9),(7140,1,569,'D',10),(7141,1,569,'E',1),(7142,1,569,'E',2),(7143,1,569,'E',3),(7144,1,569,'E',4),(7145,1,569,'E',5),(7146,1,569,'E',6),(7147,1,569,'E',7),(7148,1,569,'E',8),(7149,1,569,'E',9),(7150,1,569,'E',10),(7151,2,569,'F',1),(7152,2,569,'F',2),(7153,2,569,'F',3),(7154,2,569,'F',4),(7155,2,569,'F',5),(7156,2,569,'F',6),(7157,2,569,'F',7),(7158,2,569,'F',8),(7159,2,569,'F',9),(7160,2,569,'F',10),(7161,2,569,'G',1),(7162,2,569,'G',2),(7163,2,569,'G',3),(7164,2,569,'G',4),(7165,2,569,'G',5),(7166,2,569,'G',6),(7167,2,569,'G',7),(7168,2,569,'G',8),(7169,2,569,'G',9),(7170,2,569,'G',10),(7171,5,569,'H',1),(7172,5,569,'H',2),(7173,5,569,'H',3),(7174,5,569,'H',4),(7175,5,569,'H',5),(7176,5,569,'H',6),(7177,5,569,'H',7),(7178,5,569,'H',8),(7179,5,569,'H',9),(7180,5,569,'H',10),(7181,4,569,'I',1),(7182,4,569,'I',2),(7183,4,569,'I',3),(7184,4,569,'I',4),(7185,4,569,'I',5),(7186,4,569,'I',6),(7187,4,569,'I',7),(7188,4,569,'I',8),(7189,4,569,'I',9),(7190,4,569,'I',10),(7191,3,569,'J',1),(7192,3,569,'J',2),(7193,3,569,'J',3),(7194,3,569,'J',4),(7195,3,569,'J',5),(7196,3,569,'J',6),(7197,3,569,'J',7),(7198,3,569,'J',8),(7199,3,569,'J',9),(7200,3,569,'J',10),(7201,1,577,'A',1),(7202,1,577,'A',2),(7203,1,577,'A',3),(7204,1,577,'A',4),(7205,1,577,'A',5),(7206,1,577,'A',6),(7207,1,577,'A',7),(7208,1,577,'A',8),(7209,1,577,'A',9),(7210,1,577,'A',10),(7211,1,577,'B',1),(7212,1,577,'B',2),(7213,1,577,'B',3),(7214,1,577,'B',4),(7215,1,577,'B',5),(7216,1,577,'B',6),(7217,1,577,'B',7),(7218,1,577,'B',8),(7219,1,577,'B',9),(7220,1,577,'B',10),(7221,1,577,'C',1),(7222,1,577,'C',2),(7223,1,577,'C',3),(7224,1,577,'C',4),(7225,1,577,'C',5),(7226,1,577,'C',6),(7227,1,577,'C',7),(7228,1,577,'C',8),(7229,1,577,'C',9),(7230,1,577,'C',10),(7231,1,577,'D',1),(7232,1,577,'D',2),(7233,1,577,'D',3),(7234,1,577,'D',4),(7235,1,577,'D',5),(7236,1,577,'D',6),(7237,1,577,'D',7),(7238,1,577,'D',8),(7239,1,577,'D',9),(7240,1,577,'D',10),(7241,1,577,'E',1),(7242,1,577,'E',2),(7243,1,577,'E',3),(7244,1,577,'E',4),(7245,1,577,'E',5),(7246,1,577,'E',6),(7247,1,577,'E',7),(7248,1,577,'E',8),(7249,1,577,'E',9),(7250,1,577,'E',10),(7251,2,577,'F',1),(7252,2,577,'F',2),(7253,2,577,'F',3),(7254,2,577,'F',4),(7255,2,577,'F',5),(7256,2,577,'F',6),(7257,2,577,'F',7),(7258,2,577,'F',8),(7259,2,577,'F',9),(7260,2,577,'F',10),(7261,2,577,'G',1),(7262,2,577,'G',2),(7263,2,577,'G',3),(7264,2,577,'G',4),(7265,2,577,'G',5),(7266,2,577,'G',6),(7267,2,577,'G',7),(7268,2,577,'G',8),(7269,2,577,'G',9),(7270,2,577,'G',10),(7271,5,577,'H',1),(7272,5,577,'H',2),(7273,5,577,'H',3),(7274,5,577,'H',4),(7275,5,577,'H',5),(7276,5,577,'H',6),(7277,5,577,'H',7),(7278,5,577,'H',8),(7279,5,577,'H',9),(7280,5,577,'H',10),(7281,4,577,'I',1),(7282,4,577,'I',2),(7283,4,577,'I',3),(7284,4,577,'I',4),(7285,4,577,'I',5),(7286,4,577,'I',6),(7287,4,577,'I',7),(7288,4,577,'I',8),(7289,4,577,'I',9),(7290,4,577,'I',10),(7291,3,577,'J',1),(7292,3,577,'J',2),(7293,3,577,'J',3),(7294,3,577,'J',4),(7295,3,577,'J',5),(7296,3,577,'J',6),(7297,3,577,'J',7),(7298,3,577,'J',8),(7299,3,577,'J',9),(7300,3,577,'J',10),(7301,1,585,'A',1),(7302,1,585,'A',2),(7303,1,585,'A',3),(7304,1,585,'A',4),(7305,1,585,'A',5),(7306,1,585,'A',6),(7307,1,585,'A',7),(7308,1,585,'A',8),(7309,1,585,'A',9),(7310,1,585,'A',10),(7311,1,585,'B',1),(7312,1,585,'B',2),(7313,1,585,'B',3),(7314,1,585,'B',4),(7315,1,585,'B',5),(7316,1,585,'B',6),(7317,1,585,'B',7),(7318,1,585,'B',8),(7319,1,585,'B',9),(7320,1,585,'B',10),(7321,1,585,'C',1),(7322,1,585,'C',2),(7323,1,585,'C',3),(7324,1,585,'C',4),(7325,1,585,'C',5),(7326,1,585,'C',6),(7327,1,585,'C',7),(7328,1,585,'C',8),(7329,1,585,'C',9),(7330,1,585,'C',10),(7331,1,585,'D',1),(7332,1,585,'D',2),(7333,1,585,'D',3),(7334,1,585,'D',4),(7335,1,585,'D',5),(7336,1,585,'D',6),(7337,1,585,'D',7),(7338,1,585,'D',8),(7339,1,585,'D',9),(7340,1,585,'D',10),(7341,1,585,'E',1),(7342,1,585,'E',2),(7343,1,585,'E',3),(7344,1,585,'E',4),(7345,1,585,'E',5),(7346,1,585,'E',6),(7347,1,585,'E',7),(7348,1,585,'E',8),(7349,1,585,'E',9),(7350,1,585,'E',10),(7351,2,585,'F',1),(7352,2,585,'F',2),(7353,2,585,'F',3),(7354,2,585,'F',4),(7355,2,585,'F',5),(7356,2,585,'F',6),(7357,2,585,'F',7),(7358,2,585,'F',8),(7359,2,585,'F',9),(7360,2,585,'F',10),(7361,2,585,'G',1),(7362,2,585,'G',2),(7363,2,585,'G',3),(7364,2,585,'G',4),(7365,2,585,'G',5),(7366,2,585,'G',6),(7367,2,585,'G',7),(7368,2,585,'G',8),(7369,2,585,'G',9),(7370,2,585,'G',10),(7371,5,585,'H',1),(7372,5,585,'H',2),(7373,5,585,'H',3),(7374,5,585,'H',4),(7375,5,585,'H',5),(7376,5,585,'H',6),(7377,5,585,'H',7),(7378,5,585,'H',8),(7379,5,585,'H',9),(7380,5,585,'H',10),(7381,4,585,'I',1),(7382,4,585,'I',2),(7383,4,585,'I',3),(7384,4,585,'I',4),(7385,4,585,'I',5),(7386,4,585,'I',6),(7387,4,585,'I',7),(7388,4,585,'I',8),(7389,4,585,'I',9),(7390,4,585,'I',10),(7391,3,585,'J',1),(7392,3,585,'J',2),(7393,3,585,'J',3),(7394,3,585,'J',4),(7395,3,585,'J',5),(7396,3,585,'J',6),(7397,3,585,'J',7),(7398,3,585,'J',8),(7399,3,585,'J',9),(7400,3,585,'J',10),(7401,1,593,'A',1),(7402,1,593,'A',2),(7403,1,593,'A',3),(7404,1,593,'A',4),(7405,1,593,'A',5),(7406,1,593,'A',6),(7407,1,593,'A',7),(7408,1,593,'A',8),(7409,1,593,'A',9),(7410,1,593,'A',10),(7411,1,593,'B',1),(7412,1,593,'B',2),(7413,1,593,'B',3),(7414,1,593,'B',4),(7415,1,593,'B',5),(7416,1,593,'B',6),(7417,1,593,'B',7),(7418,1,593,'B',8),(7419,1,593,'B',9),(7420,1,593,'B',10),(7421,1,593,'C',1),(7422,1,593,'C',2),(7423,1,593,'C',3),(7424,1,593,'C',4),(7425,1,593,'C',5),(7426,1,593,'C',6),(7427,1,593,'C',7),(7428,1,593,'C',8),(7429,1,593,'C',9),(7430,1,593,'C',10),(7431,1,593,'D',1),(7432,1,593,'D',2),(7433,1,593,'D',3),(7434,1,593,'D',4),(7435,1,593,'D',5),(7436,1,593,'D',6),(7437,1,593,'D',7),(7438,1,593,'D',8),(7439,1,593,'D',9),(7440,1,593,'D',10),(7441,1,593,'E',1),(7442,1,593,'E',2),(7443,1,593,'E',3),(7444,1,593,'E',4),(7445,1,593,'E',5),(7446,1,593,'E',6),(7447,1,593,'E',7),(7448,1,593,'E',8),(7449,1,593,'E',9),(7450,1,593,'E',10),(7451,2,593,'F',1),(7452,2,593,'F',2),(7453,2,593,'F',3),(7454,2,593,'F',4),(7455,2,593,'F',5),(7456,2,593,'F',6),(7457,2,593,'F',7),(7458,2,593,'F',8),(7459,2,593,'F',9),(7460,2,593,'F',10),(7461,2,593,'G',1),(7462,2,593,'G',2),(7463,2,593,'G',3),(7464,2,593,'G',4),(7465,2,593,'G',5),(7466,2,593,'G',6),(7467,2,593,'G',7),(7468,2,593,'G',8),(7469,2,593,'G',9),(7470,2,593,'G',10),(7471,5,593,'H',1),(7472,5,593,'H',2),(7473,5,593,'H',3),(7474,5,593,'H',4),(7475,5,593,'H',5),(7476,5,593,'H',6),(7477,5,593,'H',7),(7478,5,593,'H',8),(7479,5,593,'H',9),(7480,5,593,'H',10),(7481,4,593,'I',1),(7482,4,593,'I',2),(7483,4,593,'I',3),(7484,4,593,'I',4),(7485,4,593,'I',5),(7486,4,593,'I',6),(7487,4,593,'I',7),(7488,4,593,'I',8),(7489,4,593,'I',9),(7490,4,593,'I',10),(7491,3,593,'J',1),(7492,3,593,'J',2),(7493,3,593,'J',3),(7494,3,593,'J',4),(7495,3,593,'J',5),(7496,3,593,'J',6),(7497,3,593,'J',7),(7498,3,593,'J',8),(7499,3,593,'J',9),(7500,3,593,'J',10),(7501,1,601,'A',1),(7502,1,601,'A',2),(7503,1,601,'A',3),(7504,1,601,'A',4),(7505,1,601,'A',5),(7506,1,601,'A',6),(7507,1,601,'A',7),(7508,1,601,'A',8),(7509,1,601,'A',9),(7510,1,601,'A',10),(7511,1,601,'B',1),(7512,1,601,'B',2),(7513,1,601,'B',3),(7514,1,601,'B',4),(7515,1,601,'B',5),(7516,1,601,'B',6),(7517,1,601,'B',7),(7518,1,601,'B',8),(7519,1,601,'B',9),(7520,1,601,'B',10),(7521,1,601,'C',1),(7522,1,601,'C',2),(7523,1,601,'C',3),(7524,1,601,'C',4),(7525,1,601,'C',5),(7526,1,601,'C',6),(7527,1,601,'C',7),(7528,1,601,'C',8),(7529,1,601,'C',9),(7530,1,601,'C',10),(7531,1,601,'D',1),(7532,1,601,'D',2),(7533,1,601,'D',3),(7534,1,601,'D',4),(7535,1,601,'D',5),(7536,1,601,'D',6),(7537,1,601,'D',7),(7538,1,601,'D',8),(7539,1,601,'D',9),(7540,1,601,'D',10),(7541,1,601,'E',1),(7542,1,601,'E',2),(7543,1,601,'E',3),(7544,1,601,'E',4),(7545,1,601,'E',5),(7546,1,601,'E',6),(7547,1,601,'E',7),(7548,1,601,'E',8),(7549,1,601,'E',9),(7550,1,601,'E',10),(7551,2,601,'F',1),(7552,2,601,'F',2),(7553,2,601,'F',3),(7554,2,601,'F',4),(7555,2,601,'F',5),(7556,2,601,'F',6),(7557,2,601,'F',7),(7558,2,601,'F',8),(7559,2,601,'F',9),(7560,2,601,'F',10),(7561,2,601,'G',1),(7562,2,601,'G',2),(7563,2,601,'G',3),(7564,2,601,'G',4),(7565,2,601,'G',5),(7566,2,601,'G',6),(7567,2,601,'G',7),(7568,2,601,'G',8),(7569,2,601,'G',9),(7570,2,601,'G',10),(7571,5,601,'H',1),(7572,5,601,'H',2),(7573,5,601,'H',3),(7574,5,601,'H',4),(7575,5,601,'H',5),(7576,5,601,'H',6),(7577,5,601,'H',7),(7578,5,601,'H',8),(7579,5,601,'H',9),(7580,5,601,'H',10),(7581,4,601,'I',1),(7582,4,601,'I',2),(7583,4,601,'I',3),(7584,4,601,'I',4),(7585,4,601,'I',5),(7586,4,601,'I',6),(7587,4,601,'I',7),(7588,4,601,'I',8),(7589,4,601,'I',9),(7590,4,601,'I',10),(7591,3,601,'J',1),(7592,3,601,'J',2),(7593,3,601,'J',3),(7594,3,601,'J',4),(7595,3,601,'J',5),(7596,3,601,'J',6),(7597,3,601,'J',7),(7598,3,601,'J',8),(7599,3,601,'J',9),(7600,3,601,'J',10),(7601,1,609,'A',1),(7602,1,609,'A',2),(7603,1,609,'A',3),(7604,1,609,'A',4),(7605,1,609,'A',5),(7606,1,609,'A',6),(7607,1,609,'A',7),(7608,1,609,'A',8),(7609,1,609,'A',9),(7610,1,609,'A',10),(7611,1,609,'B',1),(7612,1,609,'B',2),(7613,1,609,'B',3),(7614,1,609,'B',4),(7615,1,609,'B',5),(7616,1,609,'B',6),(7617,1,609,'B',7),(7618,1,609,'B',8),(7619,1,609,'B',9),(7620,1,609,'B',10),(7621,1,609,'C',1),(7622,1,609,'C',2),(7623,1,609,'C',3),(7624,1,609,'C',4),(7625,1,609,'C',5),(7626,1,609,'C',6),(7627,1,609,'C',7),(7628,1,609,'C',8),(7629,1,609,'C',9),(7630,1,609,'C',10),(7631,1,609,'D',1),(7632,1,609,'D',2),(7633,1,609,'D',3),(7634,1,609,'D',4),(7635,1,609,'D',5),(7636,1,609,'D',6),(7637,1,609,'D',7),(7638,1,609,'D',8),(7639,1,609,'D',9),(7640,1,609,'D',10),(7641,1,609,'E',1),(7642,1,609,'E',2),(7643,1,609,'E',3),(7644,1,609,'E',4),(7645,1,609,'E',5),(7646,1,609,'E',6),(7647,1,609,'E',7),(7648,1,609,'E',8),(7649,1,609,'E',9),(7650,1,609,'E',10),(7651,2,609,'F',1),(7652,2,609,'F',2),(7653,2,609,'F',3),(7654,2,609,'F',4),(7655,2,609,'F',5),(7656,2,609,'F',6),(7657,2,609,'F',7),(7658,2,609,'F',8),(7659,2,609,'F',9),(7660,2,609,'F',10),(7661,2,609,'G',1),(7662,2,609,'G',2),(7663,2,609,'G',3),(7664,2,609,'G',4),(7665,2,609,'G',5),(7666,2,609,'G',6),(7667,2,609,'G',7),(7668,2,609,'G',8),(7669,2,609,'G',9),(7670,2,609,'G',10),(7671,5,609,'H',1),(7672,5,609,'H',2),(7673,5,609,'H',3),(7674,5,609,'H',4),(7675,5,609,'H',5),(7676,5,609,'H',6),(7677,5,609,'H',7),(7678,5,609,'H',8),(7679,5,609,'H',9),(7680,5,609,'H',10),(7681,4,609,'I',1),(7682,4,609,'I',2),(7683,4,609,'I',3),(7684,4,609,'I',4),(7685,4,609,'I',5),(7686,4,609,'I',6),(7687,4,609,'I',7),(7688,4,609,'I',8),(7689,4,609,'I',9),(7690,4,609,'I',10),(7691,3,609,'J',1),(7692,3,609,'J',2),(7693,3,609,'J',3),(7694,3,609,'J',4),(7695,3,609,'J',5),(7696,3,609,'J',6),(7697,3,609,'J',7),(7698,3,609,'J',8),(7699,3,609,'J',9),(7700,3,609,'J',10),(7701,1,617,'A',1),(7702,1,617,'A',2),(7703,1,617,'A',3),(7704,1,617,'A',4),(7705,1,617,'A',5),(7706,1,617,'A',6),(7707,1,617,'A',7),(7708,1,617,'A',8),(7709,1,617,'A',9),(7710,1,617,'A',10),(7711,1,617,'B',1),(7712,1,617,'B',2),(7713,1,617,'B',3),(7714,1,617,'B',4),(7715,1,617,'B',5),(7716,1,617,'B',6),(7717,1,617,'B',7),(7718,1,617,'B',8),(7719,1,617,'B',9),(7720,1,617,'B',10),(7721,1,617,'C',1),(7722,1,617,'C',2),(7723,1,617,'C',3),(7724,1,617,'C',4),(7725,1,617,'C',5),(7726,1,617,'C',6),(7727,1,617,'C',7),(7728,1,617,'C',8),(7729,1,617,'C',9),(7730,1,617,'C',10),(7731,1,617,'D',1),(7732,1,617,'D',2),(7733,1,617,'D',3),(7734,1,617,'D',4),(7735,1,617,'D',5),(7736,1,617,'D',6),(7737,1,617,'D',7),(7738,1,617,'D',8),(7739,1,617,'D',9),(7740,1,617,'D',10),(7741,1,617,'E',1),(7742,1,617,'E',2),(7743,1,617,'E',3),(7744,1,617,'E',4),(7745,1,617,'E',5),(7746,1,617,'E',6),(7747,1,617,'E',7),(7748,1,617,'E',8),(7749,1,617,'E',9),(7750,1,617,'E',10),(7751,2,617,'F',1),(7752,2,617,'F',2),(7753,2,617,'F',3),(7754,2,617,'F',4),(7755,2,617,'F',5),(7756,2,617,'F',6),(7757,2,617,'F',7),(7758,2,617,'F',8),(7759,2,617,'F',9),(7760,2,617,'F',10),(7761,2,617,'G',1),(7762,2,617,'G',2),(7763,2,617,'G',3),(7764,2,617,'G',4),(7765,2,617,'G',5),(7766,2,617,'G',6),(7767,2,617,'G',7),(7768,2,617,'G',8),(7769,2,617,'G',9),(7770,2,617,'G',10),(7771,5,617,'H',1),(7772,5,617,'H',2),(7773,5,617,'H',3),(7774,5,617,'H',4),(7775,5,617,'H',5),(7776,5,617,'H',6),(7777,5,617,'H',7),(7778,5,617,'H',8),(7779,5,617,'H',9),(7780,5,617,'H',10),(7781,4,617,'I',1),(7782,4,617,'I',2),(7783,4,617,'I',3),(7784,4,617,'I',4),(7785,4,617,'I',5),(7786,4,617,'I',6),(7787,4,617,'I',7),(7788,4,617,'I',8),(7789,4,617,'I',9),(7790,4,617,'I',10),(7791,3,617,'J',1),(7792,3,617,'J',2),(7793,3,617,'J',3),(7794,3,617,'J',4),(7795,3,617,'J',5),(7796,3,617,'J',6),(7797,3,617,'J',7),(7798,3,617,'J',8),(7799,3,617,'J',9),(7800,3,617,'J',10),(7801,1,625,'A',1),(7802,1,625,'A',2),(7803,1,625,'A',3),(7804,1,625,'A',4),(7805,1,625,'A',5),(7806,1,625,'A',6),(7807,1,625,'A',7),(7808,1,625,'A',8),(7809,1,625,'A',9),(7810,1,625,'A',10),(7811,1,625,'B',1),(7812,1,625,'B',2),(7813,1,625,'B',3),(7814,1,625,'B',4),(7815,1,625,'B',5),(7816,1,625,'B',6),(7817,1,625,'B',7),(7818,1,625,'B',8),(7819,1,625,'B',9),(7820,1,625,'B',10),(7821,1,625,'C',1),(7822,1,625,'C',2),(7823,1,625,'C',3),(7824,1,625,'C',4),(7825,1,625,'C',5),(7826,1,625,'C',6),(7827,1,625,'C',7),(7828,1,625,'C',8),(7829,1,625,'C',9),(7830,1,625,'C',10),(7831,1,625,'D',1),(7832,1,625,'D',2),(7833,1,625,'D',3),(7834,1,625,'D',4),(7835,1,625,'D',5),(7836,1,625,'D',6),(7837,1,625,'D',7),(7838,1,625,'D',8),(7839,1,625,'D',9),(7840,1,625,'D',10),(7841,1,625,'E',1),(7842,1,625,'E',2),(7843,1,625,'E',3),(7844,1,625,'E',4),(7845,1,625,'E',5),(7846,1,625,'E',6),(7847,1,625,'E',7),(7848,1,625,'E',8),(7849,1,625,'E',9),(7850,1,625,'E',10),(7851,2,625,'F',1),(7852,2,625,'F',2),(7853,2,625,'F',3),(7854,2,625,'F',4),(7855,2,625,'F',5),(7856,2,625,'F',6),(7857,2,625,'F',7),(7858,2,625,'F',8),(7859,2,625,'F',9),(7860,2,625,'F',10),(7861,2,625,'G',1),(7862,2,625,'G',2),(7863,2,625,'G',3),(7864,2,625,'G',4),(7865,2,625,'G',5),(7866,2,625,'G',6),(7867,2,625,'G',7),(7868,2,625,'G',8),(7869,2,625,'G',9),(7870,2,625,'G',10),(7871,5,625,'H',1),(7872,5,625,'H',2),(7873,5,625,'H',3),(7874,5,625,'H',4),(7875,5,625,'H',5),(7876,5,625,'H',6),(7877,5,625,'H',7),(7878,5,625,'H',8),(7879,5,625,'H',9),(7880,5,625,'H',10),(7881,4,625,'I',1),(7882,4,625,'I',2),(7883,4,625,'I',3),(7884,4,625,'I',4),(7885,4,625,'I',5),(7886,4,625,'I',6),(7887,4,625,'I',7),(7888,4,625,'I',8),(7889,4,625,'I',9),(7890,4,625,'I',10),(7891,3,625,'J',1),(7892,3,625,'J',2),(7893,3,625,'J',3),(7894,3,625,'J',4),(7895,3,625,'J',5),(7896,3,625,'J',6),(7897,3,625,'J',7),(7898,3,625,'J',8),(7899,3,625,'J',9),(7900,3,625,'J',10),(7901,1,633,'A',1),(7902,1,633,'A',2),(7903,1,633,'A',3),(7904,1,633,'A',4),(7905,1,633,'A',5),(7906,1,633,'A',6),(7907,1,633,'A',7),(7908,1,633,'A',8),(7909,1,633,'A',9),(7910,1,633,'A',10),(7911,1,633,'B',1),(7912,1,633,'B',2),(7913,1,633,'B',3),(7914,1,633,'B',4),(7915,1,633,'B',5),(7916,1,633,'B',6),(7917,1,633,'B',7),(7918,1,633,'B',8),(7919,1,633,'B',9),(7920,1,633,'B',10),(7921,1,633,'C',1),(7922,1,633,'C',2),(7923,1,633,'C',3),(7924,1,633,'C',4),(7925,1,633,'C',5),(7926,1,633,'C',6),(7927,1,633,'C',7),(7928,1,633,'C',8),(7929,1,633,'C',9),(7930,1,633,'C',10),(7931,1,633,'D',1),(7932,1,633,'D',2),(7933,1,633,'D',3),(7934,1,633,'D',4),(7935,1,633,'D',5),(7936,1,633,'D',6),(7937,1,633,'D',7),(7938,1,633,'D',8),(7939,1,633,'D',9),(7940,1,633,'D',10),(7941,1,633,'E',1),(7942,1,633,'E',2),(7943,1,633,'E',3),(7944,1,633,'E',4),(7945,1,633,'E',5),(7946,1,633,'E',6),(7947,1,633,'E',7),(7948,1,633,'E',8),(7949,1,633,'E',9),(7950,1,633,'E',10),(7951,2,633,'F',1),(7952,2,633,'F',2),(7953,2,633,'F',3),(7954,2,633,'F',4),(7955,2,633,'F',5),(7956,2,633,'F',6),(7957,2,633,'F',7),(7958,2,633,'F',8),(7959,2,633,'F',9),(7960,2,633,'F',10),(7961,2,633,'G',1),(7962,2,633,'G',2),(7963,2,633,'G',3),(7964,2,633,'G',4),(7965,2,633,'G',5),(7966,2,633,'G',6),(7967,2,633,'G',7),(7968,2,633,'G',8),(7969,2,633,'G',9),(7970,2,633,'G',10),(7971,5,633,'H',1),(7972,5,633,'H',2),(7973,5,633,'H',3),(7974,5,633,'H',4),(7975,5,633,'H',5),(7976,5,633,'H',6),(7977,5,633,'H',7),(7978,5,633,'H',8),(7979,5,633,'H',9),(7980,5,633,'H',10),(7981,4,633,'I',1),(7982,4,633,'I',2),(7983,4,633,'I',3),(7984,4,633,'I',4),(7985,4,633,'I',5),(7986,4,633,'I',6),(7987,4,633,'I',7),(7988,4,633,'I',8),(7989,4,633,'I',9),(7990,4,633,'I',10),(7991,3,633,'J',1),(7992,3,633,'J',2),(7993,3,633,'J',3),(7994,3,633,'J',4),(7995,3,633,'J',5),(7996,3,633,'J',6),(7997,3,633,'J',7),(7998,3,633,'J',8),(7999,3,633,'J',9),(8000,3,633,'J',10),(8004,1,5,'A',1),(8005,1,5,'A',2),(8006,1,5,'A',3),(8007,1,5,'A',4),(8008,1,5,'A',5),(8009,1,5,'A',6),(8010,1,5,'A',7),(8011,1,5,'A',8),(8012,1,5,'A',9),(8013,1,5,'A',10),(8014,1,5,'B',1),(8015,1,5,'B',2),(8016,1,5,'B',3),(8017,1,5,'B',4),(8018,1,5,'B',5),(8019,1,5,'B',6),(8020,1,5,'B',7),(8021,1,5,'B',8),(8022,1,5,'B',9),(8023,1,5,'B',10),(8024,1,5,'C',1),(8025,1,5,'C',2),(8026,1,5,'C',3),(8027,1,5,'C',4),(8028,1,5,'C',5),(8029,1,5,'C',6),(8030,1,5,'C',7),(8031,1,5,'C',8),(8032,1,5,'C',9),(8033,1,5,'C',10),(8034,1,5,'D',1),(8035,1,5,'D',2),(8036,1,5,'D',3),(8037,1,5,'D',4),(8038,1,5,'D',5),(8039,1,5,'D',6),(8040,1,5,'D',7),(8041,1,5,'D',8),(8042,1,5,'D',9),(8043,1,5,'D',10),(8044,1,5,'E',1),(8045,1,5,'E',2),(8046,1,5,'E',3),(8047,1,5,'E',4),(8048,1,5,'E',5),(8049,1,5,'E',6),(8050,1,5,'E',7),(8051,1,5,'E',8),(8052,1,5,'E',9),(8053,1,5,'E',10),(8054,2,5,'F',1),(8055,2,5,'F',2),(8056,2,5,'F',3),(8057,2,5,'F',4),(8058,2,5,'F',5),(8059,2,5,'F',6),(8060,2,5,'F',7),(8061,2,5,'F',8),(8062,2,5,'F',9),(8063,2,5,'F',10),(8064,2,5,'G',1),(8065,2,5,'G',2),(8066,2,5,'G',3),(8067,2,5,'G',4),(8068,2,5,'G',5),(8069,2,5,'G',6),(8070,2,5,'G',7),(8071,2,5,'G',8),(8072,2,5,'G',9),(8073,2,5,'G',10),(8074,5,5,'H',1),(8075,5,5,'H',2),(8076,5,5,'H',3),(8077,5,5,'H',4),(8078,5,5,'H',5),(8079,5,5,'H',6),(8080,5,5,'H',7),(8081,5,5,'H',8),(8082,5,5,'H',9),(8083,5,5,'H',10),(8084,4,5,'I',1),(8085,4,5,'I',2),(8086,4,5,'I',3),(8087,4,5,'I',4),(8088,4,5,'I',5),(8089,4,5,'I',6),(8090,4,5,'I',7),(8091,4,5,'I',8),(8092,4,5,'I',9),(8093,4,5,'I',10),(8094,3,5,'J',1),(8095,3,5,'J',2),(8096,3,5,'J',3),(8097,3,5,'J',4),(8098,3,5,'J',5),(8099,3,5,'J',6),(8100,3,5,'J',7),(8101,3,5,'J',8),(8102,3,5,'J',9),(8103,3,5,'J',10),(8104,1,4,'A',1),(8105,1,4,'A',2),(8106,1,4,'A',3),(8107,1,4,'A',4),(8108,1,4,'A',5),(8109,1,4,'A',6),(8110,1,4,'A',7),(8111,1,4,'A',8),(8112,1,4,'A',9),(8113,1,4,'A',10),(8114,1,4,'B',1),(8115,1,4,'B',2),(8116,1,4,'B',3),(8117,1,4,'B',4),(8118,1,4,'B',5),(8119,1,4,'B',6),(8120,1,4,'B',7),(8121,1,4,'B',8),(8122,1,4,'B',9),(8123,1,4,'B',10),(8124,1,4,'C',1),(8125,1,4,'C',2),(8126,1,4,'C',3),(8127,1,4,'C',4),(8128,1,4,'C',5),(8129,1,4,'C',6),(8130,1,4,'C',7),(8131,1,4,'C',8),(8132,1,4,'C',9),(8133,1,4,'C',10),(8134,1,4,'D',1),(8135,1,4,'D',2),(8136,1,4,'D',3),(8137,1,4,'D',4),(8138,1,4,'D',5),(8139,1,4,'D',6),(8140,1,4,'D',7),(8141,1,4,'D',8),(8142,1,4,'D',9),(8143,1,4,'D',10),(8144,1,4,'E',1),(8145,1,4,'E',2),(8146,1,4,'E',3),(8147,1,4,'E',4),(8148,1,4,'E',5),(8149,1,4,'E',6),(8150,1,4,'E',7),(8151,1,4,'E',8),(8152,1,4,'E',9),(8153,1,4,'E',10),(8154,2,4,'F',1),(8155,2,4,'F',2),(8156,2,4,'F',3),(8157,2,4,'F',4),(8158,2,4,'F',5),(8159,2,4,'F',6),(8160,2,4,'F',7),(8161,2,4,'F',8),(8162,2,4,'F',9),(8163,2,4,'F',10),(8164,2,4,'G',1),(8165,2,4,'G',2),(8166,2,4,'G',3),(8167,2,4,'G',4),(8168,2,4,'G',5),(8169,2,4,'G',6),(8170,2,4,'G',7),(8171,2,4,'G',8),(8172,2,4,'G',9),(8173,2,4,'G',10),(8174,5,4,'H',1),(8175,5,4,'H',2),(8176,5,4,'H',3),(8177,5,4,'H',4),(8178,5,4,'H',5),(8179,5,4,'H',6),(8180,5,4,'H',7),(8181,5,4,'H',8),(8182,5,4,'H',9),(8183,5,4,'H',10),(8184,4,4,'I',1),(8185,4,4,'I',2),(8186,4,4,'I',3),(8187,4,4,'I',4),(8188,4,4,'I',5),(8189,4,4,'I',6),(8190,4,4,'I',7),(8191,4,4,'I',8),(8192,4,4,'I',9),(8193,4,4,'I',10),(8194,3,4,'J',1),(8195,3,4,'J',2),(8196,3,4,'J',3),(8197,3,4,'J',4),(8198,3,4,'J',5),(8199,3,4,'J',6),(8200,3,4,'J',7),(8201,3,4,'J',8),(8202,3,4,'J',9),(8203,3,4,'J',10);
/*!40000 ALTER TABLE `seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat_type`
--

DROP TABLE IF EXISTS `seat_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat_type` (
  `seat_type_id` int unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`seat_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat_type`
--

LOCK TABLES `seat_type` WRITE;
/*!40000 ALTER TABLE `seat_type` DISABLE KEYS */;
INSERT INTO `seat_type` VALUES (1,'Ghế thường',70000.00),(2,'Ghế VIP',120000.00),(3,'SweetBox',220000.00),(4,'Ghế Couple',180000.00),(5,'Ghế Cao cấp',150000.00);
/*!40000 ALTER TABLE `seat_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `showtime`
--

DROP TABLE IF EXISTS `showtime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `showtime` (
  `showtime_id` int unsigned NOT NULL AUTO_INCREMENT,
  `movie_id` int unsigned NOT NULL,
  `room_id` int unsigned NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `show_date` date NOT NULL,
  PRIMARY KEY (`showtime_id`),
  KEY `movie_id` (`movie_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `showtime_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`),
  CONSTRAINT `showtime_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=659 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `showtime`
--

LOCK TABLES `showtime` WRITE;
/*!40000 ALTER TABLE `showtime` DISABLE KEYS */;
INSERT INTO `showtime` VALUES (644,3,1,'09:00:00','11:00:00','2026-04-24'),(645,3,1,'11:30:00','13:30:00','2026-04-24'),(646,3,1,'14:00:00','16:00:00','2026-04-24'),(647,3,1,'09:00:00','11:00:00','2026-04-25'),(648,3,1,'11:30:00','13:30:00','2026-04-25'),(649,3,1,'14:00:00','16:00:00','2026-04-25'),(650,3,1,'09:00:00','11:00:00','2026-04-26'),(651,3,1,'11:30:00','13:30:00','2026-04-26'),(652,3,1,'14:00:00','16:00:00','2026-04-26'),(653,3,1,'09:00:00','11:00:00','2026-04-27'),(654,3,1,'11:30:00','13:30:00','2026-04-27'),(655,3,1,'14:00:00','16:00:00','2026-04-27'),(656,3,1,'09:00:00','11:00:00','2026-04-28'),(657,3,1,'11:30:00','13:30:00','2026-04-28'),(658,3,1,'14:00:00','16:00:00','2026-04-28');
/*!40000 ALTER TABLE `showtime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `showtime_seat`
--

DROP TABLE IF EXISTS `showtime_seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `showtime_seat` (
  `showtime_seat_id` int unsigned NOT NULL AUTO_INCREMENT,
  `status_id` int unsigned NOT NULL,
  `seat_id` int unsigned NOT NULL,
  `showtime_id` int unsigned NOT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `hold_expired_at` datetime DEFAULT NULL,
  PRIMARY KEY (`showtime_seat_id`),
  UNIQUE KEY `showtime_id` (`showtime_id`,`seat_id`),
  KEY `status_id` (`status_id`),
  KEY `seat_id` (`seat_id`),
  KEY `fk_showtime_seat_user` (`user_id`),
  KEY `idx_showtime_seat_hold` (`status_id`,`hold_expired_at`),
  CONSTRAINT `fk_showtime_seat_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `showtime_seat_ibfk_1` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`),
  CONSTRAINT `showtime_seat_ibfk_2` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`),
  CONSTRAINT `showtime_seat_ibfk_3` FOREIGN KEY (`showtime_id`) REFERENCES `showtime` (`showtime_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3206 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `showtime_seat`
--

LOCK TABLES `showtime_seat` WRITE;
/*!40000 ALTER TABLE `showtime_seat` DISABLE KEYS */;
INSERT INTO `showtime_seat` VALUES (1301,1,1,644,NULL,NULL),(1302,1,2,644,NULL,NULL),(1303,1,3,644,NULL,NULL),(1304,1,4,644,NULL,NULL),(1305,1,5,644,NULL,NULL),(1306,1,6,644,NULL,NULL),(1307,1,7,644,NULL,NULL),(1308,1,8,644,NULL,NULL),(1309,3,9,644,11,NULL),(1310,1,10,644,NULL,NULL),(1311,1,11,644,NULL,NULL),(1312,1,12,644,NULL,NULL),(1313,1,13,644,NULL,NULL),(1314,1,14,644,NULL,NULL),(1315,1,15,644,NULL,NULL),(1316,1,16,644,NULL,NULL),(1317,1,17,644,NULL,NULL),(1318,1,18,644,NULL,NULL),(1319,1,19,644,NULL,NULL),(1320,1,20,644,NULL,NULL),(1321,1,21,644,NULL,NULL),(1322,1,22,644,NULL,NULL),(1323,1,23,644,NULL,NULL),(1324,1,24,644,NULL,NULL),(1325,1,25,644,NULL,NULL),(1326,3,26,644,11,NULL),(1327,3,27,644,11,NULL),(1328,1,28,644,NULL,NULL),(1329,1,29,644,NULL,NULL),(1330,1,30,644,NULL,NULL),(1331,1,31,644,NULL,NULL),(1332,1,32,644,NULL,NULL),(1333,1,33,644,NULL,NULL),(1334,1,34,644,NULL,NULL),(1335,1,35,644,NULL,NULL),(1336,3,36,644,11,NULL),(1337,1,37,644,NULL,NULL),(1338,1,38,644,NULL,NULL),(1339,1,39,644,NULL,NULL),(1340,1,40,644,NULL,NULL),(1341,1,41,644,NULL,NULL),(1342,1,42,644,NULL,NULL),(1343,1,43,644,NULL,NULL),(1344,1,44,644,NULL,NULL),(1345,1,45,644,NULL,NULL),(1346,1,46,644,NULL,NULL),(1347,1,47,644,NULL,NULL),(1348,1,48,644,NULL,NULL),(1349,1,49,644,NULL,NULL),(1350,1,50,644,NULL,NULL),(1351,1,51,644,NULL,NULL),(1352,1,52,644,NULL,NULL),(1353,1,53,644,NULL,NULL),(1354,1,54,644,NULL,NULL),(1355,1,55,644,NULL,NULL),(1356,1,56,644,NULL,NULL),(1357,1,57,644,NULL,NULL),(1358,1,58,644,NULL,NULL),(1359,1,59,644,NULL,NULL),(1360,1,60,644,NULL,NULL),(1361,1,61,644,NULL,NULL),(1362,1,62,644,NULL,NULL),(1363,1,63,644,NULL,NULL),(1364,1,64,644,NULL,NULL),(1365,1,65,644,NULL,NULL),(1366,1,66,644,NULL,NULL),(1367,1,67,644,NULL,NULL),(1368,1,68,644,NULL,NULL),(1369,1,69,644,NULL,NULL),(1370,1,70,644,NULL,NULL),(1371,1,71,644,NULL,NULL),(1372,1,72,644,NULL,NULL),(1373,1,73,644,NULL,NULL),(1374,1,74,644,NULL,NULL),(1375,1,75,644,NULL,NULL),(1376,1,76,644,NULL,NULL),(1377,1,77,644,NULL,NULL),(1378,1,78,644,NULL,NULL),(1379,1,79,644,NULL,NULL),(1380,1,80,644,NULL,NULL),(1381,1,81,644,NULL,NULL),(1382,1,82,644,NULL,NULL),(1383,1,83,644,NULL,NULL),(1384,1,84,644,NULL,NULL),(1385,1,85,644,NULL,NULL),(1386,1,86,644,NULL,NULL),(1387,1,87,644,NULL,NULL),(1388,1,88,644,NULL,NULL),(1389,1,89,644,NULL,NULL),(1390,1,90,644,NULL,NULL),(1391,1,91,644,NULL,NULL),(1392,1,92,644,NULL,NULL),(1393,1,93,644,NULL,NULL),(1394,1,94,644,NULL,NULL),(1395,1,95,644,NULL,NULL),(1396,1,96,644,NULL,NULL),(1397,1,97,644,NULL,NULL),(1398,1,98,644,NULL,NULL),(1399,1,99,644,NULL,NULL),(1400,1,100,644,NULL,NULL),(1428,1,1,645,NULL,NULL),(1429,1,2,645,NULL,NULL),(1430,1,3,645,NULL,NULL),(1431,1,4,645,NULL,NULL),(1432,1,5,645,NULL,NULL),(1433,1,6,645,NULL,NULL),(1434,1,7,645,NULL,NULL),(1435,1,8,645,NULL,NULL),(1436,1,9,645,NULL,NULL),(1437,1,10,645,NULL,NULL),(1438,1,11,645,NULL,NULL),(1439,1,12,645,NULL,NULL),(1440,1,13,645,NULL,NULL),(1441,1,14,645,NULL,NULL),(1442,1,15,645,NULL,NULL),(1443,1,16,645,NULL,NULL),(1444,1,17,645,NULL,NULL),(1445,1,18,645,NULL,NULL),(1446,1,19,645,NULL,NULL),(1447,1,20,645,NULL,NULL),(1448,1,21,645,NULL,NULL),(1449,1,22,645,NULL,NULL),(1450,1,23,645,NULL,NULL),(1451,1,24,645,NULL,NULL),(1452,1,25,645,NULL,NULL),(1453,1,26,645,NULL,NULL),(1454,1,27,645,NULL,NULL),(1455,1,28,645,NULL,NULL),(1456,1,29,645,NULL,NULL),(1457,1,30,645,NULL,NULL),(1458,1,31,645,NULL,NULL),(1459,1,32,645,NULL,NULL),(1460,1,33,645,NULL,NULL),(1461,1,34,645,NULL,NULL),(1462,1,35,645,NULL,NULL),(1463,1,36,645,NULL,NULL),(1464,1,37,645,NULL,NULL),(1465,1,38,645,NULL,NULL),(1466,1,39,645,NULL,NULL),(1467,1,40,645,NULL,NULL),(1468,1,41,645,NULL,NULL),(1469,1,42,645,NULL,NULL),(1470,1,43,645,NULL,NULL),(1471,1,44,645,NULL,NULL),(1472,1,45,645,NULL,NULL),(1473,1,46,645,NULL,NULL),(1474,1,47,645,NULL,NULL),(1475,1,48,645,NULL,NULL),(1476,1,49,645,NULL,NULL),(1477,1,50,645,NULL,NULL),(1478,1,51,645,NULL,NULL),(1479,1,52,645,NULL,NULL),(1480,1,53,645,NULL,NULL),(1481,1,54,645,NULL,NULL),(1482,1,55,645,NULL,NULL),(1483,1,56,645,NULL,NULL),(1484,1,57,645,NULL,NULL),(1485,1,58,645,NULL,NULL),(1486,1,59,645,NULL,NULL),(1487,1,60,645,NULL,NULL),(1488,1,61,645,NULL,NULL),(1489,1,62,645,NULL,NULL),(1490,1,63,645,NULL,NULL),(1491,1,64,645,NULL,NULL),(1492,1,65,645,NULL,NULL),(1493,1,66,645,NULL,NULL),(1494,1,67,645,NULL,NULL),(1495,1,68,645,NULL,NULL),(1496,1,69,645,NULL,NULL),(1497,1,70,645,NULL,NULL),(1498,1,71,645,NULL,NULL),(1499,1,72,645,NULL,NULL),(1500,1,73,645,NULL,NULL),(1501,1,74,645,NULL,NULL),(1502,1,75,645,NULL,NULL),(1503,1,76,645,NULL,NULL),(1504,1,77,645,NULL,NULL),(1505,1,78,645,NULL,NULL),(1506,1,79,645,NULL,NULL),(1507,1,80,645,NULL,NULL),(1508,1,81,645,NULL,NULL),(1509,1,82,645,NULL,NULL),(1510,1,83,645,NULL,NULL),(1511,1,84,645,NULL,NULL),(1512,1,85,645,NULL,NULL),(1513,1,86,645,NULL,NULL),(1514,1,87,645,NULL,NULL),(1515,1,88,645,NULL,NULL),(1516,1,89,645,NULL,NULL),(1517,1,90,645,NULL,NULL),(1518,1,91,645,NULL,NULL),(1519,1,92,645,NULL,NULL),(1520,1,93,645,NULL,NULL),(1521,1,94,645,NULL,NULL),(1522,1,95,645,NULL,NULL),(1523,1,96,645,NULL,NULL),(1524,1,97,645,NULL,NULL),(1525,1,98,645,NULL,NULL),(1526,1,99,645,NULL,NULL),(1527,1,100,645,NULL,NULL),(1555,1,1,646,NULL,NULL),(1556,1,2,646,NULL,NULL),(1557,1,3,646,NULL,NULL),(1558,1,4,646,NULL,NULL),(1559,1,5,646,NULL,NULL),(1560,1,6,646,NULL,NULL),(1561,1,7,646,NULL,NULL),(1562,1,8,646,NULL,NULL),(1563,1,9,646,NULL,NULL),(1564,1,10,646,NULL,NULL),(1565,1,11,646,NULL,NULL),(1566,1,12,646,NULL,NULL),(1567,1,13,646,NULL,NULL),(1568,1,14,646,NULL,NULL),(1569,1,15,646,NULL,NULL),(1570,1,16,646,NULL,NULL),(1571,1,17,646,NULL,NULL),(1572,1,18,646,NULL,NULL),(1573,1,19,646,NULL,NULL),(1574,1,20,646,NULL,NULL),(1575,1,21,646,NULL,NULL),(1576,1,22,646,NULL,NULL),(1577,1,23,646,NULL,NULL),(1578,1,24,646,NULL,NULL),(1579,1,25,646,NULL,NULL),(1580,1,26,646,NULL,NULL),(1581,1,27,646,NULL,NULL),(1582,1,28,646,NULL,NULL),(1583,1,29,646,NULL,NULL),(1584,1,30,646,NULL,NULL),(1585,1,31,646,NULL,NULL),(1586,1,32,646,NULL,NULL),(1587,1,33,646,NULL,NULL),(1588,1,34,646,NULL,NULL),(1589,1,35,646,NULL,NULL),(1590,1,36,646,NULL,NULL),(1591,1,37,646,NULL,NULL),(1592,1,38,646,NULL,NULL),(1593,1,39,646,NULL,NULL),(1594,1,40,646,NULL,NULL),(1595,1,41,646,NULL,NULL),(1596,1,42,646,NULL,NULL),(1597,1,43,646,NULL,NULL),(1598,1,44,646,NULL,NULL),(1599,1,45,646,NULL,NULL),(1600,1,46,646,NULL,NULL),(1601,1,47,646,NULL,NULL),(1602,1,48,646,NULL,NULL),(1603,1,49,646,NULL,NULL),(1604,1,50,646,NULL,NULL),(1605,1,51,646,NULL,NULL),(1606,1,52,646,NULL,NULL),(1607,1,53,646,NULL,NULL),(1608,1,54,646,NULL,NULL),(1609,1,55,646,NULL,NULL),(1610,1,56,646,NULL,NULL),(1611,1,57,646,NULL,NULL),(1612,1,58,646,NULL,NULL),(1613,1,59,646,NULL,NULL),(1614,1,60,646,NULL,NULL),(1615,1,61,646,NULL,NULL),(1616,1,62,646,NULL,NULL),(1617,1,63,646,NULL,NULL),(1618,1,64,646,NULL,NULL),(1619,1,65,646,NULL,NULL),(1620,1,66,646,NULL,NULL),(1621,1,67,646,NULL,NULL),(1622,1,68,646,NULL,NULL),(1623,1,69,646,NULL,NULL),(1624,1,70,646,NULL,NULL),(1625,1,71,646,NULL,NULL),(1626,1,72,646,NULL,NULL),(1627,1,73,646,NULL,NULL),(1628,1,74,646,NULL,NULL),(1629,1,75,646,NULL,NULL),(1630,1,76,646,NULL,NULL),(1631,1,77,646,NULL,NULL),(1632,1,78,646,NULL,NULL),(1633,1,79,646,NULL,NULL),(1634,1,80,646,NULL,NULL),(1635,1,81,646,NULL,NULL),(1636,1,82,646,NULL,NULL),(1637,1,83,646,NULL,NULL),(1638,1,84,646,NULL,NULL),(1639,1,85,646,NULL,NULL),(1640,1,86,646,NULL,NULL),(1641,1,87,646,NULL,NULL),(1642,1,88,646,NULL,NULL),(1643,1,89,646,NULL,NULL),(1644,1,90,646,NULL,NULL),(1645,1,91,646,NULL,NULL),(1646,1,92,646,NULL,NULL),(1647,1,93,646,NULL,NULL),(1648,1,94,646,NULL,NULL),(1649,1,95,646,NULL,NULL),(1650,1,96,646,NULL,NULL),(1651,1,97,646,NULL,NULL),(1652,1,98,646,NULL,NULL),(1653,1,99,646,NULL,NULL),(1654,1,100,646,NULL,NULL),(1682,1,1,647,NULL,NULL),(1683,1,2,647,NULL,NULL),(1684,1,3,647,NULL,NULL),(1685,1,4,647,NULL,NULL),(1686,1,5,647,NULL,NULL),(1687,1,6,647,NULL,NULL),(1688,1,7,647,NULL,NULL),(1689,1,8,647,NULL,NULL),(1690,1,9,647,NULL,NULL),(1691,1,10,647,NULL,NULL),(1692,1,11,647,NULL,NULL),(1693,1,12,647,NULL,NULL),(1694,1,13,647,NULL,NULL),(1695,1,14,647,NULL,NULL),(1696,1,15,647,NULL,NULL),(1697,1,16,647,NULL,NULL),(1698,1,17,647,NULL,NULL),(1699,1,18,647,NULL,NULL),(1700,1,19,647,NULL,NULL),(1701,1,20,647,NULL,NULL),(1702,1,21,647,NULL,NULL),(1703,1,22,647,NULL,NULL),(1704,1,23,647,NULL,NULL),(1705,1,24,647,NULL,NULL),(1706,1,25,647,NULL,NULL),(1707,1,26,647,NULL,NULL),(1708,3,27,647,11,NULL),(1709,1,28,647,NULL,NULL),(1710,1,29,647,NULL,NULL),(1711,1,30,647,NULL,NULL),(1712,1,31,647,NULL,NULL),(1713,1,32,647,NULL,NULL),(1714,1,33,647,NULL,NULL),(1715,1,34,647,NULL,NULL),(1716,1,35,647,NULL,NULL),(1717,1,36,647,NULL,NULL),(1718,3,37,647,11,NULL),(1719,1,38,647,NULL,NULL),(1720,1,39,647,NULL,NULL),(1721,1,40,647,NULL,NULL),(1722,1,41,647,NULL,NULL),(1723,1,42,647,NULL,NULL),(1724,1,43,647,NULL,NULL),(1725,1,44,647,NULL,NULL),(1726,1,45,647,NULL,NULL),(1727,1,46,647,NULL,NULL),(1728,1,47,647,NULL,NULL),(1729,1,48,647,NULL,NULL),(1730,1,49,647,NULL,NULL),(1731,1,50,647,NULL,NULL),(1732,1,51,647,NULL,NULL),(1733,1,52,647,NULL,NULL),(1734,1,53,647,NULL,NULL),(1735,1,54,647,NULL,NULL),(1736,1,55,647,NULL,NULL),(1737,1,56,647,NULL,NULL),(1738,1,57,647,NULL,NULL),(1739,3,58,647,11,NULL),(1740,1,59,647,NULL,NULL),(1741,1,60,647,NULL,NULL),(1742,1,61,647,NULL,NULL),(1743,1,62,647,NULL,NULL),(1744,1,63,647,NULL,NULL),(1745,1,64,647,NULL,NULL),(1746,1,65,647,NULL,NULL),(1747,1,66,647,NULL,NULL),(1748,1,67,647,NULL,NULL),(1749,1,68,647,NULL,NULL),(1750,1,69,647,NULL,NULL),(1751,1,70,647,NULL,NULL),(1752,1,71,647,NULL,NULL),(1753,1,72,647,NULL,NULL),(1754,1,73,647,NULL,NULL),(1755,1,74,647,NULL,NULL),(1756,1,75,647,NULL,NULL),(1757,1,76,647,NULL,NULL),(1758,1,77,647,NULL,NULL),(1759,1,78,647,NULL,NULL),(1760,1,79,647,NULL,NULL),(1761,1,80,647,NULL,NULL),(1762,1,81,647,NULL,NULL),(1763,1,82,647,NULL,NULL),(1764,1,83,647,NULL,NULL),(1765,1,84,647,NULL,NULL),(1766,1,85,647,NULL,NULL),(1767,1,86,647,NULL,NULL),(1768,1,87,647,NULL,NULL),(1769,1,88,647,NULL,NULL),(1770,1,89,647,NULL,NULL),(1771,1,90,647,NULL,NULL),(1772,1,91,647,NULL,NULL),(1773,1,92,647,NULL,NULL),(1774,1,93,647,NULL,NULL),(1775,1,94,647,NULL,NULL),(1776,1,95,647,NULL,NULL),(1777,1,96,647,NULL,NULL),(1778,1,97,647,NULL,NULL),(1779,1,98,647,NULL,NULL),(1780,1,99,647,NULL,NULL),(1781,1,100,647,NULL,NULL),(1809,1,1,648,NULL,NULL),(1810,1,2,648,NULL,NULL),(1811,1,3,648,NULL,NULL),(1812,1,4,648,NULL,NULL),(1813,1,5,648,NULL,NULL),(1814,1,6,648,NULL,NULL),(1815,1,7,648,NULL,NULL),(1816,1,8,648,NULL,NULL),(1817,1,9,648,NULL,NULL),(1818,1,10,648,NULL,NULL),(1819,1,11,648,NULL,NULL),(1820,1,12,648,NULL,NULL),(1821,1,13,648,NULL,NULL),(1822,1,14,648,NULL,NULL),(1823,1,15,648,NULL,NULL),(1824,1,16,648,NULL,NULL),(1825,1,17,648,NULL,NULL),(1826,1,18,648,NULL,NULL),(1827,1,19,648,NULL,NULL),(1828,1,20,648,NULL,NULL),(1829,1,21,648,NULL,NULL),(1830,1,22,648,NULL,NULL),(1831,1,23,648,NULL,NULL),(1832,1,24,648,NULL,NULL),(1833,1,25,648,NULL,NULL),(1834,1,26,648,NULL,NULL),(1835,1,27,648,NULL,NULL),(1836,1,28,648,NULL,NULL),(1837,1,29,648,NULL,NULL),(1838,1,30,648,NULL,NULL),(1839,1,31,648,NULL,NULL),(1840,1,32,648,NULL,NULL),(1841,1,33,648,NULL,NULL),(1842,1,34,648,NULL,NULL),(1843,1,35,648,NULL,NULL),(1844,1,36,648,NULL,NULL),(1845,1,37,648,NULL,NULL),(1846,1,38,648,NULL,NULL),(1847,1,39,648,NULL,NULL),(1848,1,40,648,NULL,NULL),(1849,1,41,648,NULL,NULL),(1850,1,42,648,NULL,NULL),(1851,1,43,648,NULL,NULL),(1852,1,44,648,NULL,NULL),(1853,1,45,648,NULL,NULL),(1854,1,46,648,NULL,NULL),(1855,1,47,648,NULL,NULL),(1856,1,48,648,NULL,NULL),(1857,1,49,648,NULL,NULL),(1858,1,50,648,NULL,NULL),(1859,1,51,648,NULL,NULL),(1860,1,52,648,NULL,NULL),(1861,1,53,648,NULL,NULL),(1862,1,54,648,NULL,NULL),(1863,1,55,648,NULL,NULL),(1864,1,56,648,NULL,NULL),(1865,1,57,648,NULL,NULL),(1866,1,58,648,NULL,NULL),(1867,1,59,648,NULL,NULL),(1868,1,60,648,NULL,NULL),(1869,1,61,648,NULL,NULL),(1870,1,62,648,NULL,NULL),(1871,1,63,648,NULL,NULL),(1872,1,64,648,NULL,NULL),(1873,1,65,648,NULL,NULL),(1874,1,66,648,NULL,NULL),(1875,1,67,648,NULL,NULL),(1876,1,68,648,NULL,NULL),(1877,1,69,648,NULL,NULL),(1878,1,70,648,NULL,NULL),(1879,1,71,648,NULL,NULL),(1880,1,72,648,NULL,NULL),(1881,1,73,648,NULL,NULL),(1882,1,74,648,NULL,NULL),(1883,1,75,648,NULL,NULL),(1884,1,76,648,NULL,NULL),(1885,1,77,648,NULL,NULL),(1886,1,78,648,NULL,NULL),(1887,1,79,648,NULL,NULL),(1888,1,80,648,NULL,NULL),(1889,1,81,648,NULL,NULL),(1890,1,82,648,NULL,NULL),(1891,1,83,648,NULL,NULL),(1892,1,84,648,NULL,NULL),(1893,1,85,648,NULL,NULL),(1894,1,86,648,NULL,NULL),(1895,1,87,648,NULL,NULL),(1896,1,88,648,NULL,NULL),(1897,1,89,648,NULL,NULL),(1898,1,90,648,NULL,NULL),(1899,1,91,648,NULL,NULL),(1900,1,92,648,NULL,NULL),(1901,1,93,648,NULL,NULL),(1902,1,94,648,NULL,NULL),(1903,1,95,648,NULL,NULL),(1904,1,96,648,NULL,NULL),(1905,1,97,648,NULL,NULL),(1906,1,98,648,NULL,NULL),(1907,1,99,648,NULL,NULL),(1908,1,100,648,NULL,NULL),(1936,1,1,649,NULL,NULL),(1937,1,2,649,NULL,NULL),(1938,1,3,649,NULL,NULL),(1939,1,4,649,NULL,NULL),(1940,1,5,649,NULL,NULL),(1941,1,6,649,NULL,NULL),(1942,1,7,649,NULL,NULL),(1943,1,8,649,NULL,NULL),(1944,1,9,649,NULL,NULL),(1945,1,10,649,NULL,NULL),(1946,1,11,649,NULL,NULL),(1947,1,12,649,NULL,NULL),(1948,1,13,649,NULL,NULL),(1949,1,14,649,NULL,NULL),(1950,1,15,649,NULL,NULL),(1951,1,16,649,NULL,NULL),(1952,1,17,649,NULL,NULL),(1953,1,18,649,NULL,NULL),(1954,1,19,649,NULL,NULL),(1955,1,20,649,NULL,NULL),(1956,1,21,649,NULL,NULL),(1957,1,22,649,NULL,NULL),(1958,1,23,649,NULL,NULL),(1959,1,24,649,NULL,NULL),(1960,1,25,649,NULL,NULL),(1961,1,26,649,NULL,NULL),(1962,1,27,649,NULL,NULL),(1963,1,28,649,NULL,NULL),(1964,1,29,649,NULL,NULL),(1965,1,30,649,NULL,NULL),(1966,1,31,649,NULL,NULL),(1967,1,32,649,NULL,NULL),(1968,1,33,649,NULL,NULL),(1969,1,34,649,NULL,NULL),(1970,1,35,649,NULL,NULL),(1971,1,36,649,NULL,NULL),(1972,1,37,649,NULL,NULL),(1973,1,38,649,NULL,NULL),(1974,1,39,649,NULL,NULL),(1975,1,40,649,NULL,NULL),(1976,1,41,649,NULL,NULL),(1977,1,42,649,NULL,NULL),(1978,1,43,649,NULL,NULL),(1979,1,44,649,NULL,NULL),(1980,1,45,649,NULL,NULL),(1981,1,46,649,NULL,NULL),(1982,1,47,649,NULL,NULL),(1983,1,48,649,NULL,NULL),(1984,1,49,649,NULL,NULL),(1985,1,50,649,NULL,NULL),(1986,1,51,649,NULL,NULL),(1987,1,52,649,NULL,NULL),(1988,1,53,649,NULL,NULL),(1989,1,54,649,NULL,NULL),(1990,1,55,649,NULL,NULL),(1991,1,56,649,NULL,NULL),(1992,1,57,649,NULL,NULL),(1993,1,58,649,NULL,NULL),(1994,1,59,649,NULL,NULL),(1995,1,60,649,NULL,NULL),(1996,1,61,649,NULL,NULL),(1997,1,62,649,NULL,NULL),(1998,1,63,649,NULL,NULL),(1999,1,64,649,NULL,NULL),(2000,1,65,649,NULL,NULL),(2001,1,66,649,NULL,NULL),(2002,1,67,649,NULL,NULL),(2003,1,68,649,NULL,NULL),(2004,1,69,649,NULL,NULL),(2005,1,70,649,NULL,NULL),(2006,1,71,649,NULL,NULL),(2007,1,72,649,NULL,NULL),(2008,1,73,649,NULL,NULL),(2009,1,74,649,NULL,NULL),(2010,1,75,649,NULL,NULL),(2011,1,76,649,NULL,NULL),(2012,1,77,649,NULL,NULL),(2013,1,78,649,NULL,NULL),(2014,1,79,649,NULL,NULL),(2015,1,80,649,NULL,NULL),(2016,1,81,649,NULL,NULL),(2017,1,82,649,NULL,NULL),(2018,1,83,649,NULL,NULL),(2019,1,84,649,NULL,NULL),(2020,1,85,649,NULL,NULL),(2021,1,86,649,NULL,NULL),(2022,1,87,649,NULL,NULL),(2023,1,88,649,NULL,NULL),(2024,1,89,649,NULL,NULL),(2025,1,90,649,NULL,NULL),(2026,1,91,649,NULL,NULL),(2027,1,92,649,NULL,NULL),(2028,1,93,649,NULL,NULL),(2029,1,94,649,NULL,NULL),(2030,1,95,649,NULL,NULL),(2031,1,96,649,NULL,NULL),(2032,1,97,649,NULL,NULL),(2033,1,98,649,NULL,NULL),(2034,1,99,649,NULL,NULL),(2035,1,100,649,NULL,NULL),(2063,1,1,650,NULL,NULL),(2064,1,2,650,NULL,NULL),(2065,1,3,650,NULL,NULL),(2066,1,4,650,NULL,NULL),(2067,1,5,650,NULL,NULL),(2068,1,6,650,NULL,NULL),(2069,1,7,650,NULL,NULL),(2070,1,8,650,NULL,NULL),(2071,1,9,650,NULL,NULL),(2072,1,10,650,NULL,NULL),(2073,1,11,650,NULL,NULL),(2074,1,12,650,NULL,NULL),(2075,1,13,650,NULL,NULL),(2076,1,14,650,NULL,NULL),(2077,1,15,650,NULL,NULL),(2078,1,16,650,NULL,NULL),(2079,1,17,650,NULL,NULL),(2080,1,18,650,NULL,NULL),(2081,1,19,650,NULL,NULL),(2082,1,20,650,NULL,NULL),(2083,1,21,650,NULL,NULL),(2084,1,22,650,NULL,NULL),(2085,1,23,650,NULL,NULL),(2086,1,24,650,NULL,NULL),(2087,1,25,650,NULL,NULL),(2088,1,26,650,NULL,NULL),(2089,1,27,650,NULL,NULL),(2090,1,28,650,NULL,NULL),(2091,1,29,650,NULL,NULL),(2092,1,30,650,NULL,NULL),(2093,1,31,650,NULL,NULL),(2094,1,32,650,NULL,NULL),(2095,1,33,650,NULL,NULL),(2096,1,34,650,NULL,NULL),(2097,1,35,650,NULL,NULL),(2098,1,36,650,NULL,NULL),(2099,1,37,650,NULL,NULL),(2100,1,38,650,NULL,NULL),(2101,1,39,650,NULL,NULL),(2102,1,40,650,NULL,NULL),(2103,1,41,650,NULL,NULL),(2104,1,42,650,NULL,NULL),(2105,1,43,650,NULL,NULL),(2106,1,44,650,NULL,NULL),(2107,1,45,650,NULL,NULL),(2108,1,46,650,NULL,NULL),(2109,1,47,650,NULL,NULL),(2110,1,48,650,NULL,NULL),(2111,1,49,650,NULL,NULL),(2112,1,50,650,NULL,NULL),(2113,1,51,650,NULL,NULL),(2114,1,52,650,NULL,NULL),(2115,1,53,650,NULL,NULL),(2116,1,54,650,NULL,NULL),(2117,1,55,650,NULL,NULL),(2118,1,56,650,NULL,NULL),(2119,1,57,650,NULL,NULL),(2120,1,58,650,NULL,NULL),(2121,1,59,650,NULL,NULL),(2122,1,60,650,NULL,NULL),(2123,1,61,650,NULL,NULL),(2124,1,62,650,NULL,NULL),(2125,1,63,650,NULL,NULL),(2126,1,64,650,NULL,NULL),(2127,1,65,650,NULL,NULL),(2128,1,66,650,NULL,NULL),(2129,1,67,650,NULL,NULL),(2130,1,68,650,NULL,NULL),(2131,1,69,650,NULL,NULL),(2132,1,70,650,NULL,NULL),(2133,1,71,650,NULL,NULL),(2134,1,72,650,NULL,NULL),(2135,1,73,650,NULL,NULL),(2136,1,74,650,NULL,NULL),(2137,1,75,650,NULL,NULL),(2138,1,76,650,NULL,NULL),(2139,1,77,650,NULL,NULL),(2140,1,78,650,NULL,NULL),(2141,1,79,650,NULL,NULL),(2142,1,80,650,NULL,NULL),(2143,1,81,650,NULL,NULL),(2144,1,82,650,NULL,NULL),(2145,1,83,650,NULL,NULL),(2146,1,84,650,NULL,NULL),(2147,1,85,650,NULL,NULL),(2148,1,86,650,NULL,NULL),(2149,1,87,650,NULL,NULL),(2150,1,88,650,NULL,NULL),(2151,1,89,650,NULL,NULL),(2152,1,90,650,NULL,NULL),(2153,1,91,650,NULL,NULL),(2154,1,92,650,NULL,NULL),(2155,1,93,650,NULL,NULL),(2156,1,94,650,NULL,NULL),(2157,1,95,650,NULL,NULL),(2158,1,96,650,NULL,NULL),(2159,1,97,650,NULL,NULL),(2160,1,98,650,NULL,NULL),(2161,1,99,650,NULL,NULL),(2162,1,100,650,NULL,NULL),(2190,1,1,651,NULL,NULL),(2191,1,2,651,NULL,NULL),(2192,1,3,651,NULL,NULL),(2193,1,4,651,NULL,NULL),(2194,1,5,651,NULL,NULL),(2195,1,6,651,NULL,NULL),(2196,1,7,651,NULL,NULL),(2197,1,8,651,NULL,NULL),(2198,1,9,651,NULL,NULL),(2199,1,10,651,NULL,NULL),(2200,1,11,651,NULL,NULL),(2201,1,12,651,NULL,NULL),(2202,1,13,651,NULL,NULL),(2203,1,14,651,NULL,NULL),(2204,1,15,651,NULL,NULL),(2205,1,16,651,NULL,NULL),(2206,1,17,651,NULL,NULL),(2207,1,18,651,NULL,NULL),(2208,1,19,651,NULL,NULL),(2209,1,20,651,NULL,NULL),(2210,1,21,651,NULL,NULL),(2211,1,22,651,NULL,NULL),(2212,1,23,651,NULL,NULL),(2213,1,24,651,NULL,NULL),(2214,1,25,651,NULL,NULL),(2215,1,26,651,NULL,NULL),(2216,1,27,651,NULL,NULL),(2217,1,28,651,NULL,NULL),(2218,1,29,651,NULL,NULL),(2219,1,30,651,NULL,NULL),(2220,1,31,651,NULL,NULL),(2221,1,32,651,NULL,NULL),(2222,1,33,651,NULL,NULL),(2223,1,34,651,NULL,NULL),(2224,1,35,651,NULL,NULL),(2225,1,36,651,NULL,NULL),(2226,1,37,651,NULL,NULL),(2227,1,38,651,NULL,NULL),(2228,1,39,651,NULL,NULL),(2229,1,40,651,NULL,NULL),(2230,1,41,651,NULL,NULL),(2231,1,42,651,NULL,NULL),(2232,1,43,651,NULL,NULL),(2233,1,44,651,NULL,NULL),(2234,1,45,651,NULL,NULL),(2235,1,46,651,NULL,NULL),(2236,1,47,651,NULL,NULL),(2237,1,48,651,NULL,NULL),(2238,1,49,651,NULL,NULL),(2239,1,50,651,NULL,NULL),(2240,1,51,651,NULL,NULL),(2241,1,52,651,NULL,NULL),(2242,1,53,651,NULL,NULL),(2243,1,54,651,NULL,NULL),(2244,1,55,651,NULL,NULL),(2245,1,56,651,NULL,NULL),(2246,1,57,651,NULL,NULL),(2247,1,58,651,NULL,NULL),(2248,1,59,651,NULL,NULL),(2249,1,60,651,NULL,NULL),(2250,1,61,651,NULL,NULL),(2251,1,62,651,NULL,NULL),(2252,1,63,651,NULL,NULL),(2253,1,64,651,NULL,NULL),(2254,1,65,651,NULL,NULL),(2255,1,66,651,NULL,NULL),(2256,1,67,651,NULL,NULL),(2257,1,68,651,NULL,NULL),(2258,1,69,651,NULL,NULL),(2259,1,70,651,NULL,NULL),(2260,1,71,651,NULL,NULL),(2261,1,72,651,NULL,NULL),(2262,1,73,651,NULL,NULL),(2263,1,74,651,NULL,NULL),(2264,1,75,651,NULL,NULL),(2265,1,76,651,NULL,NULL),(2266,1,77,651,NULL,NULL),(2267,1,78,651,NULL,NULL),(2268,1,79,651,NULL,NULL),(2269,1,80,651,NULL,NULL),(2270,1,81,651,NULL,NULL),(2271,1,82,651,NULL,NULL),(2272,1,83,651,NULL,NULL),(2273,1,84,651,NULL,NULL),(2274,1,85,651,NULL,NULL),(2275,1,86,651,NULL,NULL),(2276,1,87,651,NULL,NULL),(2277,1,88,651,NULL,NULL),(2278,1,89,651,NULL,NULL),(2279,1,90,651,NULL,NULL),(2280,1,91,651,NULL,NULL),(2281,1,92,651,NULL,NULL),(2282,1,93,651,NULL,NULL),(2283,1,94,651,NULL,NULL),(2284,1,95,651,NULL,NULL),(2285,1,96,651,NULL,NULL),(2286,1,97,651,NULL,NULL),(2287,1,98,651,NULL,NULL),(2288,1,99,651,NULL,NULL),(2289,1,100,651,NULL,NULL),(2317,1,1,652,NULL,NULL),(2318,1,2,652,NULL,NULL),(2319,1,3,652,NULL,NULL),(2320,1,4,652,NULL,NULL),(2321,1,5,652,NULL,NULL),(2322,1,6,652,NULL,NULL),(2323,1,7,652,NULL,NULL),(2324,1,8,652,NULL,NULL),(2325,1,9,652,NULL,NULL),(2326,1,10,652,NULL,NULL),(2327,1,11,652,NULL,NULL),(2328,1,12,652,NULL,NULL),(2329,1,13,652,NULL,NULL),(2330,1,14,652,NULL,NULL),(2331,1,15,652,NULL,NULL),(2332,1,16,652,NULL,NULL),(2333,1,17,652,NULL,NULL),(2334,1,18,652,NULL,NULL),(2335,1,19,652,NULL,NULL),(2336,1,20,652,NULL,NULL),(2337,1,21,652,NULL,NULL),(2338,1,22,652,NULL,NULL),(2339,1,23,652,NULL,NULL),(2340,1,24,652,NULL,NULL),(2341,1,25,652,NULL,NULL),(2342,1,26,652,NULL,NULL),(2343,1,27,652,NULL,NULL),(2344,1,28,652,NULL,NULL),(2345,1,29,652,NULL,NULL),(2346,1,30,652,NULL,NULL),(2347,1,31,652,NULL,NULL),(2348,1,32,652,NULL,NULL),(2349,1,33,652,NULL,NULL),(2350,1,34,652,NULL,NULL),(2351,1,35,652,NULL,NULL),(2352,1,36,652,NULL,NULL),(2353,1,37,652,NULL,NULL),(2354,1,38,652,NULL,NULL),(2355,1,39,652,NULL,NULL),(2356,1,40,652,NULL,NULL),(2357,1,41,652,NULL,NULL),(2358,1,42,652,NULL,NULL),(2359,1,43,652,NULL,NULL),(2360,1,44,652,NULL,NULL),(2361,1,45,652,NULL,NULL),(2362,1,46,652,NULL,NULL),(2363,1,47,652,NULL,NULL),(2364,1,48,652,NULL,NULL),(2365,1,49,652,NULL,NULL),(2366,1,50,652,NULL,NULL),(2367,1,51,652,NULL,NULL),(2368,1,52,652,NULL,NULL),(2369,1,53,652,NULL,NULL),(2370,1,54,652,NULL,NULL),(2371,1,55,652,NULL,NULL),(2372,1,56,652,NULL,NULL),(2373,1,57,652,NULL,NULL),(2374,1,58,652,NULL,NULL),(2375,1,59,652,NULL,NULL),(2376,1,60,652,NULL,NULL),(2377,1,61,652,NULL,NULL),(2378,1,62,652,NULL,NULL),(2379,1,63,652,NULL,NULL),(2380,1,64,652,NULL,NULL),(2381,1,65,652,NULL,NULL),(2382,1,66,652,NULL,NULL),(2383,1,67,652,NULL,NULL),(2384,1,68,652,NULL,NULL),(2385,1,69,652,NULL,NULL),(2386,1,70,652,NULL,NULL),(2387,1,71,652,NULL,NULL),(2388,1,72,652,NULL,NULL),(2389,1,73,652,NULL,NULL),(2390,1,74,652,NULL,NULL),(2391,1,75,652,NULL,NULL),(2392,1,76,652,NULL,NULL),(2393,1,77,652,NULL,NULL),(2394,1,78,652,NULL,NULL),(2395,1,79,652,NULL,NULL),(2396,1,80,652,NULL,NULL),(2397,1,81,652,NULL,NULL),(2398,1,82,652,NULL,NULL),(2399,1,83,652,NULL,NULL),(2400,1,84,652,NULL,NULL),(2401,1,85,652,NULL,NULL),(2402,1,86,652,NULL,NULL),(2403,1,87,652,NULL,NULL),(2404,1,88,652,NULL,NULL),(2405,1,89,652,NULL,NULL),(2406,1,90,652,NULL,NULL),(2407,1,91,652,NULL,NULL),(2408,1,92,652,NULL,NULL),(2409,1,93,652,NULL,NULL),(2410,1,94,652,NULL,NULL),(2411,1,95,652,NULL,NULL),(2412,1,96,652,NULL,NULL),(2413,1,97,652,NULL,NULL),(2414,1,98,652,NULL,NULL),(2415,1,99,652,NULL,NULL),(2416,1,100,652,NULL,NULL),(2444,1,1,653,NULL,NULL),(2445,1,2,653,NULL,NULL),(2446,1,3,653,NULL,NULL),(2447,1,4,653,NULL,NULL),(2448,1,5,653,NULL,NULL),(2449,1,6,653,NULL,NULL),(2450,1,7,653,NULL,NULL),(2451,1,8,653,NULL,NULL),(2452,1,9,653,NULL,NULL),(2453,1,10,653,NULL,NULL),(2454,1,11,653,NULL,NULL),(2455,1,12,653,NULL,NULL),(2456,1,13,653,NULL,NULL),(2457,1,14,653,NULL,NULL),(2458,1,15,653,NULL,NULL),(2459,1,16,653,NULL,NULL),(2460,1,17,653,NULL,NULL),(2461,1,18,653,NULL,NULL),(2462,1,19,653,NULL,NULL),(2463,1,20,653,NULL,NULL),(2464,1,21,653,NULL,NULL),(2465,1,22,653,NULL,NULL),(2466,1,23,653,NULL,NULL),(2467,1,24,653,NULL,NULL),(2468,1,25,653,NULL,NULL),(2469,1,26,653,NULL,NULL),(2470,1,27,653,NULL,NULL),(2471,1,28,653,NULL,NULL),(2472,1,29,653,NULL,NULL),(2473,1,30,653,NULL,NULL),(2474,1,31,653,NULL,NULL),(2475,1,32,653,NULL,NULL),(2476,1,33,653,NULL,NULL),(2477,1,34,653,NULL,NULL),(2478,1,35,653,NULL,NULL),(2479,1,36,653,NULL,NULL),(2480,1,37,653,NULL,NULL),(2481,1,38,653,NULL,NULL),(2482,1,39,653,NULL,NULL),(2483,1,40,653,NULL,NULL),(2484,1,41,653,NULL,NULL),(2485,1,42,653,NULL,NULL),(2486,1,43,653,NULL,NULL),(2487,1,44,653,NULL,NULL),(2488,1,45,653,NULL,NULL),(2489,1,46,653,NULL,NULL),(2490,1,47,653,NULL,NULL),(2491,1,48,653,NULL,NULL),(2492,1,49,653,NULL,NULL),(2493,1,50,653,NULL,NULL),(2494,1,51,653,NULL,NULL),(2495,1,52,653,NULL,NULL),(2496,1,53,653,NULL,NULL),(2497,1,54,653,NULL,NULL),(2498,1,55,653,NULL,NULL),(2499,1,56,653,NULL,NULL),(2500,1,57,653,NULL,NULL),(2501,1,58,653,NULL,NULL),(2502,1,59,653,NULL,NULL),(2503,1,60,653,NULL,NULL),(2504,1,61,653,NULL,NULL),(2505,1,62,653,NULL,NULL),(2506,1,63,653,NULL,NULL),(2507,1,64,653,NULL,NULL),(2508,1,65,653,NULL,NULL),(2509,1,66,653,NULL,NULL),(2510,1,67,653,NULL,NULL),(2511,1,68,653,NULL,NULL),(2512,1,69,653,NULL,NULL),(2513,1,70,653,NULL,NULL),(2514,1,71,653,NULL,NULL),(2515,1,72,653,NULL,NULL),(2516,1,73,653,NULL,NULL),(2517,1,74,653,NULL,NULL),(2518,1,75,653,NULL,NULL),(2519,1,76,653,NULL,NULL),(2520,1,77,653,NULL,NULL),(2521,1,78,653,NULL,NULL),(2522,1,79,653,NULL,NULL),(2523,1,80,653,NULL,NULL),(2524,1,81,653,NULL,NULL),(2525,1,82,653,NULL,NULL),(2526,1,83,653,NULL,NULL),(2527,1,84,653,NULL,NULL),(2528,1,85,653,NULL,NULL),(2529,1,86,653,NULL,NULL),(2530,1,87,653,NULL,NULL),(2531,1,88,653,NULL,NULL),(2532,1,89,653,NULL,NULL),(2533,1,90,653,NULL,NULL),(2534,1,91,653,NULL,NULL),(2535,1,92,653,NULL,NULL),(2536,1,93,653,NULL,NULL),(2537,1,94,653,NULL,NULL),(2538,1,95,653,NULL,NULL),(2539,1,96,653,NULL,NULL),(2540,1,97,653,NULL,NULL),(2541,1,98,653,NULL,NULL),(2542,1,99,653,NULL,NULL),(2543,1,100,653,NULL,NULL),(2571,1,1,654,NULL,NULL),(2572,1,2,654,NULL,NULL),(2573,1,3,654,NULL,NULL),(2574,1,4,654,NULL,NULL),(2575,1,5,654,NULL,NULL),(2576,1,6,654,NULL,NULL),(2577,1,7,654,NULL,NULL),(2578,1,8,654,NULL,NULL),(2579,1,9,654,NULL,NULL),(2580,1,10,654,NULL,NULL),(2581,1,11,654,NULL,NULL),(2582,1,12,654,NULL,NULL),(2583,1,13,654,NULL,NULL),(2584,1,14,654,NULL,NULL),(2585,1,15,654,NULL,NULL),(2586,1,16,654,NULL,NULL),(2587,1,17,654,NULL,NULL),(2588,1,18,654,NULL,NULL),(2589,1,19,654,NULL,NULL),(2590,1,20,654,NULL,NULL),(2591,1,21,654,NULL,NULL),(2592,1,22,654,NULL,NULL),(2593,1,23,654,NULL,NULL),(2594,1,24,654,NULL,NULL),(2595,1,25,654,NULL,NULL),(2596,1,26,654,NULL,NULL),(2597,1,27,654,NULL,NULL),(2598,1,28,654,NULL,NULL),(2599,1,29,654,NULL,NULL),(2600,1,30,654,NULL,NULL),(2601,1,31,654,NULL,NULL),(2602,1,32,654,NULL,NULL),(2603,1,33,654,NULL,NULL),(2604,1,34,654,NULL,NULL),(2605,1,35,654,NULL,NULL),(2606,1,36,654,NULL,NULL),(2607,1,37,654,NULL,NULL),(2608,1,38,654,NULL,NULL),(2609,1,39,654,NULL,NULL),(2610,1,40,654,NULL,NULL),(2611,1,41,654,NULL,NULL),(2612,1,42,654,NULL,NULL),(2613,1,43,654,NULL,NULL),(2614,1,44,654,NULL,NULL),(2615,1,45,654,NULL,NULL),(2616,1,46,654,NULL,NULL),(2617,1,47,654,NULL,NULL),(2618,1,48,654,NULL,NULL),(2619,1,49,654,NULL,NULL),(2620,1,50,654,NULL,NULL),(2621,1,51,654,NULL,NULL),(2622,1,52,654,NULL,NULL),(2623,1,53,654,NULL,NULL),(2624,1,54,654,NULL,NULL),(2625,1,55,654,NULL,NULL),(2626,1,56,654,NULL,NULL),(2627,1,57,654,NULL,NULL),(2628,1,58,654,NULL,NULL),(2629,1,59,654,NULL,NULL),(2630,1,60,654,NULL,NULL),(2631,1,61,654,NULL,NULL),(2632,1,62,654,NULL,NULL),(2633,1,63,654,NULL,NULL),(2634,1,64,654,NULL,NULL),(2635,1,65,654,NULL,NULL),(2636,1,66,654,NULL,NULL),(2637,1,67,654,NULL,NULL),(2638,1,68,654,NULL,NULL),(2639,1,69,654,NULL,NULL),(2640,1,70,654,NULL,NULL),(2641,1,71,654,NULL,NULL),(2642,1,72,654,NULL,NULL),(2643,1,73,654,NULL,NULL),(2644,1,74,654,NULL,NULL),(2645,1,75,654,NULL,NULL),(2646,1,76,654,NULL,NULL),(2647,1,77,654,NULL,NULL),(2648,1,78,654,NULL,NULL),(2649,1,79,654,NULL,NULL),(2650,1,80,654,NULL,NULL),(2651,1,81,654,NULL,NULL),(2652,1,82,654,NULL,NULL),(2653,1,83,654,NULL,NULL),(2654,1,84,654,NULL,NULL),(2655,1,85,654,NULL,NULL),(2656,1,86,654,NULL,NULL),(2657,1,87,654,NULL,NULL),(2658,1,88,654,NULL,NULL),(2659,1,89,654,NULL,NULL),(2660,1,90,654,NULL,NULL),(2661,1,91,654,NULL,NULL),(2662,1,92,654,NULL,NULL),(2663,1,93,654,NULL,NULL),(2664,1,94,654,NULL,NULL),(2665,1,95,654,NULL,NULL),(2666,1,96,654,NULL,NULL),(2667,1,97,654,NULL,NULL),(2668,1,98,654,NULL,NULL),(2669,1,99,654,NULL,NULL),(2670,1,100,654,NULL,NULL),(2698,1,1,655,NULL,NULL),(2699,1,2,655,NULL,NULL),(2700,1,3,655,NULL,NULL),(2701,1,4,655,NULL,NULL),(2702,1,5,655,NULL,NULL),(2703,1,6,655,NULL,NULL),(2704,1,7,655,NULL,NULL),(2705,1,8,655,NULL,NULL),(2706,1,9,655,NULL,NULL),(2707,1,10,655,NULL,NULL),(2708,1,11,655,NULL,NULL),(2709,1,12,655,NULL,NULL),(2710,1,13,655,NULL,NULL),(2711,1,14,655,NULL,NULL),(2712,1,15,655,NULL,NULL),(2713,1,16,655,NULL,NULL),(2714,1,17,655,NULL,NULL),(2715,1,18,655,NULL,NULL),(2716,1,19,655,NULL,NULL),(2717,1,20,655,NULL,NULL),(2718,1,21,655,NULL,NULL),(2719,1,22,655,NULL,NULL),(2720,1,23,655,NULL,NULL),(2721,1,24,655,NULL,NULL),(2722,1,25,655,NULL,NULL),(2723,1,26,655,NULL,NULL),(2724,1,27,655,NULL,NULL),(2725,1,28,655,NULL,NULL),(2726,1,29,655,NULL,NULL),(2727,1,30,655,NULL,NULL),(2728,1,31,655,NULL,NULL),(2729,1,32,655,NULL,NULL),(2730,1,33,655,NULL,NULL),(2731,1,34,655,NULL,NULL),(2732,1,35,655,NULL,NULL),(2733,1,36,655,NULL,NULL),(2734,1,37,655,NULL,NULL),(2735,1,38,655,NULL,NULL),(2736,1,39,655,NULL,NULL),(2737,1,40,655,NULL,NULL),(2738,1,41,655,NULL,NULL),(2739,1,42,655,NULL,NULL),(2740,1,43,655,NULL,NULL),(2741,1,44,655,NULL,NULL),(2742,1,45,655,NULL,NULL),(2743,1,46,655,NULL,NULL),(2744,1,47,655,NULL,NULL),(2745,1,48,655,NULL,NULL),(2746,1,49,655,NULL,NULL),(2747,1,50,655,NULL,NULL),(2748,1,51,655,NULL,NULL),(2749,1,52,655,NULL,NULL),(2750,1,53,655,NULL,NULL),(2751,1,54,655,NULL,NULL),(2752,1,55,655,NULL,NULL),(2753,1,56,655,NULL,NULL),(2754,1,57,655,NULL,NULL),(2755,1,58,655,NULL,NULL),(2756,1,59,655,NULL,NULL),(2757,1,60,655,NULL,NULL),(2758,1,61,655,NULL,NULL),(2759,1,62,655,NULL,NULL),(2760,1,63,655,NULL,NULL),(2761,1,64,655,NULL,NULL),(2762,1,65,655,NULL,NULL),(2763,1,66,655,NULL,NULL),(2764,1,67,655,NULL,NULL),(2765,1,68,655,NULL,NULL),(2766,1,69,655,NULL,NULL),(2767,1,70,655,NULL,NULL),(2768,1,71,655,NULL,NULL),(2769,1,72,655,NULL,NULL),(2770,1,73,655,NULL,NULL),(2771,1,74,655,NULL,NULL),(2772,1,75,655,NULL,NULL),(2773,1,76,655,NULL,NULL),(2774,1,77,655,NULL,NULL),(2775,1,78,655,NULL,NULL),(2776,1,79,655,NULL,NULL),(2777,1,80,655,NULL,NULL),(2778,1,81,655,NULL,NULL),(2779,1,82,655,NULL,NULL),(2780,1,83,655,NULL,NULL),(2781,1,84,655,NULL,NULL),(2782,1,85,655,NULL,NULL),(2783,1,86,655,NULL,NULL),(2784,1,87,655,NULL,NULL),(2785,1,88,655,NULL,NULL),(2786,1,89,655,NULL,NULL),(2787,1,90,655,NULL,NULL),(2788,1,91,655,NULL,NULL),(2789,1,92,655,NULL,NULL),(2790,1,93,655,NULL,NULL),(2791,1,94,655,NULL,NULL),(2792,1,95,655,NULL,NULL),(2793,1,96,655,NULL,NULL),(2794,1,97,655,NULL,NULL),(2795,1,98,655,NULL,NULL),(2796,1,99,655,NULL,NULL),(2797,1,100,655,NULL,NULL),(2825,1,1,656,NULL,NULL),(2826,1,2,656,NULL,NULL),(2827,1,3,656,NULL,NULL),(2828,1,4,656,NULL,NULL),(2829,1,5,656,NULL,NULL),(2830,1,6,656,NULL,NULL),(2831,1,7,656,NULL,NULL),(2832,1,8,656,NULL,NULL),(2833,1,9,656,NULL,NULL),(2834,1,10,656,NULL,NULL),(2835,1,11,656,NULL,NULL),(2836,1,12,656,NULL,NULL),(2837,1,13,656,NULL,NULL),(2838,1,14,656,NULL,NULL),(2839,1,15,656,NULL,NULL),(2840,1,16,656,NULL,NULL),(2841,1,17,656,NULL,NULL),(2842,1,18,656,NULL,NULL),(2843,1,19,656,NULL,NULL),(2844,1,20,656,NULL,NULL),(2845,1,21,656,NULL,NULL),(2846,1,22,656,NULL,NULL),(2847,1,23,656,NULL,NULL),(2848,1,24,656,NULL,NULL),(2849,1,25,656,NULL,NULL),(2850,1,26,656,NULL,NULL),(2851,1,27,656,NULL,NULL),(2852,1,28,656,NULL,NULL),(2853,1,29,656,NULL,NULL),(2854,1,30,656,NULL,NULL),(2855,1,31,656,NULL,NULL),(2856,1,32,656,NULL,NULL),(2857,1,33,656,NULL,NULL),(2858,1,34,656,NULL,NULL),(2859,1,35,656,NULL,NULL),(2860,1,36,656,NULL,NULL),(2861,1,37,656,NULL,NULL),(2862,1,38,656,NULL,NULL),(2863,1,39,656,NULL,NULL),(2864,1,40,656,NULL,NULL),(2865,1,41,656,NULL,NULL),(2866,1,42,656,NULL,NULL),(2867,1,43,656,NULL,NULL),(2868,1,44,656,NULL,NULL),(2869,1,45,656,NULL,NULL),(2870,1,46,656,NULL,NULL),(2871,1,47,656,NULL,NULL),(2872,1,48,656,NULL,NULL),(2873,1,49,656,NULL,NULL),(2874,1,50,656,NULL,NULL),(2875,1,51,656,NULL,NULL),(2876,1,52,656,NULL,NULL),(2877,1,53,656,NULL,NULL),(2878,1,54,656,NULL,NULL),(2879,1,55,656,NULL,NULL),(2880,1,56,656,NULL,NULL),(2881,1,57,656,NULL,NULL),(2882,1,58,656,NULL,NULL),(2883,1,59,656,NULL,NULL),(2884,1,60,656,NULL,NULL),(2885,1,61,656,NULL,NULL),(2886,1,62,656,NULL,NULL),(2887,1,63,656,NULL,NULL),(2888,1,64,656,NULL,NULL),(2889,1,65,656,NULL,NULL),(2890,1,66,656,NULL,NULL),(2891,1,67,656,NULL,NULL),(2892,1,68,656,NULL,NULL),(2893,1,69,656,NULL,NULL),(2894,1,70,656,NULL,NULL),(2895,1,71,656,NULL,NULL),(2896,1,72,656,NULL,NULL),(2897,1,73,656,NULL,NULL),(2898,1,74,656,NULL,NULL),(2899,1,75,656,NULL,NULL),(2900,1,76,656,NULL,NULL),(2901,1,77,656,NULL,NULL),(2902,1,78,656,NULL,NULL),(2903,1,79,656,NULL,NULL),(2904,1,80,656,NULL,NULL),(2905,1,81,656,NULL,NULL),(2906,1,82,656,NULL,NULL),(2907,1,83,656,NULL,NULL),(2908,1,84,656,NULL,NULL),(2909,1,85,656,NULL,NULL),(2910,1,86,656,NULL,NULL),(2911,1,87,656,NULL,NULL),(2912,1,88,656,NULL,NULL),(2913,1,89,656,NULL,NULL),(2914,1,90,656,NULL,NULL),(2915,1,91,656,NULL,NULL),(2916,1,92,656,NULL,NULL),(2917,1,93,656,NULL,NULL),(2918,1,94,656,NULL,NULL),(2919,1,95,656,NULL,NULL),(2920,1,96,656,NULL,NULL),(2921,1,97,656,NULL,NULL),(2922,1,98,656,NULL,NULL),(2923,1,99,656,NULL,NULL),(2924,1,100,656,NULL,NULL),(2952,1,1,657,NULL,NULL),(2953,1,2,657,NULL,NULL),(2954,1,3,657,NULL,NULL),(2955,1,4,657,NULL,NULL),(2956,1,5,657,NULL,NULL),(2957,1,6,657,NULL,NULL),(2958,1,7,657,NULL,NULL),(2959,1,8,657,NULL,NULL),(2960,1,9,657,NULL,NULL),(2961,1,10,657,NULL,NULL),(2962,1,11,657,NULL,NULL),(2963,1,12,657,NULL,NULL),(2964,1,13,657,NULL,NULL),(2965,1,14,657,NULL,NULL),(2966,1,15,657,NULL,NULL),(2967,1,16,657,NULL,NULL),(2968,1,17,657,NULL,NULL),(2969,1,18,657,NULL,NULL),(2970,1,19,657,NULL,NULL),(2971,1,20,657,NULL,NULL),(2972,1,21,657,NULL,NULL),(2973,1,22,657,NULL,NULL),(2974,1,23,657,NULL,NULL),(2975,1,24,657,NULL,NULL),(2976,1,25,657,NULL,NULL),(2977,1,26,657,NULL,NULL),(2978,1,27,657,NULL,NULL),(2979,1,28,657,NULL,NULL),(2980,1,29,657,NULL,NULL),(2981,1,30,657,NULL,NULL),(2982,1,31,657,NULL,NULL),(2983,1,32,657,NULL,NULL),(2984,1,33,657,NULL,NULL),(2985,1,34,657,NULL,NULL),(2986,1,35,657,NULL,NULL),(2987,1,36,657,NULL,NULL),(2988,1,37,657,NULL,NULL),(2989,1,38,657,NULL,NULL),(2990,1,39,657,NULL,NULL),(2991,1,40,657,NULL,NULL),(2992,1,41,657,NULL,NULL),(2993,1,42,657,NULL,NULL),(2994,1,43,657,NULL,NULL),(2995,1,44,657,NULL,NULL),(2996,1,45,657,NULL,NULL),(2997,1,46,657,NULL,NULL),(2998,1,47,657,NULL,NULL),(2999,1,48,657,NULL,NULL),(3000,1,49,657,NULL,NULL),(3001,1,50,657,NULL,NULL),(3002,1,51,657,NULL,NULL),(3003,1,52,657,NULL,NULL),(3004,1,53,657,NULL,NULL),(3005,1,54,657,NULL,NULL),(3006,1,55,657,NULL,NULL),(3007,1,56,657,NULL,NULL),(3008,1,57,657,NULL,NULL),(3009,1,58,657,NULL,NULL),(3010,1,59,657,NULL,NULL),(3011,1,60,657,NULL,NULL),(3012,1,61,657,NULL,NULL),(3013,1,62,657,NULL,NULL),(3014,1,63,657,NULL,NULL),(3015,1,64,657,NULL,NULL),(3016,1,65,657,NULL,NULL),(3017,1,66,657,NULL,NULL),(3018,1,67,657,NULL,NULL),(3019,1,68,657,NULL,NULL),(3020,1,69,657,NULL,NULL),(3021,1,70,657,NULL,NULL),(3022,1,71,657,NULL,NULL),(3023,1,72,657,NULL,NULL),(3024,1,73,657,NULL,NULL),(3025,1,74,657,NULL,NULL),(3026,1,75,657,NULL,NULL),(3027,1,76,657,NULL,NULL),(3028,1,77,657,NULL,NULL),(3029,1,78,657,NULL,NULL),(3030,1,79,657,NULL,NULL),(3031,1,80,657,NULL,NULL),(3032,1,81,657,NULL,NULL),(3033,1,82,657,NULL,NULL),(3034,1,83,657,NULL,NULL),(3035,1,84,657,NULL,NULL),(3036,1,85,657,NULL,NULL),(3037,1,86,657,NULL,NULL),(3038,1,87,657,NULL,NULL),(3039,1,88,657,NULL,NULL),(3040,1,89,657,NULL,NULL),(3041,1,90,657,NULL,NULL),(3042,1,91,657,NULL,NULL),(3043,1,92,657,NULL,NULL),(3044,1,93,657,NULL,NULL),(3045,1,94,657,NULL,NULL),(3046,1,95,657,NULL,NULL),(3047,1,96,657,NULL,NULL),(3048,1,97,657,NULL,NULL),(3049,1,98,657,NULL,NULL),(3050,1,99,657,NULL,NULL),(3051,1,100,657,NULL,NULL),(3079,1,1,658,NULL,NULL),(3080,1,2,658,NULL,NULL),(3081,1,3,658,NULL,NULL),(3082,1,4,658,NULL,NULL),(3083,1,5,658,NULL,NULL),(3084,1,6,658,NULL,NULL),(3085,1,7,658,NULL,NULL),(3086,1,8,658,NULL,NULL),(3087,1,9,658,NULL,NULL),(3088,1,10,658,NULL,NULL),(3089,1,11,658,NULL,NULL),(3090,1,12,658,NULL,NULL),(3091,1,13,658,NULL,NULL),(3092,1,14,658,NULL,NULL),(3093,1,15,658,NULL,NULL),(3094,1,16,658,NULL,NULL),(3095,1,17,658,NULL,NULL),(3096,1,18,658,NULL,NULL),(3097,1,19,658,NULL,NULL),(3098,1,20,658,NULL,NULL),(3099,1,21,658,NULL,NULL),(3100,1,22,658,NULL,NULL),(3101,1,23,658,NULL,NULL),(3102,1,24,658,NULL,NULL),(3103,1,25,658,NULL,NULL),(3104,1,26,658,NULL,NULL),(3105,1,27,658,NULL,NULL),(3106,1,28,658,NULL,NULL),(3107,1,29,658,NULL,NULL),(3108,1,30,658,NULL,NULL),(3109,1,31,658,NULL,NULL),(3110,1,32,658,NULL,NULL),(3111,1,33,658,NULL,NULL),(3112,1,34,658,NULL,NULL),(3113,1,35,658,NULL,NULL),(3114,1,36,658,NULL,NULL),(3115,1,37,658,NULL,NULL),(3116,1,38,658,NULL,NULL),(3117,1,39,658,NULL,NULL),(3118,1,40,658,NULL,NULL),(3119,1,41,658,NULL,NULL),(3120,1,42,658,NULL,NULL),(3121,1,43,658,NULL,NULL),(3122,1,44,658,NULL,NULL),(3123,1,45,658,NULL,NULL),(3124,1,46,658,NULL,NULL),(3125,1,47,658,NULL,NULL),(3126,1,48,658,NULL,NULL),(3127,1,49,658,NULL,NULL),(3128,1,50,658,NULL,NULL),(3129,1,51,658,NULL,NULL),(3130,1,52,658,NULL,NULL),(3131,1,53,658,NULL,NULL),(3132,1,54,658,NULL,NULL),(3133,1,55,658,NULL,NULL),(3134,1,56,658,NULL,NULL),(3135,1,57,658,NULL,NULL),(3136,1,58,658,NULL,NULL),(3137,1,59,658,NULL,NULL),(3138,1,60,658,NULL,NULL),(3139,1,61,658,NULL,NULL),(3140,1,62,658,NULL,NULL),(3141,1,63,658,NULL,NULL),(3142,1,64,658,NULL,NULL),(3143,1,65,658,NULL,NULL),(3144,1,66,658,NULL,NULL),(3145,1,67,658,NULL,NULL),(3146,1,68,658,NULL,NULL),(3147,1,69,658,NULL,NULL),(3148,1,70,658,NULL,NULL),(3149,1,71,658,NULL,NULL),(3150,1,72,658,NULL,NULL),(3151,1,73,658,NULL,NULL),(3152,1,74,658,NULL,NULL),(3153,1,75,658,NULL,NULL),(3154,1,76,658,NULL,NULL),(3155,1,77,658,NULL,NULL),(3156,1,78,658,NULL,NULL),(3157,1,79,658,NULL,NULL),(3158,1,80,658,NULL,NULL),(3159,1,81,658,NULL,NULL),(3160,1,82,658,NULL,NULL),(3161,1,83,658,NULL,NULL),(3162,1,84,658,NULL,NULL),(3163,1,85,658,NULL,NULL),(3164,1,86,658,NULL,NULL),(3165,1,87,658,NULL,NULL),(3166,1,88,658,NULL,NULL),(3167,1,89,658,NULL,NULL),(3168,1,90,658,NULL,NULL),(3169,1,91,658,NULL,NULL),(3170,1,92,658,NULL,NULL),(3171,1,93,658,NULL,NULL),(3172,1,94,658,NULL,NULL),(3173,1,95,658,NULL,NULL),(3174,1,96,658,NULL,NULL),(3175,1,97,658,NULL,NULL),(3176,1,98,658,NULL,NULL),(3177,1,99,658,NULL,NULL),(3178,1,100,658,NULL,NULL);
/*!40000 ALTER TABLE `showtime_seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `status_id` int unsigned NOT NULL AUTO_INCREMENT,
  `status_name` enum('available','holding','booked') NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,'available'),(2,'holding'),(3,'booked');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `fullname` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `email_address` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `coin` int unsigned DEFAULT '0',
  `role` enum('admin','customer') NOT NULL DEFAULT 'customer',
  `otp` varchar(10) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email_address` (`email_address`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (2,NULL,NULL,NULL,'hihihi@gmail.com',NULL,NULL,'hihihi','$2a$10$XJlOxCyntk8iIv6zvEzS6uFm9ayUVdXPMn.G6PJG7l.LWXxruHcZW',0,'customer',NULL,NULL),(3,NULL,NULL,NULL,'khanhbeo@gmail.com',NULL,NULL,'khanhbeo','$2a$10$kNkp0QhXGKGvlzFJ2eZSM.DhSyXOQrUE5zLTE3AYD9FKpi7ye6x8.',0,'customer',NULL,NULL),(4,NULL,NULL,NULL,'thanggay@gmail.com',NULL,NULL,'thanggay','$2a$10$UTEdpfFf5RoIB7O5i.bH3eNcVlbxndw/2Yj3.dOFw3PoUwl4wVIKy',0,'customer',NULL,NULL),(5,NULL,NULL,NULL,'quyencon@gmail.com',NULL,NULL,'quyencon','$2a$10$H.5kYp7EvapHsyY0kvaD.O/tO0hYTQPgokiluAf6QGZ9.UH7EicL2',0,'customer',NULL,NULL),(6,NULL,NULL,NULL,'bimbim@gmail.com',NULL,NULL,'bimbim','$2a$10$2ONtYHEB8n4uLXhOg.yjNu1ht1PdPBNIVf6Me5LqGHIunEkNHAM2a',0,'customer',NULL,NULL),(7,NULL,NULL,NULL,'lokhanh@gmail.com',NULL,NULL,'lokhanh','$2a$10$6gBAIgXotrJtv9RO0KJfMu0nSpk2TqhXfHpiM3ofb2CaQbUS.POr.',0,'customer',NULL,NULL),(8,NULL,NULL,NULL,'duyanhkhongbietgidau@gmail.com',NULL,NULL,'duyanh','$2a$10$GqOdMkBjZ.giiHJNTFzaJe6LoA9C0nPLimPSYtLLLXZXgj8dt/./2',0,'customer',NULL,NULL),(9,NULL,NULL,NULL,'Dag.thag.205@gmail.com',NULL,NULL,'ThanLanThon','$2a$10$H5uUkfewayUToZagBP.9m.abHyUUEPUekD47Mkj3GuTC8/5xYFbpi',0,'customer',NULL,NULL),(10,NULL,NULL,NULL,'abcxyz@gmail.com',NULL,NULL,'abcxyz','$2a$10$I/7D2A.IzrDPiK0rKUc/8ObxWxUdL.6Ax8GSTKEQ1NHV2y6ZRUxzO',0,'customer',NULL,NULL),(11,NULL,NULL,NULL,'superututfivip@gmail.com',NULL,NULL,'lokhanhk','$2a$10$kVZF5DylpzIpX8v7zZwJCuY8vN.HkMUyp1TjLqnUQelmK5xFDT6C.',0,'customer',NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'cinema_db'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `evt_release_expired_invoices` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `evt_release_expired_invoices` ON SCHEDULE EVERY 1 MINUTE STARTS '2026-04-24 04:06:04' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
        CALL sp_release_expired_invoices();
    END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `evt_release_expired_seats` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `evt_release_expired_seats` ON SCHEDULE EVERY 1 MINUTE STARTS '2026-03-27 15:02:14' ON COMPLETION NOT PRESERVE ENABLE DO CALL sp_release_expired_seat() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'cinema_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `InsertSeatsForRoom5` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSeatsForRoom5`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE current_row_char CHAR(1);
    DECLARE current_seat_num INT;
    DECLARE current_seat_type INT;
    
    WHILE i <= 100 DO
        -- 1. Phân loại seat_type_id theo số thứ tự vòng lặp
        IF i <= 50 THEN
            SET current_seat_type = 1;
        ELSEIF i <= 60 THEN
            SET current_seat_type = 3;
        ELSEIF i <= 80 THEN
            SET current_seat_type = 2;
        ELSEIF i <= 90 THEN
            SET current_seat_type = 4;
        ELSE
            SET current_seat_type = 5;
        END IF;

        -- 2. Tính toán row_name (A-J) và seat_number (1-10)
        SET current_row_char = CHAR(65 + FLOOR((i - 1) / 10)); 
        SET current_seat_num = ((i - 1) % 10) + 1;

        -- 3. Thực hiện Insert (Bỏ qua seat_id để hệ thống tự tăng)
        INSERT INTO seat (seat_type_id, room_id, row_name, seat_number)
        VALUES (current_seat_type, 4, current_row_char, current_seat_num);
        
        SET i = i + 1;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SeedCinemaShowtimes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SeedCinemaShowtimes`()
BEGIN
    DECLARE v_date DATE DEFAULT '2026-05-10'; 
    DECLARE v_movie_id INT;
    DECLARE v_room_id INT;
    DECLARE v_current_start_min INT; -- Tổng số phút tính từ 00:00 của show_date
    DECLARE v_end_min INT;
    DECLARE v_max_min INT DEFAULT 1560; -- 26 giờ (tức là 02:00 sáng hôm sau: 24h + 2h)

    -- 1. Vòng lặp Ngày
    WHILE v_date <= '2026-05-20' DO
        
        -- 2. Vòng lặp Phòng
        SET v_room_id = 1;
        WHILE v_room_id <= 4 DO
            
            -- Bắt đầu lúc 8:00 sáng (8 * 60 = 480 phút)
            SET v_current_start_min = 480;
            
            -- 3. Vòng lặp Suất chiếu (Chạy đến khi bắt đầu sau 02:00 sáng hôm sau)
            -- 02:00 sáng hôm sau tương đương với 1560 phút tính từ mốc 00:00 ngày hôm đó
            WHILE v_current_start_min < v_max_min DO
                
                SET v_movie_id = FLOOR(3 + (RAND() * 7));
                SET v_end_min = v_current_start_min + 90; -- Mỗi suất 1 tiếng 30 phút (90p)
                
                -- Chèn dữ liệu (Dùng SEC_TO_TIME để chuyển phút ngược lại thành giờ HH:mm:ss)
                -- Lưu ý: MySQL TIME có thể lưu quá 24h, nên 25:00:00 chính là 01:00 sáng hôm sau
                INSERT IGNORE INTO showtime (movie_id, room_id, start_time, end_time, show_date)
                VALUES (
                    v_movie_id, 
                    v_room_id, 
                    SEC_TO_TIME(v_current_start_min * 60), 
                    SEC_TO_TIME(v_end_min * 60), 
                    v_date
                );
                
                -- Cập nhật giờ bắt đầu suất kế tiếp
                SET v_current_start_min = v_end_min;
                
            END WHILE;
            
            SET v_room_id = v_room_id + 1;
        END WHILE;
        
        SET v_date = DATE_ADD(v_date, INTERVAL 1 DAY);
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_create_showtime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_create_showtime`(
    IN p_movie_id   INT,
    IN p_room_id    INT,
    IN p_start_time DATETIME
)
BEGIN
    DECLARE v_duration INT;
    DECLARE v_end_time DATETIME;
    DECLARE v_conflict INT;

    SELECT duration INTO v_duration
    FROM movie WHERE movie_id = p_movie_id;

    IF v_duration IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Movie not found';
    END IF;

    SET v_end_time = DATE_ADD(p_start_time, INTERVAL v_duration MINUTE);

    SELECT COUNT(*) INTO v_conflict
    FROM showtime
    WHERE room_id = p_room_id
      AND p_start_time < end_time
      AND v_end_time   > start_time;

    IF v_conflict > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Showtime conflict in this room';
    END IF;

    INSERT INTO showtime(movie_id, room_id, start_time, end_time, show_date)
    VALUES(p_movie_id, p_room_id, p_start_time, v_end_time, DATE(p_start_time));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_delete_showtime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_delete_showtime`(
    IN p_showtime_id INT
)
BEGIN
    DECLARE v_sold INT;

    SELECT COUNT(*) INTO v_sold
    FROM booking_seat bs
    JOIN showtime_seat ss ON bs.showtime_seat_id = ss.showtime_seat_id
    WHERE ss.showtime_id = p_showtime_id;

    IF v_sold > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete showtime with sold tickets';
    END IF;

    DELETE FROM showtime_seat WHERE showtime_id = p_showtime_id;
    DELETE FROM showtime      WHERE showtime_id = p_showtime_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_update_showtime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_update_showtime`(
    IN p_showtime_id INT,
    IN p_start_time  DATETIME,
    IN p_room_id     INT
)
BEGIN
    DECLARE v_movie_id INT;
    DECLARE v_duration INT;
    DECLARE v_end_time DATETIME;
    DECLARE v_sold     INT;
    DECLARE v_conflict INT;

    SELECT COUNT(*) INTO v_sold
    FROM booking_seat bs
    JOIN showtime_seat ss ON bs.showtime_seat_id = ss.showtime_seat_id
    WHERE ss.showtime_id = p_showtime_id;

    IF v_sold > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot update showtime with sold tickets';
    END IF;

    SELECT movie_id INTO v_movie_id
    FROM showtime WHERE showtime_id = p_showtime_id;

    SELECT duration INTO v_duration
    FROM movie WHERE movie_id = v_movie_id;

    SET v_end_time = DATE_ADD(p_start_time, INTERVAL v_duration MINUTE);

    SELECT COUNT(*) INTO v_conflict
    FROM showtime
    WHERE room_id     = p_room_id
      AND showtime_id <> p_showtime_id
      AND p_start_time < end_time
      AND v_end_time   > start_time;

    IF v_conflict > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Showtime conflict in this room';
    END IF;

    UPDATE showtime
    SET start_time = p_start_time,
        end_time   = v_end_time,
        room_id    = p_room_id,
        show_date  = DATE(p_start_time)
    WHERE showtime_id = p_showtime_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_apply_discount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_apply_discount`(
    IN  p_invoice_id      BINARY(16),
    IN  p_discount_code   VARCHAR(50),
    OUT p_discount_amount DECIMAL(12,2)
)
BEGIN
    DECLARE v_discount_id   INT UNSIGNED;
    DECLARE v_discount_type ENUM('percent','fixed');
    DECLARE v_discount_val  DECIMAL(10,2);
    DECLARE v_start_date    DATE;
    DECLARE v_end_date      DATE;
    DECLARE v_max_usage     INT UNSIGNED;
    DECLARE v_current_usage INT;
    DECLARE v_min_order     DECIMAL(12,2);
    DECLARE v_applicable_days SET('Mon','Tue','Wed','Thu','Fri','Sat','Sun');
    DECLARE v_today_name    VARCHAR(3);
    DECLARE v_inv_subtotal  DECIMAL(12,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;

    SELECT discount_id, discount_type, discount_value, start_date, end_date, max_usage, current_usage, COALESCE(min_order_amount, 0), applicable_days
    INTO v_discount_id, v_discount_type, v_discount_val, v_start_date, v_end_date, v_max_usage, v_current_usage, v_min_order, v_applicable_days
    FROM discount WHERE discount_code = p_discount_code FOR UPDATE;

    IF v_discount_id IS NULL THEN SIGNAL SQLSTATE '45030' SET MESSAGE_TEXT = 'ERR_DISCOUNT_NOT_FOUND'; END IF;
    IF v_start_date IS NOT NULL AND CURDATE() < v_start_date THEN SIGNAL SQLSTATE '45031' SET MESSAGE_TEXT = 'ERR_DISCOUNT_NOT_STARTED'; END IF;
    IF v_end_date IS NOT NULL AND CURDATE() > v_end_date THEN SIGNAL SQLSTATE '45032' SET MESSAGE_TEXT = 'ERR_DISCOUNT_EXPIRED'; END IF;
    IF v_max_usage IS NOT NULL AND v_current_usage >= v_max_usage THEN SIGNAL SQLSTATE '45033' SET MESSAGE_TEXT = 'ERR_DISCOUNT_MAX_USAGE'; END IF;

    SET v_today_name = DATE_FORMAT(NOW(), '%a');
    IF v_applicable_days IS NOT NULL AND NOT FIND_IN_SET(v_today_name, v_applicable_days) THEN SIGNAL SQLSTATE '45034' SET MESSAGE_TEXT = 'ERR_DISCOUNT_WRONG_DAY'; END IF;

    SELECT COALESCE(subtotal, 0) INTO v_inv_subtotal FROM invoice WHERE invoice_id = p_invoice_id;
    IF v_inv_subtotal < v_min_order THEN SIGNAL SQLSTATE '45035' SET MESSAGE_TEXT = 'ERR_DISCOUNT_MIN_ORDER_NOT_MET'; END IF;

    IF v_discount_type = 'percent' THEN SET p_discount_amount = ROUND(v_inv_subtotal * v_discount_val / 100, 0);
    ELSE SET p_discount_amount = v_discount_val; END IF;
    SET p_discount_amount = LEAST(p_discount_amount, v_inv_subtotal);

    UPDATE invoice SET discount_id = v_discount_id, discount_amount = p_discount_amount, final_price = subtotal - p_discount_amount, total_price = subtotal - p_discount_amount WHERE invoice_id = p_invoice_id;
    UPDATE discount SET current_usage = current_usage + 1 WHERE discount_id = v_discount_id;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_checkout_invoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checkout_invoice`(
    IN  p_invoice_id     BINARY(16),
    IN  p_user_id        INT UNSIGNED,
    IN  p_payment_method ENUM('momo','vnpay','zalopay','cash'),
    OUT p_transaction_id VARCHAR(100)
)
BEGIN
    DECLARE v_status      VARCHAR(20);
    DECLARE v_final_price DECIMAL(12,2);
    DECLARE v_expired_at  DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;

    SELECT invoice_status, final_price, expired_at INTO v_status, v_final_price, v_expired_at
    FROM invoice WHERE invoice_id = p_invoice_id AND user_id = p_user_id FOR UPDATE;

    IF v_status IS NULL THEN SIGNAL SQLSTATE '45040' SET MESSAGE_TEXT = 'ERR_INVOICE_NOT_FOUND'; END IF;
    IF v_status <> 'holding' THEN SIGNAL SQLSTATE '45041' SET MESSAGE_TEXT = 'ERR_INVOICE_CANNOT_CHECKOUT'; END IF;
    IF v_expired_at IS NOT NULL AND NOW() > v_expired_at THEN
        UPDATE invoice SET invoice_status = 'expired' WHERE invoice_id = p_invoice_id;
        COMMIT;
        SIGNAL SQLSTATE '45042' SET MESSAGE_TEXT = 'ERR_INVOICE_EXPIRED';
    END IF;

    SET p_transaction_id = CONCAT('TXN-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%S'), '-', UPPER(SUBSTRING(MD5(RAND()), 1, 8)));

    UPDATE invoice SET invoice_status = 'paying', payment_method = p_payment_method, transaction_id = p_transaction_id, expired_at = DATE_ADD(NOW(), INTERVAL 15 MINUTE)
    WHERE invoice_id = p_invoice_id;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_invoice_add_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_invoice_add_product`(
    IN p_invoice_id BINARY(16),
    IN p_product_id INT UNSIGNED,
    IN p_quantity   INT UNSIGNED
)
BEGIN
    DECLARE v_price      DECIMAL(10,2);
    DECLARE v_inv_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;

    SELECT invoice_status INTO v_inv_status FROM invoice WHERE invoice_id = p_invoice_id FOR SHARE;
    IF v_inv_status NOT IN ('holding', 'draft') THEN SIGNAL SQLSTATE '45020' SET MESSAGE_TEXT = 'ERR_INVOICE_NOT_EDITABLE'; END IF;

    SELECT price INTO v_price FROM products WHERE product_id = p_product_id AND is_available = 1;
    IF v_price IS NULL THEN SIGNAL SQLSTATE '45021' SET MESSAGE_TEXT = 'ERR_PRODUCT_NOT_FOUND'; END IF;

    INSERT INTO booking_products(invoice_id, product_id, product_quantity, price_at_booking)
    VALUES (p_invoice_id, p_product_id, p_quantity, v_price)
    ON DUPLICATE KEY UPDATE product_quantity = product_quantity + p_quantity, price_at_booking = v_price;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_invoice_add_seat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_invoice_add_seat`(
    IN p_invoice_id      BINARY(16),
    IN p_showtime_seat_id INT UNSIGNED,
    IN p_user_id         INT UNSIGNED
)
BEGIN
    DECLARE v_price      DECIMAL(10,2);
    DECLARE v_showtime_id INT UNSIGNED;
    DECLARE v_inv_status VARCHAR(20);
    DECLARE v_inv_user   INT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT invoice_status, user_id INTO v_inv_status, v_inv_user
    FROM invoice WHERE invoice_id = p_invoice_id FOR SHARE;

    IF v_inv_status IS NULL THEN SIGNAL SQLSTATE '45010' SET MESSAGE_TEXT = 'ERR_INVOICE_NOT_FOUND'; END IF;
    IF v_inv_status NOT IN ('holding', 'draft') THEN SIGNAL SQLSTATE '45011' SET MESSAGE_TEXT = 'ERR_INVOICE_INVALID_STATUS'; END IF;
    IF v_inv_user <> p_user_id THEN SIGNAL SQLSTATE '45012' SET MESSAGE_TEXT = 'ERR_INVOICE_NOT_OWNER'; END IF;

    SELECT st.price, ss.showtime_id INTO v_price, v_showtime_id
    FROM showtime_seat ss
    JOIN seat s ON ss.seat_id = s.seat_id
    JOIN seat_type st ON s.seat_type_id = st.seat_type_id
    WHERE ss.showtime_seat_id = p_showtime_seat_id AND ss.user_id = p_user_id AND ss.status_id = 2;

    IF v_price IS NULL THEN SIGNAL SQLSTATE '45013' SET MESSAGE_TEXT = 'ERR_SEAT_NOT_HELD_BY_USER'; END IF;

    INSERT INTO booking_seat(invoice_id, showtime_id, showtime_seat_id, price_at_booking) 
    VALUES (p_invoice_id, v_showtime_id, p_showtime_seat_id, v_price);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_invoice_calculate_total` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_invoice_calculate_total`(
    IN  p_invoice_id BINARY(16),
    OUT p_subtotal   DECIMAL(12,2),
    OUT p_final      DECIMAL(12,2)
)
BEGIN
    DECLARE v_seat_total    DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_product_total DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_discount_type ENUM('percent','fixed');
    DECLARE v_discount_val  DECIMAL(10,2);
    DECLARE v_discount_amt  DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_discount_id   INT UNSIGNED;

    SELECT COALESCE(SUM(price_at_booking), 0) INTO v_seat_total FROM booking_seat WHERE invoice_id = p_invoice_id;
    SELECT COALESCE(SUM(price_at_booking * product_quantity), 0) INTO v_product_total FROM booking_products WHERE invoice_id = p_invoice_id;

    SET p_subtotal = v_seat_total + v_product_total;

    SELECT i.discount_id, d.discount_type, d.discount_value INTO v_discount_id, v_discount_type, v_discount_val
    FROM invoice i LEFT JOIN discount d ON i.discount_id = d.discount_id WHERE i.invoice_id = p_invoice_id;

    IF v_discount_id IS NOT NULL THEN
        IF v_discount_type = 'percent' THEN SET v_discount_amt = ROUND(p_subtotal * v_discount_val / 100, 0);
        ELSE SET v_discount_amt = v_discount_val; END IF;
        SET v_discount_amt = LEAST(v_discount_amt, p_subtotal);
    END IF;

    SET p_final = p_subtotal - v_discount_amt;

    UPDATE invoice SET subtotal = p_subtotal, discount_amount = v_discount_amt, final_price = p_final, total_price = p_final WHERE invoice_id = p_invoice_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_invoice_create` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_invoice_create`(
    IN  p_user_id   INT UNSIGNED,
    OUT p_invoice_id VARCHAR(36)
)
BEGIN
    DECLARE v_bin_id BINARY(16);
    SET v_bin_id = UUID_TO_BIN(UUID());

    INSERT INTO invoice(invoice_id, user_id, invoice_status, subtotal, discount_amount, final_price, created_datetime, expired_at) 
    VALUES (v_bin_id, p_user_id, 'holding', 0.00, 0.00, 0.00, NOW(), DATE_ADD(NOW(), INTERVAL 10 MINUTE));

    SET p_invoice_id = BIN_TO_UUID(v_bin_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_payment_fail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_payment_fail`(
    IN p_invoice_id BINARY(16),
    IN p_reason     VARCHAR(255)
)
sp_fail_lbl: BEGIN
    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;

    SELECT invoice_status INTO v_status FROM invoice WHERE invoice_id = p_invoice_id FOR UPDATE;

    IF v_status IN ('failed', 'expired', 'paid') THEN
        COMMIT;
        LEAVE sp_fail_lbl;
    END IF;

    UPDATE showtime_seat ss JOIN booking_seat bs ON ss.showtime_seat_id = bs.showtime_seat_id
    SET ss.status_id = 1, ss.user_id = NULL, ss.hold_expired_at = NULL WHERE bs.invoice_id = p_invoice_id;

    UPDATE invoice SET invoice_status = 'failed', failure_reason = p_reason, expired_at = NULL WHERE invoice_id = p_invoice_id;
    UPDATE discount d JOIN invoice i ON d.discount_id = i.discount_id SET d.current_usage = GREATEST(d.current_usage - 1, 0) WHERE i.invoice_id = p_invoice_id;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_payment_success` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_payment_success`(
    IN p_invoice_id      BINARY(16),
    IN p_transaction_id  VARCHAR(100)
)
sp_success_lbl: BEGIN
    DECLARE v_status   VARCHAR(20);
    DECLARE v_user_id  INT UNSIGNED;
    DECLARE v_final    DECIMAL(12,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;

    SELECT invoice_status, user_id, final_price INTO v_status, v_user_id, v_final
    FROM invoice WHERE invoice_id = p_invoice_id AND transaction_id = p_transaction_id FOR UPDATE;

    IF v_status = 'paid' THEN
        COMMIT;
        LEAVE sp_success_lbl; 
    END IF;

    IF v_status IS NULL THEN SIGNAL SQLSTATE '45050' SET MESSAGE_TEXT = 'ERR_TRANSACTION_MISMATCH'; END IF;
    IF v_status <> 'paying' THEN SIGNAL SQLSTATE '45051' SET MESSAGE_TEXT = 'ERR_INVOICE_NOT_IN_PAYING_STATUS'; END IF;

    UPDATE showtime_seat ss JOIN booking_seat bs ON ss.showtime_seat_id = bs.showtime_seat_id
    SET ss.status_id = 3, ss.user_id = v_user_id, ss.hold_expired_at = NULL WHERE bs.invoice_id = p_invoice_id;

    UPDATE invoice SET invoice_status = 'paid', paid_at = NOW(), expired_at = NULL WHERE invoice_id = p_invoice_id;
    UPDATE `user` SET coin = coin + FLOOR(v_final / 10000) WHERE user_id = v_user_id;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_release_expired_invoices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_release_expired_invoices`()
BEGIN
    DECLARE v_done    INT DEFAULT 0;
    DECLARE v_inv_id  BINARY(16);
    DECLARE cur_expired CURSOR FOR SELECT invoice_id FROM invoice WHERE invoice_status IN ('holding', 'paying') AND expired_at < NOW();
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    OPEN cur_expired;
    expire_loop: LOOP
        FETCH cur_expired INTO v_inv_id;
        IF v_done THEN LEAVE expire_loop; END IF;

        UPDATE showtime_seat ss JOIN booking_seat bs ON ss.showtime_seat_id = bs.showtime_seat_id
        SET ss.status_id = 1, ss.user_id = NULL, ss.hold_expired_at = NULL WHERE bs.invoice_id = v_inv_id;

        UPDATE discount d JOIN invoice i ON d.discount_id = i.discount_id
        SET d.current_usage = GREATEST(d.current_usage - 1, 0) WHERE i.invoice_id = v_inv_id;

        UPDATE invoice SET invoice_status = 'expired', expired_at = NULL WHERE invoice_id = v_inv_id;
    END LOOP;
    CLOSE cur_expired;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_release_expired_seat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_release_expired_seat`()
BEGIN
    UPDATE showtime_seat SET status_id = 1, user_id = NULL, hold_expired_at = NULL WHERE status_id = 2 AND hold_expired_at < NOW();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_seat_hold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seat_hold`(
    IN  p_showtime_id      INT UNSIGNED,
    IN  p_seat_id          INT UNSIGNED,
    IN  p_user_id          INT UNSIGNED,
    OUT p_showtime_seat_id INT UNSIGNED
)
BEGIN
    DECLARE v_status_id    INT UNSIGNED;
    DECLARE v_hold_user_id INT UNSIGNED;
    DECLARE v_hold_expired DATETIME;
    DECLARE v_seat_exists  INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT  showtime_seat_id, status_id, user_id, hold_expired_at
    INTO    p_showtime_seat_id, v_status_id, v_hold_user_id, v_hold_expired
    FROM    showtime_seat
    WHERE   showtime_id = p_showtime_id AND seat_id = p_seat_id
    FOR UPDATE;

    IF p_showtime_seat_id IS NULL THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'ERR_SEAT_NOT_FOUND';
    END IF;

    IF v_status_id = 3 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'ERR_SEAT_ALREADY_BOOKED';
    END IF;

    IF v_status_id = 2 AND v_hold_expired > NOW() AND v_hold_user_id <> p_user_id THEN
        SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'ERR_SEAT_HELD_BY_OTHER';
    END IF;

    UPDATE showtime_seat
    SET status_id = 2, user_id = p_user_id, hold_expired_at = DATE_ADD(NOW(), INTERVAL 10 MINUTE)
    WHERE showtime_seat_id = p_showtime_seat_id;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_seed_sample_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_sample_data`()
sp_lbl: BEGIN
    DECLARE v_movie_id INT UNSIGNED;
    DECLARE v_room_id INT UNSIGNED;
    DECLARE v_showtime_id INT UNSIGNED;
    DECLARE v_duration INT;
    DECLARE v_current_start TIME;
    DECLARE v_current_end TIME;
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    
    -- 1. Lấy thông tin phim và phòng đầu tiên
    SELECT movie_id, duration INTO v_movie_id, v_duration FROM movie LIMIT 1;
    SELECT room_id INTO v_room_id FROM room LIMIT 1;

    -- Nếu DB trống trơn chưa có phim/phòng thì dừng lại báo lỗi
    IF v_movie_id IS NULL OR v_room_id IS NULL THEN
        SELECT 'HỆ THỐNG BÁO: Bạn phải thêm ít nhất 1 Phim và 1 Phòng chiếu vào DB trước khi chạy tool này!' AS Alert;
        LEAVE sp_lbl;
    END IF;

    -- 2. Xóa dữ liệu cũ của 5 ngày gần đây
    SET FOREIGN_KEY_CHECKS = 0;
    DELETE bs FROM booking_seat bs JOIN showtime st ON bs.showtime_id = st.showtime_id WHERE st.show_date >= DATE_SUB(CURDATE(), INTERVAL 5 DAY);
    DELETE ss FROM showtime_seat ss JOIN showtime st ON ss.showtime_id = st.showtime_id WHERE st.show_date >= DATE_SUB(CURDATE(), INTERVAL 5 DAY);
    DELETE FROM showtime WHERE show_date >= DATE_SUB(CURDATE(), INTERVAL 5 DAY);
    SET FOREIGN_KEY_CHECKS = 1;

    -- 3. Vòng lặp tạo 5 ngày (từ hôm nay)
    WHILE i < 5 DO
        SET j = 0;
        SET v_current_start = '09:00:00'; -- Suất đầu tiên bắt đầu lúc 9h sáng
        
        -- Tạo 3 suất mỗi ngày
        WHILE j < 3 DO
            -- Tính giờ kết thúc = Giờ bắt đầu + thời lượng phim
            SET v_current_end = ADDTIME(v_current_start, SEC_TO_TIME(v_duration * 60));
            
            -- Chèn suất chiếu mới (ĐÃ XÓA CỘT PRICE)
            INSERT INTO showtime (movie_id, room_id, show_date, start_time, end_time)
            VALUES (v_movie_id, v_room_id, DATE_ADD(CURDATE(), INTERVAL i DAY), v_current_start, v_current_end);
            
            SET v_showtime_id = LAST_INSERT_ID();
            
            -- Đổ ghế (Lấy từ bảng seat gốc)
            INSERT INTO showtime_seat (showtime_id, seat_id, status_id)
            SELECT v_showtime_id, seat_id, 1 FROM seat WHERE room_id = v_room_id;
            
            -- Tính giờ bắt đầu cho suất TIẾP THEO = Giờ kết thúc + 30 phút dọn phòng
            SET v_current_start = ADDTIME(v_current_end, '00:30:00');
            SET j = j + 1;
        END WHILE;
        
        SET i = i + 1;
    END WHILE;
    
    SELECT 'THÀNH CÔNG: Đã tạo xong suất chiếu và ghế mẫu cho 5 ngày tới!' AS Result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-24 22:45:30
