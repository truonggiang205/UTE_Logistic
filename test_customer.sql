-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: logistic
-- ------------------------------------------------------
-- Server version	8.0.40

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

--
-- Table structure for table `action_types`
--

DROP TABLE IF EXISTS `action_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_types` (
  `action_type_id` bigint NOT NULL AUTO_INCREMENT,
  `action_code` varchar(20) NOT NULL,
  `action_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`action_type_id`),
  UNIQUE KEY `UK3ogbjeylnyfmp3xngscgh51t4` (`action_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_types`
--

LOCK TABLES `action_types` WRITE;
/*!40000 ALTER TABLE `action_types` DISABLE KEYS */;
INSERT INTO `action_types` VALUES (1,'CREATED','Khởi tạo',NULL),(2,'PICKED_UP','Đã lấy hàng',NULL),(3,'DELIVERED','Thành công',NULL);
/*!40000 ALTER TABLE `action_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cod_transactions`
--

DROP TABLE IF EXISTS `cod_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cod_transactions` (
  `cod_tx_id` bigint NOT NULL AUTO_INCREMENT,
  `amount` decimal(38,2) NOT NULL,
  `collected_at` datetime(6) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `settled_at` datetime(6) DEFAULT NULL,
  `status` enum('collected','settled','pending') DEFAULT 'pending',
  `request_id` bigint NOT NULL,
  `shipper_id` bigint DEFAULT NULL,
  PRIMARY KEY (`cod_tx_id`),
  KEY `FKqtski4j7arych0rrxqdm7hou3` (`request_id`),
  KEY `FKr66049fvmm9l6xg95mwf8t7e6` (`shipper_id`),
  CONSTRAINT `FKqtski4j7arych0rrxqdm7hou3` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`),
  CONSTRAINT `FKr66049fvmm9l6xg95mwf8t7e6` FOREIGN KEY (`shipper_id`) REFERENCES `shippers` (`shipper_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cod_transactions`
--

LOCK TABLES `cod_transactions` WRITE;
/*!40000 ALTER TABLE `cod_transactions` DISABLE KEYS */;
INSERT INTO `cod_transactions` VALUES (1,1500000.00,'2026-01-02 18:00:00.000000','Tiền mặt',NULL,'collected',104,1),(2,2000000.00,'2026-01-01 15:00:00.000000','Chuyển khoản','2026-01-02 09:00:00.000000','settled',105,1),(3,450000.00,'2026-01-02 20:00:00.000000','Tiền mặt',NULL,'collected',102,1);
/*!40000 ALTER TABLE `cod_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_addresses`
--

DROP TABLE IF EXISTS `customer_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_addresses` (
  `address_id` bigint NOT NULL AUTO_INCREMENT,
  `address_detail` varchar(255) DEFAULT NULL,
  `contact_name` varchar(100) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `district` varchar(50) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `note` varchar(255) DEFAULT NULL,
  `province` varchar(50) DEFAULT NULL,
  `ward` varchar(50) DEFAULT NULL,
  `customer_id` bigint NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `FKrvr6wl9gll7u98cda18smugp4` (`customer_id`),
  CONSTRAINT `FKrvr6wl9gll7u98cda18smugp4` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_addresses`
--

LOCK TABLES `customer_addresses` WRITE;
/*!40000 ALTER TABLE `customer_addresses` DISABLE KEYS */;
INSERT INTO `customer_addresses` VALUES (1,'123 CMT8','Chủ Shop 01','0900000004','Quận 10',1,NULL,'Ho Chi Minh','Phường 1',1,NULL),(6,'81 Trường Chinh','Kho hàng Phú Mỹ','0971597642','Thị xã Phú Mỹ',1,NULL,'Bà Rịa - Vũng Tàu','Phường Phú Mỹ',104,NULL),(7,'456 Lê Lợi','Nguyễn Văn Nhận 1','0912345678','Quận 1',0,NULL,'Ho Chi Minh','Phường Bến Thành',104,NULL),(8,'789 Hai Bà Trưng','Trần Thị Nhận 2','0987654321','Quận 3',0,NULL,'Ho Chi Minh','Phường 6',104,NULL),(9,'101 Quang Trung','Lê Văn Nhận 3','0909090909','Gò Vấp',0,NULL,'Ho Chi Minh','Phường 10',104,NULL),(11,'Tòa nhà Aurora, Lã Xuân Oai','Nguyễn Trung Kiên','0913681177','Thành phố Thủ Đức',0,NULL,'Thành phố Hồ Chí Minh','Phường Tăng Nhơn Phú A',104,'2026-01-04 13:08:26.663829');
/*!40000 ALTER TABLE `customer_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` bigint NOT NULL AUTO_INCREMENT,
  `business_name` varchar(150) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `customer_type` enum('individual','business') DEFAULT 'individual',
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `tax_code` varchar(30) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `account_holder_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(30) DEFAULT NULL,
  `bank_branch` varchar(100) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `UKeuat1oase6eqv195jvb71a93s` (`user_id`),
  CONSTRAINT `FKrh1g1a20omjmn6kurd35o3eit` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'NGHV Shop','2025-12-31 19:48:02.000000','individual',NULL,NULL,'0900000004','active',NULL,4,NULL,NULL,NULL,NULL),(104,'Hoai Nam Store','2026-01-01 02:11:22.736706','business',NULL,NULL,'0971597642','active',NULL,104,'','','','');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hubs`
--

DROP TABLE IF EXISTS `hubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hubs` (
  `hub_id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `district` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `hub_level` enum('central','regional','local') DEFAULT 'local',
  `hub_name` varchar(100) NOT NULL,
  `province` varchar(50) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `ward` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`hub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hubs`
--

LOCK TABLES `hubs` WRITE;
/*!40000 ALTER TABLE `hubs` DISABLE KEYS */;
INSERT INTO `hubs` VALUES (1,'1 Nguyen Hue',NULL,'2025-12-31 19:48:02.000000','Quan 1',NULL,'central','HCM Central Hub','Ho Chi Minh','active','Ben Nghe'),(2,'3 Trang Tien',NULL,'2025-12-31 19:48:02.000000','Hoan Kiem',NULL,'central','Ha Noi Hub','Ha Noi','active','Trang Tien'),(9,'81 Trường Chinh','02543890123','2026-01-04 14:58:45.000000','Thị xã Phú Mỹ','phumy.hub@nghv.vn','local','Bưu cục Trung tâm Phú Mỹ','Bà Rịa - Vũng Tàu','active','Phường Phú Mỹ'),(10,'Quốc lộ 51, Khu phố 1','02543894567','2026-01-04 14:58:45.000000','Thị xã Phú Mỹ','myxuan.hub@nghv.vn','local','Điểm thu gom Mỹ Xuân','Bà Rịa - Vũng Tàu','active','Phường Mỹ Xuân'),(11,'Đường Hắc Dịch - Tóc Tiên','02543898999','2026-01-04 14:58:45.000000','Thị xã Phú Mỹ','hacdich.hub@nghv.vn','local','Bưu cục Hắc Dịch','Bà Rịa - Vũng Tàu','active','Phường Hắc Dịch');
/*!40000 ALTER TABLE `hubs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parcel_actions`
--

DROP TABLE IF EXISTS `parcel_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parcel_actions` (
  `action_id` bigint NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `action_type_id` bigint NOT NULL,
  `actor_id` bigint NOT NULL,
  `from_hub_id` bigint DEFAULT NULL,
  `request_id` bigint NOT NULL,
  `to_hub_id` bigint DEFAULT NULL,
  PRIMARY KEY (`action_id`),
  KEY `FKii3nas1y31mrdxtporgg42x4d` (`action_type_id`),
  KEY `FKkv1hiqnlsa3ri9b4wlfm8ocm0` (`actor_id`),
  KEY `FK1qokfpl1bxxob6m14mq993af1` (`from_hub_id`),
  KEY `FKhd3npu2tmwfn6c9449dg2o3q7` (`request_id`),
  KEY `FKf5pey43w6vgkpftgbo5ldmvqf` (`to_hub_id`),
  CONSTRAINT `FK1qokfpl1bxxob6m14mq993af1` FOREIGN KEY (`from_hub_id`) REFERENCES `hubs` (`hub_id`),
  CONSTRAINT `FKf5pey43w6vgkpftgbo5ldmvqf` FOREIGN KEY (`to_hub_id`) REFERENCES `hubs` (`hub_id`),
  CONSTRAINT `FKhd3npu2tmwfn6c9449dg2o3q7` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`),
  CONSTRAINT `FKii3nas1y31mrdxtporgg42x4d` FOREIGN KEY (`action_type_id`) REFERENCES `action_types` (`action_type_id`),
  CONSTRAINT `FKkv1hiqnlsa3ri9b4wlfm8ocm0` FOREIGN KEY (`actor_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parcel_actions`
--

LOCK TABLES `parcel_actions` WRITE;
/*!40000 ALTER TABLE `parcel_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `parcel_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parcel_routes`
--

DROP TABLE IF EXISTS `parcel_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parcel_routes` (
  `parcel_route_id` bigint NOT NULL AUTO_INCREMENT,
  `route_order` int NOT NULL,
  `status` enum('planned','in_progress','completed') DEFAULT 'planned',
  `request_id` bigint NOT NULL,
  `route_id` bigint NOT NULL,
  PRIMARY KEY (`parcel_route_id`),
  KEY `FKkbj949kwgdts8ye0v4gywdenr` (`request_id`),
  KEY `FKo8xv3vbhxkga3twer7up7v0j` (`route_id`),
  CONSTRAINT `FKkbj949kwgdts8ye0v4gywdenr` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`),
  CONSTRAINT `FKo8xv3vbhxkga3twer7up7v0j` FOREIGN KEY (`route_id`) REFERENCES `routes` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parcel_routes`
--

LOCK TABLES `parcel_routes` WRITE;
/*!40000 ALTER TABLE `parcel_routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `parcel_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `role_name` varchar(50) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `UK716hgxp60ym1lifrdgp67xt5k` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Quản trị viên','ROLE_ADMIN','active'),(2,'Nhân viên bưu cục','ROLE_STAFF','active'),(3,'Nhân viên giao hàng','ROLE_SHIPPER','active'),(4,'Khách hàng/Chủ shop','ROLE_CUSTOMER','active');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `route_id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `estimated_time` int DEFAULT NULL,
  `from_hub_id` bigint NOT NULL,
  `to_hub_id` bigint NOT NULL,
  PRIMARY KEY (`route_id`),
  KEY `FKgokscuio4utn8v3mxeqikj72o` (`from_hub_id`),
  KEY `FKmpby2urdsr4vdwfxyc2urk9px` (`to_hub_id`),
  CONSTRAINT `FKgokscuio4utn8v3mxeqikj72o` FOREIGN KEY (`from_hub_id`) REFERENCES `hubs` (`hub_id`),
  CONSTRAINT `FKmpby2urdsr4vdwfxyc2urk9px` FOREIGN KEY (`to_hub_id`) REFERENCES `hubs` (`hub_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_requests`
--

DROP TABLE IF EXISTS `service_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_requests` (
  `request_id` bigint NOT NULL AUTO_INCREMENT,
  `chargeable_weight` decimal(10,2) DEFAULT NULL,
  `cod_amount` decimal(12,2) DEFAULT '0.00',
  `cod_fee` decimal(12,2) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expected_pickup_time` datetime(6) DEFAULT NULL,
  `height` decimal(8,2) DEFAULT NULL,
  `image_order` varchar(255) DEFAULT NULL,
  `insurance_fee` decimal(12,2) DEFAULT NULL,
  `length` decimal(8,2) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `payment_status` enum('unpaid','paid','refunded') DEFAULT 'unpaid',
  `receiver_pay_amount` decimal(12,2) DEFAULT NULL,
  `shipping_fee` decimal(12,2) DEFAULT NULL,
  `status` enum('pending','picked','in_transit','delivered','cancelled','failed') DEFAULT 'pending',
  `total_price` decimal(12,2) DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `width` decimal(8,2) DEFAULT NULL,
  `current_hub_id` bigint DEFAULT NULL,
  `customer_id` bigint NOT NULL,
  `delivery_address_id` bigint NOT NULL,
  `pickup_address_id` bigint NOT NULL,
  `service_type_id` bigint NOT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `FKnaedi6c2rbp03skhkgq7raabq` (`current_hub_id`),
  KEY `FKdc3ls1bqnn3dop9b6eeyxplsc` (`customer_id`),
  KEY `FK23fo91pknq20vtyvotgmeoqxk` (`delivery_address_id`),
  KEY `FKa2i0ke08yc50ovy0851o18g77` (`pickup_address_id`),
  KEY `FK2gr8aie88ritx1mrokseu7qmk` (`service_type_id`),
  CONSTRAINT `FK23fo91pknq20vtyvotgmeoqxk` FOREIGN KEY (`delivery_address_id`) REFERENCES `customer_addresses` (`address_id`),
  CONSTRAINT `FK2gr8aie88ritx1mrokseu7qmk` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`service_type_id`),
  CONSTRAINT `FKa2i0ke08yc50ovy0851o18g77` FOREIGN KEY (`pickup_address_id`) REFERENCES `customer_addresses` (`address_id`),
  CONSTRAINT `FKdc3ls1bqnn3dop9b6eeyxplsc` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `FKnaedi6c2rbp03skhkgq7raabq` FOREIGN KEY (`current_hub_id`) REFERENCES `hubs` (`hub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_requests`
--

LOCK TABLES `service_requests` WRITE;
/*!40000 ALTER TABLE `service_requests` DISABLE KEYS */;
INSERT INTO `service_requests` VALUES (102,1.20,450000.00,5000.00,'2026-01-02 12:33:34.000000','2026-01-03 12:33:34.000000',10.00,NULL,0.00,10.00,'Hàng quần áo','unpaid',0.00,25000.00,'delivered',480000.00,1.00,10.00,1,104,7,6,1,NULL),(103,0.50,900000.00,9000.00,'2026-01-02 12:33:34.000000','2026-01-03 12:33:34.000000',5.00,NULL,0.00,5.00,'Hàng mỹ phẩm','unpaid',0.00,35000.00,'picked',944000.00,0.40,5.00,2,104,8,6,2,NULL),(104,2.00,1500000.00,15000.00,'2026-01-02 12:33:34.000000','2026-01-04 12:33:34.000000',15.00,NULL,5000.00,15.00,'Máy pha cà phê','unpaid',0.00,42000.00,'delivered',1562000.00,1.80,15.00,1,104,9,6,1,NULL),(105,1.00,2000000.00,20000.00,'2026-01-01 12:33:34.000000','2026-01-02 12:33:34.000000',10.00,NULL,10000.00,10.00,'Đã giao thành công','paid',0.00,30000.00,'delivered',2060000.00,0.90,10.00,1,104,7,6,1,NULL),(106,1.00,0.00,0.00,'2026-01-02 12:33:34.000000','2026-01-03 12:33:34.000000',10.00,NULL,0.00,10.00,'Khách từ chối nhận','unpaid',0.00,20000.00,'failed',20000.00,1.00,10.00,2,104,8,6,1,NULL),(107,NULL,800000.00,4000.00,'2026-01-04 17:14:13.175202',NULL,NULL,NULL,0.00,NULL,NULL,'unpaid',826000.00,22000.00,'pending',26000.00,13.00,NULL,NULL,104,11,6,2,'Táo Đỏ Hưng Yên'),(108,NULL,200000.00,1000.00,'2026-01-04 21:14:08.782677',NULL,NULL,'/uploads/orders/order_1767536048679.png',0.00,NULL,NULL,'unpaid',223000.00,22000.00,'pending',23000.00,12.00,NULL,NULL,104,11,6,2,'Bánh Gạo');
/*!40000 ALTER TABLE `service_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_types` (
  `service_type_id` bigint NOT NULL AUTO_INCREMENT,
  `base_fee` decimal(12,2) DEFAULT '0.00',
  `cod_min_fee` decimal(12,2) DEFAULT '0.00',
  `cod_rate` decimal(5,4) DEFAULT '0.0000',
  `description` varchar(255) DEFAULT NULL,
  `effective_from` datetime(6) DEFAULT NULL,
  `extra_price_per_kg` decimal(12,2) DEFAULT '0.00',
  `insurance_rate` decimal(5,4) DEFAULT '0.0000',
  `is_active` bit(1) DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL,
  `service_code` varchar(20) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `version` int DEFAULT NULL,
  PRIMARY KEY (`service_type_id`),
  UNIQUE KEY `UKsgrw90exb4ty9w7e0xtckk1n7` (`service_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_types`
--

LOCK TABLES `service_types` WRITE;
/*!40000 ALTER TABLE `service_types` DISABLE KEYS */;
INSERT INTO `service_types` VALUES (1,20000.00,0.00,0.0000,NULL,NULL,5000.00,0.0000,_binary '',NULL,'STD','Standard',NULL),(2,35000.00,0.00,0.0000,NULL,NULL,7000.00,0.0000,_binary '',NULL,'EXP','Express',NULL),(3,150000.00,0.00,0.0000,'Dịch vụ vận chuyển hàng cồng kềnh, kiện lớn >= 20kg',NULL,3000.00,0.0000,_binary '',NULL,'BBS','Big/Bulky Service',NULL);
/*!40000 ALTER TABLE `service_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipper_tasks`
--

DROP TABLE IF EXISTS `shipper_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipper_tasks` (
  `task_id` bigint NOT NULL AUTO_INCREMENT,
  `assigned_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `result_note` varchar(255) DEFAULT NULL,
  `task_status` enum('assigned','in_progress','completed','failed') DEFAULT 'assigned',
  `task_type` enum('delivery','pickup') NOT NULL,
  `request_id` bigint NOT NULL,
  `shipper_id` bigint NOT NULL,
  PRIMARY KEY (`task_id`),
  KEY `FK4i6tmdaxa38xcq1cddexjjx15` (`request_id`),
  KEY `FKogbf1ct9ce1q2vljibfp30ack` (`shipper_id`),
  CONSTRAINT `FK4i6tmdaxa38xcq1cddexjjx15` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`),
  CONSTRAINT `FKogbf1ct9ce1q2vljibfp30ack` FOREIGN KEY (`shipper_id`) REFERENCES `shippers` (`shipper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipper_tasks`
--

LOCK TABLES `shipper_tasks` WRITE;
/*!40000 ALTER TABLE `shipper_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipper_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shippers`
--

DROP TABLE IF EXISTS `shippers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shippers` (
  `shipper_id` bigint NOT NULL AUTO_INCREMENT,
  `joined_at` datetime(6) DEFAULT NULL,
  `rating` decimal(38,2) DEFAULT NULL,
  `shipper_type` enum('fulltime','parttime') DEFAULT NULL,
  `status` enum('active','inactive','busy') DEFAULT 'active',
  `vehicle_type` varchar(50) DEFAULT NULL,
  `hub_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`shipper_id`),
  UNIQUE KEY `UKd1mghpc6axe2hl5b1mtmtq1pj` (`user_id`),
  KEY `FKclo7tixcra05ivvu00h1h5v5h` (`hub_id`),
  CONSTRAINT `FK3aekq9ie8kebm7202pyqlsoqs` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `FKclo7tixcra05ivvu00h1h5v5h` FOREIGN KEY (`hub_id`) REFERENCES `hubs` (`hub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shippers`
--

LOCK TABLES `shippers` WRITE;
/*!40000 ALTER TABLE `shippers` DISABLE KEYS */;
INSERT INTO `shippers` VALUES (1,'2025-12-31 19:48:02.000000',5.00,'fulltime','active','Motorbike',1,3);
/*!40000 ALTER TABLE `shippers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staff_id` bigint NOT NULL AUTO_INCREMENT,
  `joined_at` datetime(6) DEFAULT NULL,
  `staff_position` varchar(50) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `hub_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `UK7qatq4kob2sr6rlp44khhj53g` (`user_id`),
  KEY `FKhetcdwunson81jypo7qs6ccph` (`hub_id`),
  CONSTRAINT `FKdlvw23ak3u9v9bomm8g12rtc0` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `FKhetcdwunson81jypo7qs6ccph` FOREIGN KEY (`hub_id`) REFERENCES `hubs` (`hub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'2025-12-31 19:48:02.000000','Dispatcher','active',1,2);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `support_tickets`
--

DROP TABLE IF EXISTS `support_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `support_tickets` (
  `ticket_id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `message` text NOT NULL,
  `status` enum('pending','processing','resolved') DEFAULT 'pending',
  `subject` varchar(255) NOT NULL,
  `customer_id` bigint NOT NULL,
  `request_id` bigint DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `FKbj61s5pm6gwms5405fcdvgm1t` (`customer_id`),
  KEY `FK3no7plt6is595mugqhwwbtwgk` (`request_id`),
  CONSTRAINT `FK3no7plt6is595mugqhwwbtwgk` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`),
  CONSTRAINT `FKbj61s5pm6gwms5405fcdvgm1t` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `support_tickets`
--

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
INSERT INTO `support_tickets` VALUES (1,'2026-01-03 12:01:19.251886','Đơn hàng của tôi đã quá hạn giao dự kiến nhưng vẫn chưa nhận được. Vui lòng kiểm tra lộ trình.','pending','Giao hàng chậm',104,106);
/*!40000 ALTER TABLE `support_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_logs`
--

DROP TABLE IF EXISTS `system_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_logs` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(100) DEFAULT NULL,
  `log_time` datetime(6) DEFAULT NULL,
  `object_id` bigint DEFAULT NULL,
  `object_type` varchar(50) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `FK3duy1vdqrob9rjxy67079ja4w` (`user_id`),
  CONSTRAINT `FK3duy1vdqrob9rjxy67079ja4w` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_logs`
--

LOCK TABLES `system_logs` WRITE;
/*!40000 ALTER TABLE `system_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracking_codes`
--

DROP TABLE IF EXISTS `tracking_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracking_codes` (
  `tracking_id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT NULL,
  `request_id` bigint NOT NULL,
  PRIMARY KEY (`tracking_id`),
  UNIQUE KEY `UKqhfvutqnfdt5914qalxk8f868` (`code`),
  KEY `FK7b6golwml7k3tvb2oefskkyin` (`request_id`),
  CONSTRAINT `FK7b6golwml7k3tvb2oefskkyin` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracking_codes`
--

LOCK TABLES `tracking_codes` WRITE;
/*!40000 ALTER TABLE `tracking_codes` DISABLE KEYS */;
INSERT INTO `tracking_codes` VALUES (1,'TRK-102-01: Đơn hàng đã được khởi tạo thành công tại Shop','2026-01-02 12:33:34.000000','active',102),(2,'TRK-103-01: Hệ thống tiếp nhận yêu cầu gửi hàng','2026-01-02 12:33:34.000000','active',103),(3,'TRK-103-02: Shipper Nguyễn Văn A đã lấy hàng thành công','2026-01-02 15:00:00.000000','active',103),(4,'TRK-104-01: Đơn hàng sẵn sàng chờ Shipper lấy','2026-01-02 12:33:34.000000','active',104),(5,'TRK-104-02: Đã lấy hàng thành công tại điểm gửi','2026-01-02 14:20:00.000000','active',104),(6,'TRK-104-03: Đã nhập kho HCM Central Hub, chuẩn bị xuất kho','2026-01-02 18:45:00.000000','active',104),(7,'TRK-105-01: Shop đã tạo đơn hàng trên hệ thống','2026-01-01 12:33:34.000000','active',105),(8,'TRK-105-02: Đã lấy hàng thành công','2026-01-01 15:30:00.000000','active',105),(9,'TRK-105-03: Đã nhập kho Ha Noi Hub','2026-01-02 08:00:00.000000','active',105),(10,'TRK-105-04: Giao hàng thành công. Người nhận đã ký xác nhận','2026-01-02 10:15:00.000000','active',105),(11,'TRK-106-01: Đơn hàng khởi tạo','2026-01-02 12:33:34.000000','active',106),(12,'TRK-106-02: Shipper báo: Khách từ chối nhận hàng do thay đổi ý định','2026-01-02 16:20:00.000000','active',106);
/*!40000 ALTER TABLE `tracking_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `FKh8ciramu9cc9q3qcqiv4ue8a6` (`role_id`),
  CONSTRAINT `FKh8ciramu9cc9q3qcqiv4ue8a6` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`),
  CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1),(2,2),(3,3),(4,4),(100,4),(101,4),(102,4),(103,4),(104,4);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `avatar_url` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `last_login_at` datetime(6) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` enum('active','inactive','banned') DEFAULT 'active',
  `updated_at` datetime(6) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,NULL,'2025-12-31 19:48:02.000000','admin@nghv.vn','Admin User',NULL,'$2a$10$XopNOn7S84Y7QG55.vP2neP.p9x.5I.vG/P5WlG2m8p5X.y5q5q','0900000001','active','2025-12-31 19:48:02.000000','admin'),(2,NULL,'2025-12-31 19:48:02.000000','staff01@nghv.vn','Staff One',NULL,'$2a$10$XopNOn7S84Y7QG55.vP2neP.p9x.5I.vG/P5WlG2m8p5X.y5q5q','0900000002','active','2025-12-31 19:48:02.000000','staff01'),(3,NULL,'2025-12-31 19:48:02.000000','shipper01@nghv.vn','Shipper One',NULL,'$2a$10$XopNOn7S84Y7QG55.vP2neP.p9x.5I.vG/P5WlG2m8p5X.y5q5q','0900000003','active','2025-12-31 19:48:02.000000','shipper01'),(4,NULL,'2025-12-31 19:48:02.000000','cust01@gmail.com','Customer One',NULL,'$2a$10$XopNOn7S84Y7QG55.vP2neP.p9x.5I.vG/P5WlG2m8p5X.y5q5q5q','0900000004','active','2025-12-31 19:48:02.000000','cust01'),(104,'/uploads/avatars/avatar_104_1767423437391.jpg','2026-01-01 02:11:22.729458','namphamhoai1595@gmail.com','Phạm Hoài Nam',NULL,'$2a$10$P4ITl.yCRCwMw4dLpxGdqeyOr2dxSj0RXOMF3/bQ1aqnF/2wgTtxy','0971597642','active',NULL,'US506298');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vnpay_transactions`
--

DROP TABLE IF EXISTS `vnpay_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vnpay_transactions` (
  `vnpay_tx_id` bigint NOT NULL AUTO_INCREMENT,
  `amount` decimal(12,2) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `paid_at` datetime(6) DEFAULT NULL,
  `payment_status` enum('pending','success','failed') DEFAULT 'pending',
  `vnp_order_info` varchar(255) DEFAULT NULL,
  `vnp_response_code` varchar(10) DEFAULT NULL,
  `vnp_transaction_no` varchar(100) DEFAULT NULL,
  `vnp_txn_ref` varchar(100) DEFAULT NULL,
  `request_id` bigint NOT NULL,
  PRIMARY KEY (`vnpay_tx_id`),
  KEY `FKq01rf6xynfvum1fl2a8p4kevx` (`request_id`),
  CONSTRAINT `FKq01rf6xynfvum1fl2a8p4kevx` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`request_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vnpay_transactions`
--

LOCK TABLES `vnpay_transactions` WRITE;
/*!40000 ALTER TABLE `vnpay_transactions` DISABLE KEYS */;
INSERT INTO `vnpay_transactions` VALUES (2,44000.00,'2026-01-02 12:40:00.000000','2026-01-02 12:45:00.000000','success','Thanh toan phi van chuyen don #103',NULL,'14123456','REF103',103);
/*!40000 ALTER TABLE `vnpay_transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-04 21:58:54
