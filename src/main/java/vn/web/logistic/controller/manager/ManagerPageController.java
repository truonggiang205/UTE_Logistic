package vn.web.logistic.controller.manager;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.entity.Trip;
import vn.web.logistic.service.ManagerPageService;

import java.time.format.DateTimeFormatter;
import java.math.BigDecimal;

/**
 * Controller để render các trang JSP cho Manager
 * Sử dụng ManagerPageService để lấy dữ liệu (tuân thủ mô hình MVC)
 */
@Slf4j
@Controller
@RequestMapping("/manager")
@RequiredArgsConstructor
public class ManagerPageController {

    private final ManagerPageService managerPageService;

    @GetMapping("/dashboard")
    public String viewDashboard() {
        return "manager/dashboard";
    }

    @GetMapping("/hub-orders")
    public String viewHubOrders() {
        log.info("Truy cập trang Quản lý Đơn hàng Hub");
        return "manager/hub-orders";
    }

    @GetMapping("/tracking")
    public String viewTracking() {
        return "manager/tracking";
    }

    // ===================== INBOUND =====================

    /**
     * Trang Tạo Đơn Tại Quầy (Drop-off)
     */
    @GetMapping("/inbound/drop-off")
    public String viewInboundDropOff(Model model) {
        log.info("Truy cập trang Tạo Đơn Tại Quầy");
        model.addAttribute("hubs", managerPageService.getAllHubs());
        model.addAttribute("serviceTypes", managerPageService.getActiveServiceTypes());
        return "manager/inbound/drop-off";
    }

    /**
     * Trang Nhập kho từ xe tải (Hub-In)
     */
    @GetMapping("/inbound/hub-in")
    public String viewInboundHubIn(Model model) {
        log.info("Truy cập trang Nhập kho từ Hub");
        return "manager/inbound/hub-in";
    }

    /**
     * Trang Shipper bàn giao (Shipper-In)
     */
    @GetMapping("/inbound/shipper-in")
    public String viewInboundShipperIn(Model model) {
        log.info("Truy cập trang Shipper bàn giao");
        return "manager/inbound/shipper-in";
    }

    /**
     * Trang Quét nhập kho (Inbound - Scan)
     */
    @GetMapping("/inbound/scan-in")
    public String viewInboundScanIn() {
        log.info("Truy cập trang Quét nhập kho");
        return "manager/inbound/scan-in";
    }

    // ===================== OUTBOUND =====================

    /**
     * Trang Đóng Bao (Consolidate)
     */
    @GetMapping("/outbound/consolidate")
    public String viewOutboundConsolidate(Model model) {
        log.info("Truy cập trang Đóng Bao");
        model.addAttribute("hubs", managerPageService.getAllHubs());
        return "manager/outbound/consolidate";
    }

    /**
     * Trang Tạo Chuyến Xe (Trip Planning)
     */
    @GetMapping("/outbound/trip-planning")
    public String viewOutboundTripPlanning(Model model) {
        log.info("Truy cập trang Tạo Chuyến Xe");
        model.addAttribute("hubs", managerPageService.getAllHubs());
        // Lấy tất cả xe (hiển thị unavailable cho xe không available)
        model.addAttribute("vehicles", managerPageService.getAllVehicles());
        // Lấy tất cả tài xế (hiển thị inactive cho tài xế không active)
        model.addAttribute("drivers", managerPageService.getAllDrivers());
        // Lấy các chuyến đang loading để hiển thị bên phải
        model.addAttribute("trips", managerPageService.getTripsByStatus(Trip.TripStatus.loading));
        return "manager/outbound/trip-planning";
    }

    /**
     * Trang Xếp Bao vào Xe (Loading)
     */
    @GetMapping("/outbound/loading")
    public String viewOutboundLoading(Model model) {
        log.info("Truy cập trang Xếp Bao vào Xe");
        model.addAttribute("hubs", managerPageService.getAllHubs());
        // Lấy các chuyến đang loading để xếp bao
        model.addAttribute("trips", managerPageService.getTripsByStatus(Trip.TripStatus.loading));
        return "manager/outbound/loading";
    }

    /**
     * Trang Xuất Bến (Gate Out)
     */
    @GetMapping("/outbound/gate-out")
    public String viewOutboundGateOut(Model model) {
        log.info("Truy cập trang Xuất Bến");
        model.addAttribute("hubs", managerPageService.getAllHubs());
        // Lấy các chuyến đang loading
        model.addAttribute("trips", managerPageService.getTripsByStatus(Trip.TripStatus.loading));
        return "manager/outbound/gate-out";
    }

    /**
     * Trang Quản lý Chuyến Xe (Trip Management) - Xem tất cả chuyến xe kể cả đã
     * xuất bến
     */
    @GetMapping("/outbound/trip-management")
    public String viewTripManagement(Model model) {
        log.info("Truy cập trang Quản lý Chuyến Xe");
        model.addAttribute("hubs", managerPageService.getAllHubs());
        return "manager/outbound/trip-management";
    }

    // ===================== RESOURCE MANAGEMENT =====================

    /**
     * Trang Quản lý Tài xế & Xe (Resource Management)
     */
    @GetMapping("/resource/management")
    public String viewResourceManagement(Model model) {
        log.info("Truy cập trang Quản lý Tài xế & Xe");
        model.addAttribute("hubs", managerPageService.getAllHubs());
        return "manager/resource/resource-management";
    }

