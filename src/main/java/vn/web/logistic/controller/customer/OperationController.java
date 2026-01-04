package vn.web.logistic.controller.customer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.entity.*;
import vn.web.logistic.enums.RequestStatus;
import vn.web.logistic.repository.*;
import java.security.Principal;
import java.util.*;

@Controller
@RequestMapping("/customer")
public class OperationController {

	@Autowired
	private ServiceRequestRepository serviceRequestRepository;
	@Autowired
	private UserRepository userRepository;
	@Autowired
	private CustomerRepository customerRepository;
	@Autowired
	private TrackingCodeRepository trackingCodeRepository;

	@GetMapping("/operation")
	public String showOperation(@RequestParam(name = "tab", defaultValue = "all") String tab, Model model,
			Principal principal) {
		// 1. Lấy thông tin Customer
		String username = principal.getName();
		User user = userRepository.findByUsername(username).orElseThrow();
		Customer customer = customerRepository.findByUser(user).orElseThrow();

		List<ServiceRequest> orders;
		// Sử dụng trực tiếp Enum RequestStatus để truyền vào Repository
		switch (tab) {
		case "pending":
			// Truyền RequestStatus.pending thay vì "pending"
			orders = serviceRequestRepository.findByCustomerAndStatusOrderByCreatedAtDesc(customer,
					RequestStatus.pending);
			break;

		case "delivering":
			// Truyền danh sách Enum thay vì danh sách String
			orders = serviceRequestRepository.findByCustomerAndStatusInOrderByCreatedAtDesc(customer,
					Arrays.asList(RequestStatus.picked, RequestStatus.in_transit));
			break;

		case "delivered":
			// Truyền RequestStatus.delivered thay vì "delivered"
			orders = serviceRequestRepository.findByCustomerAndStatusOrderByCreatedAtDesc(customer,
					RequestStatus.delivered);
			break;

		case "failed":
			// Truyền RequestStatus.failed thay vì "failed"
			orders = serviceRequestRepository.findByCustomerAndStatusOrderByCreatedAtDesc(customer,
					RequestStatus.failed);
			break;

		default:
			orders = serviceRequestRepository.findByCustomerOrderByCreatedAtDesc(customer);
			break;
		}

		model.addAttribute("orders", orders);
		model.addAttribute("activeTab", tab);
		model.addAttribute("currentPage", "operation");
		model.addAttribute("username", user.getUsername());
		model.addAttribute("businessName", customer.getBusinessName());
		model.addAttribute("email", user.getEmail());
		model.addAttribute("currentPage", "operation");
		return "customer/operation";
	}

	// API lấy lộ trình để hiển thị Timeline (Dùng AJAX)
	@GetMapping("/api/tracking/{id}")
	@ResponseBody
	public List<TrackingCode> getTrackingHistory(@PathVariable("id") Long requestId) {
		return trackingCodeRepository.findByRequest_RequestIdOrderByCreatedAtAsc(requestId);
	}
}