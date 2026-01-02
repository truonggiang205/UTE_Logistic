package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.request.outbound.*;
import vn.web.logistic.dto.response.outbound.*;
import vn.web.logistic.entity.*;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.exception.ResourceNotFoundException;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.OutboundService;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * OutboundServiceImpl - Xử lý phân hệ Xuất Kho (Middle Mile)
 * 
 * NHÓM 1: Quản lý Đóng gói (Consolidation)
 * NHÓM 2: Điều phối xe (Trip Planning)
 * NHÓM 3: Xếp hàng lên xe (Loading)
 * NHÓM 4: Xuất bến (Gate Out)
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class OutboundServiceImpl implements OutboundService {

        private final ServiceRequestRepository serviceRequestRepository;
        private final ContainerRepository containerRepository;
        private final ContainerDetailRepository containerDetailRepository;
        private final TripRepository tripRepository;
        private final TripContainerRepository tripContainerRepository;
        private final VehicleRepository vehicleRepository;
        private final DriverRepository driverRepository;
        private final HubRepository hubRepository;
        private final UserRepository userRepository;
        private final ActionTypeRepository actionTypeRepository;
        private final ParcelActionRepository parcelActionRepository;
        private final TrackingCodeRepository trackingCodeRepository;

        // ===================================================================
        // NHÓM 1: QUẢN LÝ ĐÓNG GÓI (CONSOLIDATION)
        // ===================================================================

        /**
         * 1.1. Lấy danh sách đơn hàng chờ đóng gói tại Hub
         */
        @Override
        @Transactional(readOnly = true)
        public List<PendingOrderResponse> getPendingOrdersForConsolidation(Long hubId) {
                log.info("Lấy danh sách đơn hàng chờ đóng gói tại Hub: {}", hubId);

                // 1. Định nghĩa các trạng thái hợp lệ để đóng bao
                List<ServiceRequest.RequestStatus> validStatuses = List.of(
                                ServiceRequest.RequestStatus.picked, // Hàng mới lấy về
                                ServiceRequest.RequestStatus.in_transit, // Hàng luân chuyển từ kho khác đến
                                ServiceRequest.RequestStatus.failed // Hàng giao lỗi/hoàn trả
                );

                // 2. Gọi repository lấy danh sách đơn "sạch"
                List<ServiceRequest> orders = serviceRequestRepository
                                .findOrdersForConsolidation(validStatuses, hubId);

                log.info("Tìm thấy {} đơn hàng thỏa mãn điều kiện tại Hub {}", orders.size(), hubId);

                // 3. Map sang Response DTO
                return orders.stream()
                                .map(this::mapToPendingOrderResponse)
                                .collect(Collectors.toList());
        }

        /**
         * 1.2. Tạo bao mới (Container)
         */
        @Override
        @Transactional
        public ContainerDetailResponse createContainer(CreateContainerRequest request, Long hubId, Long actorId) {
                log.info("Tạo Container mới: {} tại Hub {}", request.getContainerCode(), hubId);

                // Validate
                if (containerRepository.existsByContainerCode(request.getContainerCode())) {
                        throw new BusinessException("Mã bao đã tồn tại: " + request.getContainerCode());
                }

                Hub createdAtHub = hubRepository.findById(hubId)
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", hubId));

                Hub destinationHub = hubRepository.findById(request.getDestinationHubId())
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId",
                                                request.getDestinationHubId()));

                User createdBy = userRepository.findById(actorId)
                                .orElseThrow(() -> new ResourceNotFoundException("User", "userId", actorId));

                // Tạo Container với đầy đủ các trường
                Container container = Container.builder()
                                .containerCode(request.getContainerCode())
                                .type(parseContainerType(request.getContainerType()))
                                .weight(BigDecimal.ZERO)
                                .createdAtHub(createdAtHub)
                                .destinationHub(destinationHub)
                                .createdBy(createdBy)
                                .status(Container.ContainerStatus.created)
                                .createdAt(LocalDateTime.now())
                                .build();

                container = containerRepository.save(container);
                log.info("Đã tạo Container: {} - ID: {}", container.getContainerCode(), container.getContainerId());

                return mapToContainerDetailResponse(container);
        }

        /**
         * 1.3. Xem danh sách các bao tại Hub
         */
        @Override
        @Transactional(readOnly = true)
        public List<ContainerListResponse> getContainersAtHub(Long hubId) {
                log.info("Lấy danh sách Container tại Hub: {}", hubId);

                // 1. Kiểm tra Hub có tồn tại không
                hubRepository.findById(hubId)
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", hubId));

                // 2. Định nghĩa các trạng thái muốn lấy (Chỉ lấy bao đang mở hoặc vừa đóng
                // xong)
                List<Container.ContainerStatus> activeStatuses = List.of(
                                Container.ContainerStatus.created,
                                Container.ContainerStatus.closed);

                // 3. Truy vấn chính xác từ DB (Nhanh và gọn)
                List<Container> containers = containerRepository.findByHubAndStatuses(hubId, activeStatuses);

                return containers.stream()
                                .map(this::mapToContainerListResponse)
                                .collect(Collectors.toList());
        }

        /**
         * 1.4. Xem chi tiết bao
         */
        @Override
        @Transactional(readOnly = true)
        public ContainerDetailResponse getContainerDetail(Long containerId) {
                log.info("Lấy chi tiết Container: {}", containerId);

                Container container = containerRepository.findByIdWithDetails(containerId)
                                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                containerId));

                return mapToContainerDetailResponse(container);
        }

        /**
         * 1.5. Thêm đơn hàng vào bao
         */
        @Override
        @Transactional
        public void addOrderToContainer(AddOrderToContainerRequest request, Long actorId) {
                log.info("Thêm đơn {} vào Container {}", request.getRequestId(), request.getContainerId());

                Container container = containerRepository.findByIdWithDetails(request.getContainerId())
                                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                request.getContainerId()));

                if (container.getStatus() != Container.ContainerStatus.created) {
                        throw new BusinessException("Container đã đóng, không thể thêm đơn");
                }

                ServiceRequest sr = serviceRequestRepository.findById(request.getRequestId())
                                .orElseThrow(() -> new ResourceNotFoundException("ServiceRequest", "requestId",
                                                request.getRequestId()));

                // Kiểm tra đơn đã trong bao khác chưa
                List<ContainerDetail> existingDetails = containerDetailRepository
                                .findByRequestRequestId(sr.getRequestId());
                if (!existingDetails.isEmpty()) {
                        throw new BusinessException("Đơn hàng đã nằm trong bao khác");
                }

                // Tạo ContainerDetail với đầy đủ các trường
                ContainerDetail detail = ContainerDetail.builder()
                                .container(container)
                                .request(sr)
                                .createdAt(LocalDateTime.now())
                                .build();
                containerDetailRepository.save(detail);

                // Cập nhật trọng lượng bao
                BigDecimal currentWeight = container.getWeight() != null ? container.getWeight() : BigDecimal.ZERO;
                BigDecimal orderWeight = sr.getWeight() != null ? sr.getWeight() : BigDecimal.ZERO;
                container.setWeight(currentWeight.add(orderWeight));
                containerRepository.save(container);

                log.info("Đã thêm đơn {} vào Container {}. Trọng lượng bao: {} kg",
                                sr.getRequestId(), container.getContainerCode(), container.getWeight());
        }

        /**
         * 1.6. Gỡ đơn hàng khỏi bao
         */
        @Override
        @Transactional
        public void removeOrderFromContainer(RemoveOrderFromContainerRequest request, Long actorId) {
                log.info("Gỡ đơn {} khỏi Container {}", request.getRequestId(), request.getContainerId());

                Container container = containerRepository.findByIdWithDetails(request.getContainerId())
                                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                request.getContainerId()));

                if (container.getStatus() != Container.ContainerStatus.created) {
                        throw new BusinessException("Container đã đóng, không thể gỡ đơn");
                }

                ServiceRequest sr = serviceRequestRepository.findById(request.getRequestId())
                                .orElseThrow(() -> new ResourceNotFoundException("ServiceRequest", "requestId",
                                                request.getRequestId()));

                // Tìm và xóa ContainerDetail
                List<ContainerDetail> details = containerDetailRepository.findByRequestRequestId(sr.getRequestId());
                ContainerDetail target = details.stream()
                                .filter(d -> d.getContainer().getContainerId().equals(container.getContainerId()))
                                .findFirst()
                                .orElseThrow(() -> new BusinessException("Đơn hàng không nằm trong bao này"));

                containerDetailRepository.delete(target);

                // Trừ trọng lượng bao
                BigDecimal currentWeight = container.getWeight() != null ? container.getWeight() : BigDecimal.ZERO;
                BigDecimal orderWeight = sr.getWeight() != null ? sr.getWeight() : BigDecimal.ZERO;
                container.setWeight(currentWeight.subtract(orderWeight).max(BigDecimal.ZERO));
                containerRepository.save(container);

                log.info("Đã gỡ đơn {} khỏi Container {}. Trọng lượng bao: {} kg",
                                sr.getRequestId(), container.getContainerCode(), container.getWeight());
        }

        /**
         * 1.7. Chốt bao (Seal Container)
         */
        @Override
        @Transactional
        public void sealContainer(Long containerId, Long actorId) {
                log.info("Chốt Container: {}", containerId);

                Container container = containerRepository.findByIdWithDetails(containerId)
                                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                containerId));

                if (container.getStatus() != Container.ContainerStatus.created) {
                        throw new BusinessException("Container không ở trạng thái 'created', không thể chốt");
                }

                // Kiểm tra có đơn trong bao không
                List<ContainerDetail> details = containerDetailRepository.findByContainerContainerId(containerId);
                if (details.isEmpty()) {
                        throw new BusinessException("Container chưa có đơn hàng, không thể chốt");
                }

                container.setStatus(Container.ContainerStatus.closed);
                containerRepository.save(container);

                log.info("Đã chốt Container: {} với {} đơn hàng", container.getContainerCode(), details.size());
        }

        /**
         * 1.7b. Mở lại bao (Reopen Container)
         */
        @Override
        @Transactional
        public void reopenContainer(Long containerId, Long actorId) {
                log.info("Mở lại Container: {}", containerId);

                Container container = containerRepository.findByIdWithDetails(containerId)
                                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                containerId));

                if (container.getStatus() != Container.ContainerStatus.closed) {
                        throw new BusinessException("Container không ở trạng thái 'closed', không thể mở lại");
                }

                // Kiểm tra bao đã được xếp lên xe chưa
                List<TripContainer> tripContainers = tripContainerRepository
                                .findByContainerContainerId(containerId);
                if (!tripContainers.isEmpty()) {
                        throw new BusinessException(
                                        "Bao đã được xếp lên xe, không thể mở lại. Vui lòng gỡ bao khỏi xe trước.");
                }

                container.setStatus(Container.ContainerStatus.created);
                containerRepository.save(container);

                log.info("Đã mở lại Container: {}", container.getContainerCode());
        }

        /**
         * 1.8. Đóng hàng loạt đơn vào bao
         */
        @Override
        @Transactional
        public ConsolidateResponse consolidate(ConsolidateRequest request, Long hubId, Long actorId) {
                log.info("=== BẮT ĐẦU ĐÓNG BAO HÀNG LOẠT ===");
                log.info("Hub: {}, Đích: {}, Số đơn: {}", request.getCurrentHubId(), request.getToHubId(),
                                request.getRequestIds().size());

                // Validate Hubs
                Hub fromHub = hubRepository.findById(request.getCurrentHubId())
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId",
                                                request.getCurrentHubId()));

                Hub toHub = hubRepository.findById(request.getToHubId())
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getToHubId()));

                User createdBy = userRepository.findById(actorId)
                                .orElseThrow(() -> new ResourceNotFoundException("User", "userId", actorId));

                // Tạo Container mới với đầy đủ các trường
                Container container = Container.builder()
                                .containerCode(generateContainerCode())
                                .type(parseContainerType(request.getContainerType()))
                                .weight(BigDecimal.ZERO)
                                .createdAtHub(fromHub)
                                .destinationHub(toHub)
                                .createdBy(createdBy)
                                .status(Container.ContainerStatus.created)
                                .createdAt(LocalDateTime.now())
                                .build();
                container = containerRepository.save(container);
                log.info("Đã tạo Container: {}", container.getContainerCode());

                // Xử lý từng đơn hàng
                List<ConsolidateResponse.ConsolidateResult> results = new ArrayList<>();
                int successCount = 0;
                int failedCount = 0;
                BigDecimal totalWeight = BigDecimal.ZERO;

                for (Long requestId : request.getRequestIds()) {
                        ConsolidateResponse.ConsolidateResult result = processConsolidateOrder(
                                        requestId, container, actorId);
                        results.add(result);
                        if (result.isSuccess()) {
                                successCount++;
                                ServiceRequest sr = serviceRequestRepository.findById(requestId).orElse(null);
                                if (sr != null && sr.getWeight() != null) {
                                        totalWeight = totalWeight.add(sr.getWeight());
                                }
                        } else {
                                failedCount++;
                        }
                }

                // Cập nhật trọng lượng container
                container.setWeight(totalWeight);
                containerRepository.save(container);

                log.info("=== HOÀN TẤT ĐÓNG BAO ===");
                log.info("Container: {}, Thành công: {}, Thất bại: {}, Tổng trọng lượng: {} kg",
                                container.getContainerCode(), successCount, failedCount, totalWeight);

                return ConsolidateResponse.builder()
                                .container(ConsolidateResponse.ContainerInfo.builder()
                                                .containerId(container.getContainerId())
                                                .containerCode(container.getContainerCode())
                                                .type(container.getType().name())
                                                .status(container.getStatus().name())
                                                .totalWeight(totalWeight)
                                                .fromHubName(fromHub.getHubName())
                                                .toHubName(toHub.getHubName())
                                                .createdAt(container.getCreatedAt())
                                                .build())
                                .successCount(successCount)
                                .failedCount(failedCount)
                                .totalRequested(request.getRequestIds().size())
                                .results(results)
                                .build();
        }

        private ConsolidateResponse.ConsolidateResult processConsolidateOrder(
                        Long requestId, Container container, Long actorId) {
                try {
                        ServiceRequest sr = serviceRequestRepository.findById(requestId)
                                        .orElseThrow(() -> new ResourceNotFoundException("ServiceRequest", "requestId",
                                                        requestId));

                        String previousStatus = sr.getStatus().name();

                        // Kiểm tra status hợp lệ (picked hoặc failed - hàng hoàn)
                        if (sr.getStatus() != ServiceRequest.RequestStatus.picked &&
                                        sr.getStatus() != ServiceRequest.RequestStatus.failed) {
                                return ConsolidateResponse.ConsolidateResult.builder()
                                                .requestId(requestId)
                                                .success(false)
                                                .message("Trạng thái không hợp lệ: " + sr.getStatus())
                                                .previousStatus(previousStatus)
                                                .build();
                        }

                        // Kiểm tra đã trong bao khác chưa
                        List<ContainerDetail> existingDetails = containerDetailRepository
                                        .findByRequestRequestId(requestId);
                        if (!existingDetails.isEmpty()) {
                                return ConsolidateResponse.ConsolidateResult.builder()
                                                .requestId(requestId)
                                                .success(false)
                                                .message("Đơn đã nằm trong bao khác")
                                                .previousStatus(previousStatus)
                                                .build();
                        }

                        // Tạo ContainerDetail với đầy đủ các trường
                        ContainerDetail detail = ContainerDetail.builder()
                                        .container(container)
                                        .request(sr)
                                        .createdAt(LocalDateTime.now())
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
        // NHÓM 2: ĐIỀU PHỐI XE (TRIP PLANNING)
        // ===================================================================

        /**
         * 2.1. Lấy danh sách tất cả Xe trong hệ thống
         */
        @Override
        @Transactional(readOnly = true)
        public List<VehicleSelectResponse> getAllVehicles() {
                log.info("Lấy danh sách tất cả xe trong hệ thống");

                List<Vehicle> vehicles = vehicleRepository.findAll();

                return vehicles.stream()
                                .map(v -> VehicleSelectResponse.builder()
                                                .vehicleId(v.getVehicleId())
                                                .plateNumber(v.getPlateNumber())
                                                .vehicleType(v.getVehicleType())
                                                .loadCapacity(v.getLoadCapacity())
                                                .status(v.getStatus().name())
                                                .currentHubId(v.getCurrentHub() != null ? v.getCurrentHub().getHubId()
                                                                : null)
                                                .currentHubName(v.getCurrentHub() != null
                                                                ? v.getCurrentHub().getHubName()
                                                                : null)
                                                .build())
                                .collect(Collectors.toList());
        }

        /**
         * 2.2. Lấy danh sách tất cả Tài xế trong hệ thống
         */
        @Override
        @Transactional(readOnly = true)
        public List<DriverSelectResponse> getAllDrivers() {
                log.info("Lấy danh sách tất cả tài xế trong hệ thống");

                List<Driver> drivers = driverRepository.findAll();

                return drivers.stream()
                                .map(d -> DriverSelectResponse.builder()
                                                .driverId(d.getDriverId())
                                                .fullName(d.getFullName())
                                                .phoneNumber(d.getPhoneNumber())
                                                .licenseNumber(d.getLicenseNumber())
                                                .licenseClass(d.getLicenseClass())
                                                .status(d.getStatus().name())
                                                .build())
                                .collect(Collectors.toList());
        }

        /**
         * 2.3. Tạo chuyến xe mới
         */
        @Override
        @Transactional
        public TripPlanningResponse createTrip(TripPlanningRequest request, Long actorId) {
                log.info("=== BẮT ĐẦU TẠO CHUYẾN XE ===");
                log.info("Xe: {}, Tài xế: {}, Từ Hub: {} -> Đến Hub: {}",
                                request.getVehicleId(), request.getDriverId(),
                                request.getFromHubId(), request.getToHubId());

                // === STEP 1: Validate Vehicle ===
                Vehicle vehicle = vehicleRepository.findById(request.getVehicleId())
                                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "vehicleId",
                                                request.getVehicleId()));

                Hub fromHub = hubRepository.findById(request.getFromHubId())
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId",
                                                request.getFromHubId()));

                // Logic tự sửa lỗi: Nếu xe đang bị ghi nhận sai vị trí, tự động cập nhật về Hub
                // hiện tại
                if (vehicle.getCurrentHub() == null ||
                                !vehicle.getCurrentHub().getHubId().equals(fromHub.getHubId())) {
                        log.warn("Xe {} đang ghi nhận ở Hub khác. Tự động cập nhật vị trí về Hub {}",
                                        vehicle.getPlateNumber(), fromHub.getHubName());
                        vehicle.setCurrentHub(fromHub);
                        vehicleRepository.save(vehicle);
                }

                // Kiểm tra xe có available không
                if (vehicle.getStatus() != Vehicle.VehicleStatus.available) {
                        throw new BusinessException(
                                        "Xe " + vehicle.getPlateNumber() + " đang ở trạng thái '" +
                                                        vehicle.getStatus() + "', không thể tạo chuyến");
                }

                // === STEP 2: Validate Driver ===
                Driver driver = driverRepository.findById(request.getDriverId())
                                .orElseThrow(() -> new ResourceNotFoundException("Driver", "driverId",
                                                request.getDriverId()));

                if (driver.getStatus() != Driver.DriverStatus.active) {
                        throw new BusinessException(
                                        "Tài xế " + driver.getFullName() + " đang không hoạt động");
                }

                // === STEP 3: Validate ToHub ===
                Hub toHub = hubRepository.findById(request.getToHubId())
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getToHubId()));

                if (fromHub.getHubId().equals(toHub.getHubId())) {
                        throw new BusinessException("Hub xuất phát và Hub đích không được trùng nhau");
                }

                // === STEP 4: Tạo Trip với đầy đủ các trường ===
                Trip trip = Trip.builder()
                                .tripCode(generateTripCode())
                                .vehicle(vehicle)
                                .driver(driver)
                                .fromHub(fromHub)
                                .toHub(toHub)
                                .departedAt(null)
                                .arrivedAt(null)
                                .status(Trip.TripStatus.loading)
                                .createdAt(LocalDateTime.now())
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
                                                .loadCapacity(vehicle.getLoadCapacity() != null
                                                                ? vehicle.getLoadCapacity().toString() + " kg"
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

        /**
         * 2.4. Xem danh sách các chuyến xe đang xử lý tại Hub
         */
        @Override
        @Transactional(readOnly = true)
        public List<TripListResponse> getTripsAtHub(Long hubId) {
                log.info("Lấy danh sách chuyến xe tại Hub: {}", hubId);

                // Validate Hub
                hubRepository.findById(hubId)
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", hubId));

                // Lấy các chuyến xe xuất phát từ Hub này với status = loading
                List<Trip> trips = tripRepository.findByStatus(Trip.TripStatus.loading);

                return trips.stream()
                                .filter(t -> t.getFromHub() != null && t.getFromHub().getHubId().equals(hubId))
                                .map(this::mapToTripListResponse)
                                .collect(Collectors.toList());
        }

        /**
         * 2.5. Xem chi tiết chuyến xe
         */
        @Override
        @Transactional(readOnly = true)
        public TripDetailResponse getTripDetail(Long tripId) {
                log.info("Lấy chi tiết chuyến xe: {}", tripId);

                Trip trip = tripRepository.findByIdWithDetails(tripId)
                                .orElseThrow(() -> new ResourceNotFoundException("Trip", "tripId", tripId));

                // Lấy danh sách container trên chuyến
                List<TripContainer> tripContainers = tripContainerRepository.findByTripIdWithContainerDetails(tripId);

                BigDecimal totalWeight = BigDecimal.ZERO;
                int totalOrderCount = 0;
                List<TripDetailResponse.ContainerOnTripInfo> containerInfos = new ArrayList<>();

                for (TripContainer tc : tripContainers) {
                        Container c = tc.getContainer();
                        int orderCount = containerDetailRepository.findByContainerContainerId(c.getContainerId())
                                        .size();
                        totalOrderCount += orderCount;

                        if (c.getWeight() != null) {
                                totalWeight = totalWeight.add(c.getWeight());
                        }

                        containerInfos.add(TripDetailResponse.ContainerOnTripInfo.builder()
                                        .containerId(c.getContainerId())
                                        .containerCode(c.getContainerCode())
                                        .type(c.getType().name())
                                        .containerStatus(c.getStatus().name())
                                        .tripContainerStatus(tc.getStatus().name())
                                        .weight(c.getWeight())
                                        .orderCount(orderCount)
                                        .loadedAt(tc.getCreatedAt())
                                        .build());
                }

                Vehicle vehicle = trip.getVehicle();
                Driver driver = trip.getDriver();

                return TripDetailResponse.builder()
                                .tripId(trip.getTripId())
                                .tripCode(trip.getTripCode())
                                .status(trip.getStatus().name())
                                .createdAt(trip.getCreatedAt())
                                .departedAt(trip.getDepartedAt())
                                .arrivedAt(trip.getArrivedAt())
                                .vehicle(TripDetailResponse.VehicleInfo.builder()
                                                .vehicleId(vehicle.getVehicleId())
                                                .plateNumber(vehicle.getPlateNumber())
                                                .vehicleType(vehicle.getVehicleType())
                                                .loadCapacity(vehicle.getLoadCapacity())
                                                .status(vehicle.getStatus().name())
                                                .build())
                                .driver(TripDetailResponse.DriverInfo.builder()
                                                .driverId(driver.getDriverId())
                                                .fullName(driver.getFullName())
                                                .phoneNumber(driver.getPhoneNumber())
                                                .licenseNumber(driver.getLicenseNumber())
                                                .licenseClass(driver.getLicenseClass())
                                                .build())
                                .fromHub(TripDetailResponse.HubInfo.builder()
                                                .hubId(trip.getFromHub().getHubId())
                                                .hubName(trip.getFromHub().getHubName())
                                                .address(trip.getFromHub().getAddress())
                                                .province(trip.getFromHub().getProvince())
                                                .build())
                                .toHub(TripDetailResponse.HubInfo.builder()
                                                .hubId(trip.getToHub().getHubId())
                                                .hubName(trip.getToHub().getHubName())
                                                .address(trip.getToHub().getAddress())
                                                .province(trip.getToHub().getProvince())
                                                .build())
                                .containers(containerInfos)
                                .totalLoadedWeight(totalWeight)
                                .vehicleCapacity(vehicle.getLoadCapacity())
                                .containerCount(containerInfos.size())
                                .totalOrderCount(totalOrderCount)
                                .build();
        }

        // ===================================================================
        // NHÓM 3: XẾP HÀNG LÊN XE (LOADING)
        // ===================================================================

        /**
         * 3.1. Lấy danh sách Bao chờ xếp lên xe
         */
        /**
         * 3.1. Lấy danh sách Bao chờ xếp lên xe (Đã đóng và chưa lên Trip nào)
         */
        @Override
        @Transactional(readOnly = true)
        public List<ContainerForLoadingResponse> getContainersReadyForLoading(Long hubId) {
                log.info("Lấy danh sách bao chờ xếp lên xe tại Hub: {}", hubId);

                // 1. Validate Hub
                hubRepository.findById(hubId)
                                .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", hubId));

                // 2. Lấy danh sách từ Repository (Database đã lọc sạch bao chưa lên xe)
                List<Container> readyContainers = containerRepository.findContainersReadyForLoading(hubId);

                log.info("Tìm thấy {} bao hàng sẵn sàng xếp xe tại Hub {}", readyContainers.size(), hubId);

                // 3. Map sang Response
                return readyContainers.stream()
                                .map(c -> {
                                        // Đếm số đơn hàng trong mỗi bao để hiển thị lên UI
                                        int orderCount = containerDetailRepository
                                                        .findByContainerContainerId(c.getContainerId()).size();

                                        return ContainerForLoadingResponse.builder()
                                                        .containerId(c.getContainerId())
                                                        .containerCode(c.getContainerCode())
                                                        .type(c.getType().name())
                                                        .status(c.getStatus().name())
                                                        .weight(c.getWeight())
                                                        .createdAtHubName(c.getCreatedAtHub().getHubName())
                                                        .destinationHubId(c.getDestinationHub().getHubId())
                                                        .destinationHubName(c.getDestinationHub().getHubName())
                                                        .orderCount(orderCount)
                                                        .build();
                                })
                                .collect(Collectors.toList());
        }

        /**
         * 3.2. Xếp bao lên chuyến xe
         */
        @Override
        @Transactional
        public void loadContainerToTrip(LoadContainerRequest request, Long actorId) {
                log.info("Xếp bao {} lên chuyến {}", request.getContainerId(), request.getTripId());

                // Validate Trip
                Trip trip = tripRepository.findByIdWithDetails(request.getTripId())
                                .orElseThrow(() -> new ResourceNotFoundException("Trip", "tripId",
                                                request.getTripId()));

                if (trip.getStatus() != Trip.TripStatus.loading) {
                        throw new BusinessException("Chuyến xe " + trip.getTripCode() +
                                        " đang ở trạng thái '" + trip.getStatus() + "', không thể xếp bao");
                }

                // Validate Container
                Container container = containerRepository.findByIdWithDetails(request.getContainerId())
                                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                request.getContainerId()));

                if (container.getStatus() != Container.ContainerStatus.closed) {
                        throw new BusinessException("Bao " + container.getContainerCode() +
                                        " chưa được đóng (status=" + container.getStatus() + ")");
                }

                // Kiểm tra container đã được xếp lên trip khác chưa
                List<TripContainer> existing = tripContainerRepository
                                .findByContainerContainerId(request.getContainerId());
                if (!existing.isEmpty()) {
                        throw new BusinessException(
                                        "Bao " + container.getContainerCode() + " đã được xếp lên chuyến khác");
                }

                // Kiểm tra đích đến có khớp không - chỉ cảnh báo, không block
                // Trong thực tế, bao có thể đi qua nhiều hub trung chuyển
                boolean destinationMismatch = !container.getDestinationHub().getHubId()
                                .equals(trip.getToHub().getHubId());
                if (destinationMismatch) {
                        log.warn("CẢNH BÁO: Bao {} có đích đến '{}', khác với Hub đích của chuyến xe '{}'. Đây có thể là bao trung chuyển.",
                                        container.getContainerCode(),
                                        container.getDestinationHub().getHubName(),
                                        trip.getToHub().getHubName());
                }

                // Tính toán tải trọng hiện tại
                BigDecimal currentLoad = tripContainerRepository.sumWeightByTripId(trip.getTripId());
                BigDecimal containerWeight = container.getWeight() != null ? container.getWeight() : BigDecimal.ZERO;
                BigDecimal newLoad = currentLoad.add(containerWeight);
                BigDecimal capacity = trip.getVehicle().getLoadCapacity();

                // Cảnh báo nếu quá tải (log warning)
                if (capacity != null && newLoad.compareTo(capacity) > 0) {
                        log.warn("CẢNH BÁO: Chuyến {} đang quá tải! Tải trọng: {} kg / Sức chứa: {} kg",
                                        trip.getTripCode(), newLoad, capacity);
                }

                // Tạo TripContainer với đầy đủ các trường
                TripContainer tripContainer = TripContainer.builder()
                                .trip(trip)
                                .container(container)
                                .status(TripContainer.TripContainerStatus.loaded)
                                .createdAt(LocalDateTime.now())
                                .build();
                tripContainerRepository.save(tripContainer);

                // Cập nhật status container -> loaded
                container.setStatus(Container.ContainerStatus.loaded);
                containerRepository.save(container);

                log.info("Đã xếp bao {} lên chuyến {}. Tải trọng hiện tại: {} kg",
                                container.getContainerCode(), trip.getTripCode(), newLoad);
        }

        /**
         * 3.3. Gỡ bao khỏi chuyến xe
         */
        @Override
        @Transactional
        public void unloadContainerFromTrip(UnloadContainerRequest request, Long actorId) {
                log.info("Gỡ bao {} khỏi chuyến {}", request.getContainerId(), request.getTripId());

                // Validate Trip
                Trip trip = tripRepository.findByIdWithDetails(request.getTripId())
                                .orElseThrow(() -> new ResourceNotFoundException("Trip", "tripId",
                                                request.getTripId()));

                if (trip.getStatus() != Trip.TripStatus.loading) {
                        throw new BusinessException("Chuyến xe " + trip.getTripCode() +
                                        " đã xuất bến (status=" + trip.getStatus() + "), không thể gỡ bao");
                }

                // Validate Container
                Container container = containerRepository.findByIdWithDetails(request.getContainerId())
                                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                request.getContainerId()));

                // Tìm TripContainer
                List<TripContainer> tripContainers = tripContainerRepository
                                .findByContainerContainerId(request.getContainerId());
                TripContainer target = tripContainers.stream()
                                .filter(tc -> tc.getTrip().getTripId().equals(request.getTripId()))
                                .findFirst()
                                .orElseThrow(() -> new BusinessException("Bao " + container.getContainerCode() +
                                                " không nằm trên chuyến xe này"));

                // Xóa TripContainer
                tripContainerRepository.delete(target);

                // Chuyển status container về closed
                container.setStatus(Container.ContainerStatus.closed);
                containerRepository.save(container);

                log.info("Đã gỡ bao {} khỏi chuyến {}", container.getContainerCode(), trip.getTripCode());
        }

        // ===================================================================
        // NHÓM 4: XUẤT BẾN (GATE OUT)
        // ===================================================================

        /**
         * 4.1. Xác nhận Xuất bến
         */
        @Override
        @Transactional
        public GateOutResponse gateOut(GateOutRequest request, Long actorId) {
                log.info("=== BẮT ĐẦU XUẤT BẾN ===");
                log.info("Trip: {}, Số container: {}", request.getTripId(),
                                request.getContainerIds() != null ? request.getContainerIds().size() : "all");

                // === STEP 1: Validate Trip ===
                Trip trip = tripRepository.findByIdWithDetails(request.getTripId())
                                .orElseThrow(() -> new ResourceNotFoundException("Trip", "tripId",
                                                request.getTripId()));

                if (trip.getStatus() != Trip.TripStatus.loading) {
                        throw new BusinessException(
                                        "Chuyến xe " + trip.getTripCode() + " đang ở trạng thái '" +
                                                        trip.getStatus()
                                                        + "', không thể xuất bến. Yêu cầu trạng thái 'loading'");
                }

                // Lấy danh sách container cần xuất
                List<Long> containerIds = request.getContainerIds();
                if (containerIds == null || containerIds.isEmpty()) {
                        // Nếu không truyền, lấy tất cả container đã load trên trip
                        List<TripContainer> tripContainers = tripContainerRepository.findByTripIdWithContainerDetails(
                                        request.getTripId());
                        containerIds = tripContainers.stream()
                                        .map(tc -> tc.getContainer().getContainerId())
                                        .collect(Collectors.toList());
                }

                if (containerIds.isEmpty()) {
                        throw new BusinessException("Chuyến xe chưa có bao hàng nào được xếp");
                }

                // === STEP 2: Validate và xử lý Container ===
                List<GateOutResponse.ContainerInfo> containerInfos = new ArrayList<>();
                List<Long> allRequestIds = new ArrayList<>();

                for (Long containerId : containerIds) {
                        Container container = containerRepository.findByIdWithDetails(containerId)
                                        .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId",
                                                        containerId));

                        // Kiểm tra container đã đóng hoặc loaded
                        if (container.getStatus() != Container.ContainerStatus.closed &&
                                        container.getStatus() != Container.ContainerStatus.loaded) {
                                throw new BusinessException(
                                                "Container " + container.getContainerCode() + " chưa sẵn sàng (status='"
                                                                +
                                                                container.getStatus()
                                                                + "'). Yêu cầu status='closed' hoặc 'loaded'");
                        }

                        // Kiểm tra container đã được gán vào trip này chưa
                        List<TripContainer> existingTripContainers = tripContainerRepository
                                        .findByContainerContainerId(containerId);
                        boolean alreadyOnThisTrip = existingTripContainers.stream()
                                        .anyMatch(tc -> tc.getTrip().getTripId().equals(trip.getTripId()));

                        if (!alreadyOnThisTrip) {
                                // Gán container vào trip với đầy đủ các trường
                                TripContainer tripContainer = TripContainer.builder()
                                                .trip(trip)
                                                .container(container)
                                                .status(TripContainer.TripContainerStatus.loaded)
                                                .createdAt(LocalDateTime.now())
                                                .build();
                                tripContainerRepository.save(tripContainer);
                        }

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
                log.info("Đã cập nhật xe {} -> in_transit, xóa vị trí hiện tại", vehicle.getPlateNumber());

                // === STEP 4: Update Trip -> on_way, set departedAt ===
                LocalDateTime departedAt = LocalDateTime.now();
                trip.setStatus(Trip.TripStatus.on_way);
                trip.setDepartedAt(departedAt);
                tripRepository.save(trip);
                log.info("Đã cập nhật chuyến {} -> on_way", trip.getTripCode());

                // === STEP 5: Update TẤT CẢ đơn hàng -> in_transit, xóa currentHub ===
                int updatedCount = 0;
                ActionType exportAction = actionTypeRepository.findByActionCode("EXPORT_WAREHOUSE").orElse(null);
                User actor = userRepository.findById(actorId).orElse(null);

                for (Long requestId : allRequestIds) {
                        ServiceRequest sr = serviceRequestRepository.findById(requestId).orElse(null);
                        if (sr != null) {
                                sr.setStatus(ServiceRequest.RequestStatus.in_transit);
                                sr.setCurrentHub(null); // Xóa vị trí hiện tại
                                serviceRequestRepository.save(sr);
                                updatedCount++;

                                // === STEP 6: INSERT ParcelAction (EXPORT_WAREHOUSE) với đầy đủ các trường ===
                                if (exportAction != null) {
                                        ParcelAction action = ParcelAction.builder()
                                                        .request(sr)
                                                        .actionType(exportAction)
                                                        .fromHub(trip.getFromHub())
                                                        .toHub(trip.getToHub())
                                                        .actor(actor)
                                                        .actionTime(LocalDateTime.now())
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

        /**
         * 4.2. Xác nhận Xuất bến cho Trip đã xếp hàng
         */
        @Override
        @Transactional
        public GateOutResponse gateOutTrip(Long tripId, Long actorId) {
                log.info("=== XUẤT BẾN CHUYẾN {} ===", tripId);

                GateOutRequest request = GateOutRequest.builder()
                                .tripId(tripId)
                                .containerIds(null) // Lấy tất cả container đã load trên trip
                                .build();

                return gateOut(request, actorId);
        }

        // ===================================================================
        // HELPER METHODS
        // ===================================================================

        private String generateContainerCode() {
                String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                String random = String.format("%04d", (int) (Math.random() * 10000));
                return "CNT-" + dateStr + "-" + random;
        }

        private String generateTripCode() {
                String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                String random = String.format("%04d", (int) (Math.random() * 10000));
                return "TRIP-" + dateStr + "-" + random;
        }

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

        private PendingOrderResponse mapToPendingOrderResponse(ServiceRequest sr) {
                // Lấy mã vận đơn
                String trackingCodeStr = null;
                Optional<TrackingCode> trackingCodeOpt = trackingCodeRepository.findByRequestId(sr.getRequestId());
                if (trackingCodeOpt.isPresent()) {
                        trackingCodeStr = trackingCodeOpt.get().getCode();
                }

                // Tính thời gian tồn kho (giờ)
                Long hoursInWarehouse = 0L;
                LocalDateTime arrivedTime = sr.getCreatedAt(); // Tạm dùng createdAt
                if (arrivedTime != null) {
                        hoursInWarehouse = Duration.between(arrivedTime, LocalDateTime.now()).toHours();
                }

                // Xác định mức ưu tiên dựa trên thời gian tồn kho và loại dịch vụ
                String priorityLevel = "NORMAL";
                if (hoursInWarehouse > 48) {
                        priorityLevel = "HIGH";
                } else if (hoursInWarehouse > 24) {
                        priorityLevel = "MEDIUM";
                }
                // Dịch vụ Express hoặc Same-day luôn ưu tiên cao
                if (sr.getServiceType() != null &&
                                (sr.getServiceType().getServiceName().toLowerCase().contains("express") ||
                                                sr.getServiceType().getServiceName().toLowerCase().contains("same"))) {
                        priorityLevel = "HIGH";
                }

                // Tính trọng lượng quy đổi (volumetric weight)
                BigDecimal volumetricWeight = null;
                if (sr.getLength() != null && sr.getWidth() != null && sr.getHeight() != null) {
                        // Công thức: L x W x H / 5000 (cho đơn vị cm)
                        volumetricWeight = sr.getLength()
                                        .multiply(sr.getWidth())
                                        .multiply(sr.getHeight())
                                        .divide(new BigDecimal("5000"), 2, BigDecimal.ROUND_HALF_UP);
                }

                // Lấy Hub đích từ địa chỉ giao hàng (nếu có logic mapping)
                Long destinationHubId = null;
                String destinationHubName = null;
                CustomerAddress deliveryAddr = sr.getDeliveryAddress();
                if (deliveryAddr != null) {
                        // Tạm thời hiển thị tỉnh đích như Hub đích
                        destinationHubName = deliveryAddr.getProvince();
                }

                return PendingOrderResponse.builder()
                                .requestId(sr.getRequestId())
                                .trackingCode(trackingCodeStr)
                                .status(sr.getStatus().name())
                                .paymentStatus(sr.getPaymentStatus() != null ? sr.getPaymentStatus().name() : null)
                                // Người gửi
                                .senderName(sr.getPickupAddress() != null ? sr.getPickupAddress().getContactName()
                                                : null)
                                .senderPhone(sr.getPickupAddress() != null ? sr.getPickupAddress().getContactPhone()
                                                : null)
                                .senderAddress(sr.getPickupAddress() != null ? sr.getPickupAddress().getAddressDetail()
                                                : null)
                                .senderProvince(sr.getPickupAddress() != null ? sr.getPickupAddress().getProvince()
                                                : null)
                                .senderDistrict(sr.getPickupAddress() != null ? sr.getPickupAddress().getDistrict()
                                                : null)
                                .senderWard(sr.getPickupAddress() != null ? sr.getPickupAddress().getWard() : null)
                                // Người nhận
                                .receiverName(sr.getDeliveryAddress() != null ? sr.getDeliveryAddress().getContactName()
                                                : null)
                                .receiverPhone(sr.getDeliveryAddress() != null
                                                ? sr.getDeliveryAddress().getContactPhone()
                                                : null)
                                .receiverAddress(sr.getDeliveryAddress() != null
                                                ? sr.getDeliveryAddress().getAddressDetail()
                                                : null)
                                .receiverProvince(
                                                sr.getDeliveryAddress() != null ? sr.getDeliveryAddress().getProvince()
                                                                : null)
                                .receiverDistrict(
                                                sr.getDeliveryAddress() != null ? sr.getDeliveryAddress().getDistrict()
                                                                : null)
                                .receiverWard(sr.getDeliveryAddress() != null ? sr.getDeliveryAddress().getWard()
                                                : null)
                                // Hàng hóa
                                .itemName(sr.getItemName())
                                .weight(sr.getWeight())
                                .length(sr.getLength())
                                .width(sr.getWidth())
                                .height(sr.getHeight())
                                .volumetricWeight(volumetricWeight)
                                // Dịch vụ
                                .serviceTypeId(sr.getServiceType() != null ? sr.getServiceType().getServiceTypeId()
                                                : null)
                                .serviceTypeName(sr.getServiceType() != null ? sr.getServiceType().getServiceName()
                                                : null)
                                .isFragile(sr.getItemName() != null && sr.getItemName().toLowerCase().contains("dễ vỡ"))
                                .isUrgent(priorityLevel.equals("HIGH"))
                                // Phí
                                .codAmount(sr.getCodAmount())
                                .shippingFee(sr.getShippingFee())
                                .totalPrice(sr.getTotalPrice())
                                // Hub hiện tại
                                .currentHubId(sr.getCurrentHub() != null ? sr.getCurrentHub().getHubId() : null)
                                .currentHubName(sr.getCurrentHub() != null ? sr.getCurrentHub().getHubName() : null)
                                // Hub đích
                                .destinationHubId(destinationHubId)
                                .destinationHubName(destinationHubName)
                                // Thời gian
                                .createdAt(sr.getCreatedAt())
                                .arrivedAtHubTime(arrivedTime)
                                .hoursInWarehouse(hoursInWarehouse)
                                .priorityLevel(priorityLevel)
                                .build();
        }

        private ContainerListResponse mapToContainerListResponse(Container c) {
                int orderCount = containerDetailRepository.findByContainerContainerId(c.getContainerId()).size();
                return ContainerListResponse.builder()
                                .containerId(c.getContainerId())
                                .containerCode(c.getContainerCode())
                                .type(c.getType().name())
                                .status(c.getStatus().name())
                                .weight(c.getWeight())
                                .createdAt(c.getCreatedAt())
                                .createdAtHubName(c.getCreatedAtHub() != null ? c.getCreatedAtHub().getHubName() : null)
                                .destinationHubName(c.getDestinationHub() != null ? c.getDestinationHub().getHubName()
                                                : null)
                                .orderCount(orderCount)
                                .build();
        }

        private ContainerDetailResponse mapToContainerDetailResponse(Container c) {
                List<ContainerDetail> details = containerDetailRepository
                                .findByContainerIdWithRequest(c.getContainerId());

                List<ContainerDetailResponse.OrderInContainerInfo> orders = details.stream()
                                .map(d -> {
                                        ServiceRequest sr = d.getRequest();
                                        return ContainerDetailResponse.OrderInContainerInfo.builder()
                                                        .requestId(sr.getRequestId())
                                                        .senderName(sr.getPickupAddress() != null
                                                                        ? sr.getPickupAddress().getContactName()
                                                                        : null)
                                                        .senderPhone(sr.getPickupAddress() != null
                                                                        ? sr.getPickupAddress().getContactPhone()
                                                                        : null)
                                                        .receiverName(sr.getDeliveryAddress() != null
                                                                        ? sr.getDeliveryAddress().getContactName()
                                                                        : null)
                                                        .receiverPhone(sr.getDeliveryAddress() != null
                                                                        ? sr.getDeliveryAddress().getContactPhone()
                                                                        : null)
                                                        .status(sr.getStatus().name())
                                                        .weight(sr.getWeight())
                                                        .totalPrice(sr.getTotalPrice())
                                                        .itemName(sr.getItemName())
                                                        .addedAt(d.getCreatedAt())
                                                        .build();
                                })
                                .collect(Collectors.toList());

                return ContainerDetailResponse.builder()
                                .containerId(c.getContainerId())
                                .containerCode(c.getContainerCode())
                                .type(c.getType().name())
                                .status(c.getStatus().name())
                                .weight(c.getWeight())
                                .createdAt(c.getCreatedAt())
                                .createdAtHub(ContainerDetailResponse.HubInfo.builder()
                                                .hubId(c.getCreatedAtHub().getHubId())
                                                .hubName(c.getCreatedAtHub().getHubName())
                                                .address(c.getCreatedAtHub().getAddress())
                                                .province(c.getCreatedAtHub().getProvince())
                                                .build())
                                .destinationHub(ContainerDetailResponse.HubInfo.builder()
                                                .hubId(c.getDestinationHub().getHubId())
                                                .hubName(c.getDestinationHub().getHubName())
                                                .address(c.getDestinationHub().getAddress())
                                                .province(c.getDestinationHub().getProvince())
                                                .build())
                                .createdByName(c.getCreatedBy() != null ? c.getCreatedBy().getFullName() : null)
                                .orders(orders)
                                .orderCount(orders.size())
                                .build();
        }

        private TripListResponse mapToTripListResponse(Trip t) {
                BigDecimal totalWeight = tripContainerRepository.sumWeightByTripId(t.getTripId());
                int containerCount = tripContainerRepository.findByTripIdWithContainerDetails(t.getTripId()).size();

                return TripListResponse.builder()
                                .tripId(t.getTripId())
                                .tripCode(t.getTripCode())
                                .status(t.getStatus().name())
                                .createdAt(t.getCreatedAt())
                                .departedAt(t.getDepartedAt())
                                .vehiclePlate(t.getVehicle() != null ? t.getVehicle().getPlateNumber() : null)
                                .vehicleType(t.getVehicle() != null ? t.getVehicle().getVehicleType() : null)
                                .driverName(t.getDriver() != null ? t.getDriver().getFullName() : null)
                                .driverPhone(t.getDriver() != null ? t.getDriver().getPhoneNumber() : null)
                                .fromHubId(t.getFromHub() != null ? t.getFromHub().getHubId() : null)
                                .fromHubName(t.getFromHub() != null ? t.getFromHub().getHubName() : null)
                                .toHubId(t.getToHub() != null ? t.getToHub().getHubId() : null)
                                .toHubName(t.getToHub() != null ? t.getToHub().getHubName() : null)
                                .containerCount(containerCount)
                                .totalWeight(totalWeight)
                                .vehicleCapacity(t.getVehicle() != null ? t.getVehicle().getLoadCapacity() : null)
                                .build();
        }
}
