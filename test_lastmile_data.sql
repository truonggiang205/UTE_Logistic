-- =====================================================
-- DỮ LIỆU TEST BỔ SUNG CHO CHỨC NĂNG LAST-MILE
-- Dựa trên seed_logistic.sql đã có
-- Sử dụng ID cao (1000+) để tránh trùng
-- =====================================================

USE logistic;

-- THÊM SHIPPERS MỚI CHO HUB 1 (để test filter)
INSERT INTO USERS (user_id, username, passwordHash, full_name, phone, email, status, createdAt)
VALUES
  (1020, 'shipper_hub1_a', 'seed:shipper123', 'Shipper Hub1 Test A', '0901111020', 'shipper_hub1_a@test.com', 'active', NOW()),
  (1021, 'shipper_hub1_b', 'seed:shipper123', 'Shipper Hub1 Test B', '0901111021', 'shipper_hub1_b@test.com', 'active', NOW());

INSERT INTO USER_ROLES (user_id, role_id) VALUES (1020, 3), (1021, 3);

INSERT INTO SHIPPERS (shipper_id, user_id, hub_id, shipperType, vehicle_type, status, joinedAt, rating)
VALUES
  (1001, 1020, 1, 'fulltime', 'Motorbike', 'active', NOW(), 4.50),
  (1002, 1021, 1, 'fulltime', 'Motorbike', 'busy', NOW(), 4.30);

-- THÊM ĐỊA CHỈ GIAO HÀNG MỚI
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note)
VALUES
  (1020, 1, 'Receiver Test X', '0900001201', '100 Nguyen Van Linh', 'Tan Phong', 'Quan 7', 'Ho Chi Minh', 0, 'Test delivery 1'),
  (1021, 1, 'Receiver Test Y', '0900001202', '200 Le Van Luong', 'Tan Kieng', 'Quan 7', 'Ho Chi Minh', 0, 'Test delivery 2'),
  (1022, 1, 'Receiver Test Z', '0900001203', '300 Pham Van Dong', 'Linh Dong', 'Thu Duc', 'Ho Chi Minh', 0, 'Test delivery 3'),
  (1023, 2, 'Receiver Test W', '0900001204', '50 Bach Dang', 'Hai Chau 1', 'Hai Chau', 'Da Nang', 0, 'Test delivery DN');

-- =====================================================
-- SERVICE REQUESTS ĐỂ TEST LAST-MILE
-- =====================================================

-- ĐƠN CHỜ GIAO (picked) - HUB 1
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES
  (1010, 1, 1, 1020, 1, NOW(), 'Test order 1010', 'picked', 1.0, 20, 15, 10, 500000, 1.0, 25000, 5000, 1000, 31000, 531000, 'unpaid', 1, NOW(), 'Điện thoại iPhone 15'),
  (1011, 1, 1, 1021, 1, NOW(), 'Test order 1011', 'picked', 0.5, 15, 10, 5, 300000, 0.5, 20000, 3000, 500, 23500, 323500, 'unpaid', 1, NOW(), 'Tai nghe AirPods Pro'),
  (1012, 1, 1, 1022, 2, NOW(), 'Test order 1012', 'picked', 2.0, 30, 20, 15, 1200000, 2.0, 35000, 12000, 2000, 49000, 1249000, 'unpaid', 1, NOW(), 'Laptop MacBook Air'),
  (1013, 1, 1, 1020, 1, NOW(), 'Test order 1013', 'picked', 0.3, 10, 8, 5, 200000, 0.3, 20000, 2000, 500, 22500, 222500, 'unpaid', 1, NOW(), 'Đồng hồ Apple Watch');

-- ĐƠN CHỜ GIAO (picked) - HUB 2 (Da Nang)
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES
  (1020, 2, 3, 1023, 1, NOW(), 'Test order DN 1020', 'picked', 1.5, 25, 15, 10, 800000, 1.5, 28000, 8000, 1500, 37500, 837500, 'unpaid', 2, NOW(), 'Máy ảnh Canon EOS'),
  (1021, 2, 3, 1023, 2, NOW(), 'Test order DN 1021', 'picked', 0.8, 18, 12, 8, 450000, 0.8, 35000, 5000, 1000, 41000, 491000, 'unpaid', 2, NOW(), 'Loa Bose SoundLink');

