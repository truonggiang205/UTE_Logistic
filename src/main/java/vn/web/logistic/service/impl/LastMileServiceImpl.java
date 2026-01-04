package vn.web.logistic.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.lastmile.AssignTaskRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmDeliveryRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmPickupRequest;
import vn.web.logistic.dto.request.lastmile.CounterPickupRequest;
import vn.web.logistic.dto.request.lastmile.DeliveryDelayRequest;
import vn.web.logistic.dto.request.lastmile.PickupDelayRequest;
import vn.web.logistic.dto.response.lastmile.AssignTaskResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmDeliveryResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmPickupResponse;
import vn.web.logistic.dto.response.lastmile.CounterPickupResponse;
import vn.web.logistic.dto.response.lastmile.DeliveryDelayResponse;
import vn.web.logistic.dto.response.lastmile.PickupDelayResponse;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.CodTransaction.CodStatus;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.ParcelAction;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.Shipper;
import vn.web.logistic.entity.Shipper.ShipperStatus;
import vn.web.logistic.entity.ShipperTask;
import vn.web.logistic.entity.ShipperTask.TaskStatus;
import vn.web.logistic.entity.ShipperTask.TaskType;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.ActionTypeRepository;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.ParcelActionRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ShipperRepository;
import vn.web.logistic.repository.ShipperTaskRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.LastMileService;

@Service
@RequiredArgsConstructor
@Slf4j
public class LastMileServiceImpl implements LastMileService {

        private final ShipperRepository shipperRepository;
        private final ShipperTaskRepository shipperTaskRepository;
        private final ServiceRequestRepository serviceRequestRepository;
        private final CodTransactionRepository codTransactionRepository;
        private final ParcelActionRepository parcelActionRepository;
        private final ActionTypeRepository actionTypeRepository;
        private final UserRepository userRepository;
        private final HubRepository hubRepository;

        // Mã action cho các loại hành động
        private static final String ACTION_DELIVERY_SUCCESS = "DELIVERY_COMPLETED";
        private static final String ACTION_DELIVERY_DELAY = "DELIVERY_DELAY";
        private static final String ACTION_COUNTER_RECEIVE = "COUNTER_RECEIVE";
        private static final String ACTION_ASSIGN_SHIPPER = "ASSIGN_SHIPPER";
        private static final String ACTION_RETURN_COMPLETED = "RETURN_COMPLETED";
        private static final String ACTION_PICKED_UP = "PICKED_UP";
        private static final String ACTION_PICKUP_DELAY = "PICKUP_DELAY";

        // DATA FETCHING

