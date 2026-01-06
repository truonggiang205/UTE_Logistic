package vn.web.logistic.service;

import java.util.List;

import vn.web.logistic.dto.response.inbound.ServiceRequestDTO;
import vn.web.logistic.dto.response.inbound.ServiceRequestDetailDTO;
import vn.web.logistic.dto.response.inbound.ServiceRequestSummaryDTO;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Route;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceType;

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
        ServiceRequest processInterHubInbound(String trackingCode, Long currentHubId, Long managerId,
                        Long actionTypeId);

        // --- CHỨC NĂNG 3: NHẬP KHO TỪ SHIPPER (PICKUP SUCCESS) ---
        // Xử lý logic: Cập nhật status 'picked' -> Cập nhật kho -> Ghi log -> Tạo
        // ParcelRoute
        // actionTypeId: ID của loại hành động được chọn từ danh sách
        // routeId: ID tuyến đường do Manager chọn (để tạo ParcelRoute)
        ServiceRequest processShipperInbound(String trackingCode, Long currentHubId, Long managerId,
                        Long actionTypeId, Long routeId);

        // --- CÁC HÀM HỖ TRỢ GIAO DIỆN ---
        List<CustomerAddress> getCustomerAddresses(String phone);

        List<ServiceType> getActiveServices();

        // Lấy danh sách tuyến đường xuất phát từ Hub (dùng cho Manager chọn tuyến)
        List<Route> getAvailableRoutes(Long hubId);

        // Lấy danh sách các loại hành động (ActionType) để Manager chọn khi quét mã
        List<ActionType> getInboundActionTypes();

        // --- CHỨC NĂNG HỖ TRỢ SHIPPER INBOUND NÂNG CAO ---

        /**
         * Tra cứu đơn hàng theo mã vận đơn (dùng để hiển thị chi tiết trước khi xác
         * nhận)
         */
        ServiceRequest getOrderByTrackingCode(String trackingCode);

        /**
         * Lấy danh sách đơn hàng đang chờ (pending) tại một Hub
         * Dùng để hiển thị danh sách đơn chờ shipper bàn giao
         */
        List<ServiceRequest> getPendingOrdersByHub(Long hubId);

        // --- CHỨC NĂNG CHUYỂN ĐỔI DTO (MVC Pattern) ---

        /**
         * Chuyển ServiceRequest sang DTO cơ bản
         */
        ServiceRequestDTO convertToDTO(ServiceRequest sr);

        /**
         * Chuyển ServiceRequest sang DTO chi tiết (đầy đủ thông tin)
         */
        ServiceRequestDetailDTO convertToDetailDTO(ServiceRequest sr);

        /**
         * Chuyển ServiceRequest sang DTO tóm tắt (cho danh sách)
         */
        ServiceRequestSummaryDTO convertToSummaryDTO(ServiceRequest sr);

        // --- CHỨC NĂNG THANH TOÁN VNPAY TẠI QUẦY ---

        /**
         * Tạo VNPay payment URL cho đơn drop-off
         * Tương tự như customer tạo đơn online nhưng dành cho Manager tại quầy
         * 
         * @param orderRequest  Dữ liệu đơn hàng
         * @param senderPhone   SĐT người gửi
         * @param receiverPhone SĐT người nhận
         * @param managerId     ID của Manager tạo đơn
         * @param routeId       ID tuyến đường
         * @param request       HttpServletRequest để lấy IP client
         * @return URL thanh toán VNPay
         */
        String createVnpayDropOffUrl(ServiceRequest orderRequest, String senderPhone, String receiverPhone,
                        Long managerId, Long routeId, jakarta.servlet.http.HttpServletRequest request) throws Exception;

        /**
         * Xử lý callback từ VNPay sau khi thanh toán
         * 
         * @param request HttpServletRequest chứa các parameters từ VNPay
         * @return URL redirect về trang kết quả
         */
        String processVnpayReturn(jakarta.servlet.http.HttpServletRequest request) throws Exception;
}
