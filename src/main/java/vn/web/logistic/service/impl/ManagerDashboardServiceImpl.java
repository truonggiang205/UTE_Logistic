package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.response.manager.ActionHistoryResponse;
import vn.web.logistic.dto.response.manager.ManagerDashboardStatsResponse;
import vn.web.logistic.dto.response.manager.OrderTrackingResponse;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.ParcelAction;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.Shipper;
import vn.web.logistic.repository.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ManagerDashboardServiceImpl implements vn.web.logistic.service.ManagerDashboardService {

    private final ServiceRequestRepository serviceRequestRepository;
    private final CodTransactionRepository codTransactionRepository;
    private final ShipperRepository shipperRepository;
    private final ShipperTaskRepository shipperTaskRepository;
    private final ParcelActionRepository parcelActionRepository;

    @Override
    public ManagerDashboardStatsResponse getManagerStats(Long hubId) {
        // Logic A: Đếm số lượng đơn hàng theo trạng thái trong Hub
        long totalOrders = serviceRequestRepository.countByHubId(hubId);
        long pendingCount = serviceRequestRepository.countByHubIdAndStatus(hubId, ServiceRequest.RequestStatus.pending);
        long pickedCount = serviceRequestRepository.countByHubIdAndStatus(hubId, ServiceRequest.RequestStatus.picked);
        long inTransitCount = serviceRequestRepository.countByHubIdAndStatus(hubId,
                ServiceRequest.RequestStatus.in_transit);
        long deliveredCount = serviceRequestRepository.countByHubIdAndStatus(hubId,
                ServiceRequest.RequestStatus.delivered);
        long cancelledCount = serviceRequestRepository.countByHubIdAndStatus(hubId,
                ServiceRequest.RequestStatus.cancelled);
        long failedCount = serviceRequestRepository.countByHubIdAndStatus(hubId, ServiceRequest.RequestStatus.failed);

        // Logic B: Tính tổng tiền COD đang pending và đã thu
        BigDecimal currentCodPendingAmount = codTransactionRepository.sumPendingCodByHubId(hubId);
        BigDecimal totalCodCollected = codTransactionRepository.sumCollectedCodByHubId(hubId);

        // Đếm số shipper đang hoạt động (active hoặc busy)
        long activeShipperCount = shipperRepository.countActiveShippersByHubId(
                hubId,
                Arrays.asList(Shipper.ShipperStatus.active, Shipper.ShipperStatus.busy));

        // Đếm số task hôm nay
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        long todayTaskCount = shipperTaskRepository.countTodayTasksByHubId(hubId, startOfDay);

        return ManagerDashboardStatsResponse.builder()
                .totalOrders(totalOrders)
                .pendingCount(pendingCount)
                .pickedCount(pickedCount)
                .inTransitCount(inTransitCount)
                .deliveredCount(deliveredCount)
                .cancelledCount(cancelledCount)
                .failedCount(failedCount)
                .currentCodPendingAmount(currentCodPendingAmount != null ? currentCodPendingAmount : BigDecimal.ZERO)
                .totalCodCollected(totalCodCollected != null ? totalCodCollected : BigDecimal.ZERO)
                .activeShipperCount(activeShipperCount)
                .todayTaskCount(todayTaskCount)
                .build();
    }

    @Override
    public List<OrderTrackingResponse> trackOrder(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }

        String cleanKeyword = keyword.trim();
        List<ServiceRequest> requests;

        // Thử parse keyword thành Long để tìm theo requestId
        try {
            Long requestId = Long.parseLong(cleanKeyword);
            requests = serviceRequestRepository.findByRequestIdOrSenderPhone(requestId, cleanKeyword);
        } catch (NumberFormatException e) {
            // Không phải số, tìm theo keyword (có thể là SĐT)
            requests = serviceRequestRepository.searchByKeyword(cleanKeyword);
        }

        return requests.stream()
                .map(this::mapToOrderTrackingResponse)
                .collect(Collectors.toList());
    }

    @Override
    public OrderTrackingResponse getOrderDetail(Long requestId) {
        return serviceRequestRepository.findById(requestId)
                .map(this::mapToOrderTrackingResponse)
                .orElse(null);
    }

    /**
     * Map ServiceRequest entity sang OrderTrackingResponse DTO
     */
    private OrderTrackingResponse mapToOrderTrackingResponse(ServiceRequest request) {
        // Lấy thông tin người gửi từ pickupAddress
        CustomerAddress sender = request.getPickupAddress();
        String senderName = sender != null ? sender.getContactName() : null;
        String senderPhone = sender != null ? sender.getContactPhone() : null;
        String senderAddress = formatAddress(sender);

        // Lấy thông tin người nhận từ deliveryAddress
        CustomerAddress receiver = request.getDeliveryAddress();
        String receiverName = receiver != null ? receiver.getContactName() : null;
        String receiverPhone = receiver != null ? receiver.getContactPhone() : null;
        String receiverAddress = formatAddress(receiver);

        // Lấy thông tin Hub hiện tại
        String currentHubName = request.getCurrentHub() != null ? request.getCurrentHub().getHubName() : null;

        // Lấy lịch sử hành trình
        List<ParcelAction> actions = parcelActionRepository.findByRequestIdWithDetails(request.getRequestId());
        List<ActionHistoryResponse> actionHistory = actions.stream()
                .map(this::mapToActionHistoryResponse)
                .collect(Collectors.toList());

        return OrderTrackingResponse.builder()
                .requestId(request.getRequestId())
                .status(request.getStatus() != null ? request.getStatus().name() : null)
                .senderName(senderName)
                .senderPhone(senderPhone)
                .pickupAddress(senderAddress)
                .receiverName(receiverName)
                .receiverPhone(receiverPhone)
                .deliveryAddress(receiverAddress)
                .itemName(request.getItemName())
                .weight(request.getWeight())
                .codAmount(request.getCodAmount())
                .shippingFee(request.getShippingFee())
                .totalPrice(request.getTotalPrice())
                .currentHubName(currentHubName)
                .createdAt(request.getCreatedAt())
                .expectedPickupTime(request.getExpectedPickupTime())
                .note(request.getNote())
                .actionHistory(actionHistory)
                .build();
    }

    /**
     * Map ParcelAction entity sang ActionHistoryResponse DTO
     */
    private ActionHistoryResponse mapToActionHistoryResponse(ParcelAction action) {
        return ActionHistoryResponse.builder()
                .actionId(action.getActionId())
                .actionCode(action.getActionType() != null ? action.getActionType().getActionCode() : null)
                .actionName(action.getActionType() != null ? action.getActionType().getActionName() : null)
                .fromHubName(action.getFromHub() != null ? action.getFromHub().getHubName() : null)
                .toHubName(action.getToHub() != null ? action.getToHub().getHubName() : null)
                .actorName(action.getActor() != null ? action.getActor().getFullName() : null)
                .actorPhone(action.getActor() != null ? action.getActor().getPhone() : null)
                .actionTime(action.getActionTime())
                .note(action.getNote())
                .build();
    }

    /**
     * Format địa chỉ đầy đủ từ CustomerAddress
     */
    private String formatAddress(CustomerAddress address) {
        if (address == null) {
            return null;
        }

        StringBuilder sb = new StringBuilder();
        if (address.getAddressDetail() != null && !address.getAddressDetail().isEmpty()) {
            sb.append(address.getAddressDetail());
        }
        if (address.getWard() != null && !address.getWard().isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(address.getWard());
        }
        if (address.getDistrict() != null && !address.getDistrict().isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(address.getDistrict());
        }
        if (address.getProvince() != null && !address.getProvince().isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(address.getProvince());
        }

        return sb.length() > 0 ? sb.toString() : null;
    }
}
