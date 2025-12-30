package vn.web.logistic.controller;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.Date;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import vn.web.logistic.dto.response.ShipperDashboardDTO;
import vn.web.logistic.service.ShipperDashboardService;

/**
 * Controller cho các trang web của Shipper
 */
@Controller
@RequestMapping("/shipper")
public class ShipperViewController {

    @Autowired
    private ShipperDashboardService shipperDashboardService;

    @GetMapping("/dashboard")
    public String dashboard(Model model, Principal principal) {
        model.addAttribute("currentPage", "dashboard");
        model.addAttribute("today", new Date());

        if (principal != null) {
            ShipperDashboardDTO dashboardData = shipperDashboardService.getDashboardData(principal.getName());

            // Statistics Cards (Tổng hợp)
            model.addAttribute("todayOrdersCount", dashboardData.getTodayOrdersCount());
            model.addAttribute("deliveringCount", dashboardData.getDeliveringCount());
            model.addAttribute("completedCount", dashboardData.getCompletedCount());
            model.addAttribute("totalCodAmount", dashboardData.getTotalCodAmount());

            // Statistics theo loại Task (Pickup)
            model.addAttribute("todayPickupCount", dashboardData.getTodayPickupCount());
            model.addAttribute("pickupInProgressCount", dashboardData.getPickupInProgressCount());
            model.addAttribute("pickupCompletedCount", dashboardData.getPickupCompletedCount());

            // Statistics theo loại Task (Delivery)
            model.addAttribute("todayDeliveryCount", dashboardData.getTodayDeliveryCount());
            model.addAttribute("deliveryInProgressCount", dashboardData.getDeliveryInProgressCount());
            model.addAttribute("deliveryCompletedCount", dashboardData.getDeliveryCompletedCount());

            // Shipper Info
            model.addAttribute("shipperRating", dashboardData.getShipperRating());
            model.addAttribute("totalRatings", dashboardData.getTotalRatings());

            // Monthly Stats
            model.addAttribute("monthlyEarnings", dashboardData.getMonthlyEarnings());
            model.addAttribute("monthlyOrders", dashboardData.getMonthlyOrders());
            model.addAttribute("successRate", dashboardData.getSuccessRate());

            // Today's Orders (theo loại)
            model.addAttribute("todayPickupOrders", dashboardData.getTodayPickupOrders());
            model.addAttribute("todayDeliveryOrders", dashboardData.getTodayDeliveryOrders());
            model.addAttribute("todayOrders", dashboardData.getTodayOrders());
        } else {
            addEmptyDashboardData(model);
        }

        return "shipper/dashboard";
    }

