package vn.web.logistic.controller.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.response.inbound.ServiceRequestDTO;
import vn.web.logistic.dto.response.inbound.ServiceRequestDetailDTO;
import vn.web.logistic.dto.response.inbound.ServiceRequestSummaryDTO;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Route;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.service.FileUploadService;
import vn.web.logistic.service.InboundService;

/**
 * Controller xử lý các API liên quan đến nhập kho (Inbound)
 * Tuân thủ MVC Pattern - Controller chỉ điều phối, logic xử lý ở Service
 */
@RestController
@RequestMapping("/api/manager/inbound")
@RequiredArgsConstructor
@Slf4j
public class InboundController {

    private final InboundService inboundService;
    private final FileUploadService fileUploadService;

    // ==================== CORE INBOUND OPERATIONS ====================

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

            // Sử dụng service method để chuyển đổi DTO (MVC Pattern)
            ServiceRequestDTO orderDTO = inboundService.convertToDTO(savedOrder);

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
            // Sử dụng service method để chuyển đổi DTO
            ServiceRequestDTO data = inboundService.convertToDTO(sr);
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
     * routeId: BẮT BUỘC - phải chọn tuyến đường trước khi bàn giao
     */
    @PostMapping("/shipper-in")
    public ResponseEntity<?> processShipperInbound(
            @RequestParam String trackingCode,
            @RequestParam Long currentHubId,
            @RequestParam Long managerId,
            @RequestParam Long actionTypeId,
            @RequestParam Long routeId) {
        try {
            // Validate routeId bắt buộc
            if (routeId == null) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "Vui lòng chọn tuyến đường trước khi xác nhận bàn giao!"));
            }

            ServiceRequest sr = inboundService.processShipperInbound(trackingCode, currentHubId, managerId,
                    actionTypeId, routeId);
            // Sử dụng service method để chuyển đổi DTO chi tiết
            ServiceRequestDetailDTO data = inboundService.convertToDetailDTO(sr);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Shipper đã bàn giao thành công!",
                    "data", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // ==================== LOOKUP & QUERY APIs ====================

    /**
     * API 4: TRA CỨU ĐƠN HÀNG THEO MÃ VẬN ĐƠN (TRƯỚC KHI XÁC NHẬN)
     * GET /api/manager/inbound/lookup
     */
    @GetMapping("/lookup")
    public ResponseEntity<?> lookupOrder(@RequestParam String trackingCode) {
        try {
            ServiceRequest sr = inboundService.getOrderByTrackingCode(trackingCode);
            ServiceRequestDetailDTO data = inboundService.convertToDetailDTO(sr);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * API 5: LẤY DANH SÁCH ĐƠN HÀNG PENDING TẠI HUB
     * GET /api/manager/inbound/pending-orders/{hubId}
     */
    @GetMapping("/pending-orders/{hubId}")
    public ResponseEntity<?> getPendingOrders(@PathVariable Long hubId) {
        try {
            List<ServiceRequest> orders = inboundService.getPendingOrdersByHub(hubId);
            List<ServiceRequestSummaryDTO> data = orders.stream()
                    .map(inboundService::convertToSummaryDTO)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "count", data.size(),
                    "data", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // ==================== UI HELPER APIs ====================

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

    // ==================== VNPAY PAYMENT APIs ====================

    /**
     * API: TẠO URL THANH TOÁN VNPAY CHO ĐƠN TẠI QUẦY
     * POST /api/manager/inbound/create-vnpay
     */
    @PostMapping("/create-vnpay")
    public ResponseEntity<?> createVnpayDropOff(
            @RequestBody ServiceRequest order,
            @RequestParam String senderPhone,
            @RequestParam String receiverPhone,
            @RequestParam Long managerId,
            @RequestParam Long routeId,
            jakarta.servlet.http.HttpServletRequest request) {
        try {
            String paymentUrl = inboundService.createVnpayDropOffUrl(
                    order, senderPhone, receiverPhone, managerId, routeId, request);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "code", "00",
                    "url", paymentUrl,
                    "message", "Đã tạo URL thanh toán VNPay"));
        } catch (Exception e) {
            log.error("Lỗi tạo VNPay URL: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "code", "99",
                    "message", "Lỗi tạo thanh toán: " + e.getMessage()));
        }
    }

    /**
     * API: XỬ LÝ CALLBACK TỪ VNPAY SAU KHI THANH TOÁN
     * GET /api/manager/inbound/vnpay-return
     */
    @GetMapping("/vnpay-return")
    public String vnpayReturn(jakarta.servlet.http.HttpServletRequest request) {
        try {
            String redirectPath = inboundService.processVnpayReturn(request);
            return "redirect:" + redirectPath;
        } catch (Exception e) {
            log.error("Lỗi xử lý VNPay return: ", e);
            return "redirect:/manager/inbound/drop-off?vnpay=error&message=" + e.getMessage();
        }
    }
}