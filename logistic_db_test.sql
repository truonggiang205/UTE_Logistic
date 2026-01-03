-- Test data for vn.web.logistic (Spring Boot JPA)
-- Schema: logistic_db_test
-- Column names matching JPA entity field mappings

USE logistic;

SET FOREIGN_KEY_CHECKS = 0;

-- Clean tables
DELETE FROM USER_ROLES;
DELETE FROM COD_TRANSACTIONS;
DELETE FROM SHIPPER_TASKS;
DELETE FROM PARCEL_ACTIONS;
DELETE FROM TRACKING_CODES;
DELETE FROM CONTAINER_DETAILS;
DELETE FROM TRIP_CONTAINERS;
DELETE FROM CONTAINERS;
DELETE FROM SERVICE_REQUESTS;
DELETE FROM CUSTOMER_ADDRESSES;
DELETE FROM CUSTOMERS;
DELETE FROM STAFF;
DELETE FROM SHIPPERS;
DELETE FROM DRIVERS;
DELETE FROM VEHICLES;
DELETE FROM HUBS;
DELETE FROM ACTION_TYPES;
DELETE FROM SERVICE_TYPES;
DELETE FROM USERS;
DELETE FROM ROLES;

-- ROLES
INSERT INTO `ROLES` (`role_id`, `role_name`, `description`, `status`) VALUES
(1, 'ADMIN',   'System administrator', 'active'),
(2, 'STAFF',   'Hub staff',            'active'),
(3, 'SHIPPER', 'Delivery shipper',     'active'),
(4, 'CUSTOMER','Customer user',        'active');

-- HUBS
INSERT INTO `HUBS` (`hub_id`, `hub_name`, `address`, `ward`, `district`, `province`, `hubLevel`, `status`, `contact_phone`, `email`, `createdAt`) VALUES
(1, 'HCM Central Hub', '1 Nguyen Hue', 'Ben Nghe', 'Quan 1', 'Ho Chi Minh', 'central',  'active', '0280000001', 'hcm-hub@logistic.local', NOW()),
(2, 'Da Nang Hub',     '2 Bach Dang',  'Hai Chau 1','Hai Chau','Da Nang',   'regional', 'active', '0236000002', 'dn-hub@logistic.local', NOW()),
(3, 'Ha Noi Hub',      '3 Trang Tien', 'Trang Tien','Hoan Kiem','Ha Noi',   'central',  'active', '0240000003', 'hn-hub@logistic.local', NOW()),
(4, 'Can Tho Hub',     '4 Hoa Binh',   'An Cu',     'Ninh Kieu','Can Tho',  'regional', 'active', '0292000004', 'ct-hub@logistic.local', NOW()),
(5, 'Hai Phong Hub',   '5 Tran Phu',   'May To',    'Ngo Quyen','Hai Phong','regional', 'active', '0225000005', 'hp-hub@logistic.local', NOW());

-- USERS
INSERT INTO `USERS` (`user_id`, `username`, `passwordHash`, `full_name`, `phone`, `email`, `status`, `createdAt`) VALUES
(1, 'admin',    'seed:admin123',    'Admin User',   '0900000001', 'admin@logistic.local',    'active', NOW()),
(2, 'staff01',  'seed:staff123',    'Staff One',    ' 0900000002', 'staff01@logistic.local',  'active', NOW()),
(3, 'shipper01','seed:shipper123',  'Shipper One',  '0900000003', 'shipper01@logistic.local','active', NOW()),
(4, 'cust01',   'seed:cust123',     'Customer One', '0900000004', 'cust01@logistic.local',   'active', NOW()),
(5, 'staff02',  'seed:staff123',    'Staff Two',    '0900000005', 'staff02@logistic.local',  'active', NOW()),
(6, 'staff03',  'seed:staff123',    'Staff Three',  '0900000006', 'staff03@logistic.local',  'active', NOW()),
(7, 'shipper02','seed:shipper123',  'Shipper Two',  '0900000007', 'shipper02@logistic.local','active', NOW()),
(8, 'shipper03','seed:shipper123',  'Shipper Three','0900000008', 'shipper03@logistic.local','active', NOW()),
(9, 'cust02',   'seed:cust123',     'Customer Two', '0900000009', 'cust02@logistic.local',   'active', NOW()),
(10,'cust03',   'seed:cust123',     'Customer Three','0900000010','cust03@logistic.local',   'active', NOW()),
(11,'custbiz01','seed:cust123',     'Biz Customer 01','0900000011','biz01@logistic.local',    'active', NOW()),
(12,'custbiz02','seed:cust123',     'Biz Customer 02','0900000012','biz02@logistic.local',    'active', NOW());

-- USER_ROLES
INSERT INTO `USER_ROLES` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 2),
(6, 2),
(7, 3),
(8, 3),
(9, 4),
(10, 4),
(11, 4),
(12, 4);

