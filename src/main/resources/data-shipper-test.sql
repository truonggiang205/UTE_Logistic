-- =============================================
-- DỮ LIỆU TEST BỔ SUNG CHO SHIPPER
-- Chạy file này SAU KHI đã chạy seed_logistic.sql
-- Tương thích schema Hibernate ngày 30/12/2025
-- =============================================

USE logistic;

-- =============================================
-- 1. THÊM ĐỊA CHỈ MỚI (dùng ID cao để tránh trùng)
-- =============================================
INSERT IGNORE INTO CUSTOMER_ADDRESSES (address_id, customer_id, contact_name, contact_phone, address_detail, ward, district, province, is_default, note) VALUES
-- Địa chỉ thêm cho Customer 1 (cust01)
(101, 1, 'Nguyễn Thị Mai', '0909111222', '123 Lý Tự Trọng', 'Bến Thành', 'Quận 1', 'Ho Chi Minh', 0, 'Giao giờ hành chính'),
(102, 1, 'Trần Văn Bình', '0909222333', '456 Điện Biên Phủ', 'Phường 25', 'Bình Thạnh', 'Ho Chi Minh', 0, 'Gọi trước 30 phút'),
(103, 1, 'Lê Hoàng Nam', '0909333444', '789 Võ Văn Tần', 'Phường 5', 'Quận 3', 'Ho Chi Minh', 0, NULL),
-- Địa chỉ thêm cho Customer 2 (cust02)
(104, 2, 'Phạm Thị Hoa', '0909444555', '101 Quang Trung', 'Phường 10', 'Gò Vấp', 'Ho Chi Minh', 0, 'Giao buổi chiều'),
(105, 2, 'Hoàng Văn Đức', '0909555666', '202 Nguyễn Văn Linh', 'Tân Thuận', 'Quận 7', 'Ho Chi Minh', 0, 'Tòa nhà văn phòng tầng 5'),
-- Địa chỉ thêm cho Customer 3 (cust03)
(106, 3, 'Vũ Thị Lan', '0909666777', '303 Cộng Hòa', 'Phường 4', 'Tân Bình', 'Ho Chi Minh', 0, NULL),
(107, 3, 'Đặng Minh Tuấn', '0909777888', '404 Phan Xích Long', 'Phường 2', 'Phú Nhuận', 'Ho Chi Minh', 0, 'Hẻm xe hơi');

-- =============================================
-- 2. THÊM SERVICE_REQUESTS (ĐƠN HÀNG MỚI)
-- Đơn từ 101-108 cho shipper01 (shipper_id = 1)
-- =============================================

INSERT IGNORE INTO SERVICE_REQUESTS (
  request_id, customer_id, pickup_address_id, delivery_address_id, service_type_id,
  expectedPickupTime, note, imageOrder, status, weight, length, width, height,
  cod_amount, chargeableWeight, shippingFee, codFee, insuranceFee, totalPrice,
  receiverPayAmount, paymentStatus, current_hub_id, createdAt
) VALUES
-- Đơn 101: Chờ lấy hàng (pickup assigned) - COD 350,000đ
(101, 1, 1, 101, 2, DATE_ADD(NOW(), INTERVAL 2 HOUR), 'Hàng dễ vỡ, xin nhẹ tay', NULL, 'pending', 2.50, 30.00, 20.00, 15.00, 350000.00, 2.50, 45000.00, 5000.00, 2000.00, 52000.00, 402000.00, 'unpaid', 1, NOW()),

-- Đơn 102: Đang lấy hàng (pickup in_progress) - COD 500,000đ
(102, 2, 3, 104, 1, DATE_ADD(NOW(), INTERVAL 1 HOUR), 'Gọi trước 15 phút', NULL, 'pending', 1.50, 25.00, 18.00, 12.00, 500000.00, 1.50, 30000.00, 6000.00, 3000.00, 39000.00, 539000.00, 'unpaid', 1, NOW()),

-- Đơn 103: Đã lấy xong, chờ giao (pickup completed, delivery assigned) - COD 750,000đ
(103, 3, 5, 106, 2, DATE_ADD(NOW(), INTERVAL -1 HOUR), 'Giao trong giờ hành chính 8h-17h', NULL, 'picked', 3.00, 40.00, 30.00, 25.00, 750000.00, 3.00, 55000.00, 8000.00, 4000.00, 67000.00, 817000.00, 'unpaid', 1, DATE_ADD(NOW(), INTERVAL -3 HOUR)),

