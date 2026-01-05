-- =============================================
-- DỮ LIỆU TEST CHO FLOW COD TRANSACTION
-- Chạy file này SAU KHI đã chạy seed_logistic.sql
-- Dùng để test: Shipper hoàn thành đơn → COD status = pending
-- Ngày tạo: 04/01/2026
-- =============================================

USE logistic;

-- =============================================
-- BƯỚC 1: XÓA DỮ LIỆU CŨ (từ test trước)
-- Tắt foreign key checks để tránh lỗi constraint
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM COD_TRANSACTIONS WHERE cod_tx_id >= 200;
DELETE FROM SHIPPER_TASKS WHERE task_id >= 200;
DELETE FROM PARCEL_ACTIONS WHERE action_id >= 200;
DELETE FROM TRACKING_CODES WHERE tracking_id >= 200;
DELETE FROM PARCEL_ROUTES WHERE parcel_route_id >= 200;
DELETE FROM SERVICE_REQUESTS WHERE request_id >= 200;
DELETE FROM CUSTOMER_ADDRESSES WHERE address_id >= 200;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- BƯỚC 2: THÊM ĐỊA CHỈ MỚI
-- =============================================
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note) VALUES
-- Địa chỉ gửi (pickup)
(200, 1, 'Anh Minh', '0901234567', '100 Nguyễn Huệ', 'Bến Nghé', 'Quận 1', 'Ho Chi Minh', 0, 'Tầng 5, tòa nhà ABC'),
(201, 2, 'Chị Hương', '0902345678', '200 Lê Lợi', 'Bến Thành', 'Quận 1', 'Ho Chi Minh', 0, 'Cửa hàng thời trang'),
(202, 3, 'Cô Lan', '0903456789', '300 Hai Bà Trưng', 'Phường 6', 'Quận 3', 'Ho Chi Minh', 0, NULL),
-- Địa chỉ nhận (delivery) 
(203, 1, 'Khách A', '0911111111', '50 Võ Văn Tần', 'Phường 5', 'Quận 3', 'Ho Chi Minh', 0, 'Gọi trước 30 phút'),
(204, 2, 'Khách B', '0922222222', '60 Cách Mạng Tháng 8', 'Phường 10', 'Quận 3', 'Ho Chi Minh', 0, 'Giao giờ hành chính'),
(205, 3, 'Khách C', '0933333333', '70 Điện Biên Phủ', 'Phường 25', 'Bình Thạnh', 'Ho Chi Minh', 0, NULL),
(206, 1, 'Khách D', '0944444444', '80 Xô Viết Nghệ Tĩnh', 'Phường 21', 'Bình Thạnh', 'Ho Chi Minh', 0, 'Tòa nhà văn phòng'),
(207, 2, 'Khách E', '0955555555', '90 Nguyễn Văn Linh', 'Tân Thuận', 'Quận 7', 'Ho Chi Minh', 0, 'Chung cư Sunrise');

-- =============================================
-- BƯỚC 3: TẠO ĐƠN HÀNG TEST
-- =============================================
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, item_name, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice,
  receiverPayAmount, paymentStatus, current_hub_id, createdAt
) VALUES
-- ======================
-- NHÓM 1: ĐƠN HÀNG ĐÃ PICK, CHỜ GIAO (để test confirmDelivery)
-- ======================
-- Đơn 201: COD 500,000đ - Chờ shipper giao
(201, 1, 200, 203, 1, NOW(), 'Điện thoại Samsung', 'Điện thoại Samsung Galaxy', 'picked', 
 0.50, 15.00, 8.00, 5.00, 500000.00, 0.50, 25000.00, 5000.00, 5000.00, 35000.00, 
 535000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 2 HOUR)),

-- Đơn 202: COD 300,000đ - Chờ shipper giao
(202, 2, 201, 204, 1, NOW(), 'Quần áo thời trang', 'Áo khoác nam', 'picked', 
 1.00, 30.00, 20.00, 10.00, 300000.00, 1.00, 22000.00, 3000.00, 3000.00, 28000.00, 
 328000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 3 HOUR)),

-- Đơn 203: COD 0đ (đã thanh toán) - Chờ shipper giao  
(203, 3, 202, 205, 2, NOW(), 'Đã thanh toán trước', 'Sách giáo khoa', 'picked', 
 2.00, 25.00, 18.00, 8.00, 0.00, 2.00, 38000.00, 0.00, 0.00, 38000.00, 
 38000.00, 'paid', 1, DATE_SUB(NOW(), INTERVAL 4 HOUR)),

