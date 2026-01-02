-- =================================================================================
-- SQL Data to Create Orders for Manual Shipper Assignment (Hub 1)
-- =================================================================================
-- Target Hub: Hub ID 1 (HCM Central Hub, 'Quan 1')
-- Shipper: Shipper ID 1 (User 'shipper01') belongs to Hub 1
--
-- This script creates:
-- 1. Two new Service Requests (Orders):
--    - Order #1001: Status 'pending' with Pickup Address in 'Quan 1' (Matches Hub 1).
--    - Order #1002: Status 'in_transit' currently at Hub 1, ready for delivery.
-- 2. Required Customer Addresses.
-- 3. Tracking Codes.
-- 4. (Commented Out) Direct Assignment to Shipper 1.
-- =================================================================================

USE logistic;

-- 1. Create Addresses
-- -------------------
-- Pickup Address for Order #1001 (MUST match Hub 1's district 'Quan 1')
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note)
VALUES (101, 1, 'Sender Quan 1', '0901000001', '123 Nguyen Hue', 'Ben Nghe', 'Quan 1', 'Ho Chi Minh', 0, 'Test Pickup Loc');

-- Delivery Address for Order #1001 (Destination)
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note)
VALUES (102, 1, 'Receiver Other', '0901000002', '456 Le Duan', 'Hai Chau 1', 'Hai Chau', 'Da Nang', 0, 'Test Delivery Loc');

-- Pickup Address for Order #1002 (Origin)
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note)
VALUES (103, 1, 'Sender Other', '0901000003', '789 Tran Phu', 'May To', 'Ngo Quyen', 'Hai Phong', 0, 'Test Origin Loc');

-- Delivery Address for Order #1002 (Destination - Local delivery in Hub 1 area)
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note)
VALUES (104, 1, 'Receiver Quan 1', '0901000004', '321 Pasteur', 'Ben Nghe', 'Quan 1', 'Ho Chi Minh', 0, 'Test Final Loc');


-- 2. Create Service Requests
-- --------------------------
-- Request #1001: PENDING PICKUP (Ready for Assignment)
-- Status = 'pending', Payment = 'unpaid', Hub = 1 (assigned by system usually, or null, but for query context 'pending' + district is key)
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
) VALUES (
  1001, 1, 101, 102, 1,
  NOW(), 'Test Pickup Assignment', 'pending', 1.5, 20, 15, 10,
  500000.00, 1.5, 30000.00, 5000.00, 0.00, 35000.00, 535000.00,
  'unpaid', 1, NOW(), 'Test Item A'
);

-- Request #1002: PENDING DELIVERY (Ready for Assignment)
-- Status = 'in_transit' (or 'picked'/'arrived_hub'), Current Hub = 1
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
) VALUES (
  1002, 1, 103, 104, 1,
  NOW(), 'Test Delivery Assignment', 'in_transit', 2.0, 30, 20, 15,
  1000000.00, 2.0, 45000.00, 10000.00, 0.00, 55000.00, 1055000.00,
  'unpaid', 1, NOW(), 'Test Item B'
);


-- 3. Create Tracking Codes
-- ------------------------
INSERT INTO TRACKING_CODES (tracking_id, request_id, code, createdAt, status)
VALUES (1001, 1001, 'TK00001001', NOW(), 'active');

INSERT INTO TRACKING_CODES (tracking_id, request_id, code, createdAt, status)
VALUES (1002, 1002, 'TK00001002', NOW(), 'active');


-- 4. Manual Assignment (OPTIONAL)
-- -------------------------------
-- Run these lines if you want to bypass the UI assignment and assign directly via SQL.
-- Shipper ID 1 is in Hub 1.

INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, taskStatus, resultNote)
VALUES (1001, 1, 1001, 'pickup', NOW(), 'assigned', 'Manually Assigned via SQL');

INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, taskStatus, resultNote)
VALUES (1002, 1, 1002, 'delivery', NOW(), 'assigned', 'Manually Assigned via SQL');

