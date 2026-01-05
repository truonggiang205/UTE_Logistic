package vn.web.logistic.controller;

import java.math.BigDecimal;
import java.security.Principal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.ChangePasswordRequest;
import vn.web.logistic.dto.response.ShipperDashboardDTO;
import vn.web.logistic.service.ShipperDashboardService;

/**
 * Controller cho các trang web của Shipper
 */
@Slf4j
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

    @GetMapping("/orders/{taskId}")
    public String orderDetail(@PathVariable Long taskId, Model model, Principal principal) {
        model.addAttribute("currentPage", "orders");

        if (principal != null) {
            var orderDetail = shipperDashboardService.getOrderDetail(taskId, principal.getName());
            if (orderDetail == null) {
                return "redirect:/shipper/orders";
            }
            model.addAttribute("order", orderDetail);
        }

        return "shipper/order-detail";
    }

    @GetMapping("/orders")
    public String orders(
            @RequestParam(required = false, defaultValue = "all") String taskType,
            @RequestParam(required = false, defaultValue = "all") String status,
            @RequestParam(required = false, defaultValue = "") String search,
            @RequestParam(required = false, defaultValue = "0") int page,
            Model model,
            Principal principal) {

        final int PAGE_SIZE = 6; // 6 đơn/trang

        model.addAttribute("currentPage", "orders");
        model.addAttribute("selectedTaskType", taskType);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("search", search);

        if (principal != null) {
            // Lấy tất cả đơn theo bộ lọc
            var allFilteredOrders = shipperDashboardService.getAllOrdersByShipper(
                    principal.getName(), taskType, status);

            // Tìm kiếm theo mã đơn hoặc số điện thoại
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.trim().toLowerCase();
                allFilteredOrders = allFilteredOrders.stream()
                        .filter(o -> (o.getTrackingNumber() != null
                                && o.getTrackingNumber().toLowerCase().contains(searchLower)) ||
                                (o.getContactPhone() != null && o.getContactPhone().contains(searchLower)) ||
                                (o.getContactName() != null && o.getContactName().toLowerCase().contains(searchLower)))
                        .collect(Collectors.toList());
            }

            // Tính toán phân trang
            int totalOrders = allFilteredOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);
            if (page < 0)
                page = 0;
            if (page >= totalPages && totalPages > 0)
                page = totalPages - 1;

            int fromIndex = page * PAGE_SIZE;
            int toIndex = Math.min(fromIndex + PAGE_SIZE, totalOrders);

            var ordersPage = totalOrders > 0
                    ? allFilteredOrders.subList(fromIndex, toIndex)
                    : java.util.List.of();

            model.addAttribute("orders", ordersPage);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("pageNumber", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", PAGE_SIZE);

            // Statistics (dùng tất cả đơn, không filter)
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
            BigDecimal totalCod = deliveryTasks.stream()
                    .map(t -> t.getCodAmount())
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            model.addAttribute("totalCodInProgress", totalCod);
        }

        return "shipper/delivering";
    }

    @GetMapping("/history")
    public String history(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate,
            @RequestParam(required = false, defaultValue = "") String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "6") int size,
            Model model,
            Principal principal) {

        model.addAttribute("currentPage", "history");

        if (principal != null) {
            // Phân trang
            Pageable pageable = PageRequest.of(page,
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
    public String cod(
            @RequestParam(defaultValue = "0") int page,
            Model model, Principal principal) {
        model.addAttribute("currentPage", "cod");

        final int HISTORY_PAGE_SIZE = 6; // 6 items/trang cho lịch sử

        if (principal != null) {
            log.info("=== DEBUG COD PAGE cho user: {} ===", principal.getName());

            // Lấy danh sách COD chưa nộp
            var unpaidOrders = shipperDashboardService.getUnpaidCodOrders(principal.getName());
            log.info("Số lượng COD chưa nộp (pending): {}", unpaidOrders.size());
            model.addAttribute("unpaidOrders", unpaidOrders);
            model.addAttribute("unpaidOrdersCount", unpaidOrders.size());

            // Tổng COD chưa nộp
            var totalUnpaidCod = shipperDashboardService.getTotalUnpaidCod(principal.getName());
            model.addAttribute("totalUnpaidCod", totalUnpaidCod);

            // Lịch sử nộp COD với phân trang
            Pageable pageable = PageRequest.of(page, HISTORY_PAGE_SIZE);
            var codHistoryPage = shipperDashboardService.getCodHistoryPaged(principal.getName(), pageable);
            model.addAttribute("codHistory", codHistoryPage.getContent());
            model.addAttribute("historyPage", page);
            model.addAttribute("historyTotalPages", codHistoryPage.getTotalPages());
            model.addAttribute("historyTotalElements", codHistoryPage.getTotalElements());

            // Tổng đã nộp hôm nay (tạm thời = 0, có thể tính sau)
            model.addAttribute("todayPaidCod", 0);
        } else {
            model.addAttribute("totalUnpaidCod", 0);
            model.addAttribute("todayPaidCod", 0);
            model.addAttribute("unpaidOrdersCount", 0);
            model.addAttribute("codHistory", java.util.List.of());
            model.addAttribute("historyPage", 0);
            model.addAttribute("historyTotalPages", 0);
            model.addAttribute("historyTotalElements", 0);
        }

        return "shipper/cod";
    }

    @PostMapping("/cod/submit")
    public String submitCod(
            @RequestParam String orderIds,
            @RequestParam String paymentMethod,
            @RequestParam(required = false) String note,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        try {
            if (principal == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập lại");
                return "redirect:/shipper/cod";
            }

            // Parse orderIds
            List<Long> codTxIds = Arrays.stream(orderIds.split(","))
                    .filter(s -> !s.isEmpty())
                    .map(Long::parseLong)
                    .collect(Collectors.toList());

            if (codTxIds.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng chọn ít nhất một đơn hàng");
                return "redirect:/shipper/cod";
            }

            shipperDashboardService.submitCod(principal.getName(), codTxIds, paymentMethod, note);
            redirectAttributes.addFlashAttribute("success",
                    "Đã nộp thành công " + codTxIds.size() + " đơn COD!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        return "redirect:/shipper/cod";
    }

    @GetMapping("/earnings")
    public String earnings(Model model, Principal principal) {
        model.addAttribute("currentPage", "earnings");

        if (principal != null) {
            var earnings = shipperDashboardService.getEarningsData(principal.getName());
            model.addAttribute("earnings", earnings);
        }

        return "shipper/earnings";
    }

    @GetMapping("/profile")
    public String profile(Model model, Principal principal) {
        model.addAttribute("currentPage", "profile");

        if (principal != null) {
            var profile = shipperDashboardService.getProfile(principal.getName());
            model.addAttribute("profile", profile);
        }

        return "shipper/profile";
    }

    @GetMapping("/notifications")
    public String notifications(Model model) {
        model.addAttribute("currentPage", "notifications");
        return "shipper/notifications";
    }

    // Change password
    @PostMapping("/change-password")
    @ResponseBody
    public ResponseEntity<?> changePassword(
            @RequestBody ChangePasswordRequest request,
            Principal principal) {

        try {
            if (principal == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("success", false, "message", "Vui lòng đăng nhập lại"));
            }

            shipperDashboardService.changePassword(principal.getName(), request);
            return ResponseEntity.ok()
                    .body(Map.of("success", true, "message", "Đổi mật khẩu thành công!"));

        } catch (Exception e) {
            log.error("Lỗi đổi mật khẩu: {}", e.getMessage());
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // Update avatar
    @PostMapping("/update-avatar")
    @ResponseBody
    public ResponseEntity<?> updateAvatar(
            @RequestParam("avatar") MultipartFile avatarFile,
            Principal principal) {

        try {
            if (principal == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("success", false, "message", "Vui lòng đăng nhập lại"));
            }

            String avatarUrl = shipperDashboardService.updateAvatar(principal.getName(), avatarFile);
            return ResponseEntity.ok()
                    .body(Map.of(
                            "success", true,
                            "message", "Cập nhật ảnh đại diện thành công!",
                            "avatarUrl", avatarUrl));

        } catch (Exception e) {
            log.error("Lỗi cập nhật ảnh đại diện: {}", e.getMessage());
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // Tự động load profile cho tất cả các trang (hiện avatar trên topbar)
    @ModelAttribute
    public void addProfileToModel(Model model, Principal principal) {
        if (principal != null) {
            try {
                var profile = shipperDashboardService.getProfile(principal.getName());
                model.addAttribute("profile", profile);
            } catch (Exception e) {
                log.debug("Không thể load profile cho topbar: {}", e.getMessage());
            }
        }
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