-- ======================
-- NHÓM 2: ĐƠN DROP-OFF (đã có sẵn COD Transaction từ khi tạo đơn)
-- ======================
-- Đơn 204: Drop-off với COD 450,000đ - Đã có COD Transaction, chờ giao
(204, 1, 200, 206, 1, NOW(), 'Đơn drop-off tại quầy', 'Laptop cũ', 'picked', 
 3.00, 40.00, 30.00, 8.00, 450000.00, 3.00, 45000.00, 4500.00, 4500.00, 54000.00, 
 504000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 1 HOUR)),

-- Đơn 205: Drop-off với COD 800,000đ - Đã có COD Transaction, chờ giao  
(205, 2, 201, 207, 2, NOW(), 'Đơn drop-off - hàng giá trị cao', 'Tai nghe AirPods', 'picked', 
 0.30, 10.00, 8.00, 5.00, 800000.00, 0.30, 40000.00, 8000.00, 8000.00, 56000.00, 
 856000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 1 HOUR)),

-- ======================
-- NHÓM 3: ĐƠN CHỜ LẤY HÀNG (để test pickup flow)
-- ======================
-- Đơn 206: Chờ shipper đến lấy
(206, 3, 202, 205, 1, DATE_ADD(NOW(), INTERVAL 2 HOUR), 'Gọi trước khi đến', 'Mỹ phẩm', 'pending', 
 0.80, 20.00, 15.00, 10.00, 250000.00, 0.80, 20000.00, 2500.00, 2500.00, 25000.00, 
 275000.00, 'unpaid', NULL, NOW()),

-- Đơn 207: Chờ shipper đến lấy - Đơn giá trị cao
(207, 1, 200, 203, 2, DATE_ADD(NOW(), INTERVAL 1 HOUR), 'Hàng dễ vỡ', 'Đồng hồ cao cấp', 'pending', 
 0.20, 12.00, 12.00, 8.00, 2000000.00, 0.20, 35000.00, 20000.00, 20000.00, 75000.00, 
 2075000.00, 'unpaid', NULL, NOW());

-- =============================================
-- BƯỚC 4: TẠO TRACKING CODES
-- =============================================
INSERT INTO TRACKING_CODES (tracking_id, request_id, code, createdAt, status) VALUES
(201, 201, 'TK00000201', NOW(), 'active'),
(202, 202, 'TK00000202', NOW(), 'active'),
(203, 203, 'TK00000203', NOW(), 'active'),
(204, 204, 'TK00000204', NOW(), 'active'),
(205, 205, 'TK00000205', NOW(), 'active'),
(206, 206, 'TK00000206', NOW(), 'active'),
(207, 207, 'TK00000207', NOW(), 'active');

-- =============================================
-- BƯỚC 5: TẠO PARCEL ROUTES
-- =============================================
INSERT INTO PARCEL_ROUTES (parcel_route_id, request_id, route_id, route_order, status) VALUES
(201, 201, 1, 1, 'planned'),
(202, 202, 1, 1, 'planned'),
(203, 203, 1, 1, 'planned'),
(204, 204, 1, 1, 'planned'),
(205, 205, 1, 1, 'planned'),
(206, 206, 1, 1, 'planned'),
(207, 207, 1, 1, 'planned');

-- =============================================
-- BƯỚC 6: TẠO SHIPPER TASKS
-- Phân công cho shipper01 (shipper_id = 1)
-- =============================================
INSERT INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote) VALUES
-- Nhóm 1: Task DELIVERY cho đơn đã pick (để test confirmDelivery)
(201, 1, 201, 'delivery', DATE_SUB(NOW(), INTERVAL 1 HOUR), NULL, 'assigned', NULL),
(202, 1, 202, 'delivery', DATE_SUB(NOW(), INTERVAL 2 HOUR), NULL, 'assigned', NULL),
(203, 1, 203, 'delivery', DATE_SUB(NOW(), INTERVAL 3 HOUR), NULL, 'in_progress', 'Đang trên đường giao'),

-- Nhóm 2: Task DELIVERY cho đơn drop-off (đã có COD Transaction)
(204, 1, 204, 'delivery', DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL, 'assigned', NULL),
(205, 1, 205, 'delivery', DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL, 'assigned', NULL),

-- Nhóm 3: Task PICKUP cho đơn chờ lấy
(206, 1, 206, 'pickup', NOW(), NULL, 'assigned', NULL),
(207, 1, 207, 'pickup', NOW(), NULL, 'assigned', NULL);

-- =============================================
-- BƯỚC 7: TẠO COD TRANSACTIONS CHO ĐƠN DROP-OFF
-- Giả lập: Đơn 204, 205 được tạo từ drop-off nên đã có COD Transaction sẵn
-- =============================================
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, transaction_type, paymentMethod) VALUES
-- COD Transaction cho đơn 204 (drop-off) - shipper_id NULL vì chưa giao
(204, 204, NULL, 504000.00, NULL, NULL, 'pending', 'delivery_cod', NULL),
-- COD Transaction cho đơn 205 (drop-off) - shipper_id NULL vì chưa giao  
(205, 205, NULL, 856000.00, NULL, NULL, 'pending', 'delivery_cod', NULL);