-- CUSTOMERS
INSERT INTO `CUSTOMERS` (`customer_id`, `user_id`, `full_name`, `business_name`, `customerType`, `email`, `phone`, `tax_code`, `status`, `created_at`) VALUES
(1, 4,  'Customer One',     NULL,                 'individual', 'cust01@logistic.local', '0900000004', NULL, 'active', NOW()),
(2, 9,  'Customer Two',     NULL,                 'individual', 'cust02@logistic.local', '0900000009', NULL, 'active', NOW()),
(3, 10, 'Customer Three',   NULL,                 'individual', 'cust03@logistic.local', '0900000010', NULL, 'active', NOW()),
(4, 11, 'Biz Customer 01',  'ACME Trading Co.,',  'business',   'biz01@logistic.local',  '0900000011', '0312345678', 'active', NOW()),
(5, 12, 'Biz Customer 02',  'Blue Ocean LLC',     'business',   'biz02@logistic.local',  '0900000012', '0412345678', 'active', NOW());

-- CUSTOMER_ADDRESSES
INSERT INTO `CUSTOMER_ADDRESSES` (`address_id`, `customer_id`, `contact_name`, `contact_phone`, `address_detail`, `ward`, `district`, `province`, `is_default`, `note`) VALUES
(1, 1, 'Customer One', '0900000004', '12 Nguyen Trai', 'Ben Thanh', 'Quan 1', 'Ho Chi Minh', 1, 'Pickup address'),
(2, 1, 'Receiver A',   '0900000100', '99 Le Loi',      'Hai Chau 1','Hai Chau','Da Nang',     0, 'Delivery address'),
(3, 2, 'Customer Two', '0900000009', '22 Vo Van Tan',  'Ward 6',    'Quan 3', 'Ho Chi Minh', 1, 'Pickup address'),
(4, 2, 'Receiver B',   '0900000200', '12 Tran Phu',    'May To',    'Ngo Quyen','Hai Phong',  0, 'Delivery address'),
(5, 3, 'Customer Three','0900000010','101 Nguyen Van Linh','An Hai Bac','Son Tra','Da Nang', 1, 'Pickup address'),
(6, 3, 'Receiver C',   '0900000300', '8 Trang Tien',   'Trang Tien','Hoan Kiem','Ha Noi',     0, 'Delivery address'),
(7, 4, 'ACME Warehouse','0900000111','KCN Tan Thuan',  'Tan Thuan Dong','Quan 7','Ho Chi Minh',1,'Business pickup'),
(8, 4, 'ACME Branch DN','0900000112','15 Bach Dang',   'Hai Chau 1','Hai Chau','Da Nang',     0, 'Business delivery'),
(9, 5, 'BlueOcean Depot','0900000121','20 Hoa Binh',   'An Cu',     'Ninh Kieu','Can Tho',    1, 'Business pickup'),
(10,5, 'BlueOcean HN',  '0900000122','88 Tran Phu',    'May To',    'Ngo Quyen','Hai Phong',  0, 'Business delivery');

-- SERVICE_TYPES
INSERT INTO `SERVICE_TYPES` (`service_type_id`, `service_code`, `service_name`, `base_fee`, `extra_price_per_kg`, `cod_rate`, `cod_min_fee`, `is_active`, `version`, `effective_from`) VALUES
(1, 'STD', 'Standard Delivery', 20000.00, 5000.00, 0.0100, 5000.00, 1, 1, NOW()),
(2, 'EXP', 'Express Delivery',  35000.00, 7000.00, 0.0125, 7000.00, 1, 1, NOW());

-- ACTION_TYPES
INSERT INTO `ACTION_TYPES` (`action_type_id`, `action_code`, `action_name`, `description`) VALUES
(1,  'CREATED',            'Request created',        'Customer creates request'),
(2,  'PICKED_UP',          'Picked up',              'Parcel picked up from sender'),
(3,  'ARRIVED_HUB',        'Arrived at hub',         'Parcel arrived at hub'),
(4,  'OUT_FOR_DEL',        'Out for delivery',       'Parcel out for delivery'),
(5,  'DELIVERED',          'Delivered',              'Parcel delivered to receiver'),
(6,  'ASSIGN_SHIPPER',     'Assign shipper',         'Manager assigns shipper for pickup/delivery'),
(7,  'DELIVERY_COMPLETED', 'Delivery completed',     'Shipper confirms successful delivery'),
(8,  'DELIVERY_DELAY',     'Delivery delayed',       'Shipper reports delivery delay/reschedule'),
(9,  'COUNTER_RECEIVE',    'Counter pickup',         'Customer picks up parcel at hub counter'),
(10, 'RETURN_COMPLETED',   'Return completed',       'Shop received returned parcel');

