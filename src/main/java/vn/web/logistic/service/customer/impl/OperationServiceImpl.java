package vn.web.logistic.service.customer.impl;

import java.security.Principal;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.TrackingCodeRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.customer.OperationService;

/**
 * Operation Service Implementation
 * Xử lý logic nghiệp vụ cho trang Operation của Customer
 */
@Service
@RequiredArgsConstructor
public class OperationServiceImpl implements OperationService {

    private final ServiceRequestRepository serviceRequestRepository;
    private final UserRepository userRepository;
    private final CustomerRepository customerRepository;
    private final TrackingCodeRepository trackingCodeRepository;

    // ==================== CUSTOMER CONTEXT ====================

    @Override
    public Customer getLoggedInCustomer(Principal principal) {
        String username = principal.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found: " + username));
        return customerRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Customer not found for user: " + username));
    }

    // ==================== ORDER OPERATIONS ====================

    @Override
    public List<ServiceRequest> getAllOrders(Customer customer) {
        return serviceRequestRepository.findByCustomerOrderByCreatedAtDesc(customer);
    }

    @Override
    public List<ServiceRequest> getPendingOrders(Customer customer) {
        return serviceRequestRepository.findByCustomerAndStatusOrderByCreatedAtDesc(
                customer, RequestStatus.pending);
    }

    @Override
    public List<ServiceRequest> getDeliveringOrders(Customer customer) {
        return serviceRequestRepository.findByCustomerAndStatusInOrderByCreatedAtDesc(
                customer, Arrays.asList(RequestStatus.picked, RequestStatus.in_transit));
    }

    @Override
    public List<ServiceRequest> getDeliveredOrders(Customer customer) {
        return serviceRequestRepository.findByCustomerAndStatusOrderByCreatedAtDesc(
                customer, RequestStatus.delivered);
    }

    @Override
    public List<ServiceRequest> getFailedOrders(Customer customer) {
        return serviceRequestRepository.findByCustomerAndStatusOrderByCreatedAtDesc(
                customer, RequestStatus.failed);
    }

    @Override
    public List<ServiceRequest> getOrdersByTab(Customer customer, String tab) {
        switch (tab) {
            case "pending":
                return getPendingOrders(customer);
            case "delivering":
                return getDeliveringOrders(customer);
            case "delivered":
                return getDeliveredOrders(customer);
            case "failed":
                return getFailedOrders(customer);
            default:
                return getAllOrders(customer);
        }
    }

    // ==================== TRACKING ====================

    @Override
    public List<TrackingCode> getTrackingHistory(Long requestId) {
        return trackingCodeRepository.findByRequest_RequestIdOrderByCreatedAtAsc(requestId);
    }
}
