package vn.web.logistic.controller.manager;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.entity.*;
import vn.web.logistic.entity.Driver.DriverStatus;
import vn.web.logistic.entity.Trip.TripStatus;
import vn.web.logistic.entity.Vehicle.VehicleStatus;
import vn.web.logistic.repository.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * ResourceController - Quản lý Tài xế, Xe, Chuyến (cho Manager)
 * Endpoint prefix: /api/manager/resource
 */
@Slf4j
@RestController
@RequestMapping("/api/manager/resource")
@RequiredArgsConstructor
public class ResourceController {

    private final DriverRepository driverRepository;
    private final VehicleRepository vehicleRepository;
    private final TripRepository tripRepository;
    private final TripContainerRepository tripContainerRepository;
    private final ContainerRepository containerRepository;
    private final ContainerDetailRepository containerDetailRepository;
    private final HubRepository hubRepository;
    private final ServiceRequestRepository serviceRequestRepository;

    // ===================== DRIVERS =====================

    /**
     * GET /api/manager/resource/drivers - Lấy tất cả tài xế
     */
    @GetMapping("/drivers")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAllDrivers() {
        log.info("API: Lấy danh sách tất cả tài xế");
        List<Driver> drivers = driverRepository.findAll();
        List<Map<String, Object>> result = drivers.stream().map(d -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("driverId", d.getDriverId());
            map.put("fullName", d.getFullName());
            map.put("phoneNumber", d.getPhoneNumber());
            map.put("licenseNumber", d.getLicenseNumber());
            map.put("licenseClass", d.getLicenseClass());
            map.put("identityCard", d.getIdentityCard());
            map.put("status", d.getStatus() != null ? d.getStatus().name() : "active");
            return map;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    /**
     * POST /api/manager/resource/drivers - Thêm tài xế mới
     */
    @PostMapping("/drivers")
    public ResponseEntity<ApiResponse<Map<String, Object>>> createDriver(@RequestBody Map<String, Object> request) {
        log.info("API: Thêm tài xế mới: {}", request);

        String fullName = (String) request.get("fullName");
        String phoneNumber = (String) request.get("phoneNumber");
        String licenseNumber = (String) request.get("licenseNumber");
        String licenseClass = (String) request.get("licenseClass");
        String identityCard = (String) request.get("identityCard");
        String statusStr = (String) request.get("status");

        // Validate
        if (driverRepository.existsByIdentityCard(identityCard)) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("CMND/CCCD đã tồn tại trong hệ thống"));
        }
        if (driverRepository.existsByLicenseNumber(licenseNumber)) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Số GPLX đã tồn tại trong hệ thống"));
        }

        Driver driver = new Driver();
        driver.setFullName(fullName);
        driver.setPhoneNumber(phoneNumber);
        driver.setLicenseNumber(licenseNumber);
        driver.setLicenseClass(licenseClass);
        driver.setIdentityCard(identityCard);
        driver.setStatus("inactive".equals(statusStr) ? DriverStatus.inactive : DriverStatus.active);
        driver.setCreatedAt(LocalDateTime.now());