-- DRIVERS
INSERT INTO `DRIVERS` (`driver_id`, `full_name`, `phone_number`, `license_number`, `license_class`, `identity_card`, `status`, `created_at`) VALUES
(1, 'Driver One',   '0911111111', 'B12345678', 'C',  '012345678901', 'active', NOW()),
(2, 'Driver Two',   '0922222222', 'B22345678', 'C',  '012345678902', 'active', NOW()),
(3, 'Driver Three', '0933333333', 'B32345678', 'D',  '012345678903', 'active', NOW());

-- VEHICLES
INSERT INTO `VEHICLES` (`vehicle_id`, `plate_number`, `vehicle_type`, `load_capacity`, `current_hub_id`, `status`, `created_at`) VALUES
(1, '51A-12345', 'Truck',    5000.00, 1, 'active', NOW()),
(2, '51B-23456', 'Van',      2000.00, 2, 'active', NOW()),
(3, '51C-34567', 'Truck',    3000.00, 3, 'active', NOW());

-- SHIPPERS
INSERT INTO `SHIPPERS` (`shipper_id`, `user_id`, `hub_id`, `shipperType`, `vehicle_type`, `status`, `joinedAt`, `rating`) VALUES
(1, 3, 1, 'fulltime', 'Motorbike', 'active', NOW(), 4.80),
(2, 7, 2, 'fulltime', 'Motorbike', 'active', NOW(), 4.60),
(3, 8, 3, 'parttime', 'Car',       'active', NOW(), 4.40);

-- STAFF
INSERT INTO `STAFF` (`staff_id`, `user_id`, `hub_id`, `staff_position`, `status`, `joinedAt`) VALUES
(1, 2, 1, 'Dispatcher', 'active', NOW()),
(2, 5, 2, 'Dispatcher', 'active', NOW()),
(3, 6, 3, 'Dispatcher', 'active', NOW());

-- SERVICE_REQUESTS
INSERT INTO `SERVICE_REQUESTS` (`request_id`, `customer_id`, `pickup_address_id`, `delivery_address_id`, `service_type_id`, `expectedPickupTime`, `note`, `status`, `weight`, `length`, `width`, `height`, `cod_amount`, `chargeableWeight`, `shippingFee`, `codFee`, `insuranceFee`, `totalPrice`, `receiverPayAmount`, `paymentStatus`, `current_hub_id`, `createdAt`, `item_name`) VALUES
(1, 1, 1, 2, 2, DATE_ADD(NOW(), INTERVAL 2 HOUR), 'Handle with care', 'pending', 1.50, 20.00, 15.00, 10.00, 150000.00, 1.50, 35000.00, 7000.00, 1000.00, 43000.00, 193000.00, 'unpaid', 1, NOW(), 'Electronics'),
(2, 2, 3, 4, 1, DATE_ADD(NOW(), INTERVAL 1 HOUR), 'Fragile - glass', 'picked', 3.20, 35.00, 25.00, 20.00, 0.00, 3.20, 36000.00, 0.00, 0.00, 36000.00, 36000.00, 'paid', 1, NOW(), 'Glassware'),
(3, 3, 5, 6, 2, DATE_ADD(NOW(), INTERVAL 30 MINUTE), 'Deliver before 5PM', 'in_transit', 0.80, 15.00, 10.00, 8.00, 50000.00, 0.80, 35000.00, 7000.00, 500.00, 42500.00, 92500.00, 'unpaid', 2, NOW(), 'Documents'),
(4, 4, 7, 8, 1, DATE_ADD(NOW(), INTERVAL 3 HOUR), 'Batch order #ACME-0007', 'in_transit', 12.50, 60.00, 40.00, 35.00, 200000.00, 12.50, 85000.00, 5000.00, 3000.00, 93000.00, 293000.00, 'unpaid', 1, NOW(), 'Bulk Products'),
(5, 5, 9, 10, 2, DATE_ADD(NOW(), INTERVAL 90 MINUTE), 'Keep upright', 'delivered', 2.10, 25.00, 20.00, 18.00, 0.00, 2.10, 48000.00, 0.00, 0.00, 48000.00, 48000.00, 'paid', 5, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Fragile Items'),
(6, 1, 1, 2, 1, DATE_ADD(NOW(), INTERVAL 4 HOUR), 'Customer requests reschedule', 'cancelled', 1.00, 20.00, 15.00, 10.00, 0.00, 1.00, 20000.00, 0.00, 0.00, 20000.00, 20000.00, 'unpaid', 1, NOW(), 'Cancelled Order');

-- TRACKING_CODES
INSERT INTO `TRACKING_CODES` (`tracking_id`, `request_id`, `code`, `createdAt`, `status`) VALUES
(1, 1, 'LK000001', NOW(), 'active'),
(2, 2, 'LK000002', NOW(), 'active'),
(3, 3, 'LK000003', NOW(), 'active'),
(4, 4, 'LK000004', NOW(), 'active'),
(5, 5, 'LK000005', NOW(), 'active'),
(6, 6, 'LK000006', NOW(), 'inactive');

-- COD_TRANSACTIONS
INSERT INTO `COD_TRANSACTIONS` (`cod_tx_id`, `request_id`, `shipper_id`, `amount`, `collectedAt`, `settledAt`, `status`, `transaction_type`, `paymentMethod`) VALUES
(1, 1, 1, 150000.00, NULL, NULL, 'pending', 'delivery_cod', 'CASH'),
(2, 3, 2, 50000.00,  NULL, NULL, 'pending', 'delivery_cod', 'CASH'),
(3, 4, 2, 200000.00, NULL, NULL, 'pending', 'delivery_cod', 'CASH');

-- SHIPPER_TASKS
INSERT INTO `SHIPPER_TASKS` (`task_id`, `shipper_id`, `request_id`, `taskType`, `assignedAt`, `completedAt`, `taskStatus`, `resultNote`) VALUES
(1, 1, 1, 'pickup', NOW(), NULL, 'assigned', 'Auto-assigned for pickup'),
(2, 1, 2, 'pickup', NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), 'completed', 'Picked up successfully'),
(3, 2, 3, 'pickup', NOW(), NULL, 'assigned', 'Assigned to shipper02'),
(4, 2, 4, 'delivery', NOW(), NULL, 'assigned', 'Delivery task created'),
(5, 3, 5, 'delivery', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY) + INTERVAL 4 HOUR, 'completed', 'Delivered and paid');