    @PostMapping("/pickup/{taskId}/update")
    public String updatePickupStatus(
            @PathVariable Long taskId,
            @RequestParam String status,
            @RequestParam(required = false) String note,
            @RequestParam(required = false, defaultValue = "orders") String from,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        try {
            // Gọi Service để xử lý business logic
            shipperDashboardService.updatePickupStatus(taskId, status, note, principal.getName());
            redirectAttributes.addFlashAttribute("success", "Cập nhật trạng thái thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        return "redirect:/shipper/" + from;
    }

    @PostMapping("/delivery/{taskId}/update")
    public String updateDeliveryStatus(
            @PathVariable Long taskId,
            @RequestParam String status,
            @RequestParam(required = false) String note,
            @RequestParam(required = false, defaultValue = "orders") String from,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        try {
            // Gọi Service để xử lý business logic
            shipperDashboardService.updateDeliveryStatus(taskId, status, note, principal.getName());
            redirectAttributes.addFlashAttribute("success", "Cập nhật trạng thái giao hàng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        return "redirect:/shipper/" + from;
    }

    @GetMapping("/orders")
    public String orders(
            @RequestParam(required = false, defaultValue = "all") String taskType,
            @RequestParam(required = false, defaultValue = "all") String status,
            Model model,
            Principal principal) {

        model.addAttribute("currentPage", "orders");
        model.addAttribute("selectedTaskType", taskType);
        model.addAttribute("selectedStatus", status);

        if (principal != null) {
            var orders = shipperDashboardService.getAllOrdersByShipper(
                    principal.getName(), taskType, status);
            model.addAttribute("orders", orders);
            model.addAttribute("totalOrders", orders.size());

            // Statistics
            var allOrders = shipperDashboardService.getAllOrdersByShipper(
                    principal.getName(), "all", "all");
            long pickupCount = allOrders.stream()
                    .filter(o -> "pickup".equals(o.getTaskType())).count();
            long deliveryCount = allOrders.stream()
                    .filter(o -> "delivery".equals(o.getTaskType())).count();
            long assignedCount = allOrders.stream()
                    .filter(o -> "assigned".equals(o.getStatus())).count();
            long inProgressCount = allOrders.stream()
                    .filter(o -> "in_progress".equals(o.getStatus())).count();
            long completedCount = allOrders.stream()
                    .filter(o -> "completed".equals(o.getStatus())).count();
            long failedCount = allOrders.stream()
                    .filter(o -> "failed".equals(o.getStatus())).count();

            model.addAttribute("allOrdersCount", allOrders.size());
            model.addAttribute("pickupCount", pickupCount);
            model.addAttribute("deliveryCount", deliveryCount);
            model.addAttribute("assignedCount", assignedCount);
            model.addAttribute("inProgressCount", inProgressCount);
            model.addAttribute("completedCount", completedCount);
            model.addAttribute("failedCount", failedCount);
        }

        return "shipper/orders";
    }

    @GetMapping("/delivering")
    public String delivering(Model model, Principal principal) {
        model.addAttribute("currentPage", "delivering");

        if (principal != null) {
            // Lấy các đơn đang xử lý (in_progress)
            var inProgressTasks = shipperDashboardService.getInProgressTasks(principal.getName());
            model.addAttribute("inProgressTasks", inProgressTasks);
            model.addAttribute("totalInProgress", inProgressTasks.size());

            // Phân loại theo pickup và delivery
            var pickupTasks = inProgressTasks.stream()
                    .filter(t -> "pickup".equals(t.getTaskType()))
                    .collect(Collectors.toList());
            var deliveryTasks = inProgressTasks.stream()
                    .filter(t -> "delivery".equals(t.getTaskType()))
                    .collect(Collectors.toList());

            model.addAttribute("pickupTasks", pickupTasks);
            model.addAttribute("deliveryTasks", deliveryTasks);
            model.addAttribute("pickupCount", pickupTasks.size());
            model.addAttribute("deliveryCount", deliveryTasks.size());

            // Tính tổng COD cần thu (chỉ từ delivery, không tính pickup)
            java.math.BigDecimal totalCod = deliveryTasks.stream()
                    .map(t -> t.getCodAmount())
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            model.addAttribute("totalCodInProgress", totalCod);
        }

        return "shipper/delivering";
    }

    @GetMapping("/history")
    public String history(
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate fromDate,
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate toDate,
            @RequestParam(required = false, defaultValue = "") String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model,
            Principal principal) {

        model.addAttribute("currentPage", "history");

        if (principal != null) {
            // Phân trang
            org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page,
                    size);

            // Lấy dữ liệu lịch sử
            var historyPage = shipperDashboardService.getOrderHistory(
                    principal.getName(), fromDate, toDate, status, pageable);

            model.addAttribute("orders", historyPage.getContent());
            model.addAttribute("totalPages", historyPage.getTotalPages());
            model.addAttribute("totalElements", historyPage.getTotalElements());
            model.addAttribute("currentPageNum", page);

            // Thống kê
            long deliveredCount = historyPage.getContent().stream()
                    .filter(o -> "completed".equals(o.getStatus())).count();
            long failedCount = historyPage.getContent().stream()
                    .filter(o -> "failed".equals(o.getStatus())).count();

            model.addAttribute("deliveredCount", deliveredCount);
            model.addAttribute("failedCount", failedCount);
            model.addAttribute("returnedCount", 0); // Chưa có logic hoàn hàng
        }

        // Giữ lại filter values
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("status", status);

        return "shipper/history";
    }

    @GetMapping("/cod")
    public String cod(Model model, Principal principal) {
        model.addAttribute("currentPage", "cod");

        if (principal != null) {
            ShipperDashboardDTO dashboardData = shipperDashboardService.getDashboardData(principal.getName());
            model.addAttribute("totalUnpaidCod", dashboardData.getTotalCodAmount());
            model.addAttribute("todayPaidCod", 0);
            model.addAttribute("unpaidOrdersCount", 0);
        } else {
            model.addAttribute("totalUnpaidCod", 0);
            model.addAttribute("todayPaidCod", 0);
            model.addAttribute("unpaidOrdersCount", 0);
        }

        return "shipper/cod";
    }

    @GetMapping("/earnings")
    public String earnings(Model model, Principal principal) {
        model.addAttribute("currentPage", "earnings");

        if (principal != null) {
            ShipperDashboardDTO dashboardData = shipperDashboardService.getDashboardData(principal.getName());
            model.addAttribute("monthlyEarnings", dashboardData.getMonthlyEarnings());
            model.addAttribute("monthlyOrders", dashboardData.getMonthlyOrders());
            model.addAttribute("successRate", dashboardData.getSuccessRate());
            if (dashboardData.getMonthlyOrders() > 0) {
                model.addAttribute("averagePerOrder",
                        dashboardData.getMonthlyEarnings().divide(
                                java.math.BigDecimal.valueOf(dashboardData.getMonthlyOrders()),
                                0, java.math.RoundingMode.HALF_UP));
            } else {
                model.addAttribute("averagePerOrder", 0);
            }
            model.addAttribute("bonusAmount", 0);
        } else {
            model.addAttribute("monthlyEarnings", 0);
            model.addAttribute("monthlyOrders", 0);
            model.addAttribute("averagePerOrder", 0);
            model.addAttribute("bonusAmount", 0);
            model.addAttribute("successRate", 0);
        }

        return "shipper/earnings";
    }

    @GetMapping("/profile")
    public String profile(Model model, Principal principal) {
        model.addAttribute("currentPage", "profile");
        return "shipper/profile";
    }

    @GetMapping("/vehicle")
    public String vehicle(Model model) {
        model.addAttribute("currentPage", "vehicle");
        return "shipper/profile";
    }

    // Helper method để set empty data
    private void addEmptyDashboardData(Model model) {
        model.addAttribute("todayOrdersCount", 0);
        model.addAttribute("deliveringCount", 0);
        model.addAttribute("completedCount", 0);
        model.addAttribute("totalCodAmount", 0);
        model.addAttribute("todayPickupCount", 0);
        model.addAttribute("pickupInProgressCount", 0);
        model.addAttribute("pickupCompletedCount", 0);
        model.addAttribute("todayDeliveryCount", 0);
        model.addAttribute("deliveryInProgressCount", 0);
        model.addAttribute("deliveryCompletedCount", 0);
        model.addAttribute("shipperRating", 0);
        model.addAttribute("totalRatings", 0);
        model.addAttribute("monthlyEarnings", 0);
        model.addAttribute("monthlyOrders", 0);
        model.addAttribute("successRate", 0);
    }
}
