package vn.web.logistic.controller.customer;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.service.customer.OperationService;

@Controller
@RequestMapping("/customer")
public class OperationController {

    @Autowired
    private OperationService operationService;

    /**
     * Hiển thị trang Operation với danh sách đơn hàng theo tab filter
     */
    @GetMapping("/operation")
    public String showOperation(
            @RequestParam(name = "tab", defaultValue = "all") String tab,
            Model model,
            Principal principal) {

        // 1. Lấy thông tin Customer từ service
        Customer customer = operationService.getLoggedInCustomer(principal);

        // 2. Lấy danh sách đơn hàng theo tab từ service
        List<ServiceRequest> orders = operationService.getOrdersByTab(customer, tab);

        // 3. Truyền dữ liệu sang view
        model.addAttribute("orders", orders);
        model.addAttribute("activeTab", tab);
        model.addAttribute("currentPage", "operation");
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("email", customer.getUser().getEmail());

        return "customer/operation";
    }

    /**
     * API lấy lộ trình để hiển thị Timeline (Dùng AJAX)
     */
    @GetMapping("/api/tracking/{id}")
    @ResponseBody
    public List<TrackingCode> getTrackingHistory(@PathVariable("id") Long requestId) {
        return operationService.getTrackingHistory(requestId);
    }
}