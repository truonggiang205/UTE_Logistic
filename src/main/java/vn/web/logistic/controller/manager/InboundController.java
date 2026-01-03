package vn.web.logistic.controller.manager;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Route;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.service.FileUploadService;
import vn.web.logistic.service.InboundService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/manager/inbound")
@RequiredArgsConstructor
@Slf4j
public class InboundController {

    private final InboundService inboundService;
    private final FileUploadService fileUploadService;

    /**
     * API 1: TẠO ĐƠN HÀNG TẠI QUẦY
     * POST /api/manager/inbound/drop-off
     */
    @PostMapping("/drop-off")
    public ResponseEntity<?> createDropOffOrder(
            @RequestBody ServiceRequest order,
            @RequestParam String senderPhone,
            @RequestParam String receiverPhone,
            @RequestParam Long managerId,
            @RequestParam Long routeId,
            @RequestParam(required = false, defaultValue = "unpaid") String paymentStatus) {
        try {
            // Set paymentStatus từ request
            if ("paid".equalsIgnoreCase(paymentStatus)) {
                order.setPaymentStatus(ServiceRequest.PaymentStatus.paid);
            } else {
                order.setPaymentStatus(ServiceRequest.PaymentStatus.unpaid);
            }

            ServiceRequest savedOrder = inboundService.createDropOffOrder(
                    order, senderPhone, receiverPhone, managerId, routeId);

            // Chuyển sang DTO để tránh lỗi Hibernate Proxy serialization
            Map<String, Object> orderDTO = convertServiceRequestToDTO(savedOrder);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Tạo đơn hàng thành công!");
            response.put("data", orderDTO);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lỗi: " + e.getMessage()));
        }
    }

