package vn.web.logistic.service;

import vn.web.logistic.entity.ServiceRequest;
import java.util.Map;

public interface OrderService {
    // Lưu đơn hàng mới kèm theo logic xử lý địa chỉ người nhận
    ServiceRequest createNewOrder(ServiceRequest request, Map<String, String> recipientInfo);
    
    // Tính toán toàn bộ phí (Ship, COD, Bảo hiểm) trước khi lưu
    ServiceRequest calculateAllFees(ServiceRequest request, boolean isHighValue);
    
 // Thêm vào file OrderService.java
    void updatePaymentStatus(String orderId, String status);
}