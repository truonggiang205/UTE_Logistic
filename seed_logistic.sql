-- Seed data for vn.web.logistic (Spring Boot JPA)
-- Target DB: jdbc:sqlserver://localhost:1433;databaseName=logistic;integratedSecurity=true
-- Run with Windows Authentication (PowerShell or CMD):
--   sqlcmd -S localhost -E -i seed_logistic.sql
-- Or if using named instance:
--   sqlcmd -S localhost\SQLEXPRESS -E -i seed_logistic.sql

IF DB_ID(N'logistic') IS NULL
BEGIN
  CREATE DATABASE logistic;
END
GO

USE logistic;
GO

-- Temporarily disable FK constraints to allow reseeding in any order
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
            + N' NOCHECK CONSTRAINT ALL;' + CHAR(10)
FROM sys.tables t;
EXEC sys.sp_executesql @sql;

-- Clean (idempotent-ish for re-runs)
IF OBJECT_ID('USER_ROLES', 'U') IS NOT NULL DELETE FROM USER_ROLES;
IF OBJECT_ID('COD_TRANSACTIONS', 'U') IS NOT NULL DELETE FROM COD_TRANSACTIONS;
IF OBJECT_ID('VNPAY_TRANSACTIONS', 'U') IS NOT NULL DELETE FROM VNPAY_TRANSACTIONS;
IF OBJECT_ID('SHIPPER_TASKS', 'U') IS NOT NULL DELETE FROM SHIPPER_TASKS;
IF OBJECT_ID('PARCEL_ACTIONS', 'U') IS NOT NULL DELETE FROM PARCEL_ACTIONS;
IF OBJECT_ID('PARCEL_ROUTES', 'U') IS NOT NULL DELETE FROM PARCEL_ROUTES;
IF OBJECT_ID('TRACKING_CODES', 'U') IS NOT NULL DELETE FROM TRACKING_CODES;
IF OBJECT_ID('SERVICE_REQUESTS', 'U') IS NOT NULL DELETE FROM SERVICE_REQUESTS;
IF OBJECT_ID('CUSTOMER_ADDRESSES', 'U') IS NOT NULL DELETE FROM CUSTOMER_ADDRESSES;
IF OBJECT_ID('CUSTOMERS', 'U') IS NOT NULL DELETE FROM CUSTOMERS;
IF OBJECT_ID('STAFF', 'U') IS NOT NULL DELETE FROM STAFF;
IF OBJECT_ID('SHIPPERS', 'U') IS NOT NULL DELETE FROM SHIPPERS;
IF OBJECT_ID('ROUTES', 'U') IS NOT NULL DELETE FROM ROUTES;
IF OBJECT_ID('HUBS', 'U') IS NOT NULL DELETE FROM HUBS;
IF OBJECT_ID('ACTION_TYPES', 'U') IS NOT NULL DELETE FROM ACTION_TYPES;
IF OBJECT_ID('SERVICE_TYPES', 'U') IS NOT NULL DELETE FROM SERVICE_TYPES;
IF OBJECT_ID('SYSTEM_LOGS', 'U') IS NOT NULL DELETE FROM SYSTEM_LOGS;
IF OBJECT_ID('USERS', 'U') IS NOT NULL DELETE FROM USERS;
IF OBJECT_ID('ROLES', 'U') IS NOT NULL DELETE FROM ROLES;

-- ROLES
SET IDENTITY_INSERT ROLES ON;
INSERT INTO ROLES (role_id, role_name, description, status)
VALUES
  (1, 'ADMIN',   'System administrator', 'active'),
  (2, 'STAFF',   'Hub staff',            'active'),
  (3, 'SHIPPER', 'Delivery shipper',     'active'),
  (4, 'CUSTOMER','Customer user',        'active');
SET IDENTITY_INSERT ROLES OFF;

