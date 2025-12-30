-- =============================================
-- CẬP NHẬT COD TEST DATA
-- Flow: pending (đang giữ) → collected (đã nộp, chờ duyệt) → settled (đã duyệt)
-- Số tiền = receiverPayAmount (COD + Cước vận chuyển)
-- =============================================
USE logistic;

-- Xóa COD cũ
DELETE FROM COD_TRANSACTIONS WHERE cod_tx_id >= 101;

-- Insert COD mới
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, paymentMethod) VALUES
-- COD pending (shipper đang giữ tiền, chưa nộp) - Hiển thị ở "Danh sách cần nộp"
-- Request 103: COD 750,000 + Cước 67,000 = 817,000
(103, 103, 1, 817000.00, NULL, NULL, 'pending', NULL),
-- Request 104: COD 200,000 + Cước 29,000 = 229,000
(104, 104, 1, 229000.00, NULL, NULL, 'pending', NULL),
-- Request 107: COD 450,000 + Cước 43,000 = 493,000
(105, 107, 1, 493000.00, NULL, NULL, 'pending', NULL),
-- COD collected (shipper đã nộp, chờ Admin duyệt) - Hiển thị ở "Lịch sử nộp" với badge "Chờ duyệt"
(106, 105, 1, 48000.00, DATE_ADD(NOW(), INTERVAL -1 HOUR), NULL, 'collected', 'cash');

-- Kiểm tra kết quả
SELECT '=== COD pending (shipper đang giữ, chờ nộp) ===' AS Info;
SELECT cod_tx_id, request_id, amount as 'Số tiền (COD+Cước)', status FROM COD_TRANSACTIONS WHERE status = 'pending';

SELECT '=== COD collected (đã nộp, chờ Admin duyệt) ===' AS Info;
SELECT cod_tx_id, request_id, amount, status FROM COD_TRANSACTIONS WHERE status = 'collected';

SELECT CONCAT('Tổng tiền shipper đang giữ: ', FORMAT(IFNULL(SUM(amount), 0), 0), 'đ') AS Total 
FROM COD_TRANSACTIONS WHERE status = 'pending' AND shipper_id = 1;
