-- =============================================
-- DỮ LIỆU TEST CHO HUB 1 (QUẬN 1, HCM)
-- Chạy file này SAU KHI đã chạy seed_logistic.sql
-- Staff login: staff01@logistic.local (Manager Hub 1)
-- Shipper login: shipper01@logistic.local (Shipper Hub 1)
-- Ngày tạo: 04/01/2026
-- =============================================

USE logistic;

-- =============================================
-- BƯỚC 1: XÓA DỮ LIỆU TEST CŨ
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM COD_TRANSACTIONS WHERE cod_tx_id >= 300;
DELETE FROM SHIPPER_TASKS WHERE task_id >= 300;
DELETE FROM PARCEL_ACTIONS WHERE action_id >= 300;
DELETE FROM TRACKING_CODES WHERE tracking_id >= 300;
DELETE FROM PARCEL_ROUTES WHERE parcel_route_id >= 300;
DELETE FROM SERVICE_REQUESTS WHERE request_id >= 300;
DELETE FROM CUSTOMER_ADDRESSES WHERE address_id >= 300;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- BƯỚC 2: TẠO ĐỊA CHỈ TRONG QUẬN 1 (Để Hub 1 xử lý)
-- =============================================
INSERT INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note) VALUES
-- Địa chỉ LẤY HÀNG (pickup) - PHẢI TRONG QUẬN 1
(300, 1, 'Shop ABC', '0901111111', '10 Nguyễn Huệ', 'Bến Nghé', 'Quan 1', 'Ho Chi Minh', 0, 'Tầng 3, tòa nhà ABC'),
(301, 2, 'Shop XYZ', '0902222222', '20 Lê Lợi', 'Bến Thành', 'Quan 1', 'Ho Chi Minh', 0, 'Cạnh chợ Bến Thành'),
(302, 3, 'Kho Online', '0903333333', '30 Đồng Khởi', 'Bến Nghé', 'Quan 1', 'Ho Chi Minh', 0, 'Hẻm 30'),
(303, 1, 'Shop Fashion', '0904444444', '40 Nguyễn Trãi', 'Phạm Ngũ Lão', 'Quan 1', 'Ho Chi Minh', 0, 'Tầng 2'),

-- Địa chỉ GIAO HÀNG (delivery) - CŨNG TRONG QUẬN 1
(310, 1, 'Anh Minh', '0911111111', '100 Hàm Nghi', 'Bến Nghé', 'Quan 1', 'Ho Chi Minh', 0, 'Tòa nhà Bitexco'),
(311, 2, 'Chị Hương', '0912222222', '88 Pasteur', 'Bến Nghé', 'Quan 1', 'Ho Chi Minh', 0, 'Căn hộ 5A'),
(312, 3, 'Anh Tuấn', '0913333333', '50 Tôn Đức Thắng', 'Bến Nghé', 'Quan 1', 'Ho Chi Minh', 0, 'Gọi trước 30 phút'),
(313, 1, 'Cô Lan', '0914444444', '15 Hai Bà Trưng', 'Đa Kao', 'Quan 1', 'Ho Chi Minh', 0, 'VP tầng 10'),
(314, 2, 'Anh Nam', '0915555555', '77 Lý Tự Trọng', 'Bến Thành', 'Quan 1', 'Ho Chi Minh', 0, NULL);

-- =============================================
-- BƯỚC 3: TẠO ĐƠN HÀNG CHỜ LẤY (status = 'pending')
-- Đây là đơn chưa pickup, cần phân công shipper đi lấy
-- =============================================
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, item_name, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice,
  receiverPayAmount, paymentStatus, current_hub_id, createdAt
) VALUES
-- Đơn 301: Chờ lấy hàng - COD 500,000đ
(301, 1, 300, 310, 1, DATE_ADD(NOW(), INTERVAL 2 HOUR), 'Hàng dễ vỡ', 'Điện thoại iPhone 15', 
 'pending', 0.50, 15.00, 8.00, 5.00, 500000.00, 0.50, 25000.00, 5000.00, 5000.00, 35000.00, 
 535000.00, 'unpaid', NULL, NOW()),

-- Đơn 302: Chờ lấy hàng - COD 300,000đ
(302, 2, 301, 311, 1, DATE_ADD(NOW(), INTERVAL 1 HOUR), 'Gọi trước 15 phút', 'Quần áo thời trang', 
 'pending', 1.00, 30.00, 20.00, 10.00, 300000.00, 1.00, 22000.00, 3000.00, 2000.00, 27000.00, 
 327000.00, 'unpaid', NULL, NOW()),

-- Đơn 303: Chờ lấy hàng - COD 750,000đ
(303, 3, 302, 312, 2, DATE_ADD(NOW(), INTERVAL 3 HOUR), 'Giao trong giờ hành chính', 'Laptop Dell', 
 'pending', 3.00, 40.00, 30.00, 8.00, 750000.00, 3.00, 45000.00, 7500.00, 7500.00, 60000.00, 
 810000.00, 'unpaid', NULL, NOW()),

