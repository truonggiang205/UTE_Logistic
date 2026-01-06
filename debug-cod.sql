-- =============================================
-- KIỂM TRA DỮ LIỆU COD COLLECTED TRONG DATABASE
-- =============================================

USE logistic;

-- 1. Xem tất cả COD Transactions
SELECT 
    cod_tx_id, 
    request_id, 
    shipper_id, 
    CONCAT(FORMAT(amount, 0), 'đ') as amount, 
    status,
    collectedAt
FROM COD_TRANSACTIONS 
ORDER BY cod_tx_id;

-- 2. Xem COD collected (đã nộp, chờ duyệt)
SELECT 
    c.cod_tx_id, 
    c.request_id, 
    c.shipper_id, 
    s.hub_id as shipper_hub_id,
    CONCAT(FORMAT(c.amount, 0), 'đ') as amount, 
    c.status
FROM COD_TRANSACTIONS c
LEFT JOIN SHIPPERS s ON c.shipper_id = s.shipper_id
WHERE c.status = 'collected';

-- 3. Kiểm tra Shipper 1 thuộc Hub nào
SELECT shipper_id, user_id, hub_id, status FROM SHIPPERS WHERE shipper_id = 1;

-- 4. Kiểm tra Hub 1
SELECT hub_id, hub_name, district FROM HUBS WHERE hub_id = 1;

-- 5. Query giống như trong Repository
SELECT DISTINCT c.shipper_id 
FROM COD_TRANSACTIONS c 
JOIN SHIPPERS s ON c.shipper_id = s.shipper_id
WHERE c.status = 'collected' AND s.hub_id = 1;

-- 6. Thêm dữ liệu test nếu chưa có
-- Xóa dữ liệu cũ
DELETE FROM COD_TRANSACTIONS WHERE cod_tx_id IN (401, 402, 403, 404);

-- Insert COD collected cho Hub 1
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, transaction_type, paymentMethod) VALUES
(401, 1, 1, 193000.00, NOW(), NULL, 'collected', 'delivery_cod', 'CASH'),
(402, 2, 1, 36000.00, NOW(), NULL, 'collected', 'delivery_cod', 'CASH'),
(403, 3, 1, 92500.00, NOW(), NULL, 'collected', 'delivery_cod', 'CASH');

-- 7. Kiểm tra lại
SELECT 'COD COLLECTED CHO SHIPPER 1 (HUB 1):' as Title;
SELECT 
    c.cod_tx_id, 
    c.request_id, 
    c.shipper_id,
    s.hub_id,
    CONCAT(FORMAT(c.amount, 0), 'đ') as amount, 
    c.status
FROM COD_TRANSACTIONS c
JOIN SHIPPERS s ON c.shipper_id = s.shipper_id
WHERE c.status = 'collected' AND s.hub_id = 1;
