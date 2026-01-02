package vn.web.logistic.service;

import vn.web.logistic.entity.*;
import java.util.List;

public interface InboundService {

    // --- CHỨC NĂNG 1: TẠO ĐƠN TẠI QUẦY (DROP-OFF) ---
    // Xử lý logic: Khách hàng -> Địa chỉ -> Tính phí -> Lưu đơn -> Ghi log -> Tạo
    // giao dịch tiền
    // routeId: Tuyến đường do Manager chọn
    ServiceRequest createDropOffOrder(ServiceRequest orderRequest, String senderPhone, String receiverPhone,
            Long managerId, Long routeId);

    // --- CHỨC NĂNG 2: NHẬP KHO TỪ XE TẢI (INTER-HUB INBOUND) ---
    // Xử lý logic: Tìm đơn theo mã -> Cập nhật kho hiện tại -> Ghi log ParcelAction
    // actionTypeId: ID của loại hành động được chọn từ danh sách
    ServiceRequest processInterHubInbound(String trackingCode, Long currentHubId, Long managerId, Long actionTypeId);

    // --- CHỨC NĂNG 3: NHẬP KHO TỪ SHIPPER (PICKUP SUCCESS) ---
    // Xử lý logic: Cập nhật status 'picked' -> Cập nhật kho -> Ghi log
    // actionTypeId: ID của loại hành động được chọn từ danh sách
    ServiceRequest processShipperInbound(String trackingCode, Long currentHubId, Long managerId, Long actionTypeId);

    // --- CÁC HÀM HỖ TRỢ GIAO DIỆN ---
    List<CustomerAddress> getCustomerAddresses(String phone);

    List<ServiceType> getActiveServices();

    // Lấy danh sách tuyến đường xuất phát từ Hub (dùng cho Manager chọn tuyến)
    List<Route> getAvailableRoutes(Long hubId);

    // Lấy danh sách các loại hành động (ActionType) để Manager chọn khi quét mã
    List<ActionType> getInboundActionTypes();
}