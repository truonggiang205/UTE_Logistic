-- =============================================
-- Insert Action Types cho Shipper Actions
-- File này chứa các action types cần thiết để ghi nhận lịch sử xử lý đơn hàng
-- =============================================

-- PICKUP Actions
INSERT INTO ACTION_TYPES (action_code, action_name, description) VALUES
('PICKUP_STARTED', 'Bắt đầu lấy hàng', 'Shipper bắt đầu quá trình lấy hàng'),
('PICKUP_COMPLETED', 'Lấy hàng thành công', 'Shipper đã lấy hàng thành công từ người gửi'),
('PICKUP_FAILED', 'Lấy hàng thất bại', 'Shipper không thể lấy được hàng'),
('PICKUP_UPDATED', 'Cập nhật lấy hàng', 'Shipper cập nhật trạng thái lấy hàng');

-- DELIVERY Actions  
INSERT INTO ACTION_TYPES (action_code, action_name, description) VALUES
('DELIVERY_STARTED', 'Bắt đầu giao hàng', 'Shipper bắt đầu quá trình giao hàng'),
('DELIVERY_COMPLETED', 'Giao hàng thành công', 'Shipper đã giao hàng thành công cho người nhận'),
('DELIVERY_FAILED', 'Giao hàng thất bại', 'Shipper không thể giao được hàng'),
('DELIVERY_UPDATED', 'Cập nhật giao hàng', 'Shipper cập nhật trạng thái giao hàng');

-- HUB Actions (dùng cho việc chuyển hàng giữa các hub)
INSERT INTO ACTION_TYPES (action_code, action_name, description) VALUES
('HUB_RECEIVED', 'Đã nhận tại hub', 'Đơn hàng đã được nhận tại hub'),
('HUB_DEPARTED', 'Đã rời hub', 'Đơn hàng đã rời hub đến điểm tiếp theo'),
('IN_TRANSIT', 'Đang vận chuyển', 'Đơn hàng đang được vận chuyển');

-- ORDER Actions
INSERT INTO ACTION_TYPES (action_code, action_name, description) VALUES
('ORDER_CREATED', 'Tạo đơn hàng', 'Đơn hàng được tạo mới'),
('ORDER_CONFIRMED', 'Xác nhận đơn', 'Đơn hàng đã được xác nhận'),
('ORDER_CANCELLED', 'Hủy đơn', 'Đơn hàng đã bị hủy'),
('ORDER_RETURNED', 'Hoàn trả', 'Đơn hàng bị hoàn trả về người gửi');
