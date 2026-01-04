package vn.web.logistic.controller.customer;

import java.util.EnumMap;
import java.util.Map;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.customer.CustomerAddressForm;
import vn.web.logistic.dto.request.customer.CustomerPickupOrderForm;
import vn.web.logistic.dto.request.customer.CustomerProfileForm;
import vn.web.logistic.dto.response.customer.CustomerParcelActionView;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.repository.ParcelActionRepository;
import vn.web.logistic.repository.ServiceTypeRepository;
import vn.web.logistic.repository.TrackingCodeRepository;
import vn.web.logistic.service.customer.CustomerOrderService;
import vn.web.logistic.service.customer.CustomerPortalService;

@Controller
@RequestMapping("/customer")
@RequiredArgsConstructor
public class CustomerPageController {

    private static final DateTimeFormatter UI_DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private final CustomerPortalService customerPortalService;
    private final CustomerOrderService customerOrderService;
    private final ServiceTypeRepository serviceTypeRepository;
    private final TrackingCodeRepository trackingCodeRepository;
    private final ParcelActionRepository parcelActionRepository;

    @GetMapping({ "", "/dashboard" })
    public String dashboard(Model model) {
        var customer = customerPortalService.getOrCreateCurrentCustomer();
        var orders = customerOrderService.getMyOrders();

        Map<ServiceRequest.RequestStatus, Long> counts = new EnumMap<>(ServiceRequest.RequestStatus.class);
        for (ServiceRequest.RequestStatus st : ServiceRequest.RequestStatus.values()) {
            counts.put(st, orders.stream().filter(o -> o.getStatus() == st).count());
        }

        model.addAttribute("customer", customer);
        model.addAttribute("orders", orders.stream().limit(5).toList());
        model.addAttribute("totalOrders", orders.size());
        model.addAttribute("pendingCount", counts.get(ServiceRequest.RequestStatus.pending));
        model.addAttribute("inTransitCount", counts.get(ServiceRequest.RequestStatus.in_transit));
        model.addAttribute("deliveredCount", counts.get(ServiceRequest.RequestStatus.delivered));
        return "customer/dashboard";
    }

    @GetMapping("/orders")
    public String orders(Model model) {
        model.addAttribute("orders", customerOrderService.getMyOrders());
        return "customer/orders";
    }

    @GetMapping("/orders/new")
    public String newOrder(Model model) {
        model.addAttribute("form", new CustomerPickupOrderForm());
        model.addAttribute("serviceTypes", serviceTypeRepository.findAllByIsActiveTrue());
        return "customer/new-order";
    }

    @PostMapping("/orders")
    public String createOrder(@Valid @ModelAttribute("form") CustomerPickupOrderForm form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("serviceTypes", serviceTypeRepository.findAllByIsActiveTrue());
            return "customer/new-order";
        }