    /**
     * Trang Hoàn Hàng (Return Goods) - Đơn thất bại 3 lần
     */
    @GetMapping("/lastmile/return-goods")
    public String viewLastMileReturnGoods(Model model) {
        log.info("Truy cập trang Hoàn Hàng");
        return "manager/lastmile/return-goods";
    }

    /**
     * Trang Xác Nhận Trả Shop - Đơn đã hoàn về Hub gốc
     */
    @GetMapping("/lastmile/return-shop")
    public String viewLastMileReturnShop(Model model) {
        log.info("Truy cập trang Xác Nhận Trả Shop");
        return "manager/lastmile/return-shop";
    }

    // ===================== LASTMILE (PAGES) =====================

    @GetMapping("/lastmile/assign-task")
    public String viewLastMileAssignTask() {
        log.info("Truy cập trang Phân công Shipper");
        return "manager/lastmile/assign-task";
    }

    @GetMapping("/lastmile/confirm-delivery")
    public String viewLastMileConfirmDelivery() {
        log.info("Truy cập trang Cập nhật kết quả giao");
        return "manager/lastmile/confirm-delivery";
    }

    @GetMapping("/lastmile/counter-pickup")
    public String viewLastMileCounterPickup() {
        log.info("Truy cập trang Khách nhận tại quầy");
        return "manager/lastmile/counter-pickup";
    }

    // ===================== COD SETTLEMENT =====================
    /**
     * Trang Quyết Toán COD (đường dẫn /finance/cod-settlement)
     */
    @GetMapping("/finance/cod-settlement")
    public String viewFinanceCodSettlement(Model model) {
        log.info("Truy cập trang Quyết Toán COD (Finance)");
        return "manager/cod-settlement";
    }

    // ===================== IN TEM VẬN ĐƠN =====================
    /**
     * Trang In Tem Vận Đơn (Print Label) - Khổ A6 cho máy in nhiệt
     */
    @GetMapping("/inbound/print-label/{requestId}")
    public String viewPrintLabel(@PathVariable Long requestId, Model model) {
        log.info("In tem vận đơn cho requestId: {}", requestId);

        ServiceRequest order = managerPageService.getOrderById(requestId);

        // Lấy mã vận đơn
        TrackingCode trackingCode = managerPageService.getTrackingCodeByRequestId(requestId);

        model.addAttribute("order", order);
        model.addAttribute("trackingCode", trackingCode != null ? trackingCode.getCode() : "N/A");

        // Format dates và numbers cho JSP (vì fmt:formatDate không hoạt động với
        // LocalDateTime)
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        model.addAttribute("createdAtFormatted",
                order.getCreatedAt() != null ? order.getCreatedAt().format(dtf) : "N/A");

        // Format số tiền để tránh lỗi null
        model.addAttribute("codAmountFormatted",
                order.getCodAmount() != null ? String.format("%,.0f", order.getCodAmount()) : "0");
        model.addAttribute("totalPriceFormatted",
                order.getTotalPrice() != null ? String.format("%,.0f", order.getTotalPrice()) : "0");

        // Thêm chi tiết phí
        model.addAttribute("shippingFeeFormatted",
                order.getShippingFee() != null ? String.format("%,.0f", order.getShippingFee()) : "0");
        model.addAttribute("codFeeFormatted",
                order.getCodFee() != null ? String.format("%,.0f", order.getCodFee()) : "0");
        model.addAttribute("insuranceFeeFormatted",
                order.getInsuranceFee() != null ? String.format("%,.0f", order.getInsuranceFee()) : "0");
        model.addAttribute("insuranceFee", order.getInsuranceFee());
        // Kiểm tra miễn ship (shippingFee = 0 hoặc null)
        model.addAttribute("isFreeShipping",
                order.getShippingFee() == null || order.getShippingFee().compareTo(BigDecimal.ZERO) == 0);

        // Null-safe item info
        model.addAttribute("itemNameSafe", order.getItemName() != null ? order.getItemName() : "Hàng hóa");
        model.addAttribute("weightSafe", order.getWeight() != null ? order.getWeight() : BigDecimal.ONE);
        model.addAttribute("lengthSafe", order.getLength() != null ? order.getLength() : BigDecimal.ONE);
        model.addAttribute("widthSafe", order.getWidth() != null ? order.getWidth() : BigDecimal.ONE);
        model.addAttribute("heightSafe", order.getHeight() != null ? order.getHeight() : BigDecimal.ONE);

        // Check COD > 0
        model.addAttribute("hasCod",
                order.getCodAmount() != null && order.getCodAmount().compareTo(BigDecimal.ZERO) > 0);

        return "manager/inbound/print-label";
    }

    // ===================== QUẢN LÝ SHIPPER =====================
    /**
     * Trang Quản Lý Shipper
     */
    @GetMapping("/shippers")
    public String viewShipperManagement(Model model) {
        log.info("Truy cập trang Quản Lý Shipper");
        return "manager/shipper-management";
    }

    /**
     * Trang Quản Lý Tài Xế
     */
    @GetMapping("/drivers")
    public String viewDriverManagement(Model model) {
        log.info("Truy cập trang Quản Lý Tài Xế");
        return "manager/driver-management";
    }

    /**
     * Trang Quản Lý Phương Tiện
     */
    @GetMapping("/vehicles")
    public String viewVehicleManagement(Model model) {
        log.info("Truy cập trang Quản Lý Phương Tiện");
        return "manager/vehicle-management";
    }
}