-- Đơn 304: Chờ lấy hàng - Đã thanh toán (COD = 0)
(304, 1, 303, 313, 1, DATE_ADD(NOW(), INTERVAL 2 HOUR), 'Đã thanh toán qua VNPAY', 'Sách giáo khoa', 
 'pending', 2.00, 25.00, 18.00, 5.00, 0.00, 2.00, 30000.00, 0.00, 0.00, 30000.00, 
 0.00, 'paid', NULL, NOW());

-- =============================================
-- BƯỚC 4: TẠO ĐƠN HÀNG ĐÃ ĐẾN HUB 1, CHỜ GIAO (status = 'in_transit')
-- current_hub_id = 1 để Hub 1 có thể phân công shipper giao
-- =============================================
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, item_name, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice,
  receiverPayAmount, paymentStatus, current_hub_id, createdAt
) VALUES
-- Đơn 311: Đã đến Hub, chờ giao - COD 450,000đ
(311, 1, 300, 310, 1, DATE_SUB(NOW(), INTERVAL 2 HOUR), 'Giao trước 18h', 'Tai nghe Sony', 
 'in_transit', 0.30, 15.00, 10.00, 8.00, 450000.00, 0.30, 20000.00, 4500.00, 4500.00, 29000.00, 
 479000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 4 HOUR)),

-- Đơn 312: Đã đến Hub, chờ giao - COD 200,000đ
(312, 2, 301, 311, 2, DATE_SUB(NOW(), INTERVAL 1 HOUR), NULL, 'Mỹ phẩm Hàn Quốc', 
 'in_transit', 0.50, 20.00, 15.00, 10.00, 200000.00, 0.50, 35000.00, 2000.00, 2000.00, 39000.00, 
 239000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 3 HOUR)),

-- Đơn 313: Đã đến Hub, chờ giao - COD 1,200,000đ (đơn giá trị cao)
(313, 3, 302, 312, 1, DATE_SUB(NOW(), INTERVAL 30 MINUTE), 'Hàng giá trị cao, cẩn thận', 'Đồng hồ Apple Watch', 
 'in_transit', 0.20, 12.00, 12.00, 6.00, 1200000.00, 0.20, 25000.00, 12000.00, 12000.00, 49000.00, 
 1249000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 2 HOUR)),

-- Đơn 314: Đã đến Hub, chờ giao - Không thu tiền (đã thanh toán)
(314, 1, 303, 313, 2, DATE_SUB(NOW(), INTERVAL 2 HOUR), 'Đã thanh toán online', 'Phụ kiện điện thoại', 
 'in_transit', 0.80, 20.00, 15.00, 10.00, 0.00, 0.80, 38000.00, 0.00, 0.00, 38000.00, 
 0.00, 'paid', 1, DATE_SUB(NOW(), INTERVAL 5 HOUR)),

-- Đơn 315: Đã đến Hub, chờ giao - COD 600,000đ
(315, 2, 301, 314, 1, DATE_SUB(NOW(), INTERVAL 3 HOUR), 'Giao giờ hành chính', 'Giày Nike', 
 'in_transit', 1.00, 35.00, 25.00, 15.00, 600000.00, 1.00, 28000.00, 6000.00, 6000.00, 40000.00, 
 640000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 6 HOUR));

-- =============================================
-- BƯỚC 5: TẠO TRACKING CODES
-- =============================================
INSERT INTO TRACKING_CODES (tracking_id, request_id, code, createdAt, status) VALUES
(301, 301, 'TK00000301', NOW(), 'active'),
(302, 302, 'TK00000302', NOW(), 'active'),
(303, 303, 'TK00000303', NOW(), 'active'),
(304, 304, 'TK00000304', NOW(), 'active'),
(311, 311, 'TK00000311', NOW(), 'active'),
(312, 312, 'TK00000312', NOW(), 'active'),
(313, 313, 'TK00000313', NOW(), 'active'),
(314, 314, 'TK00000314', NOW(), 'active'),
(315, 315, 'TK00000315', NOW(), 'active');

-- =============================================
-- BƯỚC 6: TẠO PARCEL ROUTES
-- =============================================
INSERT INTO PARCEL_ROUTES (parcel_route_id, request_id, route_id, route_order, status) VALUES
(301, 301, 1, 1, 'planned'),
(302, 302, 1, 1, 'planned'),
(303, 303, 1, 1, 'planned'),
(304, 304, 1, 1, 'planned'),
(311, 311, 1, 1, 'completed'),
(312, 312, 1, 1, 'completed'),
(313, 313, 1, 1, 'completed'),
(314, 314, 1, 1, 'completed'),
(315, 315, 1, 1, 'in_progress');

