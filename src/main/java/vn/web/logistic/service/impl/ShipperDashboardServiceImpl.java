package vn.web.logistic.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.ChangePasswordRequest;
import vn.web.logistic.dto.response.CodHistoryDTO;
import vn.web.logistic.dto.response.EarningHistoryDTO;
import vn.web.logistic.dto.response.OrderDetailDTO;
import vn.web.logistic.dto.response.ShipperDashboardDTO;
import vn.web.logistic.dto.response.ShipperDashboardDTO.TodayOrderDTO;
import vn.web.logistic.dto.response.ShipperEarningsDTO;
import vn.web.logistic.dto.response.ShipperProfileDTO;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.CodTransaction.CodStatus;
import vn.web.logistic.entity.Hub;
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
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.FileUploadService;
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
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final FileUploadService fileUploadService;

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

        // Tổng tiền COD cần nộp (pending = shipper đang giữ, cần nộp)
        BigDecimal totalCodAmount = codTransactionRepository.sumCodByShipperAndStatus(
                shipperId, CodStatus.pending);
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

        // Shipper Info
        Shipper shipper = shipperRepository.findById(shipperId).orElse(null);
        BigDecimal shipperRating = shipper != null ? shipper.getRating() : BigDecimal.valueOf(0);
        Long totalRatings = 0L;

        // Monthly Stats
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

        // Today's Orders

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

    // UPDATE PICKUP STATUS

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
            // Pickup thất bại → GIỮ NGUYÊN status pending để có thể phân công lại
            // KHÔNG đổi status sang failed, vì đơn hàng vẫn chờ được lấy
            log.info("Request {} - Pickup thất bại, giữ nguyên status {} để phân công lại",
                    request.getRequestId(), request.getStatus());
        }
    }

    // UPDATE DELIVERY STATUS

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
        var shipper = task.getShipper();

        if (taskStatus == TaskStatus.completed) {
            // Delivery hoàn thành → Đơn hàng chuyển sang "delivered" (đã giao hàng)
            request.setStatus(RequestStatus.delivered);
            serviceRequestRepository.save(request);
            log.info("Request {} chuyển sang DELIVERED", request.getRequestId());

            // Tạo COD Transaction nếu có tiền thu hộ
            createCodTransactionIfNeeded(request, shipper);
        } else if (taskStatus == TaskStatus.failed) {
            // Delivery thất bại → GIỮ NGUYÊN status in_transit để có thể phân công lại
            // KHÔNG đổi status sang failed, vì đơn hàng vẫn ở Hub và cần được giao lại
            log.info("Request {} - Delivery thất bại, giữ nguyên status {} để phân công lại",
                    request.getRequestId(), request.getStatus());
        }
    }

    /**
     * Tạo COD Transaction khi giao hàng thành công
     * Shipper cần thu và nộp: receiverPayAmount = COD + Cước vận chuyển
     * Status = pending (shipper đang giữ tiền, chờ nộp)
     */
    private void createCodTransactionIfNeeded(ServiceRequest request, Shipper shipper) {
        // CHECK 1: Nếu đơn đã paid (người gửi đã thanh toán), shipper không cần thu
        // tiền
        if (request.getPaymentStatus() == ServiceRequest.PaymentStatus.paid) {
            log.info("Request {} đã được thanh toán (paymentStatus=paid), shipper không cần thu tiền",
                    request.getRequestId());
            return;
        }

        // Tính tổng tiền shipper cần thu = receiverPayAmount (COD + Cước nếu người nhận
        // trả)
        BigDecimal totalCollect = request.getReceiverPayAmount();

        // Nếu receiverPayAmount null, tính = codAmount + totalPrice
        if (totalCollect == null || totalCollect.compareTo(BigDecimal.ZERO) <= 0) {
            BigDecimal cod = request.getCodAmount() != null ? request.getCodAmount() : BigDecimal.ZERO;
            BigDecimal shipping = request.getTotalPrice() != null ? request.getTotalPrice() : BigDecimal.ZERO;
            totalCollect = cod.add(shipping);
        }

        // Bỏ qua nếu không có tiền cần thu
        if (totalCollect == null || totalCollect.compareTo(BigDecimal.ZERO) <= 0) {
            log.info("Request {} không có tiền cần thu (COD=0, Cước=0), bỏ qua COD Transaction",
                    request.getRequestId());
            return;
        }

        // Kiểm tra xem đã có COD Transaction cho đơn này chưa
        var existingCod = codTransactionRepository.findByRequestId(request.getRequestId());

        if (existingCod.isPresent()) {
            CodTransaction existing = existingCod.get();
            // Nếu COD đã tồn tại nhưng chưa có shipper (từ drop-off), cập nhật shipper
            if (existing.getShipper() == null) {
                existing.setShipper(shipper);
                codTransactionRepository.save(existing);
                log.info("Request {} đã có COD Transaction, cập nhật shipper_id = {}",
                        request.getRequestId(), shipper.getShipperId());
            } else {
                log.info("Request {} đã có COD Transaction với shipper, bỏ qua", request.getRequestId());
            }
            return;
        }

        // Tạo COD Transaction mới với status = pending (shipper đang giữ tiền, chờ nộp)
        CodTransaction codTx = CodTransaction.builder()
                .request(request)
                .shipper(shipper)
                .amount(totalCollect) // COD + Cước
                .status(CodStatus.pending) // Chờ shipper nộp
                .collectedAt(null)
                .settledAt(null)
                .build();

        CodTransaction saved = codTransactionRepository.save(codTx);
        log.info("Đã tạo COD Transaction cho request {}: {}đ (COD+Cước), status={}",
                request.getRequestId(), totalCollect, saved.getStatus());
    }

    // PARCEL ACTION HISTORY

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

    // GET ALL ORDERS

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
                .itemName(request.getItemName() != null ? request.getItemName() : "Hàng hóa")
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

    // GET IN PROGRESS TASKS

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

    // GET ORDER HISTORY

    @Override
    public Page<TodayOrderDTO> getOrderHistory(
            String shipperEmail, LocalDate fromDate, LocalDate toDate,
            String status, Pageable pageable) {

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
        Page<ShipperTask> taskPage = shipperTaskRepository
                .findHistoryByShipperAndStatusAndDateRange(
                        shipperId, statusList, startDateTime, endDateTime, pageable);

        // 5. Convert to DTO
        return taskPage.map(this::convertToOrderDTO);
    }

    // GET ORDER DETAIL

    @Override
    public OrderDetailDTO getOrderDetail(Long taskId, String shipperEmail) {
        log.info("Lấy chi tiết đơn hàng taskId={} cho shipper: {}", taskId, shipperEmail);

        // 1. Tìm shipper
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            log.warn("Không tìm thấy shipper với email: {}", shipperEmail);
            return null;
        }

        // 2. Tìm task
        ShipperTask task = shipperTaskRepository.findById(taskId).orElse(null);
        if (task == null) {
            log.warn("Không tìm thấy task với id: {}", taskId);
            return null;
        }

        // 3. Kiểm tra task có thuộc về shipper không
        if (!task.getShipper().getShipperId().equals(shipper.getShipperId())) {
            log.warn("Task {} không thuộc về shipper {}", taskId, shipperEmail);
            return null;
        }

        ServiceRequest request = task.getRequest();
        if (request == null) {
            return null;
        }

        // 4. Build DTO
        var builder = OrderDetailDTO.builder()
                // Thông tin đơn hàng
                .requestId(request.getRequestId())
                .trackingNumber("VN" + String.format("%08d", request.getRequestId()))
                .itemName(request.getItemName() != null ? request.getItemName() : "Hàng hóa")
                .status(request.getStatus().name())
                .statusText(getRequestStatusText(request.getStatus()))
                .statusBadge(getRequestStatusBadge(request.getStatus()))
                // Task info
                .taskId(task.getTaskId())
                .taskType(task.getTaskType().name())
                .taskTypeText(task.getTaskType() == TaskType.pickup ? "Lấy hàng" : "Giao hàng")
                .taskStatus(task.getTaskStatus().name())
                .taskStatusText(getStatusText(task.getTaskStatus(), task.getTaskType()))
                .assignedAt(task.getAssignedAt())
                .completedAt(task.getCompletedAt())
                .resultNote(task.getResultNote())
                // Kích thước & Trọng lượng
                .weight(request.getWeight())
                .length(request.getLength())
                .width(request.getWidth())
                .height(request.getHeight())
                .chargeableWeight(request.getChargeableWeight())
                // Chi phí
                .codAmount(request.getCodAmount())
                .shippingFee(request.getShippingFee())
                .codFee(request.getCodFee())
                .insuranceFee(request.getInsuranceFee())
                .totalPrice(request.getTotalPrice())
                .receiverPayAmount(request.getReceiverPayAmount())
                .paymentStatus(request.getPaymentStatus() != null ? request.getPaymentStatus().name() : "unpaid")
                .paymentStatusText(getPaymentStatusText(request.getPaymentStatus()))
                // Thông tin khác
                .note(request.getNote())
                .imageOrder(request.getImageOrder())
                .expectedPickupTime(request.getExpectedPickupTime())
                .createdAt(request.getCreatedAt());

        // Thông tin người gửi (pickup address)
        if (request.getPickupAddress() != null) {
            var addr = request.getPickupAddress();
            builder.senderName(addr.getContactName())
                    .senderPhone(addr.getContactPhone())
                    .senderAddress(formatAddress(addr));
        }

        // Thông tin người nhận (delivery address)
        if (request.getDeliveryAddress() != null) {
            var addr = request.getDeliveryAddress();
            builder.receiverName(addr.getContactName())
                    .receiverPhone(addr.getContactPhone())
                    .receiverAddress(formatAddress(addr));
        }

        // Service type
        if (request.getServiceType() != null) {
            builder.serviceTypeName(request.getServiceType().getServiceName());
        }

        // Customer info
        if (request.getCustomer() != null) {
            builder.customerName(request.getCustomer().getFullName())
                    .customerPhone(request.getCustomer().getPhone())
                    .customerEmail(request.getCustomer().getEmail());
        }

        return builder.build();
    }

    private String getRequestStatusText(RequestStatus status) {
        if (status == null)
            return "Không xác định";
        return switch (status) {
            case pending -> "Chờ lấy hàng";
            case picked -> "Đã lấy hàng";
            case in_transit -> "Đang vận chuyển";
            case delivered -> "Đã giao";
            case cancelled -> "Đã hủy";
            case failed -> "Thất bại";
        };
    }

    private String getRequestStatusBadge(RequestStatus status) {
        if (status == null)
            return "secondary";
        return switch (status) {
            case pending -> "warning";
            case picked -> "info";
            case in_transit -> "primary";
            case delivered -> "success";
            case cancelled -> "dark";
            case failed -> "danger";
        };
    }

    private String getPaymentStatusText(ServiceRequest.PaymentStatus status) {
        if (status == null)
            return "Chưa thanh toán";
        return switch (status) {
            case unpaid -> "Chưa thanh toán";
            case paid -> "Đã thanh toán";
            case refunded -> "Đã hoàn tiền";
        };
    }

    // COD MANAGEMENT IMPLEMENTATION

    @Override
    public List<TodayOrderDTO> getUnpaidCodOrders(String shipperEmail) {
        log.info("Lấy danh sách COD chưa nộp của shipper: {}", shipperEmail);

        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            return List.of();
        }

        // Lấy các COD transactions có status = pending (shipper đang giữ tiền, chờ nộp)
        List<CodTransaction> codList = codTransactionRepository
                .findByShipperIdAndStatus(shipper.getShipperId(),
                        CodTransaction.CodStatus.pending);

        return codList.stream()
                .filter(cod -> cod.getRequest() != null)
                .map(cod -> {
                    ServiceRequest req = cod.getRequest();
                    var addr = req.getDeliveryAddress();
                    return TodayOrderDTO.builder()
                            .id(cod.getCodTxId())
                            .taskId(cod.getCodTxId())
                            .trackingNumber("VN" + String.format("%08d", req.getRequestId()))
                            .contactName(addr != null ? addr.getContactName() : "")
                            .contactPhone(addr != null ? addr.getContactPhone() : "")
                            .contactAddress(addr != null ? formatAddress(addr) : "")
                            .codAmount(cod.getAmount())
                            .status("pending")
                            .statusText("Chờ nộp")
                            .itemName(req.getItemName() != null ? req.getItemName() : "Hàng hóa")
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Override
    public BigDecimal getTotalUnpaidCod(String shipperEmail) {
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            return BigDecimal.ZERO;
        }

        return codTransactionRepository.sumCodByShipperAndStatus(
                shipper.getShipperId(),
                CodTransaction.CodStatus.pending);
    }

    @Override
    @Transactional
    public void submitCod(String shipperEmail, List<Long> codTxIds, String paymentMethod, String note) {
        log.info("Shipper {} nộp COD: {} transactions, method: {}", shipperEmail, codTxIds.size(), paymentMethod);

        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            throw new RuntimeException("Không tìm thấy shipper");
        }

        LocalDateTime now = LocalDateTime.now();

        for (Long codTxId : codTxIds) {
            CodTransaction codTx = codTransactionRepository.findById(codTxId).orElse(null);
            if (codTx == null) {
                log.warn("Không tìm thấy COD transaction: {}", codTxId);
                continue;
            }

            // Kiểm tra COD thuộc về shipper
            if (!codTx.getShipper().getShipperId().equals(shipper.getShipperId())) {
                log.warn("COD {} không thuộc về shipper {}", codTxId, shipperEmail);
                continue;
            }

            // Chỉ chuyển nếu đang ở status pending
            if (codTx.getStatus() != CodStatus.pending) {
                log.warn("COD {} không ở trạng thái pending (hiện: {}), bỏ qua", codTxId, codTx.getStatus());
                continue;
            }

            // Cập nhật trạng thái: pending → collected (shipper đã nộp, chờ Admin duyệt)
            codTx.setStatus(CodStatus.collected);
            codTx.setCollectedAt(now); // Thời gian shipper nộp
            codTx.setPaymentMethod(paymentMethod);
            codTransactionRepository.save(codTx);

            log.info("COD {} chuyển sang collected (đã nộp, chờ Admin duyệt)", codTxId);
        }
    }

    @Override
    public List<CodHistoryDTO> getCodHistory(String shipperEmail) {
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            return List.of();
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        List<CodHistoryDTO> result = new java.util.ArrayList<>();

        // 1. Lấy COD đã nộp, chờ Admin duyệt (collected)
        List<vn.web.logistic.entity.CodTransaction> collectedList = codTransactionRepository
                .findByShipperIdAndStatus(shipper.getShipperId(), CodStatus.collected);

        for (var cod : collectedList) {
            result.add(CodHistoryDTO.builder()
                    .transactionId(cod.getCodTxId())
                    .transactionCode("COD" + String.format("%08d", cod.getCodTxId()))
                    .amount(cod.getAmount())
                    .orderCount(1)
                    .submittedAt(cod.getCollectedAt() != null ? cod.getCollectedAt().format(formatter) : "N/A")
                    .receiverName("Chờ xác nhận")
                    .status("collected")
                    .build());
        }

        // 2. Lấy COD đã xác nhận (settled)
        List<CodTransaction> settledList = codTransactionRepository
                .findSettledByShipperId(shipper.getShipperId());

        for (var cod : settledList) {
            result.add(CodHistoryDTO.builder()
                    .transactionId(cod.getCodTxId())
                    .transactionCode("COD" + String.format("%08d", cod.getCodTxId()))
                    .amount(cod.getAmount())
                    .orderCount(1)
                    .submittedAt(cod.getSettledAt() != null ? cod.getSettledAt().format(formatter) : "N/A")
                    .receiverName("Admin")
                    .status("settled")
                    .build());
        }

        return result;
    }

    @Override
    public Page<CodHistoryDTO> getCodHistoryPaged(String shipperEmail, Pageable pageable) {
        List<CodHistoryDTO> allHistory = getCodHistory(shipperEmail);

        // Sort theo thời gian giảm dần (mới nhất lên đầu)
        allHistory.sort((a, b) -> {
            if (a.getSubmittedAt() == null)
                return 1;
            if (b.getSubmittedAt() == null)
                return -1;
            return b.getSubmittedAt().compareTo(a.getSubmittedAt());
        });

        // Phân trang thủ công
        int totalElements = allHistory.size();
        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), totalElements);

        List<CodHistoryDTO> pageContent = start < totalElements
                ? allHistory.subList(start, end)
                : java.util.List.of();

        return new PageImpl<>(pageContent, pageable, totalElements);
    }

    // EARNINGS IMPLEMENTATION

    @Override
    public ShipperEarningsDTO getEarningsData(String shipperEmail) {
        log.info("Lấy dữ liệu thu nhập của shipper: {}", shipperEmail);

        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            return ShipperEarningsDTO.builder()
                    .todayEarnings(BigDecimal.ZERO)
                    .weeklyEarnings(BigDecimal.ZERO)
                    .monthlyEarnings(BigDecimal.ZERO)
                    .totalEarnings(BigDecimal.ZERO)
                    .todayOrders(0)
                    .weeklyOrders(0)
                    .monthlyOrders(0)
                    .totalOrders(0)
                    .averagePerOrder(BigDecimal.ZERO)
                    .successRate(0)
                    .bonusAmount(BigDecimal.ZERO)
                    .chartLabels(List.of())
                    .chartData(List.of())
                    .recentHistory(List.of())
                    .build();
        }

        Long shipperId = shipper.getShipperId();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startOfToday = now.toLocalDate().atStartOfDay();
        LocalDateTime startOfWeek = now.toLocalDate().minusDays(now.getDayOfWeek().getValue() - 1).atStartOfDay();
        LocalDateTime startOfMonth = now.toLocalDate().withDayOfMonth(1).atStartOfDay();

        // Lấy tất cả task đã hoàn thành của shipper
        List<ShipperTask> allTasks = shipperTaskRepository.findByShipperShipperId(shipperId);
        List<ShipperTask> completedTasks = allTasks.stream()
                .filter(t -> t.getTaskStatus() == TaskStatus.completed)
                .collect(Collectors.toList());
        List<ShipperTask> failedTasks = allTasks.stream()
                .filter(t -> t.getTaskStatus() == TaskStatus.failed)
                .collect(Collectors.toList());

        // Tính phí shipper cho mỗi đơn (giả định: 30% phí vận chuyển)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        // Hôm nay
        List<ShipperTask> todayCompleted = completedTasks.stream()
                .filter(t -> t.getCompletedAt() != null && t.getCompletedAt().isAfter(startOfToday))
                .collect(Collectors.toList());
        BigDecimal todayEarnings = calculateEarnings(todayCompleted);

        // Tuần này
        List<ShipperTask> weeklyCompleted = completedTasks.stream()
                .filter(t -> t.getCompletedAt() != null && t.getCompletedAt().isAfter(startOfWeek))
                .collect(Collectors.toList());
        BigDecimal weeklyEarnings = calculateEarnings(weeklyCompleted);

        // Tháng này
        List<ShipperTask> monthlyCompleted = completedTasks.stream()
                .filter(t -> t.getCompletedAt() != null && t.getCompletedAt().isAfter(startOfMonth))
                .collect(Collectors.toList());
        BigDecimal monthlyEarnings = calculateEarnings(monthlyCompleted);

        // Tổng
        BigDecimal totalEarnings = calculateEarnings(completedTasks);

        // Đếm số đơn DELIVERY (chỉ delivery mới có thu nhập)
        long totalDeliveryCount = completedTasks.stream()
                .filter(t -> t.getTaskType() == TaskType.delivery)
                .count();

        // Phí trung bình (chia cho số đơn delivery, không phải tổng số task)
        BigDecimal averagePerOrder = BigDecimal.ZERO;
        if (totalDeliveryCount > 0) {
            averagePerOrder = totalEarnings.divide(
                    BigDecimal.valueOf(totalDeliveryCount), 0, RoundingMode.HALF_UP);
        }

        // Tỷ lệ thành công
        double successRate = 0;
        if (!completedTasks.isEmpty() || !failedTasks.isEmpty()) {
            successRate = Math.round((double) completedTasks.size() /
                    (completedTasks.size() + failedTasks.size()) * 100);
        }

        // Dữ liệu biểu đồ 7 ngày gần nhất
        List<String> chartLabels = new java.util.ArrayList<>();
        List<BigDecimal> chartData = new java.util.ArrayList<>();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM");

        for (int i = 6; i >= 0; i--) {
            LocalDateTime dayStart = now.toLocalDate().minusDays(i).atStartOfDay();
            LocalDateTime dayEnd = dayStart.plusDays(1);

            chartLabels.add(dayStart.format(dateFormatter));

            List<ShipperTask> dayCompleted = completedTasks.stream()
                    .filter(t -> t.getCompletedAt() != null &&
                            t.getCompletedAt().isAfter(dayStart) &&
                            t.getCompletedAt().isBefore(dayEnd))
                    .collect(Collectors.toList());
            chartData.add(calculateEarnings(dayCompleted));
        }

        // Lịch sử giao dịch gần đây (10 đơn GIAO HÀNG gần nhất)
        List<EarningHistoryDTO> recentHistory = completedTasks.stream()
                .filter(t -> t.getTaskType() == TaskType.delivery) // Chỉ lấy đơn giao hàng
                .sorted((a, b) -> {
                    if (a.getCompletedAt() == null)
                        return 1;
                    if (b.getCompletedAt() == null)
                        return -1;
                    return b.getCompletedAt().compareTo(a.getCompletedAt());
                })
                .limit(10)
                .map(task -> {
                    ServiceRequest req = task.getRequest();
                    // 13,000đ cố định cho mỗi đơn giao hàng
                    BigDecimal shipperFee = new BigDecimal("13000");

                    return EarningHistoryDTO.builder()
                            .taskId(task.getTaskId())
                            .trackingNumber(req != null ? "VN" + String.format("%08d", req.getRequestId()) : "N/A")
                            .customerName(req != null && req.getCustomer() != null &&
                                    req.getCustomer().getUser() != null ? req.getCustomer().getUser().getFullName()
                                            : "Khách hàng")
                            .amount(shipperFee)
                            .completedAt(
                                    task.getCompletedAt() != null ? task.getCompletedAt().format(formatter) : "N/A")
                            .taskType("delivery")
                            .status("completed")
                            .build();
                })
                .collect(Collectors.toList());

        // Tính bonus (ví dụ: 50,000đ nếu giao >= 20 đơn/tháng)
        BigDecimal bonusAmount = BigDecimal.ZERO;
        if (monthlyCompleted.size() >= 20) {
            bonusAmount = new BigDecimal("50000");
        }

        return ShipperEarningsDTO.builder()
                .todayEarnings(todayEarnings)
                .weeklyEarnings(weeklyEarnings)
                .monthlyEarnings(monthlyEarnings)
                .totalEarnings(totalEarnings)
                // Chỉ đếm số đơn DELIVERY (có thu nhập)
                .todayOrders((int) todayCompleted.stream().filter(t -> t.getTaskType() == TaskType.delivery).count())
                .weeklyOrders((int) weeklyCompleted.stream().filter(t -> t.getTaskType() == TaskType.delivery).count())
                .monthlyOrders(
                        (int) monthlyCompleted.stream().filter(t -> t.getTaskType() == TaskType.delivery).count())
                .totalOrders((int) totalDeliveryCount)
                .averagePerOrder(averagePerOrder)
                .successRate(successRate)
                .bonusAmount(bonusAmount)
                .chartLabels(chartLabels)
                .chartData(chartData)
                .recentHistory(recentHistory)
                .build();
    }

    /**
     * Tính thu nhập shipper từ danh sách task
     * Công thức: 13,000đ cố định cho mỗi đơn GIAO HÀNG (delivery)
     * Không tính tiền cho đơn LẤY HÀNG (pickup)
     */
    private static final BigDecimal DELIVERY_FEE = new BigDecimal("13000");

    private BigDecimal calculateEarnings(List<ShipperTask> tasks) {
        long deliveryCount = tasks.stream()
                .filter(t -> t.getTaskType() == TaskType.delivery)
                .count();
        return DELIVERY_FEE.multiply(BigDecimal.valueOf(deliveryCount));
    }

    // PROFILE IMPLEMENTATION

    @Override
    public ShipperProfileDTO getProfile(String shipperEmail) {
        log.info("Lấy thông tin cá nhân của shipper: {}", shipperEmail);

        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail).orElse(null);
        if (shipper == null) {
            return null;
        }

        User user = shipper.getUser();
        Hub hub = shipper.getHub();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        // Thống kê
        List<ShipperTask> allTasks = shipperTaskRepository.findByShipperShipperId(shipper.getShipperId());
        int totalOrders = allTasks.size();
        int completedOrders = (int) allTasks.stream()
                .filter(t -> t.getTaskStatus() == TaskStatus.completed)
                .count();
        int failedOrders = (int) allTasks.stream()
                .filter(t -> t.getTaskStatus() == TaskStatus.failed)
                .count();
        double successRate = 0;
        if (completedOrders + failedOrders > 0) {
            successRate = Math.round((double) completedOrders / (completedOrders + failedOrders) * 100);
        }

        // Tổng thu nhập
        long deliveryCompleted = allTasks.stream()
                .filter(t -> t.getTaskType() == TaskType.delivery && t.getTaskStatus() == TaskStatus.completed)
                .count();
        BigDecimal totalEarnings = DELIVERY_FEE.multiply(BigDecimal.valueOf(deliveryCompleted));

        return ShipperProfileDTO.builder()
                // User info
                .userId(user.getUserId())
                .username(user.getUsername())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .avatarUrl(user.getAvatarUrl())
                .userStatus(user.getStatus() != null ? user.getStatus().name() : "active")
                .lastLoginAt(user.getLastLoginAt() != null ? user.getLastLoginAt().format(formatter) : "N/A")
                .createdAt(user.getCreatedAt() != null ? user.getCreatedAt().format(formatter) : "N/A")
                // Shipper info
                .shipperId(shipper.getShipperId())
                .shipperType(shipper.getShipperType() != null ? shipper.getShipperType().name() : "fulltime")
                .vehicleType(shipper.getVehicleType())
                .shipperStatus(shipper.getStatus() != null ? shipper.getStatus().name() : "active")
                .joinedAt(shipper.getJoinedAt() != null ? shipper.getJoinedAt().format(formatter) : "N/A")
                .rating(shipper.getRating() != null ? shipper.getRating() : BigDecimal.ZERO)
                .totalRatings(0) // TODO: Implement rating count
                // Stats
                .totalOrders(totalOrders)
                .completedOrders(completedOrders)
                .failedOrders(failedOrders)
                .successRate(successRate)
                .totalEarnings(totalEarnings)
                // Hub
                .hubName(hub != null ? hub.getHubName() : "Chưa phân bổ")
                .hubAddress(hub != null ? hub.getAddress() : "N/A")
                .build();
    }

    // Change Password

    @Override
    @Transactional
    public void changePassword(String shipperEmail, ChangePasswordRequest request) {
        log.info("Đổi mật khẩu cho shipper: {}", shipperEmail);

        // 1. Tìm shipper theo email
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin shipper"));

        User user = shipper.getUser();
        if (user == null) {
            throw new RuntimeException("Không tìm thấy thông tin tài khoản");
        }

        // 2. Kiểm tra mật khẩu hiện tại
        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPasswordHash())) {
            throw new RuntimeException("Mật khẩu hiện tại không đúng");
        }

        // 3. Kiểm tra mật khẩu mới và xác nhận khớp nhau
        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("Mật khẩu mới và xác nhận không khớp");
        }

        // 4. Kiểm tra mật khẩu mới không trùng với mật khẩu cũ
        if (passwordEncoder.matches(request.getNewPassword(), user.getPasswordHash())) {
            throw new RuntimeException("Mật khẩu mới không được trùng với mật khẩu hiện tại");
        }

        // 5. Mã hóa và cập nhật mật khẩu mới
        String encodedPassword = passwordEncoder.encode(request.getNewPassword());
        user.setPasswordHash(encodedPassword);
        user.setUpdatedAt(LocalDateTime.now());

        userRepository.save(user);
        log.info("Đã đổi mật khẩu thành công cho user: {}", user.getUsername());
    }

    @Override
    @Transactional
    public String updateAvatar(String shipperEmail, MultipartFile avatarFile) {
        log.info("Cập nhật ảnh đại diện cho shipper: {}", shipperEmail);

        // 1. Tìm shipper
        Shipper shipper = shipperRepository.findByUserEmail(shipperEmail)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin shipper"));

        User user = shipper.getUser();
        if (user == null) {
            throw new RuntimeException("Không tìm thấy thông tin tài khoản");
        }

        // 2. Xóa avatar cũ nếu có
        if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) {
            try {
                // Chỉ xóa nếu là file upload local (không phải URL external)
                if (user.getAvatarUrl().startsWith("/uploads/shippers/")) {
                    fileUploadService.deleteImage(user.getAvatarUrl().replace("/uploads/", ""));
                }
            } catch (Exception e) {
                log.warn("Không thể xóa avatar cũ: {}", e.getMessage());
            }
        }

        // 3. Upload avatar mới
        String newAvatarPath = fileUploadService.uploadImage(avatarFile, "shippers");

        // 4. Cập nhật URL trong database
        user.setAvatarUrl("/uploads/" + newAvatarPath);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);

        log.info("Đã cập nhật avatar thành công: {}", newAvatarPath);
        return user.getAvatarUrl();
    }
}