-- =============================================
-- BƯỚC 8: GHI LOG PARCEL ACTIONS (Lịch sử đơn hàng)
-- =============================================
INSERT INTO PARCEL_ACTIONS (action_id, request_id, action_type_id, from_hub_id, to_hub_id, actor_id, actionTime, note) VALUES
-- Đơn 201: Đã tạo và lấy hàng
(201, 201, 1, NULL, NULL, 4, DATE_SUB(NOW(), INTERVAL 3 HOUR), 'Khách tạo đơn'),
(202, 201, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 2 HOUR), 'Shipper lấy hàng thành công'),
(203, 201, 6, 1, NULL, 2, DATE_SUB(NOW(), INTERVAL 1 HOUR), 'Phân công shipper giao hàng'),

-- Đơn 204: Drop-off, phân công giao
(204, 204, 1, NULL, 1, 4, DATE_SUB(NOW(), INTERVAL 1 HOUR), 'Khách gửi tại quầy (drop-off)'),
(205, 204, 6, 1, NULL, 2, DATE_SUB(NOW(), INTERVAL 30 MINUTE), 'Phân công shipper giao hàng'),

-- Đơn 205: Drop-off, phân công giao
(206, 205, 1, NULL, 1, 4, DATE_SUB(NOW(), INTERVAL 1 HOUR), 'Khách gửi tại quầy (drop-off)'),
(207, 205, 6, 1, NULL, 2, DATE_SUB(NOW(), INTERVAL 30 MINUTE), 'Phân công shipper giao hàng');

-- =============================================
-- TỔNG KẾT DỮ LIỆU TEST
-- =============================================
-- 
-- ✅ KỊCH BẢN TEST 1: Shipper giao đơn BÌNH THƯỜNG (không có COD Transaction trước)
--    - Đơn 201, 202, 203: Khi hoàn thành sẽ TẠO MỚI COD Transaction với status = 'pending'
--    - Đăng nhập: shipper01@logistic.local hoặc staff01@logistic.local (manager)
--    - API: POST /api/manager/lastmile/confirm-delivery với taskId = 201, 202, hoặc 203
--
-- ✅ KỊCH BẢN TEST 2: Shipper giao đơn DROP-OFF (đã có sẵn COD Transaction)
--    - Đơn 204, 205: Khi hoàn thành sẽ CẬP NHẬT COD Transaction (không tạo duplicate)
--    - Kiểm tra: shipper_id được cập nhật vào COD Transaction
--    - Status vẫn giữ là 'pending'
--
-- ✅ KỊCH BẢN TEST 3: Khách nhận tại quầy (counter pickup)
--    - Đơn 201-205 đều có thể test counter pickup
--    - API: POST /api/manager/lastmile/counter-pickup với requestId
--    - Kết quả: COD status = 'settled' (quyết toán ngay)
--
-- ✅ KỊCH BẢN TEST 4: Shipper nộp COD
--    - Sau khi hoàn thành đơn, vào trang COD để nộp tiền
--    - API: POST /api/shipper/cod/submit
--    - Kết quả: status từ 'pending' → 'collected'
--
-- =============================================

SELECT '✅ Dữ liệu test COD Transaction đã được tạo thành công!' AS Result;
SELECT '' AS '';
SELECT '📋 DANH SÁCH ĐƠN HÀNG TEST:' AS Title;
SELECT request_id, item_name, status, cod_amount, receiverPayAmount 
FROM SERVICE_REQUESTS WHERE request_id >= 200 ORDER BY request_id;

SELECT '' AS '';
SELECT '📋 SHIPPER TASKS CHO SHIPPER01:' AS Title;
SELECT task_id, request_id, taskType, taskStatus 
FROM SHIPPER_TASKS WHERE task_id >= 200 ORDER BY task_id;

SELECT '' AS '';
SELECT '📋 COD TRANSACTIONS HIỆN TẠI:' AS Title;
SELECT cod_tx_id, request_id, shipper_id, amount, status 
FROM COD_TRANSACTIONS WHERE cod_tx_id >= 200 ORDER BY cod_tx_id;

SELECT '' AS '';
SELECT '🔐 ĐĂNG NHẬP ĐỂ TEST:' AS Title;
SELECT 'Shipper: shipper01@logistic.local (password từ seed)' AS Account
UNION ALL
SELECT 'Manager: staff01@logistic.local (password từ seed)' AS Account;
