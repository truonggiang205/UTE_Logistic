package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.dto.request.lastmile.AssignTaskRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmDeliveryRequest;
import vn.web.logistic.dto.request.lastmile.CounterPickupRequest;
import vn.web.logistic.dto.request.lastmile.DeliveryDelayRequest;
import vn.web.logistic.dto.response.lastmile.AssignTaskResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmDeliveryResponse;
import vn.web.logistic.dto.response.lastmile.CounterPickupResponse;
import vn.web.logistic.dto.response.lastmile.DeliveryDelayResponse;
import vn.web.logistic.entity.*;
import vn.web.logistic.entity.CodTransaction.CodStatus;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.Shipper.ShipperStatus;
import vn.web.logistic.entity.ShipperTask.TaskStatus;
import vn.web.logistic.entity.ShipperTask.TaskType;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.LastMileService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
    private static final String ACTION_DELIVERY_SUCCESS = "DELIVERY_SUCCESS";
    private static final String ACTION_DELIVERY_DELAY = "DELIVERY_DELAY";
    private static final String ACTION_COUNTER_RECEIVE = "COUNTER_RECEIVE";
    private static final String ACTION_ASSIGN_SHIPPER = "ASSIGN_SHIPPER";

    // ====================== CHỨC NĂNG 1: PHÂN CÔNG SHIPPER ======================
    @Override
    @Transactional
    public AssignTaskResponse assignTask(AssignTaskRequest request, Long actorUserId) {
        log.info("Bắt đầu phân công Shipper. ShipperId: {}, Số đơn: {}",
                request.getShipperId(), request.getRequestIds().size());

        // 1. Validate Shipper tồn tại và đang active
        Shipper shipper = shipperRepository.findById(request.getShipperId())
                .orElseThrow(
                        () -> new IllegalArgumentException("Không tìm thấy Shipper với ID: " + request.getShipperId()));

        if (shipper.getStatus() != ShipperStatus.active) {
            throw new IllegalStateException(
                    "Shipper không ở trạng thái active. Trạng thái hiện tại: " + shipper.getStatus());
        }

        // 2. Lấy thông tin user thực hiện (actor)
        User actor = userRepository.findById(actorUserId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy User với ID: " + actorUserId));

        // 3. Lấy ActionType cho phân công shipper
        ActionType assignAction = actionTypeRepository.findByActionCode(ACTION_ASSIGN_SHIPPER)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy ActionType: " + ACTION_ASSIGN_SHIPPER));

        // 4. Tạo ShipperTask cho từng đơn hàng
        LocalDateTime now = LocalDateTime.now();
        List<AssignTaskResponse.TaskInfo> taskInfos = new ArrayList<>();

        for (Long requestId : request.getRequestIds()) {
            // Lấy đơn hàng
            ServiceRequest serviceRequest = serviceRequestRepository.findById(requestId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đơn hàng với ID: " + requestId));

            // Validate trạng thái đơn hàng (phải là picked hoặc in_transit)
            if (serviceRequest.getStatus() != RequestStatus.picked &&
                    serviceRequest.getStatus() != RequestStatus.in_transit) {
                throw new IllegalStateException("Đơn hàng " + requestId + " không ở trạng thái phù hợp để giao. " +
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

        // 5. Cập nhật trạng thái Shipper thành busy
        shipper.setStatus(ShipperStatus.busy);
        shipperRepository.save(shipper);

        log.info("Phân công thành công {} đơn cho Shipper {}", taskInfos.size(), shipper.getUser().getFullName());

        return AssignTaskResponse.builder()
                .shipperId(shipper.getShipperId())
                .shipperName(shipper.getUser().getFullName())
                .shipperPhone(shipper.getUser().getPhone())
                .assignedCount(taskInfos.size())
                .tasks(taskInfos)
                .assignedAt(now)
                .build();
    }

    // ====================== CHỨC NĂNG 2: XÁC NHẬN GIAO XONG ======================
    @Override
    @Transactional
    public ConfirmDeliveryResponse confirmDelivery(ConfirmDeliveryRequest request, Long actorUserId) {
        log.info("Xác nhận giao hàng thành công. TaskId: {}", request.getTaskId());

        LocalDateTime now = LocalDateTime.now();

        // 1. Lấy ShipperTask
        ShipperTask task = shipperTaskRepository.findById(request.getTaskId())
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Task với ID: " + request.getTaskId()));

        // Validate trạng thái task
        if (task.getTaskStatus() != TaskStatus.assigned && task.getTaskStatus() != TaskStatus.in_progress) {
            throw new IllegalStateException("Task không ở trạng thái có thể hoàn thành. " +
                    "Trạng thái hiện tại: " + task.getTaskStatus());
        }

        // 2. Lấy User thực hiện
        User actor = userRepository.findById(actorUserId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy User với ID: " + actorUserId));

        // 3. Lấy ActionType cho giao hàng thành công
        ActionType deliverySuccessAction = actionTypeRepository.findByActionCode(ACTION_DELIVERY_SUCCESS)
                .orElseThrow(
                        () -> new IllegalArgumentException("Không tìm thấy ActionType: " + ACTION_DELIVERY_SUCCESS));

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

        // 7. Tạo CodTransaction nếu có COD
        CodTransaction codTx = null;
        if (request.getCodCollected() != null && request.getCodCollected().compareTo(BigDecimal.ZERO) > 0) {
            codTx = CodTransaction.builder()
                    .request(serviceRequest)
                    .shipper(task.getShipper())
                    .amount(request.getCodCollected())
                    .collectedAt(now)
                    .status(CodStatus.pending) // Shipper đang giữ tiền, chưa nộp về bưu cục
                    .paymentMethod("CASH")
                    .build();
            codTransactionRepository.save(codTx);
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

    // ====================== CHỨC NĂNG 3: XÁC NHẬN HẸN LẠI ======================
    @Override
    @Transactional
    public DeliveryDelayResponse deliveryDelay(DeliveryDelayRequest request, Long actorUserId) {
        log.info("Xác nhận hẹn lại giao hàng. TaskId: {}, Lý do: {}",
                request.getTaskId(), request.getReason());

        LocalDateTime now = LocalDateTime.now();

        // 1. Lấy ShipperTask
        ShipperTask task = shipperTaskRepository.findById(request.getTaskId())
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Task với ID: " + request.getTaskId()));

        // Validate trạng thái task
        if (task.getTaskStatus() != TaskStatus.assigned && task.getTaskStatus() != TaskStatus.in_progress) {
            throw new IllegalStateException("Task không ở trạng thái có thể cập nhật. " +
                    "Trạng thái hiện tại: " + task.getTaskStatus());
        }

        // 2. Lấy User thực hiện
        User actor = userRepository.findById(actorUserId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy User với ID: " + actorUserId));

        // 3. Lấy ActionType cho hẹn lại giao
        ActionType deliveryDelayAction = actionTypeRepository.findByActionCode(ACTION_DELIVERY_DELAY)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy ActionType: " + ACTION_DELIVERY_DELAY));

        // 4. Cập nhật Task thành failed
        task.setTaskStatus(TaskStatus.failed);
        task.setCompletedAt(now);
        task.setResultNote(request.getReason());
        shipperTaskRepository.save(task);

        // 5. KHÔNG cập nhật trạng thái đơn hàng - giữ nguyên picked
        ServiceRequest serviceRequest = task.getRequest();
        // Đơn hàng vẫn giữ trạng thái cũ để có thể phân công lại ngày mai

        // 6. Ghi log ParcelAction
        ParcelAction action = ParcelAction.builder()
                .request(serviceRequest)
                .actionType(deliveryDelayAction)
                .fromHub(serviceRequest.getCurrentHub())
                .actor(actor)
                .actionTime(now)
                .note("Hẹn lại giao: " + request.getReason())
                .build();
        parcelActionRepository.save(action);

        log.info("Hẹn lại giao hàng thành công. TaskId: {}, RequestId: {}",
                task.getTaskId(), serviceRequest.getRequestId());

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

    // ====================== CHỨC NĂNG 4: KHÁCH NHẬN TẠI QUẦY
    // ======================
    @Override
    @Transactional
    public CounterPickupResponse counterPickup(CounterPickupRequest request, Long actorUserId) {
        log.info("Khách nhận tại quầy. RequestId: {}, CMND: {}",
                request.getRequestId(), request.getCustomerIdCard());

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

        // 2. Lấy Hub hiện tại
        Hub currentHub = hubRepository.findById(request.getCurrentHubId())
                .orElseThrow(
                        () -> new IllegalArgumentException("Không tìm thấy Hub với ID: " + request.getCurrentHubId()));

        // 3. Lấy User thực hiện
        User actor = userRepository.findById(actorUserId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy User với ID: " + actorUserId));

        // 4. Lấy ActionType cho nhận tại quầy
        ActionType counterReceiveAction = actionTypeRepository.findByActionCode(ACTION_COUNTER_RECEIVE)
                .orElseThrow(
                        () -> new IllegalArgumentException("Không tìm thấy ActionType: " + ACTION_COUNTER_RECEIVE));

        // 5. Cập nhật đơn hàng thành delivered
        serviceRequest.setStatus(RequestStatus.delivered);
        serviceRequestRepository.save(serviceRequest);

        // 6. Ghi log ParcelAction
        ParcelAction action = ParcelAction.builder()
                .request(serviceRequest)
                .actionType(counterReceiveAction)
                .fromHub(currentHub)
                .actor(actor)
                .actionTime(now)
                .note("Khách nhận tại quầy. CMND/CCCD: " + request.getCustomerIdCard())
                .build();
        parcelActionRepository.save(action);

        // 7. Tạo CodTransaction với status = settled (đã quyết toán ngay)
        CodTransaction codTx = null;
        BigDecimal codAmount = serviceRequest.getCodAmount();
        if (codAmount != null && codAmount.compareTo(BigDecimal.ZERO) > 0) {
            codTx = CodTransaction.builder()
                    .request(serviceRequest)
                    .shipper(null) // Không qua shipper
                    .amount(codAmount)
                    .collectedAt(now)
                    .settledAt(now) // Quyết toán ngay tại quầy
                    .status(CodStatus.settled)
                    .paymentMethod("CASH")
                    .build();
            codTransactionRepository.save(codTx);
        }

        log.info("Khách nhận tại quầy thành công. RequestId: {}", serviceRequest.getRequestId());

        return CounterPickupResponse.builder()
                .requestId(serviceRequest.getRequestId())
                .trackingCode("TK" + String.format("%08d", serviceRequest.getRequestId()))
                .requestStatus(RequestStatus.delivered.name())
                .customerIdCard(request.getCustomerIdCard())
                .codAmount(codAmount)
                .codTxId(codTx != null ? codTx.getCodTxId() : null)
                .codStatus(codTx != null ? CodStatus.settled.name() : null)
                .actionId(action.getActionId())
                .actionType(ACTION_COUNTER_RECEIVE)
                .receivedAt(now)
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
}