        try {
            ServiceRequest created = customerOrderService.createPickupOrder(form);
            redirectAttributes.addFlashAttribute("success", "Tạo đơn thành công! Mã đơn: " + created.getRequestId());
            return "redirect:/customer/orders/" + created.getRequestId();
        } catch (Exception ex) {
            model.addAttribute("serviceTypes", serviceTypeRepository.findAllByIsActiveTrue());
            model.addAttribute("error", ex.getMessage());
            return "customer/new-order";
        }
    }

    @GetMapping("/orders/{id}")
    public String orderDetail(@PathVariable("id") Long requestId, Model model) {
        ServiceRequest sr = customerOrderService.getMyOrderOrThrow(requestId);
        model.addAttribute("order", sr);
        model.addAttribute("tracking", trackingCodeRepository.findByRequestId(requestId).orElse(null));

        if (sr.getCreatedAt() != null) {
            model.addAttribute("createdAtText", sr.getCreatedAt().format(UI_DATE_TIME));
        }

        var actions = parcelActionRepository.findByRequestIdWithDetails(requestId);
        var actionViews = actions.stream().map(a -> CustomerParcelActionView.builder()
                .actionName(a.getActionType() != null ? a.getActionType().getActionName() : null)
                .fromHubName(a.getFromHub() != null ? a.getFromHub().getHubName() : null)
                .toHubName(a.getToHub() != null ? a.getToHub().getHubName() : null)
                .actorName(a.getActor() != null ? a.getActor().getFullName() : null)
                .note(a.getNote())
                .timeText(a.getActionTime() != null ? a.getActionTime().format(UI_DATE_TIME) : null)
                .build()).toList();
        model.addAttribute("actionViews", actionViews);
        return "customer/order-detail";
    }

    @PostMapping("/orders/{id}/cancel")
    public String cancelOrder(@PathVariable("id") Long requestId, RedirectAttributes redirectAttributes) {
        try {
            customerOrderService.cancelMyOrder(requestId);
            redirectAttributes.addFlashAttribute("success", "Đã hủy đơn hàng #" + requestId);
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/customer/orders/" + requestId;
    }

    @GetMapping("/tracking")
    public String trackingPage() {
        return "customer/tracking";
    }

    @PostMapping("/tracking")
    public String trackingLookup(String code, RedirectAttributes redirectAttributes) {
        if (code == null || code.isBlank()) {
            redirectAttributes.addFlashAttribute("error", "Vui lòng nhập mã vận đơn");
            return "redirect:/customer/tracking";
        }

        return trackingCodeRepository.findByCode(code.trim())
                .map(tc -> "redirect:/customer/orders/" + tc.getRequest().getRequestId())
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("error", "Không tìm thấy mã vận đơn: " + code);
                    return "redirect:/customer/tracking";
                });
    }

    @GetMapping("/addresses")
    public String addresses(Model model) {
        model.addAttribute("addresses", customerPortalService.getCurrentCustomerAddresses());
        model.addAttribute("form", new CustomerAddressForm());
        return "customer/addresses";
    }

    @PostMapping("/addresses")
    public String addAddress(@Valid @ModelAttribute("form") CustomerAddressForm form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("addresses", customerPortalService.getCurrentCustomerAddresses());
            return "customer/addresses";
        }

        try {
            customerPortalService.addAddress(form);
            redirectAttributes.addFlashAttribute("success", "Đã thêm địa chỉ");
            return "redirect:/customer/addresses";
        } catch (Exception ex) {
            model.addAttribute("addresses", customerPortalService.getCurrentCustomerAddresses());
            model.addAttribute("error", ex.getMessage());
            return "customer/addresses";
        }
    }

    @PostMapping("/addresses/{id}/default")
    public String setDefault(@PathVariable("id") Long addressId, RedirectAttributes redirectAttributes) {
        customerPortalService.setDefaultAddress(addressId);
        redirectAttributes.addFlashAttribute("success", "Đã đặt làm mặc định");
        return "redirect:/customer/addresses";
    }

    @PostMapping("/addresses/{id}/delete")
    public String deleteAddress(@PathVariable("id") Long addressId, RedirectAttributes redirectAttributes) {
        customerPortalService.deleteAddress(addressId);
        redirectAttributes.addFlashAttribute("success", "Đã xóa địa chỉ");
        return "redirect:/customer/addresses";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        var customer = customerPortalService.getOrCreateCurrentCustomer();
        CustomerProfileForm form = new CustomerProfileForm();
        form.setFullName(customer.getFullName());
        form.setPhone(customer.getPhone());
        form.setEmail(customer.getEmail());
        model.addAttribute("form", form);
        return "customer/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@Valid @ModelAttribute("form") CustomerProfileForm form,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (bindingResult.hasErrors()) {
            return "customer/profile";
        }

        try {
            customerPortalService.updateProfile(form);
            redirectAttributes.addFlashAttribute("success", "Cập nhật hồ sơ thành công");
            return "redirect:/customer/profile";
        } catch (Exception ex) {
            model.addAttribute("error", ex.getMessage());
            return "customer/profile";
        }
    }
}