-- Đơn 104: Đang giao hàng (delivery in_progress) - COD 200,000đ
(104, 1, 1, 102, 1, DATE_ADD(NOW(), INTERVAL -2 HOUR), NULL, NULL, 'in_transit', 0.50, 15.00, 10.00, 8.00, 200000.00, 0.50, 25000.00, 3000.00, 1000.00, 29000.00, 229000.00, 'unpaid', 1, DATE_ADD(NOW(), INTERVAL -4 HOUR)),

-- Đơn 105: Đã giao xong (delivery completed) - COD 0đ (thanh toán online)
(105, 2, 3, 105, 2, DATE_ADD(NOW(), INTERVAL -5 HOUR), 'Đã thanh toán online', NULL, 'delivered', 2.00, 28.00, 20.00, 16.00, 0.00, 2.00, 48000.00, 0.00, 0.00, 48000.00, 48000.00, 'paid', 1, DATE_ADD(NOW(), INTERVAL -8 HOUR)),

-- Đơn 106: Chờ lấy hàng (pickup assigned) - COD 1,200,000đ (đơn giá trị cao)
(106, 3, 5, 107, 2, DATE_ADD(NOW(), INTERVAL 3 HOUR), 'Hàng giá trị cao - điện thoại', NULL, 'pending', 1.00, 20.00, 12.00, 8.00, 1200000.00, 1.00, 40000.00, 12000.00, 6000.00, 58000.00, 1258000.00, 'unpaid', 1, NOW()),

-- Đơn 107: Chờ giao (delivery assigned) - COD 450,000đ
(107, 1, 1, 103, 1, DATE_ADD(NOW(), INTERVAL -30 MINUTE), 'Giao trước 18h', NULL, 'picked', 2.20, 32.00, 22.00, 18.00, 450000.00, 2.20, 35000.00, 5500.00, 2500.00, 43000.00, 493000.00, 'unpaid', 1, DATE_ADD(NOW(), INTERVAL -2 HOUR)),

-- Đơn 108: Giao thất bại (delivery failed) - COD 180,000đ
(108, 2, 3, 104, 1, DATE_ADD(NOW(), INTERVAL -6 HOUR), 'Khách hẹn giao lại ngày mai', NULL, 'failed', 1.80, 26.00, 18.00, 14.00, 180000.00, 1.80, 28000.00, 2800.00, 900.00, 31700.00, 211700.00, 'unpaid', 1, DATE_ADD(NOW(), INTERVAL -10 HOUR));

-- =============================================
-- 3. THÊM TRACKING_CODES CHO ĐƠN MỚI
-- =============================================
INSERT IGNORE INTO TRACKING_CODES (tracking_id, request_id, code, createdAt, status) VALUES
(101, 101, 'LK000101', NOW(), 'active'),
(102, 102, 'LK000102', NOW(), 'active'),
(103, 103, 'LK000103', NOW(), 'active'),
(104, 104, 'LK000104', NOW(), 'active'),
(105, 105, 'LK000105', NOW(), 'active'),
(106, 106, 'LK000106', NOW(), 'active'),
(107, 107, 'LK000107', NOW(), 'active'),
(108, 108, 'LK000108', NOW(), 'active');

-- =============================================
-- 4. THÊM SHIPPER_TASKS CHO SHIPPER01 (shipper_id = 1)
-- =============================================
INSERT IGNORE INTO SHIPPER_TASKS (task_id, shipper_id, request_id, taskType, assignedAt, completedAt, taskStatus, resultNote) VALUES
-- Task 101: Đơn 101 - Pickup chờ lấy
(101, 1, 101, 'pickup', NOW(), NULL, 'assigned', NULL),

-- Task 102: Đơn 102 - Pickup đang lấy
(102, 1, 102, 'pickup', DATE_ADD(NOW(), INTERVAL -30 MINUTE), NULL, 'in_progress', 'Đang trên đường đến địa điểm'),

-- Task 103: Đơn 103 - Pickup đã xong
(103, 1, 103, 'pickup', DATE_ADD(NOW(), INTERVAL -3 HOUR), DATE_ADD(NOW(), INTERVAL -2 HOUR), 'completed', 'Đã lấy hàng thành công'),