-- USERS
-- NOTE: password_hash here is only seed data (no security wired yet)
SET IDENTITY_INSERT USERS ON;
INSERT INTO USERS (
  user_id, username, password_hash, full_name, phone, email, status,
  avatar_url, last_login_at, created_at, updated_at
)
VALUES
  (1, 'admin',    'seed:admin123',    'Admin User',   '0900000001', 'admin@logistic.local',    'active', NULL, NULL, GETDATE(), GETDATE()),
  (2, 'staff01',  'seed:staff123',    'Staff One',    '0900000002', 'staff01@logistic.local',  'active', NULL, NULL, GETDATE(), GETDATE()),
  (3, 'shipper01','seed:shipper123',  'Shipper One',  '0900000003', 'shipper01@logistic.local','active', NULL, NULL, GETDATE(), GETDATE()),
  (4, 'cust01',   'seed:cust123',     'Customer One', '0900000004', 'cust01@logistic.local',   'active', NULL, NULL, GETDATE(), GETDATE()),
  (5, 'staff02',  'seed:staff123',    'Staff Two',    '0900000005', 'staff02@logistic.local',  'active', NULL, NULL, GETDATE(), GETDATE()),
  (6, 'staff03',  'seed:staff123',    'Staff Three',  '0900000006', 'staff03@logistic.local',  'active', NULL, NULL, GETDATE(), GETDATE()),
  (7, 'shipper02','seed:shipper123',  'Shipper Two',  '0900000007', 'shipper02@logistic.local','active', NULL, NULL, GETDATE(), GETDATE()),
  (8, 'shipper03','seed:shipper123',  'Shipper Three','0900000008', 'shipper03@logistic.local','active', NULL, NULL, GETDATE(), GETDATE()),
  (9, 'cust02',   'seed:cust123',     'Customer Two', '0900000009', 'cust02@logistic.local',   'active', NULL, NULL, GETDATE(), GETDATE()),
  (10,'cust03',   'seed:cust123',     'Customer Three','0900000010','cust03@logistic.local',   'active', NULL, NULL, GETDATE(), GETDATE()),
  (11,'custbiz01','seed:cust123',     'Biz Customer 01','0900000011','biz01@logistic.local',    'active', NULL, NULL, GETDATE(), GETDATE()),
  (12,'custbiz02','seed:cust123',     'Biz Customer 02','0900000012','biz02@logistic.local',    'active', NULL, NULL, GETDATE(), GETDATE());
SET IDENTITY_INSERT USERS OFF;

-- USER_ROLES (join table defined in User entity)
INSERT INTO USER_ROLES (user_id, role_id)
VALUES
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

-- HUBS
SET IDENTITY_INSERT HUBS ON;
INSERT INTO HUBS (
  hub_id, hub_name, address, ward, district, province,
  hub_level, status, created_at, contact_phone, email
)
VALUES
  (1, 'HCM Central Hub', '1 Nguyen Hue', 'Ben Nghe', 'Quan 1', 'Ho Chi Minh', 'central',  'active', GETDATE(), '0280000001', 'hcm-hub@logistic.local'),
  (2, 'Da Nang Hub',     '2 Bach Dang',  'Hai Chau 1','Hai Chau','Da Nang',   'regional', 'active', GETDATE(), '0236000002', 'dn-hub@logistic.local'),
  (3, 'Ha Noi Hub',      '3 Trang Tien', 'Trang Tien','Hoan Kiem','Ha Noi',   'central',  'active', GETDATE(), '0240000003', 'hn-hub@logistic.local'),
  (4, 'Can Tho Hub',     '4 Hoa Binh',   'An Cu',     'Ninh Kieu','Can Tho',  'regional', 'active', GETDATE(), '0292000004', 'ct-hub@logistic.local'),
  (5, 'Hai Phong Hub',   '5 Tran Phu',   'May To',    'Ngo Quyen','Hai Phong','regional', 'active', GETDATE(), '0225000005', 'hp-hub@logistic.local');
SET IDENTITY_INSERT HUBS OFF;

-- STAFF
SET IDENTITY_INSERT STAFF ON;
INSERT INTO STAFF (staff_id, user_id, hub_id, staff_position, status, joined_at)
VALUES
  (1, 2, 1, 'Dispatcher', 'active', GETDATE()),
  (2, 5, 2, 'Dispatcher', 'active', GETDATE()),
  (3, 6, 3, 'Dispatcher', 'active', GETDATE());
SET IDENTITY_INSERT STAFF OFF;

-- SHIPPERS
SET IDENTITY_INSERT SHIPPERS ON;
INSERT INTO SHIPPERS (shipper_id, user_id, hub_id, shipper_type, vehicle_type, status, joined_at, rating)
VALUES
  (1, 3, 1, 'fulltime', 'Motorbike', 'active', GETDATE(), 4.80),
  (2, 7, 2, 'fulltime', 'Motorbike', 'active', GETDATE(), 4.60),
  (3, 8, 3, 'parttime', 'Car',       'active', GETDATE(), 4.40);
SET IDENTITY_INSERT SHIPPERS OFF;

