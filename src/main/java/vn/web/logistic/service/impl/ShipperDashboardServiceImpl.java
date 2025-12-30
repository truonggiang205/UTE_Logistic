package vn.web.logistic.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.response.ShipperDashboardDTO;
import vn.web.logistic.dto.response.ShipperDashboardDTO.TodayOrderDTO;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.CodTransaction.CodStatus;
import vn.web.logistic.entity.ParcelAction;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.Shipper;
import vn.web.logistic.entity.ShipperTask;
import vn.web.logistic.entity.ShipperTask.TaskStatus;
import vn.web.logistic.entity.ShipperTask.TaskType;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.ActionTypeRepository;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.ParcelActionRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ShipperRepository;
import vn.web.logistic.repository.ShipperTaskRepository;
import vn.web.logistic.service.ShipperDashboardService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ShipperDashboardServiceImpl implements ShipperDashboardService {

    private final ShipperRepository shipperRepository;
    private final ShipperTaskRepository shipperTaskRepository;
    private final CodTransactionRepository codTransactionRepository;
    private final ServiceRequestRepository serviceRequestRepository;
    private final ActionTypeRepository actionTypeRepository;
    private final ParcelActionRepository parcelActionRepository;

    @Override
    public ShipperDashboardDTO getDashboardData(String email) {
        Shipper shipper = shipperRepository.findByUserEmail(email).orElse(null);

        if (shipper == null) {
            log.warn("Không tìm thấy shipper với email: {}", email);
            return getEmptyDashboard();
        }

        return getDashboardDataByShipperId(shipper.getShipperId());
    }

    @Override
    public ShipperDashboardDTO getDashboardDataByShipperId(Long shipperId) {
        // Lấy thời gian hôm nay
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(LocalTime.MAX);

        // Lấy thời gian tháng này
        LocalDateTime startOfMonth = today.withDayOfMonth(1).atStartOfDay();
        LocalDateTime endOfMonth = today.plusMonths(1).withDayOfMonth(1).atStartOfDay();

        List<TaskStatus> inProgressStatuses = Arrays.asList(TaskStatus.assigned, TaskStatus.in_progress);

        // Statistics Cards (Tổng hợp)

        // Tổng số đơn hôm nay (pickup + delivery)
        Long todayOrdersCount = shipperTaskRepository.countTodayTasksByShipper(
                shipperId, startOfDay, endOfDay);

        // Số đơn đang xử lý (assigned + in_progress)
        Long deliveringCount = shipperTaskRepository.countTasksByShipperAndStatuses(
                shipperId, inProgressStatuses);

        // Số đơn đã hoàn thành hôm nay
        Long completedCount = shipperTaskRepository.countCompletedTodayByShipper(
                shipperId, TaskStatus.completed, startOfDay, endOfDay);

        // Tổng tiền COD cần nộp
        BigDecimal totalCodAmount = codTransactionRepository.sumCodByShipperAndStatus(
                shipperId, CodStatus.collected);
        if (totalCodAmount == null) {
            totalCodAmount = BigDecimal.ZERO;
        }

        // Statistics theo loại Task

        // PICKUP Statistics
        Long todayPickupCount = shipperTaskRepository.countTodayTasksByShipperAndType(
                shipperId, TaskType.pickup, startOfDay, endOfDay);

        Long pickupInProgressCount = shipperTaskRepository.countTasksByShipperTypeAndStatuses(
                shipperId, TaskType.pickup, inProgressStatuses);

        Long pickupCompletedCount = shipperTaskRepository.countCompletedTodayByShipperAndType(
                shipperId, TaskType.pickup, TaskStatus.completed, startOfDay, endOfDay);

        // DELIVERY Statistics
        Long todayDeliveryCount = shipperTaskRepository.countTodayTasksByShipperAndType(
                shipperId, TaskType.delivery, startOfDay, endOfDay);

        Long deliveryInProgressCount = shipperTaskRepository.countTasksByShipperTypeAndStatuses(
                shipperId, TaskType.delivery, inProgressStatuses);

        Long deliveryCompletedCount = shipperTaskRepository.countCompletedTodayByShipperAndType(
                shipperId, TaskType.delivery, TaskStatus.completed, startOfDay, endOfDay);

        // === Shipper Info ===
        Shipper shipper = shipperRepository.findById(shipperId).orElse(null);
        BigDecimal shipperRating = shipper != null ? shipper.getRating() : BigDecimal.valueOf(0);
        Long totalRatings = 0L;

        // === Monthly Stats ===
        Long monthlyOrders = shipperTaskRepository.countCompletedMonthlyByShipper(
                shipperId, TaskStatus.completed, startOfMonth, endOfMonth);

        // Tính thu nhập (tạm tính = số đơn * 15,000đ/đơn)
        BigDecimal monthlyEarnings = BigDecimal.valueOf(monthlyOrders != null ? monthlyOrders : 0)
                .multiply(BigDecimal.valueOf(15000));

        // Tính tỷ lệ thành công
        Long totalMonthlyTasks = shipperTaskRepository.countTotalMonthlyTasksByShipper(
                shipperId, startOfMonth, endOfMonth);
        Integer successRate = 0;
        if (totalMonthlyTasks != null && totalMonthlyTasks > 0 && monthlyOrders != null) {
            successRate = BigDecimal.valueOf(monthlyOrders)
                    .multiply(BigDecimal.valueOf(100))
                    .divide(BigDecimal.valueOf(totalMonthlyTasks), 0, RoundingMode.HALF_UP)
                    .intValue();
        }

        // === Today's Orders ===

        // Pickup orders hôm nay
        List<ShipperTask> pickupTasks = shipperTaskRepository.findTodayTasksByShipperAndType(
                shipperId, TaskType.pickup, startOfDay, endOfDay);
        List<TodayOrderDTO> todayPickupOrders = pickupTasks.stream()
                .limit(5)
                .map(t -> mapToTodayOrderDTO(t, TaskType.pickup))
                .collect(Collectors.toList());

        // Delivery orders hôm nay
        List<ShipperTask> deliveryTasks = shipperTaskRepository.findTodayTasksByShipperAndType(
                shipperId, TaskType.delivery, startOfDay, endOfDay);
        List<TodayOrderDTO> todayDeliveryOrders = deliveryTasks.stream()
                .limit(5)
                .map(t -> mapToTodayOrderDTO(t, TaskType.delivery))
                .collect(Collectors.toList());

        // Tất cả orders hôm nay (top 5)
        List<ShipperTask> allTasks = shipperTaskRepository.findTodayTasksByShipper(
                shipperId, startOfDay, endOfDay);
        List<TodayOrderDTO> todayOrders = allTasks.stream()
                .limit(5)
                .map(t -> mapToTodayOrderDTO(t, t.getTaskType()))
                .collect(Collectors.toList());

        return ShipperDashboardDTO.builder()
                // Tổng hợp
                .todayOrdersCount(todayOrdersCount != null ? todayOrdersCount : 0L)
                .deliveringCount(deliveringCount != null ? deliveringCount : 0L)
                .completedCount(completedCount != null ? completedCount : 0L)
                .totalCodAmount(totalCodAmount)
                // Pickup
                .todayPickupCount(todayPickupCount != null ? todayPickupCount : 0L)
                .pickupInProgressCount(pickupInProgressCount != null ? pickupInProgressCount : 0L)
                .pickupCompletedCount(pickupCompletedCount != null ? pickupCompletedCount : 0L)
                // Delivery
                .todayDeliveryCount(todayDeliveryCount != null ? todayDeliveryCount : 0L)
                .deliveryInProgressCount(deliveryInProgressCount != null ? deliveryInProgressCount : 0L)
                .deliveryCompletedCount(deliveryCompletedCount != null ? deliveryCompletedCount : 0L)
                // Shipper info
                .shipperRating(shipperRating)
                .totalRatings(totalRatings)
                // Monthly
                .monthlyEarnings(monthlyEarnings)
                .monthlyOrders(monthlyOrders != null ? monthlyOrders : 0L)
                .successRate(successRate)
                // Orders
                .todayPickupOrders(todayPickupOrders)
                .todayDeliveryOrders(todayDeliveryOrders)
                .todayOrders(todayOrders)
                .build();
    }

    // Map ShipperTask sang TodayOrderDTO
    private TodayOrderDTO mapToTodayOrderDTO(ShipperTask task, TaskType taskType) {
        var request = task.getRequest();
        var address = taskType == TaskType.pickup ? request.getPickupAddress() : request.getDeliveryAddress();

        String fullAddress = "N/A";
        String contactName = "N/A";
        String contactPhone = "N/A";

        if (address != null) {
            contactName = address.getContactName() != null ? address.getContactName() : "N/A";
            contactPhone = address.getContactPhone() != null ? address.getContactPhone() : "N/A";

            StringBuilder sb = new StringBuilder();
            if (address.getAddressDetail() != null)
                sb.append(address.getAddressDetail());
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
            fullAddress = sb.length() > 0 ? sb.toString() : "N/A";
        }

        return TodayOrderDTO.builder()
                .id(request.getRequestId())
                .taskId(task.getTaskId())
                .trackingNumber(getTrackingNumber(request.getRequestId()))
                .contactName(contactName)
                .contactPhone(contactPhone)
                .contactAddress(fullAddress)
                .contactLabel(taskType == TaskType.pickup ? "Người gửi" : "Người nhận")
                .codAmount(request.getCodAmount() != null ? request.getCodAmount() : BigDecimal.ZERO)
                .status(task.getTaskStatus().name())
                .statusText(getStatusText(task.getTaskStatus(), taskType))
                .statusBadge(getStatusBadge(task.getTaskStatus()))
                .taskType(taskType.name())
                .taskTypeText(getTaskTypeText(taskType))
                .build();
    }

    private String getTrackingNumber(Long requestId) {
        return String.format("VN%08d", requestId);
    }

    // Lấy text hiển thị cho status (phân biệt pickup/delivery)
    private String getStatusText(TaskStatus status, TaskType taskType) {
        if (taskType == TaskType.pickup) {
            return switch (status) {
                case assigned -> "Chờ lấy hàng";
                case in_progress -> "Đang lấy hàng";
                case completed -> "Đã lấy hàng";
                case failed -> "Lấy hàng thất bại";
            };
        } else {
            return switch (status) {
                case assigned -> "Chờ giao hàng";
                case in_progress -> "Đang giao hàng";
                case completed -> "Đã giao hàng";
                case failed -> "Giao hàng thất bại";
            };
        }
    }

    private String getStatusBadge(TaskStatus status) {
        return switch (status) {
            case assigned -> "warning";
            case in_progress -> "info";
            case completed -> "success";
            case failed -> "danger";
        };
    }

    private String getTaskTypeText(TaskType taskType) {
        return switch (taskType) {
            case pickup -> "Lấy hàng";
            case delivery -> "Giao hàng";
        };
    }

    private ShipperDashboardDTO getEmptyDashboard() {
        return ShipperDashboardDTO.builder()
                .todayOrdersCount(0L)
                .deliveringCount(0L)
                .completedCount(0L)
                .totalCodAmount(BigDecimal.ZERO)
                .todayPickupCount(0L)
                .pickupInProgressCount(0L)
                .pickupCompletedCount(0L)
                .todayDeliveryCount(0L)
                .deliveryInProgressCount(0L)
                .deliveryCompletedCount(0L)
                .shipperRating(BigDecimal.ZERO)
                .totalRatings(0L)
                .monthlyEarnings(BigDecimal.ZERO)
                .monthlyOrders(0L)
                .successRate(0)
                .todayPickupOrders(List.of())
                .todayDeliveryOrders(List.of())
                .todayOrders(List.of())
                .build();
    }

    // ==================== UPDATE PICKUP STATUS ====================

    @Override
    @Transactional
    public void updatePickupStatus(Long taskId, String status, String note, String shipperEmail) {
        log.info("Bắt đầu cập nhật pickup task {} với status {} cho shipper {}", taskId, status, shipperEmail);

        // 1. Tìm shipper theo email
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin shipper"));

        // 2. Tìm task
        ShipperTask task = shipperTaskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy task: " + taskId));

        // 3. Kiểm tra quyền (task có thuộc về shipper này không)
        if (!task.getShipper().getShipperId().equals(shipper.getShipperId())) {
            throw new RuntimeException("Bạn không có quyền cập nhật task này");
        }

        // 4. Kiểm tra task type phải là pickup
        if (task.getTaskType() != TaskType.pickup) {
            throw new RuntimeException("Task này không phải là pickup task");
        }

        // 5. Parse và validate status
        TaskStatus newStatus;
        try {
            newStatus = TaskStatus.valueOf(status);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Trạng thái không hợp lệ: " + status);
        }

        // 6. Cập nhật ShipperTask
        TaskStatus oldStatus = task.getTaskStatus();
        task.setTaskStatus(newStatus);
        task.setResultNote(note);

        if (newStatus == TaskStatus.completed || newStatus == TaskStatus.failed) {
            task.setCompletedAt(LocalDateTime.now());
        }

        shipperTaskRepository.save(task);
        log.info("Đã cập nhật task {} từ {} sang {}", taskId, oldStatus, newStatus);

        // 7. Ghi nhận lịch sử hành động
        String actionCode = getPickupActionCode(newStatus);
        User actor = shipper.getUser();
        recordParcelAction(task.getRequest(), actionCode, actor, note);

        // 8. Đồng bộ cập nhật ServiceRequest status
        updateServiceRequestStatusAfterPickup(task, newStatus);
    }

    // Cập nhật trạng thái ServiceRequest sau khi pickup
    private void updateServiceRequestStatusAfterPickup(ShipperTask task, TaskStatus taskStatus) {
        var request = task.getRequest();

        if (taskStatus == TaskStatus.completed) {
            // Pickup hoàn thành → Đơn hàng chuyển sang "picked" (đã lấy hàng)
            request.setStatus(RequestStatus.picked);
            serviceRequestRepository.save(request);
            log.info("Request {} chuyển sang PICKED", request.getRequestId());
        } else if (taskStatus == TaskStatus.failed) {
            // Pickup thất bại → Đơn hàng chuyển sang "failed"
            request.setStatus(RequestStatus.failed);
            serviceRequestRepository.save(request);
            log.info("Request {} chuyển sang FAILED (pickup thất bại)", request.getRequestId());
        }
    }

    // ==================== UPDATE DELIVERY STATUS ====================

    @Override
    @Transactional
    public void updateDeliveryStatus(Long taskId, String status, String note, String shipperEmail) {
        log.info("Bắt đầu cập nhật delivery task {} với status {} cho shipper {}", taskId, status, shipperEmail);

        // 1. Tìm shipper theo email
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin shipper"));

        // 2. Tìm task
        ShipperTask task = shipperTaskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy task: " + taskId));

        // 3. Kiểm tra quyền (task có thuộc về shipper này không)
        if (!task.getShipper().getShipperId().equals(shipper.getShipperId())) {
            throw new RuntimeException("Bạn không có quyền cập nhật task này");
        }

        // 4. Kiểm tra task type phải là delivery
        if (task.getTaskType() != TaskType.delivery) {
            throw new RuntimeException("Task này không phải là delivery task");
        }

        // 5. Parse và validate status
        TaskStatus newStatus;
        try {
            newStatus = TaskStatus.valueOf(status);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Trạng thái không hợp lệ: " + status);
        }

        // 6. Cập nhật ShipperTask
        TaskStatus oldStatus = task.getTaskStatus();
        task.setTaskStatus(newStatus);
        task.setResultNote(note);

        if (newStatus == TaskStatus.completed || newStatus == TaskStatus.failed) {
            task.setCompletedAt(LocalDateTime.now());
        }

        shipperTaskRepository.save(task);
        log.info("Đã cập nhật task {} từ {} sang {}", taskId, oldStatus, newStatus);

        // 7. Ghi nhận lịch sử hành động
        String actionCode = getDeliveryActionCode(newStatus);
        User actor = shipper.getUser();
        recordParcelAction(task.getRequest(), actionCode, actor, note);

        // 8. Đồng bộ cập nhật ServiceRequest status
        updateServiceRequestStatusAfterDelivery(task, newStatus);
    }

    // Cập nhật trạng thái ServiceRequest sau khi delivery
    private void updateServiceRequestStatusAfterDelivery(ShipperTask task, TaskStatus taskStatus) {
        var request = task.getRequest();

        if (taskStatus == TaskStatus.completed) {
            // Delivery hoàn thành → Đơn hàng chuyển sang "delivered" (đã giao hàng)
            request.setStatus(RequestStatus.delivered);
            serviceRequestRepository.save(request);
            log.info("Request {} chuyển sang DELIVERED", request.getRequestId());
        } else if (taskStatus == TaskStatus.failed) {
            // Delivery thất bại → Đơn hàng chuyển sang "failed"
            request.setStatus(RequestStatus.failed);
            serviceRequestRepository.save(request);
            log.info("Request {} chuyển sang FAILED (delivery thất bại)", request.getRequestId());
        }
    }

    // ==================== PARCEL ACTION HISTORY ====================

    /**
     * Ghi nhận lịch sử hành động vào bảng PARCEL_ACTIONS
     */
    private void recordParcelAction(ServiceRequest request, String actionCode, User actor, String note) {
        try {
            // Tìm ActionType theo code
            ActionType actionType = actionTypeRepository.findByActionCode(actionCode)
                    .orElse(null);

            if (actionType == null) {
                log.warn("Không tìm thấy ActionType với code: {}. Bỏ qua ghi nhận lịch sử.", actionCode);
                return;
            }

            // Tạo ParcelAction mới
            ParcelAction parcelAction = ParcelAction.builder()
                    .request(request)
                    .actionType(actionType)
                    .actor(actor)
                    .actionTime(LocalDateTime.now())
                    .note(note)
                    .build();

            parcelActionRepository.save(parcelAction);
            log.info("Đã ghi nhận lịch sử hành động: {} cho request {}", actionCode, request.getRequestId());

        } catch (Exception e) {
            // Không throw exception để không ảnh hưởng flow chính
            log.error("Lỗi khi ghi nhận lịch sử hành động: {}", e.getMessage());
        }
    }

    /**
     * Lấy action code cho pickup dựa trên status
     */
    private String getPickupActionCode(TaskStatus status) {
        return switch (status) {
            case in_progress -> "PICKUP_STARTED";
            case completed -> "PICKUP_COMPLETED";
            case failed -> "PICKUP_FAILED";
            default -> "PICKUP_UPDATED";
        };
    }

    /**
     * Lấy action code cho delivery dựa trên status
     */
    private String getDeliveryActionCode(TaskStatus status) {
        return switch (status) {
            case in_progress -> "DELIVERY_STARTED";
            case completed -> "DELIVERY_COMPLETED";
            case failed -> "DELIVERY_FAILED";
            default -> "DELIVERY_UPDATED";
        };
    }

    // ==================== GET ALL ORDERS ====================

    @Override
    public List<TodayOrderDTO> getAllOrdersByShipper(String shipperEmail, String taskType, String status) {
        log.info("Lấy tất cả đơn hàng của shipper {} với filter: taskType={}, status={}",
                shipperEmail, taskType, status);

        // 1. Tìm shipper
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            log.warn("Không tìm thấy shipper với email: {}", shipperEmail);
            return List.of();
        }

        Long shipperId = shipper.getShipperId();

        // 2. Lấy tất cả tasks của shipper
        List<ShipperTask> tasks = shipperTaskRepository.findByShipperShipperId(shipperId);

        // 3. Filter theo taskType nếu có
        if (taskType != null && !taskType.isEmpty() && !taskType.equals("all")) {
            TaskType filterType = TaskType.valueOf(taskType);
            tasks = tasks.stream()
                    .filter(t -> t.getTaskType() == filterType)
                    .collect(Collectors.toList());
        }

        // 4. Filter theo status nếu có
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            TaskStatus filterStatus = TaskStatus.valueOf(status);
            tasks = tasks.stream()
                    .filter(t -> t.getTaskStatus() == filterStatus)
                    .collect(Collectors.toList());
        }

        // 5. Convert to DTO
        return tasks.stream()
                .map(this::convertToOrderDTO)
                .collect(Collectors.toList());
    }

    private TodayOrderDTO convertToOrderDTO(ShipperTask task) {
        var request = task.getRequest();
        boolean isPickup = task.getTaskType() == TaskType.pickup;

        // Lấy thông tin liên hệ
        String contactName = "";
        String contactPhone = "";
        String contactAddress = "";
        String contactLabel;

        if (isPickup) {
            // Pickup: lấy thông tin từ pickupAddress (người gửi)
            contactLabel = "Người gửi";
            if (request.getPickupAddress() != null) {
                var addr = request.getPickupAddress();
                contactName = addr.getContactName() != null ? addr.getContactName() : "";
                contactPhone = addr.getContactPhone() != null ? addr.getContactPhone() : "";
                contactAddress = formatAddress(addr);
            }
        } else {
            // Delivery: lấy thông tin từ deliveryAddress (người nhận)
            contactLabel = "Người nhận";
            if (request.getDeliveryAddress() != null) {
                var addr = request.getDeliveryAddress();
                contactName = addr.getContactName() != null ? addr.getContactName() : "";
                contactPhone = addr.getContactPhone() != null ? addr.getContactPhone() : "";
                contactAddress = formatAddress(addr);
            }
        }

        return TodayOrderDTO.builder()
                .id(request.getRequestId())
                .taskId(task.getTaskId())
                .trackingNumber("VN" + String.format("%08d", request.getRequestId())) // Generate tracking
                .contactName(contactName)
                .contactPhone(contactPhone)
                .contactAddress(contactAddress)
                .contactLabel(contactLabel)
                .codAmount(request.getCodAmount() != null ? request.getCodAmount() : BigDecimal.ZERO)
                .status(task.getTaskStatus().name())
                .statusText(getStatusText(task.getTaskStatus(), task.getTaskType()))
                .statusBadge(getStatusBadge(task.getTaskStatus()))
                .taskType(task.getTaskType().name())
                .taskTypeText(isPickup ? "Lấy hàng" : "Giao hàng")
                .build();
    }

    private String formatAddress(vn.web.logistic.entity.CustomerAddress addr) {
        if (addr == null)
            return "";
        StringBuilder sb = new StringBuilder();
        if (addr.getAddressDetail() != null)
            sb.append(addr.getAddressDetail());
        if (addr.getWard() != null) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(addr.getWard());
        }
        if (addr.getDistrict() != null) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(addr.getDistrict());
        }
        if (addr.getProvince() != null) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(addr.getProvince());
        }
        return sb.toString();
    }

    // ==================== GET IN PROGRESS TASKS ====================

    @Override
    public List<TodayOrderDTO> getInProgressTasks(String shipperEmail) {
        log.info("Lấy các đơn đang xử lý (in_progress) của shipper: {}", shipperEmail);

        // 1. Tìm shipper
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            log.warn("Không tìm thấy shipper với email: {}", shipperEmail);
            return List.of();
        }

        Long shipperId = shipper.getShipperId();

        // 2. Lấy tất cả task có status = in_progress
        List<ShipperTask> tasks = shipperTaskRepository.findByShipperShipperIdAndTaskStatus(
                shipperId, TaskStatus.in_progress);

        // 3. Convert to DTO
        return tasks.stream()
                .map(this::convertToOrderDTO)
                .collect(Collectors.toList());
    }

    // ==================== GET ORDER HISTORY ====================

    @Override
    public org.springframework.data.domain.Page<TodayOrderDTO> getOrderHistory(
            String shipperEmail, LocalDate fromDate, LocalDate toDate,
            String status, org.springframework.data.domain.Pageable pageable) {

        log.info("Lấy lịch sử đơn hàng của shipper: {}, từ {} đến {}, status: {}",
                shipperEmail, fromDate, toDate, status);

        // 1. Tìm shipper
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            log.warn("Không tìm thấy shipper với email: {}", shipperEmail);
            return org.springframework.data.domain.Page.empty();
        }

        Long shipperId = shipper.getShipperId();

        // 2. Xác định filter status (chỉ lấy completed và failed)
        List<TaskStatus> statusList;
        if (status != null && !status.isEmpty()) {
            if ("completed".equals(status) || "delivered".equals(status)) {
                statusList = List.of(TaskStatus.completed);
            } else if ("failed".equals(status)) {
                statusList = List.of(TaskStatus.failed);
            } else {
                statusList = List.of(TaskStatus.completed, TaskStatus.failed);
            }
        } else {
            statusList = List.of(TaskStatus.completed, TaskStatus.failed);
        }

        // 3. Xác định khoảng thời gian
        LocalDateTime startDateTime = fromDate != null
                ? fromDate.atStartOfDay()
                : LocalDate.now().minusMonths(1).atStartOfDay();
        LocalDateTime endDateTime = toDate != null
                ? toDate.atTime(LocalTime.MAX)
                : LocalDate.now().atTime(LocalTime.MAX);

        // 4. Lấy tasks từ repository với phân trang
        org.springframework.data.domain.Page<ShipperTask> taskPage = shipperTaskRepository
                .findHistoryByShipperAndStatusAndDateRange(
                        shipperId, statusList, startDateTime, endDateTime, pageable);

        // 5. Convert to DTO
        return taskPage.map(this::convertToOrderDTO);
    }
}