        driver = driverRepository.save(driver);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("driverId", driver.getDriverId());
        result.put("fullName", driver.getFullName());
        result.put("message", "Tạo tài xế thành công");

        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Thêm tài xế thành công", result));
    }

    /**
     * PUT /api/manager/resource/drivers/{id} - Cập nhật tài xế
     */
    @PutMapping("/drivers/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> updateDriver(
            @PathVariable Long id, @RequestBody Map<String, Object> request) {
        log.info("API: Cập nhật tài xế {}: {}", id, request);

        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Tài xế không tồn tại: " + id));

        String identityCard = (String) request.get("identityCard");
        String licenseNumber = (String) request.get("licenseNumber");

        // Validate trùng lặp
        if (driverRepository.existsByIdentityCardAndDriverIdNot(identityCard, id)) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("CMND/CCCD đã tồn tại trong hệ thống"));
        }
        if (driverRepository.existsByLicenseNumberAndDriverIdNot(licenseNumber, id)) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Số GPLX đã tồn tại trong hệ thống"));
        }

        driver.setFullName((String) request.get("fullName"));
        driver.setPhoneNumber((String) request.get("phoneNumber"));
        driver.setLicenseNumber(licenseNumber);
        driver.setLicenseClass((String) request.get("licenseClass"));
        driver.setIdentityCard(identityCard);
        String statusStr = (String) request.get("status");
        driver.setStatus("inactive".equals(statusStr) ? DriverStatus.inactive : DriverStatus.active);
        // Driver không có updatedAt

        driverRepository.save(driver);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("driverId", driver.getDriverId());
        result.put("message", "Cập nhật tài xế thành công");

        return ResponseEntity.ok(ApiResponse.success("Cập nhật tài xế thành công", result));
    }

    /**
     * DELETE /api/manager/resource/drivers/{id} - Xóa tài xế
     */
    @DeleteMapping("/drivers/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteDriver(@PathVariable Long id) {
        log.info("API: Xóa tài xế {}", id);

        if (!driverRepository.existsById(id)) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Tài xế không tồn tại"));
        }

        driverRepository.deleteById(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa tài xế thành công", null));
    }

    // ===================== VEHICLES =====================

    /**
     * GET /api/manager/resource/vehicles - Lấy tất cả xe
     */
    @GetMapping("/vehicles")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAllVehicles() {
        log.info("API: Lấy danh sách tất cả xe");
        List<Vehicle> vehicles = vehicleRepository.findAll();
        List<Map<String, Object>> result = vehicles.stream().map(v -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("vehicleId", v.getVehicleId());
            map.put("plateNumber", v.getPlateNumber());
            map.put("vehicleType", v.getVehicleType());
            map.put("loadCapacity", v.getLoadCapacity());
            map.put("currentHubId", v.getCurrentHub() != null ? v.getCurrentHub().getHubId() : null);
            map.put("currentHubName", v.getCurrentHub() != null ? v.getCurrentHub().getHubName() : null);
            map.put("status", v.getStatus() != null ? v.getStatus().name() : "available");
            return map;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    /**
     * POST /api/manager/resource/vehicles - Thêm xe mới
     */
    @PostMapping("/vehicles")
    public ResponseEntity<ApiResponse<Map<String, Object>>> createVehicle(@RequestBody Map<String, Object> request) {
        log.info("API: Thêm xe mới: {}", request);

        String plateNumber = (String) request.get("plateNumber");

        if (vehicleRepository.existsByPlateNumber(plateNumber)) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Biển số xe đã tồn tại trong hệ thống"));
        }

        Vehicle vehicle = new Vehicle();
        vehicle.setPlateNumber(plateNumber);
        vehicle.setVehicleType((String) request.get("vehicleType"));

        Object loadCapacity = request.get("loadCapacity");
        if (loadCapacity != null) {
            vehicle.setLoadCapacity(new java.math.BigDecimal(loadCapacity.toString()));
        }

        Object hubIdObj = request.get("currentHubId");
        if (hubIdObj != null && !hubIdObj.toString().isEmpty()) {
            Long hubId = Long.parseLong(hubIdObj.toString());
            Hub hub = hubRepository.findById(hubId).orElse(null);
            vehicle.setCurrentHub(hub);
        }

        String statusStr = (String) request.get("status");
        vehicle.setStatus(parseVehicleStatus(statusStr));
        vehicle.setCreatedAt(LocalDateTime.now());

        vehicle = vehicleRepository.save(vehicle);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("vehicleId", vehicle.getVehicleId());
        result.put("plateNumber", vehicle.getPlateNumber());

        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Thêm xe thành công", result));
    }

    /**
     * PUT /api/manager/resource/vehicles/{id} - Cập nhật xe
     */
    @PutMapping("/vehicles/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> updateVehicle(
            @PathVariable Long id, @RequestBody Map<String, Object> request) {
        log.info("API: Cập nhật xe {}: {}", id, request);

        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Xe không tồn tại: " + id));

        String plateNumber = (String) request.get("plateNumber");
        if (vehicleRepository.existsByPlateNumberAndVehicleIdNot(plateNumber, id)) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Biển số xe đã tồn tại trong hệ thống"));
        }

        vehicle.setPlateNumber(plateNumber);
        vehicle.setVehicleType((String) request.get("vehicleType"));

        Object loadCapacity = request.get("loadCapacity");
        if (loadCapacity != null) {
            vehicle.setLoadCapacity(new java.math.BigDecimal(loadCapacity.toString()));
        }

        Object hubIdObj = request.get("currentHubId");
        if (hubIdObj != null && !hubIdObj.toString().isEmpty()) {
            Long hubId = Long.parseLong(hubIdObj.toString());
            Hub hub = hubRepository.findById(hubId).orElse(null);
            vehicle.setCurrentHub(hub);
        } else {
            vehicle.setCurrentHub(null);
        }

        String statusStr = (String) request.get("status");
        vehicle.setStatus(parseVehicleStatus(statusStr));
        // Vehicle không có updatedAt

        vehicleRepository.save(vehicle);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("vehicleId", vehicle.getVehicleId());
        result.put("message", "Cập nhật xe thành công");

        return ResponseEntity.ok(ApiResponse.success("Cập nhật xe thành công", result));
    }

    /**
     * DELETE /api/manager/resource/vehicles/{id} - Xóa xe
     */
    @DeleteMapping("/vehicles/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteVehicle(@PathVariable Long id) {
        log.info("API: Xóa xe {}", id);

        Vehicle vehicle = vehicleRepository.findById(id).orElse(null);
        if (vehicle == null) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Xe không tồn tại"));
        }

        if (vehicle.getStatus() == VehicleStatus.in_transit) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Không thể xóa xe đang vận chuyển"));
        }

        vehicleRepository.deleteById(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa xe thành công", null));
    }

    // ===================== TRIPS =====================

    /**
     * GET /api/manager/resource/all-trips - Lấy tất cả chuyến xe (bao gồm đã xuất
     * bến)
     */
    @GetMapping("/all-trips")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAllTrips(
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        log.info("API: Lấy tất cả chuyến xe - hubId: {}, status: {}, startDate: {}, endDate: {}",
                hubId, status, startDate, endDate);

        TripStatus tripStatus = null;
        if (status != null && !status.isEmpty()) {
            try {
                tripStatus = TripStatus.valueOf(status);
            } catch (Exception ignored) {
            }
        }

        LocalDateTime start = null;
        LocalDateTime end = null;
        try {
            if (startDate != null && !startDate.isEmpty()) {
                start = LocalDate.parse(startDate).atStartOfDay();
            }
            if (endDate != null && !endDate.isEmpty()) {
                end = LocalDate.parse(endDate).atTime(LocalTime.MAX);
            }
        } catch (Exception ignored) {
        }

        List<Trip> trips = tripRepository.findAllWithFilters(
                hubId, null, tripStatus, start, end,
                org.springframework.data.domain.Pageable.unpaged()).getContent();

        List<Map<String, Object>> result = trips.stream().map(t -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("tripId", t.getTripId());
            map.put("tripCode", t.getTripCode());
            map.put("status", t.getStatus() != null ? t.getStatus().name() : null);
            map.put("createdAt", t.getCreatedAt());
            map.put("departedAt", t.getDepartedAt());
            map.put("arrivedAt", t.getArrivedAt());

            // Vehicle info
            if (t.getVehicle() != null) {
                Map<String, Object> vehicleInfo = new LinkedHashMap<>();
                vehicleInfo.put("vehicleId", t.getVehicle().getVehicleId());
                vehicleInfo.put("plateNumber", t.getVehicle().getPlateNumber());
                vehicleInfo.put("vehicleType", t.getVehicle().getVehicleType());
                map.put("vehicle", vehicleInfo);
            }

            // Driver info
            if (t.getDriver() != null) {
                Map<String, Object> driverInfo = new LinkedHashMap<>();
                driverInfo.put("driverId", t.getDriver().getDriverId());
                driverInfo.put("fullName", t.getDriver().getFullName());
                driverInfo.put("phoneNumber", t.getDriver().getPhoneNumber());
                map.put("driver", driverInfo);
            }

            // From/To Hub
            if (t.getFromHub() != null) {
                Map<String, Object> fromHub = new LinkedHashMap<>();
                fromHub.put("hubId", t.getFromHub().getHubId());
                fromHub.put("hubName", t.getFromHub().getHubName());
                map.put("fromHub", fromHub);
            }
            if (t.getToHub() != null) {
                Map<String, Object> toHub = new LinkedHashMap<>();
                toHub.put("hubId", t.getToHub().getHubId());
                toHub.put("hubName", t.getToHub().getHubName());
                map.put("toHub", toHub);
            }

            // Count containers
            long containerCount = tripContainerRepository.countByTrip_TripId(t.getTripId());
            map.put("containerCount", containerCount);

            return map;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(ApiResponse.success(result));
    }

    /**
     * GET /api/manager/resource/trips/{tripId}/full-detail - Chi tiết chuyến xe đầy
     * đủ (bao gồm đơn hàng)
     */
    @GetMapping("/trips/{tripId}/full-detail")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getTripFullDetail(@PathVariable Long tripId) {
        log.info("API: Lấy chi tiết đầy đủ chuyến xe {}", tripId);

        Trip trip = tripRepository.findByIdWithDetails(tripId)
                .orElseThrow(() -> new RuntimeException("Chuyến xe không tồn tại: " + tripId));

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("tripId", trip.getTripId());
        result.put("tripCode", trip.getTripCode());
        result.put("status", trip.getStatus() != null ? trip.getStatus().name() : null);
        result.put("createdAt", trip.getCreatedAt());
        result.put("departedAt", trip.getDepartedAt());
        result.put("arrivedAt", trip.getArrivedAt());

        // Vehicle info
        if (trip.getVehicle() != null) {
            Map<String, Object> vehicleInfo = new LinkedHashMap<>();
            vehicleInfo.put("vehicleId", trip.getVehicle().getVehicleId());
            vehicleInfo.put("plateNumber", trip.getVehicle().getPlateNumber());
            vehicleInfo.put("vehicleType", trip.getVehicle().getVehicleType());
            vehicleInfo.put("loadCapacity", trip.getVehicle().getLoadCapacity());
            vehicleInfo.put("status",
                    trip.getVehicle().getStatus() != null ? trip.getVehicle().getStatus().name() : null);
            result.put("vehicle", vehicleInfo);
        }

        // Driver info
        if (trip.getDriver() != null) {
            Map<String, Object> driverInfo = new LinkedHashMap<>();
            driverInfo.put("driverId", trip.getDriver().getDriverId());
            driverInfo.put("fullName", trip.getDriver().getFullName());
            driverInfo.put("phoneNumber", trip.getDriver().getPhoneNumber());
            driverInfo.put("licenseNumber", trip.getDriver().getLicenseNumber());
            result.put("driver", driverInfo);
        }

        // Hubs
        if (trip.getFromHub() != null) {
            Map<String, Object> fromHub = new LinkedHashMap<>();
            fromHub.put("hubId", trip.getFromHub().getHubId());
            fromHub.put("hubName", trip.getFromHub().getHubName());
            fromHub.put("address", trip.getFromHub().getAddress());
            result.put("fromHub", fromHub);
        }
        if (trip.getToHub() != null) {
            Map<String, Object> toHub = new LinkedHashMap<>();
            toHub.put("hubId", trip.getToHub().getHubId());
            toHub.put("hubName", trip.getToHub().getHubName());
            toHub.put("address", trip.getToHub().getAddress());
            result.put("toHub", toHub);
        }

        // Containers with orders
        List<TripContainer> tripContainers = tripContainerRepository.findByTrip_TripId(tripId);
        List<Map<String, Object>> containersInfo = new ArrayList<>();

        for (TripContainer tc : tripContainers) {
            Container container = tc.getContainer();
            if (container == null)
                continue;

            Map<String, Object> containerMap = new LinkedHashMap<>();
            containerMap.put("containerId", container.getContainerId());
            containerMap.put("containerCode", container.getContainerCode());
            containerMap.put("containerType", container.getType() != null ? container.getType().name() : null);
            containerMap.put("status", container.getStatus() != null ? container.getStatus().name() : null);
            containerMap.put("currentWeight", container.getWeight());
            containerMap.put("loadedAt", tc.getCreatedAt()); // TripContainer dùng createdAt

            // Destination hub
            if (container.getDestinationHub() != null) {
                containerMap.put("destinationHubName", container.getDestinationHub().getHubName());
            }

            // Orders in container
            List<ContainerDetail> details = containerDetailRepository
                    .findByContainer_ContainerId(container.getContainerId());
            List<Map<String, Object>> ordersInfo = new ArrayList<>();

            for (ContainerDetail cd : details) {
                ServiceRequest order = cd.getRequest(); // ContainerDetail dùng request không phải getServiceRequest
                if (order == null)
                    continue;

                Map<String, Object> orderMap = new LinkedHashMap<>();
                orderMap.put("requestId", order.getRequestId());
                // Lấy tracking từ TrackingCodeRepository nếu cần, tạm bỏ qua
                orderMap.put("trackingNumber", null);

                // ServiceRequest không có sender/receiver trực tiếp, phải qua
                // pickupAddress/deliveryAddress
                CustomerAddress pickup = order.getPickupAddress();
                CustomerAddress delivery = order.getDeliveryAddress();

                orderMap.put("senderName", pickup != null ? pickup.getContactName() : null);
                orderMap.put("senderPhone", pickup != null ? pickup.getContactPhone() : null);
                orderMap.put("senderAddress",
                        pickup != null
                                ? (pickup.getAddressDetail() + ", " + pickup.getWard() + ", " + pickup.getDistrict()
                                        + ", " + pickup.getProvince())
                                : null);
                orderMap.put("receiverName", delivery != null ? delivery.getContactName() : null);
                orderMap.put("receiverPhone", delivery != null ? delivery.getContactPhone() : null);
                orderMap.put("receiverAddress",
                        delivery != null
                                ? (delivery.getAddressDetail() + ", " + delivery.getWard() + ", "
                                        + delivery.getDistrict() + ", " + delivery.getProvince())
                                : null);
                orderMap.put("itemName", order.getItemName());
                orderMap.put("weight", order.getWeight());
                orderMap.put("status", order.getStatus());
                orderMap.put("codAmount", order.getCodAmount());
                orderMap.put("totalPrice", order.getTotalPrice());
                orderMap.put("addedToContainerAt", cd.getCreatedAt()); // ContainerDetail dùng createdAt

                ordersInfo.add(orderMap);
            }

            containerMap.put("orderCount", ordersInfo.size());
            containerMap.put("orders", ordersInfo);
            containersInfo.add(containerMap);
        }

        result.put("containerCount", containersInfo.size());
        result.put("containers", containersInfo);

        // Calculate total orders
        int totalOrders = containersInfo.stream()
                .mapToInt(c -> (Integer) c.get("orderCount"))
                .sum();
        result.put("totalOrders", totalOrders);

        return ResponseEntity.ok(ApiResponse.success(result));
    }

    /**
     * POST /api/manager/resource/trips/{tripId}/arrive - Xác nhận xe đến bến
     */
    @PostMapping("/trips/{tripId}/arrive")
    public ResponseEntity<ApiResponse<Map<String, Object>>> tripArrival(
            @PathVariable Long tripId,
            @RequestParam(required = false) Long actorId) {

        log.info("API: Xác nhận xe đến bến - tripId: {}, actorId: {}", tripId, actorId);

        Trip trip = tripRepository.findByIdWithDetails(tripId)
                .orElseThrow(() -> new RuntimeException("Chuyến xe không tồn tại: " + tripId));

        if (trip.getStatus() != TripStatus.on_way) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Chỉ có thể xác nhận đến bến cho chuyến đang trên đường (on_way)"));
        }

        LocalDateTime now = LocalDateTime.now();

        // Update trip status
        trip.setStatus(TripStatus.completed);
        trip.setArrivedAt(now);
        tripRepository.save(trip);

        // Update vehicle status
        Vehicle vehicle = trip.getVehicle();
        if (vehicle != null) {
            vehicle.setStatus(VehicleStatus.available);
            vehicle.setCurrentHub(trip.getToHub()); // Xe đã đến hub đích
            vehicleRepository.save(vehicle);
        }

        // Update containers status -> ready to unload at destination hub
        List<TripContainer> tripContainers = tripContainerRepository.findByTrip_TripId(tripId);
        for (TripContainer tc : tripContainers) {
            Container container = tc.getContainer();
            if (container != null) {
                // Container đã đến đích, chuyển sang trạng thái received (đã nhận tại hub đích)
                container.setStatus(Container.ContainerStatus.received);
                containerRepository.save(container);
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("tripId", tripId);
        result.put("status", "completed");
        result.put("arrivedAt", now);
        result.put("message", "Đã xác nhận xe đến bến thành công");

        return ResponseEntity.ok(ApiResponse.success("Xe đã đến bến thành công", result));
    }

    /**
     * GET /api/manager/resource/orders/{orderId} - Lấy chi tiết đơn hàng
     */
    @GetMapping("/orders/{orderId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getOrderDetail(@PathVariable Long orderId) {
        log.info("API: Lấy chi tiết đơn hàng {}", orderId);

        ServiceRequest order = serviceRequestRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Đơn hàng không tồn tại: " + orderId));

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("requestId", order.getRequestId());
        // TrackingNumber không nằm trong ServiceRequest, cần query từ TrackingCode
        // table
        result.put("trackingNumber", null);
        result.put("status", order.getStatus());
        result.put("createdAt", order.getCreatedAt());

        // Sender info từ pickupAddress
        CustomerAddress pickup = order.getPickupAddress();
        result.put("senderName", pickup != null ? pickup.getContactName() : null);
        result.put("senderPhone", pickup != null ? pickup.getContactPhone() : null);
        result.put("senderAddress", pickup != null ? pickup.getAddressDetail() : null);
        result.put("senderWard", pickup != null ? pickup.getWard() : null);
        result.put("senderDistrict", pickup != null ? pickup.getDistrict() : null);
        result.put("senderProvince", pickup != null ? pickup.getProvince() : null);

        // Receiver info từ deliveryAddress
        CustomerAddress delivery = order.getDeliveryAddress();
        result.put("receiverName", delivery != null ? delivery.getContactName() : null);
        result.put("receiverPhone", delivery != null ? delivery.getContactPhone() : null);
        result.put("receiverAddress", delivery != null ? delivery.getAddressDetail() : null);
        result.put("receiverWard", delivery != null ? delivery.getWard() : null);
        result.put("receiverDistrict", delivery != null ? delivery.getDistrict() : null);
        result.put("receiverProvince", delivery != null ? delivery.getProvince() : null);

        // Item info
        result.put("itemName", order.getItemName());
        result.put("itemDescription", order.getNote()); // Dùng note làm description
        result.put("weight", order.getWeight());
        result.put("length", order.getLength());
        result.put("width", order.getWidth());
        result.put("height", order.getHeight());

        // Fees
        result.put("shippingFee", order.getShippingFee());
        result.put("codAmount", order.getCodAmount());
        result.put("codFee", order.getCodFee());
        result.put("insuranceFee", order.getInsuranceFee());
        result.put("totalPrice", order.getTotalPrice());

        // Service type
        if (order.getServiceType() != null) {
            result.put("serviceTypeName", order.getServiceType().getServiceName());
        }

        // Current hub
        if (order.getCurrentHub() != null) {
            result.put("currentHubName", order.getCurrentHub().getHubName());
        }

        // Notes
        result.put("note", order.getNote());

        return ResponseEntity.ok(ApiResponse.success(result));
    }

    // ===================== HELPER METHODS =====================

    private VehicleStatus parseVehicleStatus(String status) {
        if (status == null)
            return VehicleStatus.available;
        try {
            return VehicleStatus.valueOf(status);
        } catch (Exception e) {
            return VehicleStatus.available;
        }
    }
}