-- SERVICE_TYPES
SET IDENTITY_INSERT SERVICE_TYPES ON;
INSERT INTO SERVICE_TYPES (
  service_type_id, service_code, service_name,
  base_fee, extra_price_per_kg, cod_rate, cod_min_fee, insurance_rate, description
)
VALUES
  (1, 'STD', 'Standard Delivery', 20000.00, 5000.00, 0.0100, 5000.00, 0.0050, '2-4 days'),
  (2, 'EXP', 'Express Delivery',  35000.00, 7000.00, 0.0125, 7000.00, 0.0075, '1-2 days');
SET IDENTITY_INSERT SERVICE_TYPES OFF;

-- ACTION_TYPES
SET IDENTITY_INSERT ACTION_TYPES ON;
INSERT INTO ACTION_TYPES (action_type_id, action_code, action_name, description)
VALUES
  (1, 'CREATED',      'Request created',        'Customer creates request'),
  (2, 'PICKED_UP',    'Picked up',              'Parcel picked up from sender'),
  (3, 'ARRIVED_HUB',  'Arrived at hub',         'Parcel arrived at hub'),
  (4, 'OUT_FOR_DEL',  'Out for delivery',       'Parcel out for delivery'),
  (5, 'DELIVERED',    'Delivered',              'Parcel delivered to receiver');
SET IDENTITY_INSERT ACTION_TYPES OFF;

-- ROUTES
SET IDENTITY_INSERT ROUTES ON;
INSERT INTO ROUTES (route_id, from_hub_id, to_hub_id, estimated_time, description)
VALUES
  (1, 1, 2, 24, 'HCM -> Da Nang'),
  (2, 2, 3, 18, 'Da Nang -> Ha Noi'),
  (3, 1, 4, 10, 'HCM -> Can Tho'),
  (4, 4, 2, 20, 'Can Tho -> Da Nang'),
  (5, 3, 5, 8,  'Ha Noi -> Hai Phong'),
  (6, 2, 5, 22, 'Da Nang -> Hai Phong');
SET IDENTITY_INSERT ROUTES OFF;

-- CUSTOMERS
SET IDENTITY_INSERT CUSTOMERS ON;
INSERT INTO CUSTOMERS (
  customer_id, user_id, customer_type, business_name, status, created_at,
  email, phone, tax_code
)
VALUES
  (1, 4,  'individual', NULL,                'active', GETDATE(), 'cust01@logistic.local', '0900000004', NULL),
  (2, 9,  'individual', NULL,                'active', GETDATE(), 'cust02@logistic.local', '0900000009', NULL),
  (3, 10, 'individual', NULL,                'active', GETDATE(), 'cust03@logistic.local', '0900000010', NULL),
  (4, 11, 'business',   'ACME Trading Co.,',  'active', GETDATE(), 'biz01@logistic.local',  '0900000011', '0312345678'),
  (5, 12, 'business',   'Blue Ocean LLC',     'active', GETDATE(), 'biz02@logistic.local',  '0900000012', '0412345678');
SET IDENTITY_INSERT CUSTOMERS OFF;

-- CUSTOMER_ADDRESSES
SET IDENTITY_INSERT CUSTOMER_ADDRESSES ON;
INSERT INTO CUSTOMER_ADDRESSES (
  address_id, customer_id, contact_name, contact_phone, address_detail,
  ward, district, province, is_default, note
)
VALUES
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
SET IDENTITY_INSERT CUSTOMER_ADDRESSES OFF;

-- SERVICE_REQUESTS
SET IDENTITY_INSERT SERVICE_REQUESTS ON;
INSERT INTO SERVICE_REQUESTS (
  request_id,
  customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expected_pickup_time, note, imageOrder,
  status,
  weight, length, width, height,
  cod_amount, chargeable_weight,
  shipping_fee, cod_fee, insurance_fee, total_price, receiver_pay_amount,
  payment_status,
  current_hub_id,
  created_at
)
VALUES
  (
    1,
    1, 1, 2, 2,
    DATEADD(HOUR, 2, GETDATE()), 'Handle with care', NULL,
    'pending',
    1.50, 20.00, 15.00, 10.00,
    150000.00, 1.50,
    35000.00, 7000.00, 1000.00, 43000.00, 193000.00,
    'unpaid',
    1,
    GETDATE()
  ),
  (
    2,
    2, 3, 4, 1,
    DATEADD(HOUR, 1, GETDATE()), 'Fragile - glass', NULL,
    'picked',
    3.20, 35.00, 25.00, 20.00,
    0.00, 3.20,
    36000.00, 0.00, 0.00, 36000.00, 36000.00,
    'paid',
    1,
    GETDATE()
  ),
  (
    3,
    3, 5, 6, 2,
    DATEADD(MINUTE, 30, GETDATE()), 'Deliver before 5PM', NULL,
    'in_transit',
    0.80, 15.00, 10.00, 8.00,
    50000.00, 0.80,
    35000.00, 7000.00, 500.00, 42500.00, 92500.00,
    'unpaid',
    2,
    GETDATE()
  ),
  (
    4,
    4, 7, 8, 1,
    DATEADD(HOUR, 3, GETDATE()), 'Batch order #ACME-0007', NULL,
    'in_transit',
    12.50, 60.00, 40.00, 35.00,
    200000.00, 12.50,
    85000.00, 5000.00, 3000.00, 93000.00, 293000.00,
    'unpaid',
    1,
    GETDATE()
  ),
  (
    5,
    5, 9, 10, 2,
    DATEADD(MINUTE, 90, GETDATE()), 'Keep upright', NULL,
    'delivered',
    2.10, 25.00, 20.00, 18.00,
    0.00, 2.10,
    48000.00, 0.00, 0.00, 48000.00, 48000.00,
    'paid',
    5,
    DATEADD(DAY, -2, GETDATE())
  ),
  (
    6,
    1, 1, 2, 1,
    DATEADD(HOUR, 4, GETDATE()), 'Customer requests reschedule', NULL,
    'cancelled',
    1.00, 20.00, 15.00, 10.00,
    0.00, 1.00,
    20000.00, 0.00, 0.00, 20000.00, 20000.00,
    'unpaid',
    1,
    GETDATE()
  );
