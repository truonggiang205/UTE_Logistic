-- =============================================
-- FILE: cleanup-orphan-cod.sql
-- XÓA CÁC COD TRANSACTION ĐANG THAM CHIẾU ĐẾN REQUEST KHÔNG TỒN TẠI
-- Chạy file này để dọn dẹp dữ liệu không nhất quán
-- =============================================

USE logistic;

-- Bước 1: Hiển thị các COD Transaction đang orphan (không có request tương ứng)
SELECT 
    c.cod_tx_id, 
    c.request_id, 
    c.shipper_id, 
    c.amount, 
    c.status,
    'ORPHAN - Sẽ bị xóa' AS note
FROM COD_TRANSACTIONS c
LEFT JOIN SERVICE_REQUESTS r ON c.request_id = r.request_id
WHERE r.request_id IS NULL;

-- Bước 2: Xóa các COD Transaction orphan
DELETE c FROM COD_TRANSACTIONS c
LEFT JOIN SERVICE_REQUESTS r ON c.request_id = r.request_id
WHERE r.request_id IS NULL;

-- Bước 3: Kiểm tra lại
SELECT 'Đã xóa các COD Transaction orphan!' AS Result;
SELECT COUNT(*) AS 'Tổng COD còn lại' FROM COD_TRANSACTIONS;
