package vn.web.logistic.service;

import vn.web.logistic.entity.ServiceRequest;

import java.util.List;
import java.util.Map;

public interface HubOrdersService {

    /**
     * Lấy danh sách đơn hàng theo Hub
     * 
     * @param hubId   ID của Hub
     * @param status  Trạng thái đơn hàng (có thể null)
     * @param keyword Từ khóa tìm kiếm (có thể null)
     * @return Danh sách đơn hàng dạng DTO
     */
    List<Map<String, Object>> getOrdersByHub(Long hubId, String status, String keyword);

    /**
     * Cập nhật thông tin đơn hàng
     * 
     * @param requestId  ID đơn hàng
     * @param updateData Dữ liệu cần cập nhật
     * @return Đơn hàng đã cập nhật
     */
    ServiceRequest updateOrder(Long requestId, Map<String, Object> updateData);

    /**
     * Xóa đơn hàng và tất cả dữ liệu liên quan
     * 
     * @param requestId ID đơn hàng
     */
    void deleteOrder(Long requestId);
}