SET IDENTITY_INSERT SERVICE_REQUESTS OFF;

-- TRACKING_CODES
SET IDENTITY_INSERT TRACKING_CODES ON;
INSERT INTO TRACKING_CODES (tracking_id, request_id, code, created_at, status)
VALUES
  (1, 1, 'LK000001', GETDATE(), 'active'),
  (2, 2, 'LK000002', GETDATE(), 'active'),
  (3, 3, 'LK000003', GETDATE(), 'active'),
  (4, 4, 'LK000004', GETDATE(), 'active'),
  (5, 5, 'LK000005', GETDATE(), 'active'),
  (6, 6, 'LK000006', GETDATE(), 'inactive');
SET IDENTITY_INSERT TRACKING_CODES OFF;

-- SHIPPER_TASKS
SET IDENTITY_INSERT SHIPPER_TASKS ON;
INSERT INTO SHIPPER_TASKS (
  task_id, shipper_id, request_id, task_type,
  assigned_at, completed_at, task_status, result_note
)
VALUES
  (1, 1, 1, 'pickup', GETDATE(), NULL, 'assigned', 'Auto-assigned for pickup'),
  (2, 1, 2, 'pickup', GETDATE(), DATEADD(HOUR, 2, GETDATE()), 'completed', 'Picked up successfully'),
  (3, 2, 3, 'pickup', GETDATE(), NULL, 'assigned', 'Assigned to shipper02'),
  (4, 2, 4, 'delivery', GETDATE(), NULL, 'assigned', 'Delivery task created'),
  (5, 3, 5, 'delivery', DATEADD(DAY, -2, GETDATE()), DATEADD(HOUR, -44, GETDATE()), 'completed', 'Delivered and paid');
SET IDENTITY_INSERT SHIPPER_TASKS OFF;

-- PARCEL_ROUTES
SET IDENTITY_INSERT PARCEL_ROUTES ON;
INSERT INTO PARCEL_ROUTES (parcel_route_id, request_id, route_id, route_order, status)
VALUES
  (1, 1, 1, 1, 'planned'),
  (2, 1, 2, 2, 'planned'),
  (3, 2, 1, 1, 'planned'),
  (4, 2, 6, 2, 'planned'),
  (5, 3, 2, 1, 'planned'),
  (6, 3, 5, 2, 'planned'),
  (7, 4, 1, 1, 'planned'),
  (8, 4, 2, 2, 'planned'),
  (9, 5, 5, 1, 'planned'),
  (10,6, 1, 1, 'planned');
SET IDENTITY_INSERT PARCEL_ROUTES OFF;

