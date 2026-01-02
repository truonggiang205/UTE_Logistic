package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.FileUploadService;
import vn.web.logistic.service.HubOrdersService;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class HubOrdersServiceImpl implements HubOrdersService {

    private final ServiceRequestRepository serviceRequestRepo;
    private final TrackingCodeRepository trackingCodeRepo;
    private final ParcelActionRepository parcelActionRepo;
    private final CodTransactionRepository codTransactionRepo;
    private final ParcelRouteRepository parcelRouteRepo;
    private final ContainerDetailRepository containerDetailRepo;
    private final FileUploadService fileUploadService;

    @Override
    public List<Map<String, Object>> getOrdersByHub(Long hubId, String status, String keyword) {
        List<ServiceRequest> orders;

        if (keyword != null && !keyword.isEmpty()) {
            // Tìm kiếm theo mã đơn hoặc SĐT
            orders = serviceRequestRepo.searchByKeyword(keyword);
            // Filter theo hub
            orders = orders.stream()
                    .filter(o -> o.getCurrentHub() != null && o.getCurrentHub().getHubId().equals(hubId))
                    .collect(Collectors.toList());
        } else if (status != null && !status.isEmpty()) {
            // Lọc theo trạng thái
            ServiceRequest.RequestStatus requestStatus = ServiceRequest.RequestStatus.valueOf(status);
            orders = serviceRequestRepo.findByHubIdAndStatus(hubId, requestStatus);
        } else {
            // Lấy tất cả đơn hàng của hub
            orders = serviceRequestRepo.findAllByHubId(hubId);
        }

        // Convert to DTO
        return orders.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public ServiceRequest updateOrder(Long requestId, Map<String, Object> updateData) {
        ServiceRequest order = serviceRequestRepo.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Đơn hàng không tồn tại: " + requestId));

        // Cập nhật trạng thái đơn hàng
        if (updateData.containsKey("status")) {
            String statusStr = (String) updateData.get("status");
            order.setStatus(ServiceRequest.RequestStatus.valueOf(statusStr));
        }

        // Cập nhật trạng thái thanh toán
        if (updateData.containsKey("paymentStatus")) {
            String paymentStatusStr = (String) updateData.get("paymentStatus");
            order.setPaymentStatus(ServiceRequest.PaymentStatus.valueOf(paymentStatusStr));
        }

        // Cập nhật tên hàng hóa
        if (updateData.containsKey("itemName")) {
            order.setItemName((String) updateData.get("itemName"));
        }

        // Cập nhật ghi chú
        if (updateData.containsKey("note")) {
            order.setNote((String) updateData.get("note"));
        }

        log.info("Cập nhật đơn hàng #{}: status={}, paymentStatus={}",
                requestId, order.getStatus(), order.getPaymentStatus());

        return serviceRequestRepo.save(order);
    }

    @Override
    @Transactional
    public void deleteOrder(Long requestId) {
        ServiceRequest order = serviceRequestRepo.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Đơn hàng không tồn tại: " + requestId));

        log.info("Bắt đầu xóa đơn hàng #{}", requestId);

        // 1. Xóa tracking codes
        trackingCodeRepo.deleteByRequest_RequestId(requestId);
        log.info("Đã xóa tracking codes của đơn hàng #{}", requestId);

        // 2. Xóa parcel actions (lịch sử hành động)
        parcelActionRepo.deleteByRequest_RequestId(requestId);
        log.info("Đã xóa parcel actions của đơn hàng #{}", requestId);

        // 3. Xóa COD transactions
        codTransactionRepo.deleteByRequest_RequestId(requestId);
        log.info("Đã xóa COD transactions của đơn hàng #{}", requestId);

        // 4. Xóa parcel routes
        parcelRouteRepo.deleteByRequest_RequestId(requestId);
        log.info("Đã xóa parcel routes của đơn hàng #{}", requestId);

        // 5. Xóa container details (nếu có)
        containerDetailRepo.deleteByRequest_RequestId(requestId);
        log.info("Đã xóa container details của đơn hàng #{}", requestId);

        // 6. Xóa ảnh nếu có
        if (order.getImageOrder() != null && !order.getImageOrder().isEmpty()) {
            fileUploadService.deleteImage(order.getImageOrder());
            log.info("Đã xóa ảnh của đơn hàng #{}", requestId);
        }

        // 7. Cuối cùng xóa đơn hàng
        serviceRequestRepo.delete(order);
        log.info("Đã xóa đơn hàng #{} thành công", requestId);
    }

    private Map<String, Object> convertToDTO(ServiceRequest order) {
        Map<String, Object> dto = new HashMap<>();
        dto.put("requestId", order.getRequestId());
        dto.put("status", order.getStatus() != null ? order.getStatus().name() : null);
        dto.put("paymentStatus", order.getPaymentStatus() != null ? order.getPaymentStatus().name() : null);
        dto.put("itemName", order.getItemName());
        dto.put("note", order.getNote());
        dto.put("totalPrice", order.getTotalPrice());
        dto.put("codAmount", order.getCodAmount());
        dto.put("createdAt", order.getCreatedAt());
        dto.put("imageOrder", order.getImageOrder());

        // Thông tin người gửi
        if (order.getPickupAddress() != null) {
            dto.put("senderName", order.getPickupAddress().getContactName());
            dto.put("senderPhone", order.getPickupAddress().getContactPhone());
        }

        // Thông tin người nhận
        if (order.getDeliveryAddress() != null) {
            dto.put("receiverName", order.getDeliveryAddress().getContactName());
            dto.put("receiverPhone", order.getDeliveryAddress().getContactPhone());
        }

        // Hub hiện tại
        if (order.getCurrentHub() != null) {
            dto.put("hubId", order.getCurrentHub().getHubId());
            dto.put("hubName", order.getCurrentHub().getHubName());
        }

        return dto;
    }
}