        @Override
        public List<Map<String, Object>> getShippers(Long hubId, String status) {
                log.info("Lấy danh sách shipper. HubId: {}, Status: {}", hubId, status);

                List<Shipper> shippers;
                if (hubId != null) {
                        shippers = shipperRepository.findByHubHubId(hubId);
                } else {
                        shippers = shipperRepository.findAll();
                }

                // Filter theo status nếu có
                if (status != null && !status.isEmpty()) {
                        ShipperStatus shipperStatus = ShipperStatus.valueOf(status);
                        shippers = shippers.stream()
                                        .filter(s -> s.getStatus() == shipperStatus)
                                        .collect(Collectors.toList());
                }

                // Convert to DTO
                return shippers.stream().map(s -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("shipperId", s.getShipperId());
                        map.put("shipperName", s.getUser() != null ? s.getUser().getFullName() : "N/A");
                        map.put("phone", s.getUser() != null ? s.getUser().getPhone() : "N/A");
                        map.put("status", s.getStatus().name());
                        map.put("vehicleType", s.getVehicleType());
                        map.put("rating", s.getRating());
                        if (s.getHub() != null) {
                                map.put("hubId", s.getHub().getHubId());
                                map.put("hubName", s.getHub().getHubName());
                        }
                        return map;
                }).collect(Collectors.toList());
        }

        @Override
        public List<Map<String, Object>> getOrdersForDelivery(Long hubId, String status, String trackingCode) {
                log.info("Lấy danh sách đơn hàng. HubId: {}, Status: {}, TrackingCode: {}", hubId, status,
                                trackingCode);

                List<ServiceRequest> orders;

                // Nếu có trackingCode, tìm theo tracking code hoặc requestId
                if (trackingCode != null && !trackingCode.trim().isEmpty()) {
                        String searchTerm = trackingCode.trim();
                        orders = new ArrayList<>();

                        // Thử parse requestId từ tracking code (format: TK00000001 hoặc CP000001)
                        Long requestId = null;
                        if (searchTerm.matches("^(TK|CP|LK)\\d+$")) {
                                try {
                                        requestId = Long.parseLong(searchTerm.replaceAll("^(TK|CP|LK)", ""));
                                } catch (NumberFormatException e) {
                                        // Ignore
                                }
                        } else if (searchTerm.matches("^\\d+$")) {
                                try {
                                        requestId = Long.parseLong(searchTerm);
                                } catch (NumberFormatException e) {
                                        // Ignore
                                }
                        }

                        if (requestId != null) {
                                serviceRequestRepository.findById(requestId).ifPresent(orders::add);
                        }
                } else {
                        // Lấy tất cả đơn và filter
                        orders = serviceRequestRepository.findAll();

                        // Filter theo hubId nếu có
                        if (hubId != null) {
                                orders = orders.stream()
                                                .filter(o -> o.getCurrentHub() != null &&
                                                                o.getCurrentHub().getHubId().equals(hubId))
                                                .collect(Collectors.toList());
                        }

                        // Filter theo status - Mặc định bao gồm cả picked VÀ in_transit (sẵn sàng giao)
                        if (status != null && !status.isEmpty()) {
                                // Nếu có chỉ định status cụ thể
                                RequestStatus requestStatus = RequestStatus.valueOf(status);
                                orders = orders.stream()
                                                .filter(o -> o.getStatus() == requestStatus)
                                                .collect(Collectors.toList());
                        } else {
                                // Mặc định: lấy đơn picked hoặc in_transit (đơn sẵn sàng giao)
                                orders = orders.stream()
                                                .filter(o -> o.getStatus() == RequestStatus.picked
                                                                || o.getStatus() == RequestStatus.in_transit)
                                                .collect(Collectors.toList());
                        }

                        // QUAN TRỌNG: Loại bỏ đơn đã có task DELIVERY active (assigned/in_progress)
                        // Chỉ hiển thị đơn chưa được phân công hoặc đã failed (có thể phân công lại)
                        orders = orders.stream()
                                        .filter(o -> !hasActiveDeliveryTask(o.getRequestId()))
                                        .collect(Collectors.toList());
                }

                // Convert to DTO
                return orders.stream().map(o -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("requestId", o.getRequestId());
                        map.put("trackingCode", "TK" + String.format("%08d", o.getRequestId()));
                        map.put("status", o.getStatus().name());
                        map.put("receiverPayAmount", o.getReceiverPayAmount());
                        map.put("itemName", o.getItemName());
                        if (o.getPickupAddress() != null) {
                                map.put("senderName", o.getPickupAddress().getContactName());
                                map.put("senderPhone", o.getPickupAddress().getContactPhone());
                        }
                        if (o.getDeliveryAddress() != null) {
                                map.put("receiverName", o.getDeliveryAddress().getContactName());
                                map.put("receiverPhone", o.getDeliveryAddress().getContactPhone());
                                map.put("receiverAddress", buildFullAddress(o.getDeliveryAddress()));
                        }
                        if (o.getCurrentHub() != null) {
                                map.put("hubId", o.getCurrentHub().getHubId());
                                map.put("hubName", o.getCurrentHub().getHubName());
                        }
                        return map;
                }).collect(Collectors.toList());
        }

        @Override
        public List<Map<String, Object>> getShipperTasks(Long hubId, Long shipperId, String status) {
                log.info("Lấy danh sách task. HubId: {}, ShipperId: {}, Status: {}", hubId, shipperId, status);

                List<ShipperTask> tasks = shipperTaskRepository.findAll();

                // Filter theo hubId nếu có
                // Chỉ filter theo shipper.hub (shipper thuộc hub nào)
                // KHÔNG filter theo request.currentHub vì đơn pickup chưa có currentHub
                if (hubId != null) {
                        final Long finalHubId = hubId;
                        tasks = tasks.stream()
                                        .filter(t -> t.getShipper() != null && t.getShipper().getHub() != null
                                                        && t.getShipper().getHub().getHubId().equals(finalHubId))
                                        .collect(Collectors.toList());
                }

                // Filter theo shipperId nếu có
                if (shipperId != null) {
                        tasks = tasks.stream()
                                        .filter(t -> t.getShipper().getShipperId().equals(shipperId))
                                        .collect(Collectors.toList());
                }

                // Filter theo status nếu có
                if (status != null && !status.isEmpty()) {
                        TaskStatus taskStatus = TaskStatus.valueOf(status);
                        tasks = tasks.stream()
                                        .filter(t -> t.getTaskStatus() == taskStatus)
                                        .collect(Collectors.toList());
                }

                // Convert to DTO
                return tasks.stream().map(t -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("taskId", t.getTaskId());
                        map.put("taskType", t.getTaskType().name());
                        map.put("taskStatus", t.getTaskStatus().name());
                        map.put("assignedAt", t.getAssignedAt());
                        map.put("completedAt", t.getCompletedAt());
                        map.put("resultNote", t.getResultNote());

                        // Thông tin shipper
                        if (t.getShipper() != null) {
                                map.put("shipperId", t.getShipper().getShipperId());
                                map.put("shipperName",
                                                t.getShipper().getUser() != null
                                                                ? t.getShipper().getUser().getFullName()
                                                                : "N/A");
                                map.put("shipperPhone",
                                                t.getShipper().getUser() != null
                                                                ? t.getShipper().getUser().getPhone()
                                                                : "N/A");
                        }

                        // Thông tin đơn hàng
                        if (t.getRequest() != null) {
                                map.put("requestId", t.getRequest().getRequestId());
                                map.put("trackingCode", "TK" + String.format("%08d", t.getRequest().getRequestId()));
                                map.put("requestStatus", t.getRequest().getStatus().name());
                                map.put("receiverPayAmount", t.getRequest().getReceiverPayAmount());
                                map.put("itemName", t.getRequest().getItemName());

                                // Hiển thị thông tin theo loại task
                                if (t.getTaskType() == TaskType.pickup) {
                                        // Task PICKUP - Hiển thị thông tin NGƯỜI GỬI
                                        if (t.getRequest().getPickupAddress() != null) {
                                                map.put("contactName",
                                                                t.getRequest().getPickupAddress().getContactName());
                                                map.put("contactPhone",
                                                                t.getRequest().getPickupAddress().getContactPhone());
                                                map.put("contactAddress",
                                                                buildFullAddress(t.getRequest().getPickupAddress()));
                                                map.put("contactLabel", "Người gửi");
                                        }
                                        // Cũng thêm thông tin người gửi với key chuẩn
                                        if (t.getRequest().getPickupAddress() != null) {
                                                map.put("senderName",
                                                                t.getRequest().getPickupAddress().getContactName());
                                                map.put("senderPhone",
                                                                t.getRequest().getPickupAddress().getContactPhone());
                                                map.put("senderAddress",
                                                                buildFullAddress(t.getRequest().getPickupAddress()));
                                        }
                                } else {
                                        // Task DELIVERY - Hiển thị thông tin NGƯỜI NHẬN
                                        if (t.getRequest().getDeliveryAddress() != null) {
                                                map.put("contactName",
                                                                t.getRequest().getDeliveryAddress().getContactName());
                                                map.put("contactPhone",
                                                                t.getRequest().getDeliveryAddress().getContactPhone());
                                                map.put("contactAddress",
                                                                buildFullAddress(t.getRequest().getDeliveryAddress()));
                                                map.put("contactLabel", "Người nhận");
                                        }
                                        // Cũng thêm thông tin người nhận với key chuẩn
                                        if (t.getRequest().getDeliveryAddress() != null) {
                                                map.put("receiverName",
                                                                t.getRequest().getDeliveryAddress().getContactName());
                                                map.put("receiverPhone",
                                                                t.getRequest().getDeliveryAddress().getContactPhone());
                                                map.put("receiverAddress",
                                                                buildFullAddress(t.getRequest().getDeliveryAddress()));
                                        }
                                }

                                // Thông tin Hub hiện tại
                                if (t.getRequest().getCurrentHub() != null) {
                                        map.put("currentHubId", t.getRequest().getCurrentHub().getHubId());
                                        map.put("currentHubName", t.getRequest().getCurrentHub().getHubName());
                                }
                        }
                        return map;
                }).collect(Collectors.toList());
        }

        // ========================= CHỨC NĂNG HOÀN HÀNG =========================

        @Override
        public List<Map<String, Object>> getOrdersPendingReturnGoods(Long hubId) {
                log.info("Lấy danh sách đơn cần hoàn hàng (3+ lần thất bại). HubId: {}", hubId);

                // Lấy danh sách requestId có >= 3 lần failed
                List<Long> requestIds = shipperTaskRepository.findRequestIdsWithFailedDeliveries();

                List<Map<String, Object>> data = new ArrayList<>();
                for (Long requestId : requestIds) {
                        ServiceRequest order = serviceRequestRepository.findById(requestId).orElse(null);
                        if (order == null)
                                continue;

                        // Filter theo hubId của manager
                        if (hubId != null && (order.getCurrentHub() == null
                                        || !order.getCurrentHub().getHubId().equals(hubId))) {
                                continue;
                        }

                        // Bỏ qua đơn đã delivered hoặc cancelled (đã hoàn tất)
                        if (order.getStatus() == RequestStatus.delivered
                                        || order.getStatus() == RequestStatus.cancelled)
                                continue;

                        long failedCount = shipperTaskRepository.countFailedDeliveryByRequestId(requestId);

                        // Kiểm tra đã kích hoạt hoàn hàng chưa (status = failed)
                        boolean alreadyActivated = order.getStatus() == RequestStatus.failed;

                        Map<String, Object> map = new HashMap<>();
                        map.put("requestId", order.getRequestId());
                        map.put("trackingCode", "TK" + String.format("%08d", order.getRequestId()));
                        map.put("status", order.getStatus().name());
                        map.put("shippingFee", order.getShippingFee());
                        map.put("receiverPayAmount", order.getReceiverPayAmount());
                        map.put("failedCount", failedCount);
                        map.put("itemName", order.getItemName());
                        map.put("alreadyActivated", alreadyActivated);
                        if (order.getPickupAddress() != null) {
                                map.put("senderName", order.getPickupAddress().getContactName());
                                map.put("senderPhone", order.getPickupAddress().getContactPhone());
                        }
                        if (order.getDeliveryAddress() != null) {
                                map.put("receiverName", order.getDeliveryAddress().getContactName());
                                map.put("receiverPhone", order.getDeliveryAddress().getContactPhone());
                                map.put("receiverAddress", buildFullAddress(order.getDeliveryAddress()));
                        }
                        data.add(map);
                }

                return data;
        }

        @Override
        public List<Map<String, Object>> getOrdersPendingReturnShop(Long hubId) {
                log.info("Lấy danh sách đơn chờ trả shop (đã về Hub gốc, status=failed). HubId: {}", hubId);

                // Lấy tất cả đơn có status = failed và filter theo hubId
                final Long finalHubId = hubId;
                List<ServiceRequest> failedOrders = serviceRequestRepository.findAll().stream()
                                .filter(o -> o.getStatus() == RequestStatus.failed)
                                .filter(o -> o.getCurrentHub() != null)
                                .filter(o -> finalHubId == null || o.getCurrentHub().getHubId().equals(finalHubId))
                                .collect(Collectors.toList());

                List<Map<String, Object>> data = new ArrayList<>();
                for (ServiceRequest order : failedOrders) {
                        // Tìm Hub gốc từ action PICKED_UP đầu tiên
                        Optional<Hub> originHubOpt = parcelActionRepository
                                        .findOriginHubByRequestId(order.getRequestId());

                        // Chỉ hiển thị đơn đã về Hub gốc (currentHub = originHub)
                        if (originHubOpt.isEmpty()) {
                                continue; // Không tìm thấy action PICKED_UP, bỏ qua
                        }

                        Hub originHub = originHubOpt.get();
                        if (!order.getCurrentHub().getHubId().equals(originHub.getHubId())) {
                                continue; // Đơn chưa về Hub gốc, bỏ qua
                        }

                        Map<String, Object> map = new HashMap<>();
                        map.put("requestId", order.getRequestId());
                        map.put("trackingCode", "TK" + String.format("%08d", order.getRequestId()));
                        map.put("status", order.getStatus().name());
                        map.put("shippingFee", order.getShippingFee());
                        map.put("receiverPayAmount", order.getReceiverPayAmount());
                        map.put("itemName", order.getItemName());
                        map.put("currentHubName", order.getCurrentHub().getHubName());
                        map.put("originHubName", originHub.getHubName());
                        map.put("isAtOriginHub", true);
                        if (order.getPickupAddress() != null) {
                                map.put("senderName", order.getPickupAddress().getContactName());
                                map.put("senderPhone", order.getPickupAddress().getContactPhone());
                        }
                        if (order.getDeliveryAddress() != null) {
                                map.put("receiverName", order.getDeliveryAddress().getContactName());
                                map.put("receiverPhone", order.getDeliveryAddress().getContactPhone());
                        }
                        data.add(map);
                }

                return data;
        }

        @Override
        @Transactional
        public Map<String, Object> activateReturnGoods(Long requestId) {
                log.info("Kích hoạt hoàn hàng thủ công. RequestId: {}", requestId);

                ServiceRequest order = serviceRequestRepository.findById(requestId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy đơn hàng: " + requestId));

                // Kiểm tra số lần failed
                long failedCount = shipperTaskRepository.countFailedDeliveryByRequestId(requestId);
                if (failedCount < 3) {
                        throw new IllegalStateException(
                                        "Đơn hàng chưa đủ 3 lần giao thất bại (hiện tại: " + failedCount + ")");
                }

                // Kiểm tra đã hoàn chưa
                if (order.getStatus() == RequestStatus.failed) {
                        throw new IllegalStateException("Đơn hàng đã được đánh dấu hoàn hàng trước đó");
                }

                // Cập nhật status = failed
                order.setStatus(RequestStatus.failed);
                serviceRequestRepository.save(order);

                // Tạo CodTransaction return_fee = shippingFee (phí vận chuyển)
                BigDecimal returnFeeAmount = order.getShippingFee() != null
                                ? order.getShippingFee()
                                : BigDecimal.ZERO;

                if (returnFeeAmount.compareTo(BigDecimal.ZERO) > 0) {
                        CodTransaction returnFeeTx = CodTransaction.builder()
                                        .request(order)
                                        .amount(returnFeeAmount)
                                        .codType(CodTransaction.CodType.return_fee)
                                        .status(CodStatus.pending)
                                        .paymentMethod("CASH")
                                        .build();
                        codTransactionRepository.save(returnFeeTx);
                }

                log.info("Kích hoạt hoàn hàng thành công. RequestId: {}, ReturnFee: {}", requestId, returnFeeAmount);

                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("requestId", requestId);
                result.put("trackingCode", "TK" + String.format("%08d", requestId));
                result.put("newStatus", "failed");
                result.put("returnFee", returnFeeAmount);
                result.put("message", "Kích hoạt hoàn hàng thành công");
                return result;
        }

        @Override
        @Transactional
        public Map<String, Object> completeReturnGoods(Long requestId, Long actorUserId) {
                log.info("Hoàn tất trả hàng cho Shop. RequestId: {}", requestId);

                ServiceRequest order = serviceRequestRepository.findById(requestId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy đơn hàng: " + requestId));

                // Kiểm tra đơn đã được kích hoạt hoàn hàng chưa (status = failed)
                if (order.getStatus() != RequestStatus.failed) {
                        throw new IllegalStateException(
                                        "Đơn hàng chưa được kích hoạt hoàn hàng (status hiện tại: " + order.getStatus()
                                                        + ")");
                }

                // Cập nhật status = cancelled (kết thúc vòng đời đơn hàng)
                order.setStatus(RequestStatus.cancelled);
                serviceRequestRepository.save(order);

                // Tìm và cập nhật CodTransaction return_fee --> settled (đã thu tiền)
                BigDecimal settledAmount = BigDecimal.ZERO;
                List<CodTransaction> returnFeeTxs = codTransactionRepository.findAll()
                                .stream()
                                .filter(tx -> tx.getRequest().getRequestId().equals(requestId)
                                                && tx.getCodType() == CodTransaction.CodType.return_fee
                                                && tx.getStatus() == CodStatus.pending)
                                .collect(Collectors.toList());

                LocalDateTime now = LocalDateTime.now();
                for (CodTransaction tx : returnFeeTxs) {
                        tx.setStatus(CodStatus.settled);
                        tx.setSettledAt(now);
                        tx.setCollectedAt(now);
                        codTransactionRepository.save(tx);
                        settledAmount = settledAmount.add(tx.getAmount());
                }

                // Cập nhật paymentStatus = paid sau khi thu phí hoàn
                if (!returnFeeTxs.isEmpty()) {
                        order.setPaymentStatus(ServiceRequest.PaymentStatus.paid);
                        serviceRequestRepository.save(order);
                }

                // Ghi log ParcelAction RETURN_COMPLETED
                ActionType returnCompletedAction = actionTypeRepository
                                .findByActionCode(ACTION_RETURN_COMPLETED).orElse(null);

                if (returnCompletedAction != null) {
                        User actor = userRepository.findById(actorUserId).orElse(null);

                        ParcelAction action = ParcelAction.builder()
                                        .request(order)
                                        .actionType(returnCompletedAction)
                                        .fromHub(order.getCurrentHub())
                                        .actor(actor)
                                        .actionTime(now)
                                        .note("Shop đã nhận lại hàng. Phí hoàn đã thu: " + settledAmount + " VNĐ")
                                        .build();
                        parcelActionRepository.save(action);
                }

                log.info("Hoàn tất trả hàng cho Shop. RequestId: {}, SettledAmount: {}", requestId, settledAmount);

                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("requestId", requestId);
                result.put("trackingCode", "TK" + String.format("%08d", requestId));
                result.put("newStatus", "cancelled");
                result.put("settledAmount", settledAmount);
                result.put("message", "Đã trả lại hàng cho Shop và thu phí hoàn thành công");
                return result;
        }

        // ========================= CHỨC NĂNG GIAO HÀNG =========================

        // CHỨC NĂNG 1: PHÂN CÔNG SHIPPER
        @Override
        @Transactional
        public AssignTaskResponse assignTask(AssignTaskRequest request, Long actorUserId) {
                log.info("Bắt đầu phân công Shipper. ShipperId: {}, Số đơn: {}",
                                request.getShipperId(), request.getRequestIds().size());

                // 1. Validate Shipper tồn tại và đang active
                Shipper shipper = shipperRepository.findById(request.getShipperId())
                                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Shipper với ID: "
                                                + request.getShipperId()));
                if (shipper.getStatus() != ShipperStatus.active) {
                        throw new IllegalStateException(
                                        "Shipper không ở trạng thái active. Trạng thái hiện tại: "
                                                        + shipper.getStatus());
                }

                // 2. Lấy thông tin user thực hiện (actor)
                User actor = userRepository.findById(actorUserId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy User với ID: " + actorUserId));

                // 3. Lấy ActionType cho phân công shipper
                ActionType assignAction = actionTypeRepository.findByActionCode(ACTION_ASSIGN_SHIPPER)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy ActionType: " + ACTION_ASSIGN_SHIPPER));

                // 4. Tạo ShipperTask cho từng đơn hàng
                LocalDateTime now = LocalDateTime.now();
                List<AssignTaskResponse.TaskInfo> taskInfos = new ArrayList<>();

                for (Long requestId : request.getRequestIds()) {
                        // Lấy đơn hàng
                        ServiceRequest serviceRequest = serviceRequestRepository.findById(requestId)
                                        .orElseThrow(() -> new IllegalArgumentException(
                                                        "Không tìm thấy đơn hàng với ID: " + requestId));

                        // Validate trạng thái đơn hàng (phải là picked hoặc in_transit)
                        if (serviceRequest.getStatus() != RequestStatus.picked &&
                                        serviceRequest.getStatus() != RequestStatus.in_transit) {
                                throw new IllegalStateException(
                                                "Đơn hàng " + requestId + " không ở trạng thái phù hợp để giao. " +
                                                                "Trạng thái hiện tại: " + serviceRequest.getStatus());
                        }

                        // Tạo ShipperTask mới
                        ShipperTask task = ShipperTask.builder()
                                        .shipper(shipper)
                                        .request(serviceRequest)
                                        .taskType(TaskType.delivery)
                                        .taskStatus(TaskStatus.assigned)
                                        .assignedAt(now)
                                        .build();
                        shipperTaskRepository.save(task);

                        // Ghi log ParcelAction
                        ParcelAction action = ParcelAction.builder()
                                        .request(serviceRequest)
                                        .actionType(assignAction)
                                        .fromHub(serviceRequest.getCurrentHub())
                                        .actor(actor)
                                        .actionTime(now)
                                        .note("Phân công cho shipper: " + shipper.getUser().getFullName())
                                        .build();
                        parcelActionRepository.save(action);

                        // Thêm vào danh sách kết quả
                        CustomerAddress deliveryAddr = serviceRequest.getDeliveryAddress();
                        String receiverName = deliveryAddr != null ? deliveryAddr.getContactName() : "N/A";
                        String receiverAddress = deliveryAddr != null ? buildFullAddress(deliveryAddr) : "N/A";

                        taskInfos.add(AssignTaskResponse.TaskInfo.builder()
                                        .taskId(task.getTaskId())
                                        .requestId(requestId)
                                        .trackingCode("TK" + String.format("%08d", requestId))
                                        .receiverName(receiverName)
                                        .receiverAddress(receiverAddress)
                                        .taskStatus(TaskStatus.assigned.name())
                                        .build());
                }
                log.info("Phân công thành công {} đơn cho Shipper {}", taskInfos.size(),
                                shipper.getUser().getFullName());

                return AssignTaskResponse.builder()
                                .shipperId(shipper.getShipperId())
                                .shipperName(shipper.getUser().getFullName())
                                .shipperPhone(shipper.getUser().getPhone())
                                .assignedCount(taskInfos.size())
                                .tasks(taskInfos)
                                .assignedAt(now)
                                .build();
        }

        // CHỨC NĂNG 2: XÁC NHẬN GIAO XONG
        @Override
        @Transactional
        public ConfirmDeliveryResponse confirmDelivery(ConfirmDeliveryRequest request, Long actorUserId) {
                log.info("Xác nhận giao hàng thành công. TaskId: {}", request.getTaskId());

                LocalDateTime now = LocalDateTime.now();

                // 1. Lấy ShipperTask
                ShipperTask task = shipperTaskRepository.findById(request.getTaskId())
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy Task với ID: " + request.getTaskId()));

                // Validate trạng thái task
                if (task.getTaskStatus() != TaskStatus.assigned && task.getTaskStatus() != TaskStatus.in_progress) {
                        throw new IllegalStateException("Task không ở trạng thái có thể hoàn thành. " +
                                        "Trạng thái hiện tại: " + task.getTaskStatus());
                }

                // 2. Lấy User thực hiện
                User actor = userRepository.findById(actorUserId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy User với ID: " + actorUserId));

                // 3. Lấy ActionType cho giao hàng thành công
                ActionType deliverySuccessAction = actionTypeRepository.findByActionCode(ACTION_DELIVERY_SUCCESS)
                                .orElseThrow(
                                                () -> new IllegalArgumentException("Không tìm thấy ActionType: "
                                                                + ACTION_DELIVERY_SUCCESS));

                // 4. Cập nhật Task thành completed
                task.setTaskStatus(TaskStatus.completed);
                task.setCompletedAt(now);
                task.setResultNote(request.getNote());
                shipperTaskRepository.save(task);

                // 5. Cập nhật đơn hàng thành delivered
                ServiceRequest serviceRequest = task.getRequest();
                serviceRequest.setStatus(RequestStatus.delivered);
                serviceRequestRepository.save(serviceRequest);

                // 6. Ghi log ParcelAction
                ParcelAction action = ParcelAction.builder()
                                .request(serviceRequest)
                                .actionType(deliverySuccessAction)
                                .fromHub(serviceRequest.getCurrentHub())
                                .actor(actor)
                                .actionTime(now)
                                .note(request.getNote() != null ? request.getNote() : "Giao hàng thành công")
                                .build();
                parcelActionRepository.save(action);

                // 7. Tạo hoặc cập nhật CodTransaction nếu có COD
                CodTransaction codTx = null;
                BigDecimal codCollected = request.getCodCollected();
                if (codCollected == null) {
                        codCollected = serviceRequest.getReceiverPayAmount();
                }
                if (codCollected != null && codCollected.compareTo(BigDecimal.ZERO) > 0) {
                        // Kiểm tra xem đã có COD Transaction cho đơn này chưa (từ drop-off)
                        var existingCod = codTransactionRepository.findByRequestId(serviceRequest.getRequestId());

                        if (existingCod.isPresent()) {
                                // Nếu đã tồn tại, cập nhật shipper và đảm bảo status = pending
                                codTx = existingCod.get();
                                if (codTx.getShipper() == null) {
                                        codTx.setShipper(task.getShipper());
                                }
                                codTx.setStatus(CodStatus.pending); // Đảm bảo status là pending
                                codTransactionRepository.save(codTx);
                                log.info("Request {} đã có COD Transaction, cập nhật shipper_id = {}",
                                                serviceRequest.getRequestId(), task.getShipper().getShipperId());
                        } else {
                                // Tạo mới COD Transaction
                                codTx = CodTransaction.builder()
                                                .request(serviceRequest)
                                                .shipper(task.getShipper())
                                                .amount(codCollected)
                                                .collectedAt(null) // Chưa thu, sẽ set khi shipper nộp tiền
                                                .status(CodStatus.pending) // Shipper đang giữ tiền, chờ nộp
                                                .paymentMethod("CASH")
                                                .build();
                                codTransactionRepository.save(codTx);
                                log.info("Tạo mới COD Transaction cho request {}: {}đ, status=pending",
                                                serviceRequest.getRequestId(), codCollected);
                        }
                }

                // 8. Reset shipper status về active nếu không còn task active nào
                Shipper shipper = task.getShipper();
                long activeTaskCount = shipperTaskRepository.countActiveTasksByShipperId(shipper.getShipperId());
                if (activeTaskCount == 0 && shipper.getStatus() == ShipperStatus.busy) {
                        shipper.setStatus(ShipperStatus.active);
                        shipperRepository.save(shipper);
                        log.info("Shipper {} không còn task active, chuyển về trạng thái active",
                                        shipper.getUser().getFullName());
                }

                log.info("Giao hàng thành công. TaskId: {}, RequestId: {}",
                                task.getTaskId(), serviceRequest.getRequestId());

                return ConfirmDeliveryResponse.builder()
                                .taskId(task.getTaskId())
                                .requestId(serviceRequest.getRequestId())
                                .trackingCode("TK" + String.format("%08d", serviceRequest.getRequestId()))
                                .taskStatus(TaskStatus.completed.name())
                                .requestStatus(RequestStatus.delivered.name())
                                .codCollected(request.getCodCollected())
                                .codTxId(codTx != null ? codTx.getCodTxId() : null)
                                .codStatus(codTx != null ? codTx.getStatus().name() : null)
                                .completedAt(now)
                                .note(request.getNote())
                                .build();
        }

        // CHỨC NĂNG 3: XÁC NHẬN HẸN LẠI
        @Override
        @Transactional
        public DeliveryDelayResponse deliveryDelay(DeliveryDelayRequest request, Long actorUserId) {
                log.info("Xác nhận hẹn lại giao hàng. TaskId: {}, Lý do: {}",
                                request.getTaskId(), request.getReason());

                LocalDateTime now = LocalDateTime.now();

                // 1. Lấy ShipperTask
                ShipperTask task = shipperTaskRepository.findById(request.getTaskId())
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy Task với ID: " + request.getTaskId()));

                // Validate trạng thái task
                if (task.getTaskStatus() != TaskStatus.assigned && task.getTaskStatus() != TaskStatus.in_progress) {
                        throw new IllegalStateException("Task không ở trạng thái có thể cập nhật. " +
                                        "Trạng thái hiện tại: " + task.getTaskStatus());
                }

                // 2. Lấy User thực hiện
                User actor = userRepository.findById(actorUserId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy User với ID: " + actorUserId));

                // 3. Lấy ActionType cho hẹn lại giao
                ActionType deliveryDelayAction = actionTypeRepository.findByActionCode(ACTION_DELIVERY_DELAY)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy ActionType: " + ACTION_DELIVERY_DELAY));

                // 4. Cập nhật Task thành failed
                task.setTaskStatus(TaskStatus.failed);
                task.setCompletedAt(now);
                task.setResultNote(request.getReason());
                shipperTaskRepository.save(task);

                // 5. Lấy đơn hàng và Shipper
                ServiceRequest serviceRequest = task.getRequest();
                Shipper shipper = task.getShipper();

                // 5.1: Kiểm tra số lần giao thất bại - CHỈ LOG WARNING, KHÔNG TỰ ĐỘNG HOÀN
                long failedCount = shipperTaskRepository.countFailedDeliveryByRequestId(serviceRequest.getRequestId());
                boolean needsReturnGoods = failedCount >= 3;

                if (needsReturnGoods) {
                        // CHỈ LOG WARNING - Manager sẽ kích hoạt hoàn hàng thủ công qua trang Return
                        // Goods
                        log.warn("Đơn hàng {} đã thất bại {} lần. Cần kích hoạt hoàn hàng qua trang quản lý.",
                                        serviceRequest.getRequestId(), failedCount);
                }

                // 5.5 Reset shipper status về active nếu không còn task active nào
                long activeTaskCount = shipperTaskRepository.countActiveTasksByShipperId(shipper.getShipperId());
                if (activeTaskCount == 0 && shipper.getStatus() == ShipperStatus.busy) {
                        shipper.setStatus(ShipperStatus.active);
                        shipperRepository.save(shipper);
                        log.info("Shipper {} không còn task active, chuyển về trạng thái active",
                                        shipper.getUser().getFullName());
                }

                // 6. Ghi log ParcelAction
                String actionNote = needsReturnGoods
                                ? "Giao thất bại lần " + failedCount + " (cần hoàn hàng): " + request.getReason()
                                : "Hẹn lại giao: " + request.getReason();
                ParcelAction action = ParcelAction.builder()

                                .request(serviceRequest)
                                .actionType(deliveryDelayAction)
                                .fromHub(serviceRequest.getCurrentHub())
                                .actor(actor)
                                .actionTime(now)
                                .note(actionNote)
                                .build();
                parcelActionRepository.save(action);

                log.info("Hẹn lại giao hàng thành công. TaskId: {}, RequestId: {}, Lần thất bại: {}, Cần hoàn hàng: {}",
                                task.getTaskId(), serviceRequest.getRequestId(), failedCount, needsReturnGoods);

                return DeliveryDelayResponse.builder()
                                .taskId(task.getTaskId())
                                .requestId(serviceRequest.getRequestId())
                                .trackingCode("TK" + String.format("%08d", serviceRequest.getRequestId()))
                                .taskStatus(TaskStatus.failed.name())
                                .requestStatus(serviceRequest.getStatus().name())
                                .reason(request.getReason())
                                .actionId(action.getActionId())
                                .actionType(ACTION_DELIVERY_DELAY)
                                .recordedAt(now)
                                .build();
        }

        // CHỨC NĂNG 4: KHÁCH NHẬN TẠI QUẦY
        @Override
        @Transactional
        public CounterPickupResponse counterPickup(CounterPickupRequest request, Long actorUserId) {
                log.info("Khách nhận tại quầy. RequestId: {}", request.getRequestId());

                LocalDateTime now = LocalDateTime.now();

                // 1. Lấy đơn hàng
                ServiceRequest serviceRequest = serviceRequestRepository.findById(request.getRequestId())
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy đơn hàng với ID: " + request.getRequestId()));

                // Validate trạng thái đơn hàng
                if (serviceRequest.getStatus() == RequestStatus.delivered ||
                                serviceRequest.getStatus() == RequestStatus.cancelled ||
                                serviceRequest.getStatus() == RequestStatus.failed) {
                        throw new IllegalStateException("Đơn hàng không thể nhận tại quầy. " +
                                        "Trạng thái hiện tại: " + serviceRequest.getStatus());
                }

                // 2. Kiểm tra đơn hàng có đang được Shipper giao không
                boolean hasActiveDeliveryTask = shipperTaskRepository.existsActiveTaskByRequestAndType(
                                serviceRequest, TaskType.delivery);
                if (hasActiveDeliveryTask) {
                        throw new IllegalStateException(
                                        "Đơn hàng đang được Shipper giao, không thể nhận tại quầy. " +
                                                        "Vui lòng chờ Shipper hoàn thành hoặc hủy task giao hàng trước.");
                }

                // 3. Lấy Hub hiện tại từ đơn hàng
                Hub currentHub = serviceRequest.getCurrentHub();
                if (currentHub == null) {
                        throw new IllegalStateException("Đơn hàng chưa có Hub hiện tại");
                }

                // 4. Lấy User thực hiện
                User actor = userRepository.findById(actorUserId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy User với ID: " + actorUserId));

                // 5. Lấy ActionType cho nhận tại quầy
                ActionType counterReceiveAction = actionTypeRepository.findByActionCode(ACTION_COUNTER_RECEIVE)
                                .orElseThrow(
                                                () -> new IllegalArgumentException("Không tìm thấy ActionType: "
                                                                + ACTION_COUNTER_RECEIVE));

                // 6. Cập nhật đơn hàng thành delivered
                serviceRequest.setStatus(RequestStatus.delivered);
                serviceRequestRepository.save(serviceRequest);

                // 7. Ghi log ParcelAction
                String note = request.getNote() != null ? request.getNote() : "Khách nhận trực tiếp tại quầy";
                ParcelAction action = ParcelAction.builder()
                                .request(serviceRequest)
                                .actionType(counterReceiveAction)
                                .fromHub(currentHub)
                                //
                                .actor(actor)
                                .actionTime(now)
                                .note(note)
                                .build();
                parcelActionRepository.save(action);

                // 8. Tạo hoặc cập nhật CodTransaction với status = settled (đã quyết toán ngay tại quầy)
                CodTransaction codTx = null;
                //
                BigDecimal codCollected = request.getCodCollected();
                // Nếu không truyền codCollected, dùng receiverPayAmount trên đơn (tổng tiền
                // người nhận phải trả)
                //
                if (codCollected == null) {
                        codCollected = serviceRequest.getReceiverPayAmount();
                }
                if (codCollected != null && codCollected.compareTo(BigDecimal.ZERO) > 0) {
                        // Kiểm tra xem đã có COD Transaction cho request này chưa
                        Optional<CodTransaction> existingCod = codTransactionRepository.findByRequestId(serviceRequest.getRequestId());

                                        
                        if (existingCod.isPresent()) {
                                // Nếu đã tồn tại, cập nhật status = settled (thu tiền ngay tại quầy)
                                codTx = existingCod.get();
                                codTx.setStatus(CodStatus.settled);
                                codTx.setCollectedAt(now);
                                codTx.setSettledAt(now);
                                codTransactionRepository.save(codTx);
                                log.info("Request {} đã có COD Transaction, cập nhật status = settled (nhận tại quầy)",
                                                serviceRequest.getRequestId());
                        } else {
                                // Tạo mới COD Transaction với status = settled
                                codTx = CodTransaction.builder()
                                                .request(serviceRequest)
                                                .shipper(null) // Không qua shipper
                                                .amount(codCollected)
                                                .collectedAt(now)
                                                .settledAt(now) // Quyết toán ngay tại quầy
                                                .status(CodStatus.settled)
                                                .paymentMethod("CASH")
                                                .build();
                                codTransactionRepository.save(codTx);
                                log.info("Tạo mới COD Transaction cho request {}: {}đ, status=settled (nhận tại quầy)",
                                                serviceRequest.getRequestId(), codCollected);
                        }
                        

                        serviceRequest.setPaymentStatus(ServiceRequest.PaymentStatus.paid);
                        serviceRequestRepository.save(serviceRequest);
                }

                log.info("Khách nhận tại quầy thành công. RequestId: {}, COD: {}",
                                serviceRequest.getRequestId(), codCollected);

                return CounterPickupResponse.builder()
                                .requestId(serviceRequest.getRequestId())
                                .trackingCode("TK" + String.format("%08d", serviceRequest.getRequestId()))
                                .requestStatus(RequestStatus.delivered.name())
                                .codAmount(codCollected)
                                .codTxId(codTx != null ? codTx.getCodTxId() : null)
                                .codStatus(codTx != null ? CodStatus.settled.name() : null)
                                .actionId(action.getActionId())
                                .actionType(ACTION_COUNTER_RECEIVE)
                                .receivedAt(now)
                                .note(note)
                                .build();
        }

        // CHỨC NĂNG LẤY HÀNG (PICKUP)
        // CHỨC NĂNG 5: XÁC NHẬN LẤY HÀNG THÀNH CÔNG
        @Override
        @Transactional
        public ConfirmPickupResponse confirmPickup(ConfirmPickupRequest request, Long actorUserId) {
                log.info("Xác nhận lấy hàng thành công. TaskId: {}", request.getTaskId());

                LocalDateTime now = LocalDateTime.now();

                // 1. Lấy ShipperTask
                ShipperTask task = shipperTaskRepository.findById(request.getTaskId())
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy Task với ID: " + request.getTaskId()));

                // Validate đây là task pickup
                if (task.getTaskType() != TaskType.pickup) {
                        throw new IllegalStateException("Task này không phải là task lấy hàng");
                }

                // Validate trạng thái task
                if (task.getTaskStatus() != TaskStatus.assigned && task.getTaskStatus() != TaskStatus.in_progress) {
                        throw new IllegalStateException("Task không ở trạng thái có thể hoàn thành. " +
                                        "Trạng thái hiện tại: " + task.getTaskStatus());
                }

                // 2. Lấy User thực hiện
                User actor = userRepository.findById(actorUserId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy User với ID: " + actorUserId));

                // 3. Lấy ActionType cho lấy hàng thành công
                ActionType pickupSuccessAction = actionTypeRepository.findByActionCode(ACTION_PICKED_UP)
                                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy ActionType: "
                                                + ACTION_PICKED_UP));

                // 4. Cập nhật Task thành completed
                task.setTaskStatus(TaskStatus.completed);
                task.setCompletedAt(now);
                task.setResultNote(request.getNote());
                shipperTaskRepository.save(task);

                // 5. Cập nhật đơn hàng thành picked
                ServiceRequest serviceRequest = task.getRequest();
                serviceRequest.setStatus(RequestStatus.picked);

                // Cập nhật current_hub = hub của shipper (nơi hàng sẽ được đưa về)
                Shipper shipper = task.getShipper();
                if (shipper.getHub() != null) {
                        serviceRequest.setCurrentHub(shipper.getHub());
                }
                serviceRequestRepository.save(serviceRequest);

                // 6. Reset shipper status về active nếu không còn task active nào
                long activeTaskCount = shipperTaskRepository.countActiveTasksByShipperId(shipper.getShipperId());
                if (activeTaskCount == 0 && shipper.getStatus() == ShipperStatus.busy) {
                        shipper.setStatus(ShipperStatus.active);
                        shipperRepository.save(shipper);
                        log.info("Shipper {} không còn task active, chuyển về trạng thái active",
                                        shipper.getUser().getFullName());
                }

                // 7. Ghi log ParcelAction
                ParcelAction action = ParcelAction.builder()
                                .request(serviceRequest)
                                .actionType(pickupSuccessAction)
                                .toHub(shipper.getHub())
                                .actor(actor)
                                .actionTime(now)
                                .note(request.getNote() != null ? request.getNote() : "Lấy hàng thành công")
                                .build();
                parcelActionRepository.save(action);

                log.info("Xác nhận lấy hàng thành công. TaskId: {}, RequestId: {}",
                                task.getTaskId(), serviceRequest.getRequestId());

                return ConfirmPickupResponse.builder()
                                .taskId(task.getTaskId())
                                .requestId(serviceRequest.getRequestId())
                                .trackingCode("TK" + String.format("%08d", serviceRequest.getRequestId()))
                                .taskStatus(TaskStatus.completed.name())
                                .requestStatus(RequestStatus.picked.name())
                                .note(request.getNote())
                                .actionId(action.getActionId())
                                .actionType(ACTION_PICKED_UP)
                                .recordedAt(now)
                                .build();
        }

        // CHỨC NĂNG 6: XÁC NHẬN LẤY HÀNG THẤT BẠI (HẸN LẠI)
        @Override
        @Transactional
        public PickupDelayResponse pickupDelay(PickupDelayRequest request, Long actorUserId) {
                log.info("Xác nhận hẹn lại lấy hàng. TaskId: {}, Lý do: {}",
                                request.getTaskId(), request.getReason());

                LocalDateTime now = LocalDateTime.now();

                // 1. Lấy ShipperTask
                ShipperTask task = shipperTaskRepository.findById(request.getTaskId())
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy Task với ID: " + request.getTaskId()));

                // Validate đây là task pickup
                if (task.getTaskType() != TaskType.pickup) {
                        throw new IllegalStateException("Task này không phải là task lấy hàng");
                }

                // Validate trạng thái task
                if (task.getTaskStatus() != TaskStatus.assigned && task.getTaskStatus() != TaskStatus.in_progress) {
                        throw new IllegalStateException("Task không ở trạng thái có thể cập nhật. " +
                                        "Trạng thái hiện tại: " + task.getTaskStatus());
                }

                // 2. Lấy User thực hiện
                User actor = userRepository.findById(actorUserId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Không tìm thấy User với ID: " + actorUserId));

                // 3. Lấy ActionType cho hẹn lại lấy hàng (dùng chung DELIVERY_DELAY hoặc tạo
                // mới)
                ActionType pickupDelayAction = actionTypeRepository.findByActionCode(ACTION_PICKUP_DELAY)
                                .orElse(actionTypeRepository.findByActionCode(ACTION_DELIVERY_DELAY).orElse(null));

                // 4. Cập nhật Task thành failed
                task.setTaskStatus(TaskStatus.failed);
                task.setCompletedAt(now);
                task.setResultNote(request.getReason());
                shipperTaskRepository.save(task);

                // 5. Lấy đơn hàng và Shipper
                ServiceRequest serviceRequest = task.getRequest();
                Shipper shipper = task.getShipper();
                // Order status vẫn giữ nguyên = pending (để có thể phân công lại)

                // 6. Reset shipper status về active nếu không còn task active nào
                long activeTaskCount = shipperTaskRepository.countActiveTasksByShipperId(shipper.getShipperId());
                if (activeTaskCount == 0 && shipper.getStatus() == ShipperStatus.busy) {
                        shipper.setStatus(ShipperStatus.active);
                        shipperRepository.save(shipper);
                        log.info("Shipper {} không còn task active, chuyển về trạng thái active",
                                        shipper.getUser().getFullName());
                }

                // 7. Ghi log ParcelAction (nếu có ActionType)
                ParcelAction action = null;
                if (pickupDelayAction != null) {
                        action = ParcelAction.builder()
                                        .request(serviceRequest)
                                        .actionType(pickupDelayAction)
                                        .fromHub(shipper.getHub())
                                        .actor(actor)
                                        .actionTime(now)
                                        .note("Lấy hàng thất bại: " + request.getReason())
                                        .build();
                        parcelActionRepository.save(action);
                }

                log.info("Hẹn lại lấy hàng thành công. TaskId: {}, RequestId: {}",
                                task.getTaskId(), serviceRequest.getRequestId());

                return PickupDelayResponse.builder()
                                .taskId(task.getTaskId())
                                .requestId(serviceRequest.getRequestId())
                                .trackingCode("TK" + String.format("%08d", serviceRequest.getRequestId()))
                                .taskStatus(TaskStatus.failed.name())
                                .requestStatus(serviceRequest.getStatus().name())
                                .reason(request.getReason())
                                .actionId(action != null ? action.getActionId() : null)
                                .actionType(ACTION_PICKUP_DELAY)
                                .recordedAt(now)
                                .build();
        }

        // Helper method: Tạo địa chỉ đầy đủ từ CustomerAddress
        private String buildFullAddress(CustomerAddress address) {
                StringBuilder sb = new StringBuilder();
                if (address.getAddressDetail() != null) {
                        sb.append(address.getAddressDetail());
                }
                if (address.getWard() != null) {
                        if (sb.length() > 0)
                                sb.append(", ");
                        sb.append(address.getWard());
                }
                if (address.getDistrict() != null) {
                        if (sb.length() > 0)
                                sb.append(", ");
                        sb.append(address.getDistrict());
                }
                if (address.getProvince() != null) {
                        if (sb.length() > 0)
                                sb.append(", ");
                        sb.append(address.getProvince());
                }
                return sb.length() > 0 ? sb.toString() : "N/A";
        }

        // Helper method: Kiểm tra đơn hàng có task active (assigned/in_progress) hay
        // không
        private boolean hasActiveTask(Long requestId) {
                List<ShipperTask> tasks = shipperTaskRepository.findByRequestRequestId(requestId);
                return tasks.stream()
                                .anyMatch(t -> t.getTaskStatus() == TaskStatus.assigned
                                                || t.getTaskStatus() == TaskStatus.in_progress);
        }

        // Helper method: Kiểm tra đơn hàng có task DELIVERY active
        // (assigned/in_progress) hay không
        // Dùng cho việc phân công giao hàng - chỉ kiểm tra task loại delivery
        private boolean hasActiveDeliveryTask(Long requestId) {
                List<ShipperTask> tasks = shipperTaskRepository.findByRequestRequestId(requestId);
                return tasks.stream()
                                .anyMatch(t -> t.getTaskType() == TaskType.delivery
                                                && (t.getTaskStatus() == TaskStatus.assigned
                                                                || t.getTaskStatus() == TaskStatus.in_progress));
        }
}
