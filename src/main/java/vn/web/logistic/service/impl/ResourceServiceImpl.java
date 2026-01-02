package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.entity.*;
import vn.web.logistic.entity.Container.ContainerStatus;
import vn.web.logistic.entity.Driver.DriverStatus;
import vn.web.logistic.entity.Trip.TripStatus;
import vn.web.logistic.entity.Vehicle.VehicleStatus;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.ResourceService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Implementation của ResourceService
 * Xử lý business logic cho quản lý tài nguyên (Tài xế, Xe, Chuyến)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ResourceServiceImpl implements ResourceService {

    private final DriverRepository driverRepository;
    private final VehicleRepository vehicleRepository;
    private final TripRepository tripRepository;
    private final TripContainerRepository tripContainerRepository;
    private final ContainerRepository containerRepository;
    private final ContainerDetailRepository containerDetailRepository;
    private final HubRepository hubRepository;
    private final ServiceRequestRepository serviceRequestRepository;

    // ===================== DRIVERS =====================

    @Override
    public List<Map<String, Object>> getAllDrivers() {
        log.info("Service: Lấy danh sách tất cả tài xế");
        List<Driver> drivers = driverRepository.findAll();
        return drivers.stream().map(d -> {
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
    }

    @Override
    @Transactional
    public Map<String, Object> createDriver(Map<String, Object> request) {
        log.info("Service: Thêm tài xế mới: {}", request);

        String fullName = (String) request.get("fullName");
        String phoneNumber = (String) request.get("phoneNumber");
        String licenseNumber = (String) request.get("licenseNumber");
        String licenseClass = (String) request.get("licenseClass");
        String identityCard = (String) request.get("identityCard");
        String statusStr = (String) request.get("status");

        // Validate
        if (driverRepository.existsByIdentityCard(identityCard)) {
            throw new BusinessException("CMND/CCCD đã tồn tại trong hệ thống");
        }
        if (driverRepository.existsByLicenseNumber(licenseNumber)) {
            throw new BusinessException("Số GPLX đã tồn tại trong hệ thống");
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

        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> updateDriver(Long id, Map<String, Object> request) {
        log.info("Service: Cập nhật tài xế {}: {}", id, request);

        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Tài xế không tồn tại: " + id));

        String identityCard = (String) request.get("identityCard");
        String licenseNumber = (String) request.get("licenseNumber");

        // Validate trùng lặp
        if (driverRepository.existsByIdentityCardAndDriverIdNot(identityCard, id)) {
            throw new BusinessException("CMND/CCCD đã tồn tại trong hệ thống");
        }
        if (driverRepository.existsByLicenseNumberAndDriverIdNot(licenseNumber, id)) {
            throw new BusinessException("Số GPLX đã tồn tại trong hệ thống");
        }

        driver.setFullName((String) request.get("fullName"));
        driver.setPhoneNumber((String) request.get("phoneNumber"));
        driver.setLicenseNumber(licenseNumber);
        driver.setLicenseClass((String) request.get("licenseClass"));
        driver.setIdentityCard(identityCard);
        String statusStr = (String) request.get("status");
        driver.setStatus("inactive".equals(statusStr) ? DriverStatus.inactive : DriverStatus.active);

        driverRepository.save(driver);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("driverId", driver.getDriverId());
        result.put("message", "Cập nhật tài xế thành công");

        return result;
    }

    @Override
    @Transactional
    public void deleteDriver(Long id) {
        log.info("Service: Xóa tài xế {}", id);

        if (!driverRepository.existsById(id)) {
            throw new BusinessException("Tài xế không tồn tại");
        }

        driverRepository.deleteById(id);
    }

    // ===================== VEHICLES =====================

    @Override
    public List<Map<String, Object>> getAllVehicles() {
        log.info("Service: Lấy danh sách tất cả xe");
        List<Vehicle> vehicles = vehicleRepository.findAll();
        return vehicles.stream().map(v -> {
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
    }

    @Override
    @Transactional
    public Map<String, Object> createVehicle(Map<String, Object> request) {
        log.info("Service: Thêm xe mới: {}", request);

        String plateNumber = (String) request.get("plateNumber");

        if (vehicleRepository.existsByPlateNumber(plateNumber)) {
            throw new BusinessException("Biển số xe đã tồn tại trong hệ thống");
        }

        Vehicle vehicle = new Vehicle();
        vehicle.setPlateNumber(plateNumber);
        vehicle.setVehicleType((String) request.get("vehicleType"));

        Object loadCapacity = request.get("loadCapacity");
        if (loadCapacity != null) {
            vehicle.setLoadCapacity(new BigDecimal(loadCapacity.toString()));
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

        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> updateVehicle(Long id, Map<String, Object> request) {
        log.info("Service: Cập nhật xe {}: {}", id, request);

        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Xe không tồn tại: " + id));

        String plateNumber = (String) request.get("plateNumber");
        if (vehicleRepository.existsByPlateNumberAndVehicleIdNot(plateNumber, id)) {
            throw new BusinessException("Biển số xe đã tồn tại trong hệ thống");
        }

        vehicle.setPlateNumber(plateNumber);
        vehicle.setVehicleType((String) request.get("vehicleType"));

        Object loadCapacity = request.get("loadCapacity");
        if (loadCapacity != null) {
            vehicle.setLoadCapacity(new BigDecimal(loadCapacity.toString()));
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

        vehicleRepository.save(vehicle);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("vehicleId", vehicle.getVehicleId());
        result.put("message", "Cập nhật xe thành công");

        return result;
    }

    @Override
    @Transactional
    public void deleteVehicle(Long id) {
        log.info("Service: Xóa xe {}", id);

        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Xe không tồn tại"));

        if (vehicle.getStatus() == VehicleStatus.in_transit) {
            throw new BusinessException("Không thể xóa xe đang vận chuyển");
        }

        vehicleRepository.deleteById(id);
    }

    // ===================== TRIPS =====================

    @Override
    public List<Map<String, Object>> getAllTrips(Long hubId, String status, LocalDateTime start, LocalDateTime end) {
        log.info("Service: Lấy tất cả chuyến xe - hubId: {}, status: {}, start: {}, end: {}",
                hubId, status, start, end);

        TripStatus tripStatus = null;
        if (status != null && !status.isEmpty()) {
            try {
                tripStatus = TripStatus.valueOf(status);
            } catch (Exception ignored) {
            }
        }

        List<Trip> trips = tripRepository.findAllWithFilters(
                hubId, null, tripStatus, start, end,
                Pageable.unpaged()).getContent();

        return trips.stream().map(t -> {
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
    }

    @Override
    public Map<String, Object> getTripFullDetail(Long tripId) {
        log.info("Service: Lấy chi tiết đầy đủ chuyến xe {}", tripId);

        Trip trip = tripRepository.findByIdWithDetails(tripId)
                .orElseThrow(() -> new BusinessException("Chuyến xe không tồn tại: " + tripId));

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
            containerMap.put("loadedAt", tc.getCreatedAt());

            // Destination hub
            if (container.getDestinationHub() != null) {
                containerMap.put("destinationHubName", container.getDestinationHub().getHubName());
            }

            // Orders in container
            List<ContainerDetail> details = containerDetailRepository
                    .findByContainer_ContainerId(container.getContainerId());
            List<Map<String, Object>> ordersInfo = new ArrayList<>();

            for (ContainerDetail cd : details) {
                ServiceRequest order = cd.getRequest();
                if (order == null)
                    continue;

                Map<String, Object> orderMap = new LinkedHashMap<>();
                orderMap.put("requestId", order.getRequestId());
                orderMap.put("trackingNumber", null);

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
                orderMap.put("addedToContainerAt", cd.getCreatedAt());

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

        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> tripArrival(Long tripId, Long actorId) {
        log.info("Service: Xác nhận xe đến bến - tripId: {}, actorId: {}", tripId, actorId);

        Trip trip = tripRepository.findByIdWithDetails(tripId)
                .orElseThrow(() -> new BusinessException("Chuyến xe không tồn tại: " + tripId));

        if (trip.getStatus() != TripStatus.on_way) {
            throw new BusinessException("Chỉ có thể xác nhận đến bến cho chuyến đang trên đường (on_way)");
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
            vehicle.setCurrentHub(trip.getToHub());
            vehicleRepository.save(vehicle);
        }

        // Update containers status
        List<TripContainer> tripContainers = tripContainerRepository.findByTrip_TripId(tripId);
        for (TripContainer tc : tripContainers) {
            Container container = tc.getContainer();
            if (container != null) {
                container.setStatus(ContainerStatus.received);
                containerRepository.save(container);
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("tripId", tripId);
        result.put("status", "completed");
        result.put("arrivedAt", now);
        result.put("message", "Đã xác nhận xe đến bến thành công");

        return result;
    }

    // ===================== ORDERS =====================

    @Override
    public Map<String, Object> getOrderDetail(Long orderId) {
        log.info("Service: Lấy chi tiết đơn hàng {}", orderId);

        ServiceRequest order = serviceRequestRepository.findById(orderId)
                .orElseThrow(() -> new BusinessException("Đơn hàng không tồn tại: " + orderId));

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("requestId", order.getRequestId());
        result.put("trackingNumber", null);
        result.put("status", order.getStatus());
        result.put("createdAt", order.getCreatedAt());

        // Sender info
        CustomerAddress pickup = order.getPickupAddress();
        result.put("senderName", pickup != null ? pickup.getContactName() : null);
        result.put("senderPhone", pickup != null ? pickup.getContactPhone() : null);
        result.put("senderAddress", pickup != null ? pickup.getAddressDetail() : null);
        result.put("senderWard", pickup != null ? pickup.getWard() : null);
        result.put("senderDistrict", pickup != null ? pickup.getDistrict() : null);
        result.put("senderProvince", pickup != null ? pickup.getProvince() : null);

        // Receiver info
        CustomerAddress delivery = order.getDeliveryAddress();
        result.put("receiverName", delivery != null ? delivery.getContactName() : null);
        result.put("receiverPhone", delivery != null ? delivery.getContactPhone() : null);
        result.put("receiverAddress", delivery != null ? delivery.getAddressDetail() : null);
        result.put("receiverWard", delivery != null ? delivery.getWard() : null);
        result.put("receiverDistrict", delivery != null ? delivery.getDistrict() : null);
        result.put("receiverProvince", delivery != null ? delivery.getProvince() : null);

        // Item info
        result.put("itemName", order.getItemName());
        result.put("itemDescription", order.getNote());
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

        result.put("note", order.getNote());

        return result;
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
