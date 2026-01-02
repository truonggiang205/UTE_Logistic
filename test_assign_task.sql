-- =====================================================
-- DỮ LIỆU TEST CHO CHỨC NĂNG PHÂN CÔNG SHIPPER
-- Bao gồm: PICKUP (lấy hàng) và DELIVERY (giao hàng)
-- Dựa trên cấu trúc seed_logistic.sql
-- Sử dụng ID từ 2000+ để tránh trùng
-- =====================================================

USE logistic;

-- Thêm ActionType PICKUP_DELAY nếu chưa có
INSERT IGNORE INTO ACTION_TYPES (action_type_id, action_code, action_name, description)
VALUES (11, 'PICKUP_DELAY', 'Lấy hàng thất bại', 'Shipper không lấy được hàng, cần phân công lại');

-- =====================================================
-- THÊM ĐỊA CHỈ PICKUP VÀ DELIVERY
-- Sử dụng customer_id hợp lệ (1-5 từ seed_logistic)
-- =====================================================
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note)
VALUES
  -- Địa chỉ PICKUP (người gửi) - Quận 1 (thuộc Hub 1)
  (2001, 1, 'Shop ABC', '0909200101', '100 Nguyen Hue', 'Ben Nghe', 'Quan 1', 'Ho Chi Minh', 0, 'Shop quần áo'),
  (2002, 1, 'Shop XYZ', '0909200102', '200 Le Loi', 'Ben Thanh', 'Quan 1', 'Ho Chi Minh', 0, 'Shop điện tử'),
  (2003, 2, 'Shop DEF', '0909200103', '50 Hai Ba Trung', 'Ben Nghe', 'Quan 1', 'Ho Chi Minh', 0, 'Shop mỹ phẩm'),
  
  -- Địa chỉ DELIVERY (người nhận) - Sử dụng customer_id hợp lệ
  (2010, 1, 'Nguyen Van A', '0909201001', '10 Nguyen Van Linh', 'Tan Phong', 'Quan 7', 'Ho Chi Minh', 0, 'Nhà riêng'),
  (2011, 1, 'Tran Thi B', '0909201002', '20 Le Van Luong', 'Tan Kieng', 'Quan 7', 'Ho Chi Minh', 0, 'Chung cư'),
  (2012, 2, 'Le Van C', '0909201003', '30 Pham Van Dong', 'Linh Dong', 'Thu Duc', 'Ho Chi Minh', 0, 'Nhà riêng');

-- =====================================================
-- ĐƠN CẦN PICKUP (status = pending, pickup ở Quận 1)
-- ĐƠN MỚI - CHƯA PHÂN CÔNG
-- =====================================================
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES
  -- Đơn chờ pickup - chưa phân công
  (2001, 1, 2001, 2010, 1, NOW(), 'Đơn cần lấy hàng 1', 'pending', 1.0, 20, 15, 10, 500000, 1.0, 25000, 5000, 1000, 31000, 531000, 'unpaid', NULL, NOW(), 'Áo thun nam'),
  (2002, 1, 2001, 2011, 1, NOW(), 'Đơn cần lấy hàng 2', 'pending', 0.5, 15, 10, 5, 300000, 0.5, 20000, 3000, 500, 23500, 323500, 'unpaid', NULL, NOW(), 'Quần jean'),
  (2003, 1, 2002, 2012, 2, NOW(), 'Đơn cần lấy hàng 3', 'pending', 0.3, 10, 8, 5, 800000, 0.3, 35000, 8000, 2000, 45000, 845000, 'unpaid', NULL, NOW(), 'Điện thoại Samsung'),
  (2004, 2, 2003, 2010, 1, NOW(), 'Đơn cần lấy hàng 4', 'pending', 0.2, 12, 8, 3, 200000, 0.2, 20000, 2000, 500, 22500, 222500, 'unpaid', NULL, NOW(), 'Son môi');

