package vn.web.logistic.controller.manager;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.entity.Trip;
import vn.web.logistic.repository.DriverRepository;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.ServiceTypeRepository;
import vn.web.logistic.repository.TripRepository;
import vn.web.logistic.repository.VehicleRepository;

/**
 * Controller để render các trang JSP cho Manager
 */
@Slf4j
@Controller
@RequestMapping("/manager")
@RequiredArgsConstructor
public class ManagerPageController {

    private final HubRepository hubRepository;
    private final ServiceTypeRepository serviceTypeRepository;
    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;
    private final TripRepository tripRepository;

    @GetMapping("/dashboard")
    public String viewDashboard() {
        return "manager/dashboard";
    }

    @GetMapping("/tracking")
    public String viewTracking() {
        return "manager/tracking";
    }

    // ===================== INBOUND =====================

    /**
     * Trang Quét Nhập Kho (Scan In)
     */
    @GetMapping("/inbound/scan-in")
    public String viewInboundScanIn(Model model) {
        log.info("Truy cập trang Quét Nhập Kho");
        model.addAttribute("hubs", hubRepository.findAll());
        return "manager/inbound/scan-in";
    }

    /**
     * Trang Tạo Đơn Tại Quầy (Drop-off)
     */
    @GetMapping("/inbound/drop-off")
    public String viewInboundDropOff(Model model) {
        log.info("Truy cập trang Tạo Đơn Tại Quầy");
        model.addAttribute("hubs", hubRepository.findAll());
        model.addAttribute("serviceTypes", serviceTypeRepository.findAllByIsActiveTrue());
        return "manager/inbound/drop-off";
    }

    // ===================== OUTBOUND =====================

    /**
     * Trang Đóng Bao (Consolidate)
     */
    @GetMapping("/outbound/consolidate")
    public String viewOutboundConsolidate(Model model) {
        log.info("Truy cập trang Đóng Bao");
        model.addAttribute("hubs", hubRepository.findAll());
        return "manager/outbound/consolidate";
    }

    /**
     * Trang Tạo Chuyến Xe (Trip Planning)
     */
    @GetMapping("/outbound/trip-planning")
    public String viewOutboundTripPlanning(Model model) {
        log.info("Truy cập trang Tạo Chuyến Xe");
        model.addAttribute("hubs", hubRepository.findAll());
        // Lấy tất cả xe (hiển thị unavailable cho xe không available)
        model.addAttribute("vehicles", vehicleRepository.findAll());
        // Lấy tất cả tài xế (hiển thị inactive cho tài xế không active)
        model.addAttribute("drivers", driverRepository.findAll());
        // Lấy các chuyến đang loading để hiển thị bên phải
        model.addAttribute("trips", tripRepository.findAllWithFilters(
                null, null, Trip.TripStatus.loading, null, null,
                org.springframework.data.domain.Pageable.unpaged()).getContent());
        return "manager/outbound/trip-planning";
    }

    /**
     * Trang Xuất Bến (Gate Out)
     */
    @GetMapping("/outbound/gate-out")
    public String viewOutboundGateOut(Model model) {
        log.info("Truy cập trang Xuất Bến");
        // Lấy các chuyến đang loading
        model.addAttribute("trips", tripRepository.findAllWithFilters(
                null, null, Trip.TripStatus.loading, null, null,
                org.springframework.data.domain.Pageable.unpaged()).getContent());
        return "manager/outbound/gate-out";
    }

    // ===================== LAST MILE (GIAO HÀNG) =====================

    /**
     * Trang Phân công Shipper (Assign Task)
     */
    @GetMapping("/lastmile/assign-task")
    public String viewLastMileAssignTask(Model model) {
        log.info("Truy cập trang Phân công Shipper");
        return "manager/lastmile/assign-task";
    }

    /**
     * Trang Xác nhận Giao Xong / Hẹn Lại (Confirm Delivery)
     */
    @GetMapping("/lastmile/confirm-delivery")
    public String viewLastMileConfirmDelivery(Model model) {
        log.info("Truy cập trang Xác nhận Giao Xong");
        return "manager/lastmile/confirm-delivery";
    }

    /**
     * Trang Khách Nhận Tại Quầy (Counter Pickup)
     */
    @GetMapping("/lastmile/counter-pickup")
    public String viewLastMileCounterPickup(Model model) {
        log.info("Truy cập trang Khách Nhận Tại Quầy");
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
}
