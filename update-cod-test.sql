-- Cập nhật/Thêm COD với status = collected để test
-- Số tiền = receiverPayAmount (COD + Cước vận chuyển)
USE logistic;

-- Xóa COD cũ
DELETE FROM COD_TRANSACTIONS WHERE cod_tx_id >= 101;

-- Insert COD mới với status collected
-- Amount = receiverPayAmount từ SERVICE_REQUESTS (COD + Cước)
INSERT INTO COD_TRANSACTIONS (cod_tx_id, request_id, shipper_id, amount, collectedAt, settledAt, status, paymentMethod) VALUES
-- COD pending (chờ thu) - chưa giao xong
-- Request 101: COD 350,000 + Cước 52,000 = 402,000
(101, 101, 1, 402000.00, NULL, NULL, 'pending', NULL),
-- Request 102: COD 500,000 + Cước 39,000 = 539,000
(102, 102, 1, 539000.00, NULL, NULL, 'pending', NULL),
-- COD collected (đã thu từ khách, chờ nộp về công ty) - ĐƠN ĐÃ GIAO XONG
-- Request 103: COD 750,000 + Cước 67,000 = 817,000
(103, 103, 1, 817000.00, DATE_ADD(NOW(), INTERVAL -2 HOUR), NULL, 'collected', NULL),
-- Request 104: COD 200,000 + Cước 29,000 = 229,000
(104, 104, 1, 229000.00, DATE_ADD(NOW(), INTERVAL -1 HOUR), NULL, 'collected', NULL),
-- Request 107: COD 450,000 + Cước 43,000 = 493,000
(105, 107, 1, 493000.00, DATE_ADD(NOW(), INTERVAL -30 MINUTE), NULL, 'collected', NULL);

-- Kiểm tra kết quả
SELECT 'COD với status collected (đã thu, chờ nộp):' AS Info;
SELECT cod_tx_id, request_id, shipper_id, amount as 'Tổng tiền (COD+Cước)', status FROM COD_TRANSACTIONS WHERE status = 'collected';
SELECT CONCAT('Tổng cần nộp: ', FORMAT(SUM(amount), 0), 'đ') AS Total FROM COD_TRANSACTIONS WHERE status = 'collected' AND shipper_id = 1;
