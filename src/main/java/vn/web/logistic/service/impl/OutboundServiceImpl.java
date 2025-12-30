package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.request.outbound.ConsolidateRequest;
import vn.web.logistic.dto.request.outbound.GateOutRequest;
import vn.web.logistic.dto.request.outbound.TripPlanningRequest;
import vn.web.logistic.dto.response.outbound.ConsolidateResponse;
import vn.web.logistic.dto.response.outbound.GateOutResponse;
import vn.web.logistic.dto.response.outbound.TripPlanningResponse;
import vn.web.logistic.entity.*;
import vn.web.logistic.exception.ResourceNotFoundException;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.OutboundService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation của OutboundService
 * Xử lý các chức năng XUẤT KHO (MIDDLE MILE)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OutboundServiceImpl implements OutboundService {

    private final ContainerRepository containerRepository;
    private final ContainerDetailRepository containerDetailRepository;
    private final ServiceRequestRepository serviceRequestRepository;
    private final TripRepository tripRepository;
    private final TripContainerRepository tripContainerRepository;
    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;
    private final HubRepository hubRepository;
    private final UserRepository userRepository;
    private final ParcelActionRepository parcelActionRepository;
    private final ActionTypeRepository actionTypeRepository;

    // ===================================================================
    // CHỨC NĂNG 5: ĐÓNG BAO (Consolidate)
    // ===================================================================

    @Override
    @Transactional
    public ConsolidateResponse consolidate(ConsolidateRequest request, Long actorId) {
        log.info("=== BẮT ĐẦU ĐÓNG BAO ===");
        log.info("Số đơn: {}, Hub đích: {}, Hub hiện tại: {}",
                request.getRequestIds().size(), request.getToHubId(), request.getCurrentHubId());

        // Validate Hub
        Hub currentHub = hubRepository.findById(request.getCurrentHubId())
                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getCurrentHubId()));
        Hub destinationHub = hubRepository.findById(request.getToHubId())
                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getToHubId()));

        // Validate User
        User actor = userRepository.findById(actorId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "userId", actorId));

        // === STEP 1: Tạo Container mới ===
        Container container = Container.builder()
                .containerCode(generateContainerCode())
                .type(parseContainerType(request.getContainerType()))
                .createdAtHub(currentHub)
                .destinationHub(destinationHub)
                .createdBy(actor)
                .status(Container.ContainerStatus.created)
                .weight(BigDecimal.ZERO)
                .build();
        container = containerRepository.save(container);
        log.info("Đã tạo Container: {}", container.getContainerCode());

        // === STEP 2: Gán các đơn vào Container ===
        List<ConsolidateResponse.ConsolidateResult> results = new ArrayList<>();
        BigDecimal totalWeight = BigDecimal.ZERO;
        int successCount = 0;
        int failedCount = 0;

        for (Long requestId : request.getRequestIds()) {
            ConsolidateResponse.ConsolidateResult result = processConsolidateOrder(
                    requestId, container);
            results.add(result);

            if (result.isSuccess()) {
                successCount++;
                // Cộng trọng lượng
                ServiceRequest sr = serviceRequestRepository.findById(requestId).orElse(null);
                if (sr != null && sr.getWeight() != null) {
                    totalWeight = totalWeight.add(sr.getWeight());
                }
            } else {
                failedCount++;
            }
        }

        // === STEP 3: Cập nhật trọng lượng và đóng Container ===
        container.setWeight(totalWeight);
        if (successCount > 0) {
            container.setStatus(Container.ContainerStatus.closed);
        }
        containerRepository.save(container);

        log.info("Kết quả đóng bao: {}/{} đơn thành công, tổng trọng lượng: {} kg",
                successCount, request.getRequestIds().size(), totalWeight);

        // Build response
        return ConsolidateResponse.builder()
                .container(ConsolidateResponse.ContainerInfo.builder()
                        .containerId(container.getContainerId())
                        .containerCode(container.getContainerCode())
                        .type(container.getType().name())
                        .status(container.getStatus().name())
                        .totalWeight(container.getWeight())
                        .fromHubName(currentHub.getHubName())
                        .toHubName(destinationHub.getHubName())
                        .createdAt(container.getCreatedAt())
                        .build())
                .successCount(successCount)
                .failedCount(failedCount)
                .totalRequested(request.getRequestIds().size())
                .results(results)
                .build();
    }

    /**
     * Xử lý đóng bao cho từng đơn hàng
     */
    private ConsolidateResponse.ConsolidateResult processConsolidateOrder(
            Long requestId, Container container) {

        try {
            ServiceRequest sr = serviceRequestRepository.findById(requestId)
                    .orElse(null);

            if (sr == null) {
                return ConsolidateResponse.ConsolidateResult.builder()
                        .requestId(requestId)
                        .success(false)
                        .message("Không tìm thấy đơn hàng")
                        .build();
            }

            String previousStatus = sr.getStatus().name();

            // Kiểm tra status - chỉ cho phép 'picked' hoặc 'failed'
            if (sr.getStatus() != ServiceRequest.RequestStatus.picked &&
                    sr.getStatus() != ServiceRequest.RequestStatus.failed) {
                return ConsolidateResponse.ConsolidateResult.builder()
                        .requestId(requestId)
                        .success(false)
                        .message("Đơn có trạng thái '" + previousStatus + "' không hợp lệ. " +
                                "Chỉ chấp nhận 'picked' hoặc 'failed'")
                        .previousStatus(previousStatus)
                        .build();
            }

            // Kiểm tra đơn đã được đóng bao chưa
            List<ContainerDetail> existingDetails = containerDetailRepository
                    .findByRequestRequestId(requestId);
            if (!existingDetails.isEmpty()) {
                return ConsolidateResponse.ConsolidateResult.builder()
                        .requestId(requestId)
                        .success(false)
                        .message("Đơn đã được đóng vào container khác")
                        .previousStatus(previousStatus)
                        .build();
            }

            // Tạo ContainerDetail - gán đơn vào container
            ContainerDetail detail = ContainerDetail.builder()
                    .container(container)
                    .request(sr)
                    .build();
            containerDetailRepository.save(detail);

            return ConsolidateResponse.ConsolidateResult.builder()
                    .requestId(requestId)
                    .success(true)
                    .message("Đã đóng vào container " + container.getContainerCode())
                    .previousStatus(previousStatus)
                    .build();

        } catch (Exception e) {
            log.error("Lỗi khi đóng bao đơn {}: {}", requestId, e.getMessage());
            return ConsolidateResponse.ConsolidateResult.builder()
                    .requestId(requestId)
                    .success(false)
                    .message("Lỗi: " + e.getMessage())
                    .build();
        }
    }

    // ===================================================================
    // CHỨC NĂNG 6: TẠO CHUYẾN XE (Trip Planning)
    // ===================================================================

    @Override
    @Transactional
    public TripPlanningResponse createTrip(TripPlanningRequest request, Long actorId) {
        log.info("=== BẮT ĐẦU TẠO CHUYẾN XE ===");
        log.info("Xe: {}, Tài xế: {}, Từ Hub: {} -> Đến Hub: {}",
                request.getVehicleId(), request.getDriverId(),
                request.getFromHubId(), request.getToHubId());

        // === STEP 1: Validate Vehicle ===
        Vehicle vehicle = vehicleRepository.findById(request.getVehicleId())
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "vehicleId", request.getVehicleId()));

        // Kiểm tra xe có available không
        if (vehicle.getStatus() != Vehicle.VehicleStatus.available) {
            throw new IllegalArgumentException(
                    "Xe " + vehicle.getPlateNumber() + " đang ở trạng thái '" +
                            vehicle.getStatus() + "', không thể tạo chuyến");
        }

        // Kiểm tra xe có đang ở Hub này không
        Hub fromHub = hubRepository.findById(request.getFromHubId())
                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getFromHubId()));

        if (vehicle.getCurrentHub() == null ||
                !vehicle.getCurrentHub().getHubId().equals(fromHub.getHubId())) {
            String currentHubName = vehicle.getCurrentHub() != null ? vehicle.getCurrentHub().getHubName()
                    : "không xác định";
            throw new IllegalArgumentException(
                    "Xe " + vehicle.getPlateNumber() + " đang ở Hub '" + currentHubName +
                            "', không phải Hub '" + fromHub.getHubName() + "'");
        }

        // === STEP 2: Validate Driver ===
        Driver driver = driverRepository.findById(request.getDriverId())
                .orElseThrow(() -> new ResourceNotFoundException("Driver", "driverId", request.getDriverId()));

        if (driver.getStatus() != Driver.DriverStatus.active) {
            throw new IllegalArgumentException(
                    "Tài xế " + driver.getFullName() + " đang không hoạt động");
        }

        // === STEP 3: Validate ToHub ===
        Hub toHub = hubRepository.findById(request.getToHubId())
                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getToHubId()));

        if (fromHub.getHubId().equals(toHub.getHubId())) {
            throw new IllegalArgumentException("Hub xuất phát và Hub đích không được trùng nhau");
        }

        // === STEP 4: Tạo Trip ===
        Trip trip = Trip.builder()
                .tripCode(generateTripCode())
                .vehicle(vehicle)
                .driver(driver)
                .fromHub(fromHub)
                .toHub(toHub)
                .status(Trip.TripStatus.loading)
                .build();
        trip = tripRepository.save(trip);

        log.info("Đã tạo chuyến xe: {} - Xe: {} - Tài xế: {}",
                trip.getTripCode(), vehicle.getPlateNumber(), driver.getFullName());

        // Build response
        return TripPlanningResponse.builder()
                .tripId(trip.getTripId())
                .tripCode(trip.getTripCode())
                .status(trip.getStatus().name())
                .vehicle(TripPlanningResponse.VehicleInfo.builder()
                        .vehicleId(vehicle.getVehicleId())
                        .plateNumber(vehicle.getPlateNumber())
                        .vehicleType(vehicle.getVehicleType())
                        .loadCapacity(vehicle.getLoadCapacity() != null ? vehicle.getLoadCapacity().toString() + " kg"
                                : "N/A")
                        .build())
                .driver(TripPlanningResponse.DriverInfo.builder()
                        .driverId(driver.getDriverId())
                        .fullName(driver.getFullName())
                        .phoneNumber(driver.getPhoneNumber())
                        .licenseNumber(driver.getLicenseNumber())
                        .build())
                .fromHub(TripPlanningResponse.HubInfo.builder()
                        .hubId(fromHub.getHubId())
                        .hubName(fromHub.getHubName())
                        .address(fromHub.getAddress())
                        .build())
                .toHub(TripPlanningResponse.HubInfo.builder()
                        .hubId(toHub.getHubId())
                        .hubName(toHub.getHubName())
                        .address(toHub.getAddress())
                        .build())
                .createdAt(trip.getCreatedAt())
                .build();
    }

    // ===================================================================
    // CHỨC NĂNG 7: XUẤT BẾN (Gate Out)
    // ===================================================================

    @Override
    @Transactional
    public GateOutResponse gateOut(GateOutRequest request, Long actorId) {
        log.info("=== BẮT ĐẦU XUẤT BẾN ===");
        log.info("Trip: {}, Số container: {}", request.getTripId(), request.getContainerIds().size());

        // === STEP 1: Validate Trip ===
        Trip trip = tripRepository.findByIdWithDetails(request.getTripId())
                .orElseThrow(() -> new ResourceNotFoundException("Trip", "tripId", request.getTripId()));

        if (trip.getStatus() != Trip.TripStatus.loading) {
            throw new IllegalArgumentException(
                    "Chuyến xe " + trip.getTripCode() + " đang ở trạng thái '" +
                            trip.getStatus() + "', không thể xuất bến. Yêu cầu trạng thái 'loading'");
        }

        // === STEP 2: Validate và gán Container vào Trip ===
        List<GateOutResponse.ContainerInfo> containerInfos = new ArrayList<>();
        List<Long> allRequestIds = new ArrayList<>();

        for (Long containerId : request.getContainerIds()) {
            Container container = containerRepository.findByIdWithDetails(containerId)
                    .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId", containerId));

            // Kiểm tra container đã đóng chưa
            if (container.getStatus() != Container.ContainerStatus.closed) {
                throw new IllegalArgumentException(
                        "Container " + container.getContainerCode() + " chưa đóng (status='" +
                                container.getStatus() + "'). Yêu cầu status='closed'");
            }

            // Kiểm tra destination có khớp với trip không
            if (!container.getDestinationHub().getHubId().equals(trip.getToHub().getHubId())) {
                throw new IllegalArgumentException(
                        "Container " + container.getContainerCode() + " có đích đến '" +
                                container.getDestinationHub().getHubName() + "', không khớp với chuyến xe đi '" +
                                trip.getToHub().getHubName() + "'");
            }

            // Gán container vào trip
            TripContainer tripContainer = TripContainer.builder()
                    .trip(trip)
                    .container(container)
                    .status(TripContainer.TripContainerStatus.loaded)
                    .build();
            tripContainerRepository.save(tripContainer);

            // Cập nhật status container -> loaded
            container.setStatus(Container.ContainerStatus.loaded);
            containerRepository.save(container);

            // Lấy danh sách đơn hàng trong container
            List<ContainerDetail> details = containerDetailRepository
                    .findByContainerIdWithRequest(containerId);
            int orderCount = details.size();
            for (ContainerDetail d : details) {
                allRequestIds.add(d.getRequest().getRequestId());
            }

            containerInfos.add(GateOutResponse.ContainerInfo.builder()
                    .containerId(container.getContainerId())
                    .containerCode(container.getContainerCode())
                    .type(container.getType().name())
                    .orderCount(orderCount)
                    .build());
        }

        // === STEP 3: Update Vehicle -> in_transit, current_hub = NULL ===
        Vehicle vehicle = trip.getVehicle();
        vehicle.setStatus(Vehicle.VehicleStatus.in_transit);
        vehicle.setCurrentHub(null);
        vehicleRepository.save(vehicle);
        log.info("Đã cập nhật xe {} -> in_transit", vehicle.getPlateNumber());

        // === STEP 4: Update Trip -> on_way, set departedAt ===
        LocalDateTime departedAt = LocalDateTime.now();
        trip.setStatus(Trip.TripStatus.on_way);
        trip.setDepartedAt(departedAt);
        tripRepository.save(trip);
        log.info("Đã cập nhật chuyến {} -> on_way", trip.getTripCode());

        // === STEP 5: Update TẤT CẢ đơn hàng -> in_transit ===
        int updatedCount = 0;
        ActionType exportAction = actionTypeRepository.findByActionCode("EXPORT_WAREHOUSE")
                .orElse(null);

        for (Long requestId : allRequestIds) {
            ServiceRequest sr = serviceRequestRepository.findById(requestId).orElse(null);
            if (sr != null) {
                sr.setStatus(ServiceRequest.RequestStatus.in_transit);
                serviceRequestRepository.save(sr);
                updatedCount++;

                // === STEP 6: INSERT ParcelAction (EXPORT_WAREHOUSE) ===
                if (exportAction != null) {
                    ParcelAction action = ParcelAction.builder()
                            .request(sr)
                            .actionType(exportAction)
                            .fromHub(trip.getFromHub())
                            .toHub(trip.getToHub())
                            .actor(userRepository.findById(actorId).orElse(null))
                            .note("Xuất bến - Chuyến " + trip.getTripCode())
                            .build();
                    parcelActionRepository.save(action);
                }
            }
        }

        log.info("Đã cập nhật {} đơn hàng -> in_transit và ghi log EXPORT_WAREHOUSE", updatedCount);

        // Build response
        return GateOutResponse.builder()
                .trip(GateOutResponse.TripInfo.builder()
                        .tripId(trip.getTripId())
                        .tripCode(trip.getTripCode())
                        .status(trip.getStatus().name())
                        .vehiclePlate(vehicle.getPlateNumber())
                        .driverName(trip.getDriver().getFullName())
                        .driverPhone(trip.getDriver().getPhoneNumber())
                        .fromHubName(trip.getFromHub().getHubName())
                        .toHubName(trip.getToHub().getHubName())
                        .build())
                .containerCount(containerInfos.size())
                .totalOrders(allRequestIds.size())
                .updatedOrdersCount(updatedCount)
                .containers(containerInfos)
                .departedAt(departedAt)
                .build();
    }

    // ===================================================================
    // HELPER METHODS
    // ===================================================================

    /**
     * Generate mã Container tự động
     * Format: CNT-YYYYMMDD-XXXX
     */
    private String generateContainerCode() {
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String random = String.format("%04d", (int) (Math.random() * 10000));
        return "CNT-" + dateStr + "-" + random;
    }

    /**
     * Generate mã Trip tự động
     * Format: TRIP-YYYYMMDD-XXXX
     */
    private String generateTripCode() {
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String random = String.format("%04d", (int) (Math.random() * 10000));
        return "TRIP-" + dateStr + "-" + random;
    }

    /**
     * Parse container type từ string
     */
    private Container.ContainerType parseContainerType(String type) {
        if (type == null || type.isEmpty()) {
            return Container.ContainerType.standard;
        }
        try {
            return Container.ContainerType.valueOf(type.toLowerCase());
        } catch (IllegalArgumentException e) {
            return Container.ContainerType.standard;
        }
    }
}