-- PARCEL_ACTIONS
-- actor_id: user_id of staff/shipper, action_type_id from ACTION_TYPES
SET IDENTITY_INSERT PARCEL_ACTIONS ON;
INSERT INTO PARCEL_ACTIONS (
  action_id, request_id, action_type_id,
  from_hub_id, to_hub_id,
  actor_id, action_time, note
)
VALUES
  (1, 1, 1, NULL, NULL, 4, GETDATE(), 'Customer created request'),
  (2, 1, 2, NULL, 1,    3, DATEADD(HOUR, 3, GETDATE()), 'Picked up at sender'),
  (3, 2, 1, NULL, NULL, 9, GETDATE(), 'Customer created request'),
  (4, 2, 2, NULL, 1,    3, DATEADD(HOUR, 2, GETDATE()), 'Picked up and sent to hub'),
  (5, 2, 3, 1,    2,    2, DATEADD(HOUR, 6, GETDATE()), 'Arrived at Da Nang hub'),
  (6, 3, 1, NULL, NULL, 10, GETDATE(), 'Customer created request'),
  (7, 3, 2, NULL, 2,     7, DATEADD(HOUR, 1, GETDATE()), 'Picked up by shipper02'),
  (8, 3, 3, 2,    3,     5, DATEADD(HOUR, 10, GETDATE()), 'Transferred to Ha Noi hub'),
  (9, 4, 1, NULL, NULL, 11, GETDATE(), 'Business customer created request'),
  (10,4, 2, NULL, 1,     7, DATEADD(HOUR, 4, GETDATE()), 'Pickup at ACME warehouse'),
  (11,4, 3, 1,    2,     2, DATEADD(HOUR, 28, GETDATE()), 'Arrived at Da Nang hub'),
  (12,5, 1, NULL, NULL, 12, DATEADD(DAY, -2, GETDATE()), 'Business customer created request'),
  (13,5, 4, 3,    5,     8, DATEADD(HOUR, -46, GETDATE()), 'Out for delivery'),
  (14,5, 5, 3,    5,     8, DATEADD(HOUR, -44, GETDATE()), 'Delivered successfully'),
  (15,6, 1, NULL, NULL, 4, GETDATE(), 'Customer created request'),
  (16,6, 2, NULL, 1,     3, DATEADD(MINUTE, 30, GETDATE()), 'Picked up then cancelled by customer');
SET IDENTITY_INSERT PARCEL_ACTIONS OFF;

-- COD_TRANSACTIONS
SET IDENTITY_INSERT COD_TRANSACTIONS ON;
INSERT INTO COD_TRANSACTIONS (
  cod_tx_id, request_id, shipper_id, amount,
  collected_at, settled_at, status, paymentMethod
)
VALUES
  (1, 1, 1, 150000.00, NULL, NULL, 'pending', 'cash'),
  (2, 3, 2, 50000.00,  NULL, NULL, 'pending', 'cash'),
  (3, 4, 2, 200000.00, NULL, NULL, 'pending', 'cash');
SET IDENTITY_INSERT COD_TRANSACTIONS OFF;

-- VNPAY_TRANSACTIONS (optional example)
SET IDENTITY_INSERT VNPAY_TRANSACTIONS ON;
INSERT INTO VNPAY_TRANSACTIONS (
  vnpay_tx_id, request_id, amount,
  vnp_txn_ref, vnp_transaction_no, vnp_response_code, vnp_order_info,
  payment_status, paid_at, created_at
)
VALUES
  (1, 1, 43000.00, 'SEED-REF-0001', NULL, NULL, 'Shipping fee payment', 'pending', NULL, GETDATE()),
  (2, 2, 36000.00, 'SEED-REF-0002', 'TXN-0002', '00', 'Shipping fee payment', 'success', GETDATE(), GETDATE()),
  (3, 5, 48000.00, 'SEED-REF-0005', 'TXN-0005', '00', 'Shipping fee payment', 'success', DATEADD(HOUR, -44, GETDATE()), DATEADD(DAY, -2, GETDATE()));
SET IDENTITY_INSERT VNPAY_TRANSACTIONS OFF;

-- SYSTEM_LOGS
SET IDENTITY_INSERT SYSTEM_LOGS ON;
INSERT INTO SYSTEM_LOGS (log_id, user_id, action, object_type, object_id, log_time)
VALUES
  (1, 1, 'SEED_DB', 'DATABASE', 1, GETDATE()),
  (2, 1, 'CREATE_USER', 'USERS', 5, GETDATE()),
  (3, 1, 'CREATE_USER', 'USERS', 7, GETDATE()),
  (4, 2, 'ASSIGN_TASK', 'SHIPPER_TASKS', 1, GETDATE()),
  (5, 5, 'ASSIGN_TASK', 'SHIPPER_TASKS', 3, GETDATE());
SET IDENTITY_INSERT SYSTEM_LOGS OFF;

-- Re-enable FK constraints
DECLARE @sql2 NVARCHAR(MAX) = N'';
SELECT @sql2 += N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
             + N' WITH CHECK CHECK CONSTRAINT ALL;' + CHAR(10)
FROM sys.tables t;
EXEC sys.sp_executesql @sql2;

PRINT 'Database seeding completed successfully!';