-- PARCEL_ACTIONS
INSERT INTO `PARCEL_ACTIONS` (`action_id`, `request_id`, `action_type_id`, `from_hub_id`, `to_hub_id`, `actor_id`, `actionTime`, `note`) VALUES
(1, 1, 1, NULL, NULL, 4, NOW(), 'Customer created request'),
(2, 1, 2, NULL, 1,    3, DATE_ADD(NOW(), INTERVAL 3 HOUR), 'Picked up at sender'),
(3, 2, 1, NULL, NULL, 9, NOW(), 'Customer created request'),
(4, 2, 2, NULL, 1,    3, DATE_ADD(NOW(), INTERVAL 2 HOUR), 'Picked up and sent to hub'),
(5, 2, 3, 1,    2,    2, DATE_ADD(NOW(), INTERVAL 6 HOUR), 'Arrived at Da Nang hub'),
(6, 3, 1, NULL, NULL, 10, NOW(), 'Customer created request'),
(7, 3, 2, NULL, 2,     7, DATE_ADD(NOW(), INTERVAL 1 HOUR), 'Picked up by shipper02'),
(8, 3, 3, 2,    3,     5, DATE_ADD(NOW(), INTERVAL 10 HOUR), 'Transferred to Ha Noi hub'),
(9, 4, 1, NULL, NULL, 11, NOW(), 'Business customer created request'),
(10,4, 2, NULL, 1,     7, DATE_ADD(NOW(), INTERVAL 4 HOUR), 'Pickup at ACME warehouse'),
(11,4, 3, 1,    2,     2, DATE_ADD(NOW(), INTERVAL 28 HOUR), 'Arrived at Da Nang hub'),
(12,5, 1, NULL, NULL, 12, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Business customer created request'),
(13,5, 4, 3,    5,     8, DATE_SUB(NOW(), INTERVAL 2 DAY) + INTERVAL 2 HOUR, 'Out for delivery'),
(14,5, 5, 3,    5,     8, DATE_SUB(NOW(), INTERVAL 2 DAY) + INTERVAL 4 HOUR, 'Delivered successfully'),
(15,6, 1, NULL, NULL, 4, NOW(), 'Customer created request'),
(16,6, 2, NULL, 1,     3, DATE_ADD(NOW(), INTERVAL 30 MINUTE), 'Picked up then cancelled by customer');

-- CONTAINERS (empty for now)
-- INSERT INTO `CONTAINERS` (`container_id`, `container_code`, `type`, `weight`, `created_at_hub_id`, `destination_hub_id`, `created_by`, `status`, `created_at`) VALUES

-- CONTAINER_DETAILS (empty for now)
-- INSERT INTO `CONTAINER_DETAILS` (`id`, `container_id`, `request_id`, `created_at`) VALUES

-- TRIP_CONTAINERS (empty for now)
-- INSERT INTO `TRIP_CONTAINERS` (`id`, `trip_id`, `container_id`, `status`, `created_at`) VALUES

SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Seed data inserted successfully!' AS Result;