-- =============================================
-- BƯỚC 7: TẠO PARCEL ACTIONS (Lịch sử)
-- =============================================
INSERT INTO PARCEL_ACTIONS (action_id, request_id, action_type_id, from_hub_id, to_hub_id, actor_id, actionTime, note) VALUES
-- Đơn pickup (chưa lấy hàng, chỉ có action CREATED)
(301, 301, 1, NULL, NULL, 4, NOW(), 'Khách tạo đơn hàng'),
(302, 302, 1, NULL, NULL, 9, NOW(), 'Khách tạo đơn hàng'),
(303, 303, 1, NULL, NULL, 10, NOW(), 'Khách tạo đơn hàng'),
(304, 304, 1, NULL, NULL, 4, NOW(), 'Khách tạo đơn hàng'),

-- Đơn đã lấy (có action CREATED + PICKED_UP + ARRIVED_HUB)
(311, 311, 1, NULL, NULL, 4, DATE_SUB(NOW(), INTERVAL 6 HOUR), 'Khách tạo đơn hàng'),
(312, 311, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 4 HOUR), 'Shipper lấy hàng thành công'),
(313, 311, 3, NULL, 1, 2, DATE_SUB(NOW(), INTERVAL 2 HOUR), 'Đã nhập kho Hub 1'),

(314, 312, 1, NULL, NULL, 9, DATE_SUB(NOW(), INTERVAL 5 HOUR), 'Khách tạo đơn hàng'),
(315, 312, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 3 HOUR), 'Shipper lấy hàng thành công'),
(316, 312, 3, NULL, 1, 2, DATE_SUB(NOW(), INTERVAL 1 HOUR), 'Đã nhập kho Hub 1'),

(317, 313, 1, NULL, NULL, 10, DATE_SUB(NOW(), INTERVAL 4 HOUR), 'Khách tạo đơn hàng'),
(318, 313, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 2 HOUR), 'Shipper lấy hàng thành công'),

(319, 314, 1, NULL, NULL, 4, DATE_SUB(NOW(), INTERVAL 7 HOUR), 'Khách tạo đơn hàng'),
(320, 314, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 5 HOUR), 'Shipper lấy hàng thành công'),

(321, 315, 1, NULL, NULL, 9, DATE_SUB(NOW(), INTERVAL 8 HOUR), 'Khách tạo đơn hàng'),
(322, 315, 2, NULL, 1, 3, DATE_SUB(NOW(), INTERVAL 6 HOUR), 'Shipper lấy hàng thành công'),
(323, 315, 3, NULL, 1, 2, DATE_SUB(NOW(), INTERVAL 3 HOUR), 'Đã nhập kho Hub 1');

-- =============================================
-- BƯỚC 8: TẠO ĐƠN ĐÃ GIAO THÀNH CÔNG (status = 'delivered')
-- Để test quyết toán COD
-- =============================================
INSERT INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, item_name, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice,
  receiverPayAmount, paymentStatus, current_hub_id, createdAt
) VALUES
-- Đơn 321: Đã giao xong - COD 550,000đ
(321, 1, 300, 310, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Đã giao thành công', 'Điện thoại Xiaomi', 
 'delivered', 0.40, 15.00, 8.00, 5.00, 500000.00, 0.40, 22000.00, 5000.00, 5000.00, 32000.00, 
 532000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),

-- Đơn 322: Đã giao xong - COD 380,000đ
(322, 2, 301, 311, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Đã giao thành công', 'Túi xách nữ', 
 'delivered', 0.80, 25.00, 20.00, 15.00, 350000.00, 0.80, 20000.00, 3500.00, 3500.00, 27000.00, 
 377000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),

-- Đơn 323: Đã giao xong - COD 920,000đ
(323, 3, 302, 312, 2, DATE_SUB(NOW(), INTERVAL 6 HOUR), 'Đã giao thành công', 'Camera hành trình', 
 'delivered', 0.60, 18.00, 12.00, 10.00, 850000.00, 0.60, 35000.00, 8500.00, 8500.00, 52000.00, 
 902000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),

-- Đơn 324: Đã giao xong - COD 280,000đ
(324, 1, 303, 313, 1, DATE_SUB(NOW(), INTERVAL 4 HOUR), 'Đã giao thành công', 'Ốp lưng điện thoại', 
 'delivered', 0.20, 10.00, 8.00, 3.00, 250000.00, 0.20, 18000.00, 2500.00, 2500.00, 23000.00, 
 273000.00, 'unpaid', 1, DATE_SUB(NOW(), INTERVAL 8 HOUR));