-- Task 104: Đơn 103 - Delivery chờ giao
(104, 1, 103, 'delivery', DATE_ADD(NOW(), INTERVAL -2 HOUR), NULL, 'assigned', NULL),

-- Task 105: Đơn 104 - Delivery đang giao
(105, 1, 104, 'delivery', DATE_ADD(NOW(), INTERVAL -1 HOUR), NULL, 'in_progress', 'Đang giao, còn 2km'),

-- Task 106: Đơn 105 - Delivery đã giao xong
(106, 1, 105, 'delivery', DATE_ADD(NOW(), INTERVAL -6 HOUR), DATE_ADD(NOW(), INTERVAL -5 HOUR), 'completed', 'Đã giao thành công, khách ký nhận'),

-- Task 107: Đơn 106 - Pickup chờ lấy (đơn giá trị cao)
(107, 1, 106, 'pickup', NOW(), NULL, 'assigned', NULL),

-- Task 108: Đơn 107 - Delivery chờ giao
(108, 1, 107, 'delivery', DATE_ADD(NOW(), INTERVAL -1 HOUR), NULL, 'assigned', NULL),

-- Task 109: Đơn 108 - Delivery thất bại
(109, 1, 108, 'delivery', DATE_ADD(NOW(), INTERVAL -8 HOUR), DATE_ADD(NOW(), INTERVAL -6 HOUR), 'failed', 'Khách không nghe máy, đã gọi 3 lần. Khách SMS hẹn giao lại ngày mai.');

-- =============================================
-- 5. THÊM COD_TRANSACTIONS
-- =============================================
INSERT IGNORE INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, paymentMethod) VALUES
-- COD pending (chờ thu) - chưa giao xong
(101, 101, 1, 350000.00, NULL, NULL, 'pending', NULL),
(102, 102, 1, 500000.00, NULL, NULL, 'pending', NULL),
-- COD collected (đã thu từ khách, chờ nộp về công ty) - ĐƠN ĐÃ GIAO XONG
(103, 103, 1, 750000.00, DATE_ADD(NOW(), INTERVAL -2 HOUR), NULL, 'collected', NULL),
(104, 104, 1, 200000.00, DATE_ADD(NOW(), INTERVAL -1 HOUR), NULL, 'collected', NULL),
(105, 107, 1, 450000.00, DATE_ADD(NOW(), INTERVAL -30 MINUTE), NULL, 'collected', NULL);

-- =============================================
-- 6. THÊM PARCEL_ROUTES
-- =============================================
INSERT IGNORE INTO PARCEL_ROUTES (parcel_route_id, request_id, route_id, route_order, status) VALUES
(101, 101, 1, 1, 'planned'),
(102, 102, 1, 1, 'planned'),
(103, 103, 1, 1, 'planned'),
(104, 104, 1, 1, 'planned'),
(105, 105, 1, 1, 'completed'),
(106, 106, 1, 1, 'planned'),
(107, 107, 1, 1, 'planned'),
(108, 108, 1, 1, 'planned');

-- =============================================
-- TỔNG KẾT DỮ LIỆU TEST CHO SHIPPER01
-- =============================================
-- 
-- PICKUP Tasks:
--   ├── 2 assigned (đơn 101, 106)
--   ├── 1 in_progress (đơn 102)
--   └── 1 completed (đơn 103)
--
-- DELIVERY Tasks:
--   ├── 2 assigned (đơn 103, 107)
--   ├── 1 in_progress (đơn 104)
--   ├── 1 completed (đơn 105)
--   └── 1 failed (đơn 108)
--
-- Tổng COD cần thu:
--   350,000 + 500,000 + 750,000 + 200,000 + 1,200,000 + 450,000 + 180,000 = 3,630,000đ
--
-- =============================================

SELECT '✅ Dữ liệu test cho Shipper đã được thêm thành công!' AS Result;
SELECT 'Đăng nhập: shipper01@logistic.local' AS LoginInfo;
SELECT CONCAT('Tổng đơn mới: ', COUNT(*)) AS TotalNewOrders FROM SERVICE_REQUESTS WHERE request_id >= 101;
SELECT CONCAT('Tổng task cho shipper01: ', COUNT(*)) AS TotalTasks FROM SHIPPER_TASKS WHERE shipper_id = 1;