    /**
     * API 2: QUÉT MÃ NHẬP KHO TRUNG CHUYỂN (TỪ HUB KHÁC TỚI)
     * POST /api/manager/inbound/hub-in
     */
    @PostMapping("/hub-in")
    public ResponseEntity<?> processHubInbound(
            @RequestParam String trackingCode,
            @RequestParam Long currentHubId,
            @RequestParam Long managerId,
            @RequestParam Long actionTypeId) {
        try {
            ServiceRequest sr = inboundService.processInterHubInbound(trackingCode, currentHubId, managerId,
                    actionTypeId);
            // Trả về DTO để tránh lỗi Hibernate Proxy serialization
            Map<String, Object> data = convertServiceRequestToDTO(sr);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Nhập kho thành công vận đơn: " + trackingCode,
                    "data", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * API 3: SHIPPER BÀN GIAO HÀNG CHO BƯU CỤC
     * POST /api/manager/inbound/shipper-in
     */
    @PostMapping("/shipper-in")
    public ResponseEntity<?> processShipperInbound(
            @RequestParam String trackingCode,
            @RequestParam Long currentHubId,
            @RequestParam Long managerId,
            @RequestParam Long actionTypeId) {
        try {
            ServiceRequest sr = inboundService.processShipperInbound(trackingCode, currentHubId, managerId,
                    actionTypeId);
            // Trả về DTO để tránh lỗi Hibernate Proxy serialization
            Map<String, Object> data = convertServiceRequestToDTO(sr);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Shipper đã bàn giao thành công!",
                    "data", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // --- CÁC API HỖ TRỢ GIAO DIỆN (UI HELPERS) ---

    /**
     * Upload ảnh hàng hóa
     * POST /api/manager/inbound/upload-image
     */
    @PostMapping("/upload-image")
    public ResponseEntity<?> uploadParcelImage(@RequestParam("file") MultipartFile file) {
        try {
            String imagePath = fileUploadService.uploadImage(file, "parcels");
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Upload ảnh thành công",
                    "imagePath", imagePath));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lỗi upload ảnh: " + e.getMessage()));
        }
    }

    /**
     * Lấy danh sách địa chỉ cũ của khách theo SĐT (để gợi ý khi nhập)
     */
    @GetMapping("/customer-addresses")
    public ResponseEntity<List<CustomerAddress>> getAddresses(@RequestParam String phone) {
        return ResponseEntity.ok(inboundService.getCustomerAddresses(phone));
    }

    /**
     * Lấy danh sách các dịch vụ (Nhanh, Tiết kiệm...)
     */
    @GetMapping("/active-services")
    public ResponseEntity<List<ServiceType>> getServices() {
        return ResponseEntity.ok(inboundService.getActiveServices());
    }

    /**
     * Lấy danh sách các hướng đi (Route) từ bưu cục hiện tại
     * Trả về DTO để tránh lỗi Hibernate Proxy serialization
     */
    @GetMapping("/available-routes/{hubId}")
    public ResponseEntity<?> getRoutes(@PathVariable Long hubId) {
        try {
            log.debug("Loading routes for hubId={}", hubId);
            List<Route> routes = inboundService.getAvailableRoutes(hubId);
            log.debug("Found {} routes for hubId={}", routes.size(), hubId);

            // Chuyển sang Map để tránh lỗi Hibernate Proxy
            List<Map<String, Object>> routeDTOs = routes.stream()
                    .map(r -> {
                        Map<String, Object> dto = new HashMap<>();
                        dto.put("routeId", r.getRouteId());
                        dto.put("description", r.getDescription());
                        dto.put("estimatedTime", r.getEstimatedTime());

                        // FromHub
                        if (r.getFromHub() != null) {
                            Map<String, Object> fromHub = new HashMap<>();
                            fromHub.put("hubId", r.getFromHub().getHubId());
                            fromHub.put("hubName", r.getFromHub().getHubName());
                            fromHub.put("province", r.getFromHub().getProvince());
                            dto.put("fromHub", fromHub);
                        }

                        // ToHub
                        if (r.getToHub() != null) {
                            Map<String, Object> toHub = new HashMap<>();
                            toHub.put("hubId", r.getToHub().getHubId());
                            toHub.put("hubName", r.getToHub().getHubName());
                            toHub.put("province", r.getToHub().getProvince());
                            dto.put("toHub", toHub);
                        }

                        return dto;
                    })
                    .collect(Collectors.toList());

            return ResponseEntity.ok(routeDTOs);
        } catch (Exception e) {
            log.error("Error loading routes for hubId={}: {}", hubId, e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lỗi lấy danh sách tuyến: " + e.getMessage()));
        }
    }

    /**
     * Lấy danh sách các loại hành động (ActionType) để Manager chọn khi quét mã
     */
    @GetMapping("/action-types")
    public ResponseEntity<?> getActionTypes() {
        try {
            List<ActionType> actionTypes = inboundService.getInboundActionTypes();

            // Chuyển sang DTO để tránh lỗi serialization
            List<Map<String, Object>> dtos = actionTypes.stream()
                    .map(at -> {
                        Map<String, Object> dto = new HashMap<>();
                        dto.put("actionTypeId", at.getActionTypeId());
                        dto.put("actionCode", at.getActionCode());
                        dto.put("description", at.getDescription());
                        return dto;
                    })
                    .collect(Collectors.toList());

            return ResponseEntity.ok(dtos);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lỗi lấy danh sách ActionType: " + e.getMessage()));
        }
    }

    /**
     * Chuyển ServiceRequest entity sang DTO để tránh lỗi Hibernate Proxy
     * serialization
     */
    private Map<String, Object> convertServiceRequestToDTO(ServiceRequest sr) {
        Map<String, Object> dto = new HashMap<>();
        dto.put("requestId", sr.getRequestId());
        dto.put("status", sr.getStatus() != null ? sr.getStatus().name() : null);
        dto.put("note", sr.getNote());
        dto.put("createdAt", sr.getCreatedAt());

        // Pickup Address
        if (sr.getPickupAddress() != null) {
            Map<String, Object> pickup = new HashMap<>();
            pickup.put("contactName", sr.getPickupAddress().getContactName());
            pickup.put("contactPhone", sr.getPickupAddress().getContactPhone());
            pickup.put("addressDetail", sr.getPickupAddress().getAddressDetail());
            pickup.put("ward", sr.getPickupAddress().getWard());
            pickup.put("district", sr.getPickupAddress().getDistrict());
            pickup.put("province", sr.getPickupAddress().getProvince());
            dto.put("pickupAddress", pickup);
        }

        // Delivery Address
        if (sr.getDeliveryAddress() != null) {
            Map<String, Object> delivery = new HashMap<>();
            delivery.put("contactName", sr.getDeliveryAddress().getContactName());
            delivery.put("contactPhone", sr.getDeliveryAddress().getContactPhone());
            delivery.put("addressDetail", sr.getDeliveryAddress().getAddressDetail());
            delivery.put("ward", sr.getDeliveryAddress().getWard());
            delivery.put("district", sr.getDeliveryAddress().getDistrict());
            delivery.put("province", sr.getDeliveryAddress().getProvince());
            dto.put("deliveryAddress", delivery);
        }

        // Current Hub
        if (sr.getCurrentHub() != null) {
            Map<String, Object> hub = new HashMap<>();
            hub.put("hubId", sr.getCurrentHub().getHubId());
            hub.put("hubName", sr.getCurrentHub().getHubName());
            dto.put("currentHub", hub);
        }

        return dto;
    }
}