-- Thêm tracking codes cho đơn đã giao
INSERT INTO TRACKING_CODES (tracking_id, request_id, code, createdAt, status) VALUES
(321, 321, 'TK00000321', DATE_SUB(NOW(), INTERVAL 2 DAY), 'active'),
(322, 322, 'TK00000322', DATE_SUB(NOW(), INTERVAL 2 DAY), 'active'),
(323, 323, 'TK00000323', DATE_SUB(NOW(), INTERVAL 1 DAY), 'active'),
(324, 324, 'TK00000324', DATE_SUB(NOW(), INTERVAL 8 HOUR), 'active');

-- =============================================
-- BƯỚC 9: TẠO COD TRANSACTIONS ĐÃ NỘP (status = 'collected')
-- Đây là COD shipper đã nộp về bưu cục, chờ Manager duyệt
-- =============================================
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, transaction_type, paymentMethod) VALUES
-- COD đã nộp, chờ duyệt (status = 'collected')
(321, 321, 1, 532000.00, DATE_SUB(NOW(), INTERVAL 2 HOUR), NULL, 'collected', 'delivery_cod', 'CASH'),
(322, 322, 1, 377000.00, DATE_SUB(NOW(), INTERVAL 2 HOUR), NULL, 'collected', 'delivery_cod', 'CASH'),
(323, 323, 1, 902000.00, DATE_SUB(NOW(), INTERVAL 1 HOUR), NULL, 'collected', 'delivery_cod', 'CASH'),
(324, 324, 1, 273000.00, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL, 'collected', 'delivery_cod', 'CASH');

-- =============================================
-- TỔNG KẾT DỮ LIỆU TEST
-- =============================================
-- 
-- ĐƠN CẦN LẤY HÀNG (PICKUP) - 4 đơn:
--   ├── #301: iPhone 15 - COD 535,000đ
--   ├── #302: Quần áo - COD 327,000đ  
--   ├── #303: Laptop Dell - COD 810,000đ
--   └── #304: Sách giáo khoa - Đã thanh toán (không thu tiền)
--
-- ĐƠN CẦN GIAO (DELIVERY) - 5 đơn tại Hub 1:
--   ├── #311: Tai nghe Sony - COD 479,000đ
--   ├── #312: Mỹ phẩm - COD 239,000đ
--   ├── #313: Apple Watch - COD 1,249,000đ (giá trị cao)
--   ├── #314: Phụ kiện ĐT - Đã thanh toán
--   └── #315: Giày Nike - COD 640,000đ
--
-- COD ĐÃ NỘP, CHỜ DUYỆT (collected) - 4 đơn:
--   ├── #321: Điện thoại Xiaomi - 532,000đ
--   ├── #322: Túi xách nữ - 377,000đ
--   ├── #323: Camera hành trình - 902,000đ
--   └── #324: Ốp lưng điện thoại - 273,000đ
--   Tổng: 2,084,000đ chờ Manager duyệt
--
-- ĐĂNG NHẬP:
--   Manager Hub 1: staff01@logistic.local
--   Shipper Hub 1: shipper01@logistic.local
--
-- =============================================

SELECT '✅ Dữ liệu test cho Hub 1 đã được tạo thành công!' AS Result;

SELECT '' AS '';
SELECT '📦 ĐƠN CẦN LẤY HÀNG (pickup trong Quận 1):' AS Title;
SELECT request_id, item_name, 
       CONCAT(FORMAT(cod_amount, 0), 'đ') as COD,
       CONCAT(FORMAT(receiverPayAmount, 0), 'đ') as 'Tổng thu',
       status 
FROM SERVICE_REQUESTS WHERE request_id BETWEEN 301 AND 304 ORDER BY request_id;

SELECT '' AS '';
SELECT '🚚 ĐƠN CẦN GIAO (delivery từ Hub 1):' AS Title;
SELECT request_id, item_name, 
       CONCAT(FORMAT(cod_amount, 0), 'đ') as COD,
       CONCAT(FORMAT(receiverPayAmount, 0), 'đ') as 'Tổng thu',
       status, current_hub_id 
FROM SERVICE_REQUESTS WHERE request_id BETWEEN 311 AND 315 ORDER BY request_id;

SELECT '' AS '';
SELECT '� COD ĐÃ NỘP, CHỜ MANAGER DUYỆT (collected):' AS Title;
SELECT c.cod_tx_id, c.request_id, r.item_name,
       CONCAT(FORMAT(c.amount, 0), 'đ') as 'Số tiền',
       c.status, c.collectedAt as 'Thời gian nộp'
FROM COD_TRANSACTIONS c 
JOIN SERVICE_REQUESTS r ON c.request_id = r.request_id
WHERE c.status = 'collected' AND c.shipper_id = 1
ORDER BY c.cod_tx_id;

SELECT CONCAT('Tổng cần duyệt: ', FORMAT(SUM(amount), 0), 'đ') AS 'Tổng'
FROM COD_TRANSACTIONS WHERE status = 'collected' AND shipper_id = 1;

