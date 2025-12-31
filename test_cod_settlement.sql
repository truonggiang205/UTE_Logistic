-- ============================================
-- TEST DATA cho COD Settlement
-- Chạy file này để tạo dữ liệu test quyết toán COD
-- Request ID có sẵn: 1, 2, 3, 4, 5, 6
-- Shipper ID có sẵn: 1, 2 (thuộc Hub 1)
-- ============================================

-- Xóa dữ liệu COD cũ
DELETE FROM COD_TRANSACTIONS;

-- Thêm COD Transactions với các trạng thái khác nhau
-- Shipper 1 (thuộc Hub 1) - có 3 COD chờ quyết toán
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, paymentMethod) VALUES
(1, 1, 1, 500000.00, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL, 'collected', 'cash'),
(2, 3, 1, 350000.00, DATE_SUB(NOW(), INTERVAL 2 DAY), NULL, 'collected', 'cash'),
(3, 4, 1, 280000.00, DATE_SUB(NOW(), INTERVAL 3 HOUR), NULL, 'collected', 'transfer');

-- Shipper 2 (thuộc Hub 1) - có 2 COD chờ quyết toán
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, paymentMethod) VALUES
(4, 2, 2, 150000.00, DATE_SUB(NOW(), INTERVAL 5 HOUR), NULL, 'collected', 'cash'),
(5, 5, 2, 420000.00, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL, 'collected', 'cash');

-- COD pending (chưa giao hàng, shipper chưa thu tiền)
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, paymentMethod) VALUES
(6, 6, 1, 300000.00, NULL, NULL, 'pending', 'cash');

-- ============================================
-- KIỂM TRA DỮ LIỆU
-- ============================================
SELECT 'COD chờ quyết toán (collected)' AS type, COUNT(*) AS count, SUM(amount) AS total FROM COD_TRANSACTIONS WHERE status = 'collected';
SELECT 'COD pending' AS type, COUNT(*) AS count, SUM(amount) AS total FROM COD_TRANSACTIONS WHERE status = 'pending';

-- Kiểm tra shipper có COD collected theo Hub
SELECT 
    s.shipper_id,
    u.full_name AS shipper_name,
    h.hub_name,
    COUNT(c.cod_tx_id) AS cod_count,
    SUM(c.amount) AS total_amount
FROM COD_TRANSACTIONS c
JOIN SHIPPERS s ON c.shipper_id = s.shipper_id
JOIN USERS u ON s.user_id = u.user_id
JOIN HUBS h ON s.hub_id = h.hub_id
WHERE c.status = 'collected'
GROUP BY s.shipper_id, u.full_name, h.hub_name;