-- =====================================================
-- ĐƠN ĐÃ PICKUP (status = picked/in_transit) - CHỜ GIAO
-- =====================================================
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES
  -- Đơn đã pickup, đang ở Hub 1, chờ giao
  (2010, 1, 2001, 2010, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Đơn chờ giao 1', 'picked', 1.5, 25, 15, 10, 700000, 1.5, 28000, 7000, 1500, 36500, 736500, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Laptop Dell'),
  (2011, 1, 2002, 2011, 2, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Đơn chờ giao 2', 'picked', 0.8, 18, 12, 8, 1200000, 0.8, 35000, 12000, 3000, 50000, 1250000, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'iPhone 15'),
  (2012, 2, 2003, 2012, 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Đơn chờ giao 3', 'in_transit', 0.5, 15, 10, 5, 500000, 0.5, 25000, 5000, 1000, 31000, 531000, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Tai nghe AirPods');

-- =====================================================
-- ĐƠN ĐÃ PHÂN CÔNG (có task assigned/failed)
-- =====================================================

-- Đơn 2020: Đã phân công PICKUP cho shipper 1 (đang xử lý)
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (2020, 1, 2001, 2010, 1, NOW(), 'Đơn đang lấy hàng', 'pending', 0.5, 15, 10, 5, 400000, 0.5, 22000, 4000, 800, 26800, 426800, 'unpaid', NULL, NOW(), 'Giày Nike');

INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES (2020, 1, 2020, 'pickup', NOW(), NULL, 'assigned', 'Đang đi lấy hàng');

-- Đơn 2021: Pickup thất bại 1 lần - CÓ THỂ PHÂN CÔNG LẠI
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (2021, 1, 2002, 2011, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Đơn pickup thất bại 1 lần', 'pending', 0.3, 12, 8, 5, 350000, 0.3, 20000, 3500, 700, 24200, 374200, 'unpaid', NULL, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Đồng hồ Casio');

INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES (2021, 1, 2021, 'pickup', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 'failed', 'Shop đóng cửa');

-- Đơn 2022: Đã phân công DELIVERY cho shipper 1 (đang giao)
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (2022, 1, 2001, 2010, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Đơn đang giao', 'picked', 1.0, 20, 15, 10, 600000, 1.0, 26000, 6000, 1200, 33200, 633200, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Balo Laptop');

INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES (2022, 1, 2022, 'delivery', NOW(), NULL, 'assigned', 'Đang giao hàng');

-- Đơn 2023: Delivery thất bại 1 lần - CÓ THỂ PHÂN CÔNG LẠI
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (2023, 2, 2003, 2012, 1, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Đơn giao thất bại 1 lần', 'picked', 0.4, 14, 10, 6, 450000, 0.4, 23000, 4500, 900, 28400, 478400, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Nước hoa');

INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES (2023, 1, 2023, 'delivery', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 'failed', 'Khách không có nhà');

-- Đơn 2024: Delivery thất bại 2 lần - CÓ THỂ PHÂN CÔNG LẠI
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (2024, 1, 2001, 2011, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Đơn giao thất bại 2 lần', 'in_transit', 0.6, 16, 12, 8, 550000, 0.6, 24000, 5500, 1100, 30600, 580600, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Túi xách');

INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES 
  (2024, 1, 2024, 'delivery', DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY), 'failed', 'Địa chỉ sai'),
  (2025, 2, 2024, 'delivery', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), 'failed', 'Khách từ chối nhận');

-- =====================================================
-- HIỂN THỊ TÓM TẮT DỮ LIỆU TEST
-- =====================================================
SELECT '=== DỮ LIỆU TEST PHÂN CÔNG SHIPPER ĐÃ TẠO ===' AS message;

SELECT 'ĐƠN CẦN PICKUP (pending):' AS category, COUNT(*) AS total
FROM SERVICE_REQUESTS WHERE request_id >= 2000 AND status = 'pending';

SELECT 'ĐƠN CẦN GIAO (picked/in_transit):' AS category, COUNT(*) AS total
FROM SERVICE_REQUESTS WHERE request_id >= 2000 AND status IN ('picked', 'in_transit');

SELECT 'TASKS ĐÃ TẠO:' AS category, COUNT(*) AS total
FROM SHIPPER_TASKS WHERE request_id >= 2000;

-- =====================================================
-- THÔNG TIN ĐĂNG NHẬP
-- =====================================================
-- Staff Hub 1 (Quận 1): staff01@logistic.local / staff123
-- Shipper Hub 1: shipper01@logistic.local / shipper123
-- =====================================================