-- ĐƠN ĐÃ PHÂN CÔNG SHIPPER (có task assigned) - HUB 1
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES
  (1030, 1, 1, 1020, 1, NOW(), 'Assigned to shipper', 'picked', 0.5, 15, 10, 5, 350000, 0.5, 22000, 3500, 700, 26200, 376200, 'unpaid', 1, NOW(), 'Túi xách LV Original'),
  (1031, 1, 1, 1021, 1, NOW(), 'Assigned to shipper', 'picked', 1.2, 22, 18, 12, 750000, 1.2, 26000, 7500, 1500, 35000, 785000, 'unpaid', 1, NOW(), 'Giày Nike Air Jordan');

-- =====================================================
-- ĐƠN CẦN HOÀN HÀNG (3+ lần thất bại) - HUB 1
-- =====================================================

-- Đơn 1050: 3 lần thất bại, CHƯA kích hoạt hoàn (status = picked)
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (1050, 1, 1, 1020, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), '3 lần thất bại - chưa hoàn', 'picked', 0.8, 15, 12, 10, 2000000, 0.8, 30000, 20000, 5000, 55000, 2055000, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Máy ảnh Sony A7 (3 lần thất bại)');

-- Đơn 1051: 4 lần thất bại, CHƯA kích hoạt hoàn (status = picked)
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (1051, 1, 1, 1021, 1, DATE_SUB(NOW(), INTERVAL 8 DAY), '4 lần thất bại - chưa hoàn', 'picked', 3.0, 40, 30, 25, 5000000, 3.0, 45000, 50000, 10000, 105000, 5105000, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Máy in HP LaserJet (4 lần thất bại)');

-- Đơn 1052: 3 lần thất bại, ĐÃ kích hoạt hoàn (status = failed)
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (1052, 1, 1, 1022, 1, DATE_SUB(NOW(), INTERVAL 12 DAY), '3 lần thất bại - đã kích hoạt hoàn', 'failed', 0.5, 18, 12, 8, 1500000, 0.5, 25000, 15000, 3000, 43000, 1543000, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 15 DAY), 'Loa Bluetooth JBL (đã kích hoạt hoàn)');

-- =====================================================
-- ĐƠN CHỜ TRẢ SHOP (failed + đã về Hub gốc) - HUB 1
-- =====================================================

INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice, receiverPayAmount,
  paymentStatus, current_hub_id, createdAt, item_name
)
VALUES (1060, 1, 1, 1020, 1, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Chờ trả shop', 'failed', 0.3, 15, 10, 5, 500000, 0.3, 20000, 5000, 1000, 26000, 526000, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 'Đồ chơi trẻ em (chờ trả shop)');

-- =====================================================
-- SHIPPER TASKS
-- =====================================================

-- Tasks cho đơn đã phân công (sử dụng shipper hiện có: 1, 2, 3 và mới: 1001, 1002)
INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES
  (1010, 1, 1030, 'delivery', NOW(), NULL, 'assigned', 'Đang giao'),
  (1011, 1001, 1031, 'delivery', NOW(), NULL, 'assigned', 'Đang giao');

-- Tasks thất bại cho đơn 1050 (3 lần) - HUB 1
INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES
  (1050, 1, 1050, 'delivery', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), 'failed', 'Khách không có nhà'),
  (1051, 1001, 1050, 'delivery', DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY), 'failed', 'Khách từ chối nhận hàng'),
  (1052, 1002, 1050, 'delivery', DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY), 'failed', 'Không liên lạc được khách');

-- Tasks thất bại cho đơn 1051 (4 lần) - HUB 1
INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES
  (1060, 1, 1051, 'delivery', DATE_SUB(NOW(), INTERVAL 8 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY), 'failed', 'Địa chỉ sai'),
  (1061, 1001, 1051, 'delivery', DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY), 'failed', 'Khách đi vắng'),
  (1062, 1002, 1051, 'delivery', DATE_SUB(NOW(), INTERVAL 6 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY), 'failed', 'Khách hẹn mai nhưng không nhận'),
  (1063, 1, 1051, 'delivery', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), 'failed', 'Khách không nghe điện thoại');

-- Tasks thất bại cho đơn 1052 (3 lần - đã kích hoạt hoàn)
INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES
  (1070, 1, 1052, 'delivery', DATE_SUB(NOW(), INTERVAL 12 DAY), DATE_SUB(NOW(), INTERVAL 12 DAY), 'failed', 'Khách không có nhà'),
  (1071, 1001, 1052, 'delivery', DATE_SUB(NOW(), INTERVAL 11 DAY), DATE_SUB(NOW(), INTERVAL 11 DAY), 'failed', 'Số điện thoại sai'),
  (1072, 1002, 1052, 'delivery', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), 'failed', 'Khách từ chối nhận');

-- Tasks thất bại cho đơn 1060 (đơn chờ trả shop)
INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote)
VALUES
  (1080, 1, 1060, 'delivery', DATE_SUB(NOW(), INTERVAL 20 DAY), DATE_SUB(NOW(), INTERVAL 20 DAY), 'failed', 'Không giao được'),
  (1081, 1001, 1060, 'delivery', DATE_SUB(NOW(), INTERVAL 19 DAY), DATE_SUB(NOW(), INTERVAL 19 DAY), 'failed', 'Khách từ chối'),
  (1082, 1002, 1060, 'delivery', DATE_SUB(NOW(), INTERVAL 18 DAY), DATE_SUB(NOW(), INTERVAL 18 DAY), 'failed', 'Địa chỉ không tồn tại');

-- =====================================================
-- PARCEL ACTIONS (để xác định Hub gốc cho đơn chờ trả shop)
-- =====================================================

-- Actions PICKED_UP để đánh dấu Hub gốc (action_type_id = 2)
INSERT INTO PARCEL_ACTIONS (action_id, request_id, action_type_id, from_hub_id, to_hub_id, actor_id, actionTime, note)
VALUES
  (1050, 1050, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Lấy hàng thành công'),
  (1051, 1051, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Lấy hàng thành công'),
  (1052, 1052, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 15 DAY), 'Lấy hàng thành công'),
  (1060, 1060, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 25 DAY), 'Lấy hàng thành công');

-- =====================================================
-- COD TRANSACTIONS
-- =====================================================

-- Return fee cho đơn 1052 (đã kích hoạt hoàn)
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, transaction_type, paymentMethod)
VALUES (1052, 1052, NULL, 25000, NULL, NULL, 'pending', 'return_fee', 'CASH');

-- Return fee cho đơn 1060 (chờ trả shop)
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, transaction_type, paymentMethod)
VALUES (1060, 1060, NULL, 20000, NULL, NULL, 'pending', 'return_fee', 'CASH');

-- =====================================================
-- THÔNG TIN ĐĂNG NHẬP (từ seed_logistic.sql)
-- =====================================================
-- Staff Hub 1 (HCM): staff01@logistic.local / staff123
-- Staff Hub 2 (Da Nang): staff02@logistic.local / staff123
-- Staff Hub 3 (Ha Noi): staff03@logistic.local / staff123
-- =====================================================

SELECT '=== DỮ LIỆU TEST LAST-MILE ĐÃ ĐƯỢC TẠO THÀNH CÔNG ===' AS message;

-- Tóm tắt dữ liệu test
SELECT 'TỔNG QUAN DỮ LIỆU TEST:' AS info;

SELECT 'Shippers Hub 1 (HCM)' AS category, COUNT(*) AS count FROM SHIPPERS WHERE hub_id = 1
UNION ALL SELECT 'Shippers Hub 2 (Da Nang)', COUNT(*) FROM SHIPPERS WHERE hub_id = 2
UNION ALL SELECT 'Shippers Hub 3 (Ha Noi)', COUNT(*) FROM SHIPPERS WHERE hub_id = 3
UNION ALL SELECT 'Đơn chờ giao (picked) Hub 1', COUNT(*) FROM SERVICE_REQUESTS WHERE status = 'picked' AND current_hub_id = 1
UNION ALL SELECT 'Đơn chờ giao (picked) Hub 2', COUNT(*) FROM SERVICE_REQUESTS WHERE status = 'picked' AND current_hub_id = 2
UNION ALL SELECT 'Đơn hoàn hàng (failed) Hub 1', COUNT(*) FROM SERVICE_REQUESTS WHERE status = 'failed' AND current_hub_id = 1;

-- Hiển thị chi tiết đơn cần hoàn hàng
SELECT 'ĐƠN CẦN HOÀN HÀNG (3+ lần thất bại):' AS info;
SELECT 
    sr.request_id,
    sr.item_name,
    sr.status,
    h.hub_name AS current_hub,
    COUNT(st.task_id) AS failed_count
FROM SERVICE_REQUESTS sr
JOIN SHIPPER_TASKS st ON sr.request_id = st.request_id AND st.taskStatus = 'failed'
JOIN HUBS h ON sr.current_hub_id = h.hub_id
WHERE sr.request_id >= 1000
GROUP BY sr.request_id, sr.item_name, sr.status, h.hub_name
HAVING COUNT(st.task_id) >= 3
ORDER BY sr.request_id;
