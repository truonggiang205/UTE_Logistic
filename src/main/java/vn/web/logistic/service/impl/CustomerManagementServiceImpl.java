package vn.web.logistic.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.response.admin.CustomerDetailResponse;
import vn.web.logistic.dto.response.admin.CustomerDetailResponse.AddressInfo;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.Customer.CustomerStatus;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.service.CustomerManagementService;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomerManagementServiceImpl implements CustomerManagementService {

    private final CustomerRepository customerRepository;
    private final CustomerAddressRepository customerAddressRepository;

    @Override
    public PageResponse<CustomerDetailResponse> getAll(String status, String keyword, Pageable pageable) {
        CustomerStatus customerStatus = null;
        if (status != null && !status.isEmpty()) {
            try {
                customerStatus = CustomerStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status value: {}", status);
            }
        }

        Page<Customer> page = customerRepository.findWithFilters(customerStatus, keyword, pageable);

        List<CustomerDetailResponse> content = page.getContent().stream()
                .map(this::toResponseWithoutAddresses)
                .collect(Collectors.toList());

        return PageResponse.<CustomerDetailResponse>builder()
                .content(content)
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .first(page.isFirst())
                .last(page.isLast())
                .build();
    }

    @Override
    public CustomerDetailResponse getById(Long customerId) {
        Customer customer = customerRepository.findByIdWithUser(customerId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách hàng với ID: " + customerId));

        // Lấy tất cả địa chỉ
        List<CustomerAddress> addresses = customerAddressRepository.findByCustomerCustomerId(customerId);

        return toResponseWithAddresses(customer, addresses);
    }

    @Override
    public CustomerDetailResponse getByUserId(Long userId) {
        Customer customer = customerRepository.findByUserUserId(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách hàng với User ID: " + userId));

        // Lấy tất cả địa chỉ
        List<CustomerAddress> addresses = customerAddressRepository.findByCustomerCustomerId(customer.getCustomerId());

        return toResponseWithAddresses(customer, addresses);
    }

    // =============== Helper Methods ===============

    private CustomerDetailResponse toResponseWithoutAddresses(Customer customer) {
        User user = customer.getUser();

        return CustomerDetailResponse.builder()
                .userId(user != null ? user.getUserId() : null)
                .username(user != null ? user.getUsername() : null)
                .userEmail(user != null ? user.getEmail() : null)
                .userPhone(user != null ? user.getPhone() : null)
                .userStatus(user != null && user.getStatus() != null ? user.getStatus().name() : null)
                .lastLoginAt(user != null ? user.getLastLoginAt() : null)
                .customerId(customer.getCustomerId())
                .fullName(customer.getFullName())
                .businessName(customer.getBusinessName())
                .customerType(customer.getCustomerType() != null ? customer.getCustomerType().name() : null)
                .email(customer.getEmail())
                .phone(customer.getPhone())
                .taxCode(customer.getTaxCode())
                .status(customer.getStatus() != null ? customer.getStatus().name() : null)
                .createdAt(customer.getCreatedAt())
                .addresses(new ArrayList<>()) // Không load addresses trong list
                .build();
    }

    private CustomerDetailResponse toResponseWithAddresses(Customer customer, List<CustomerAddress> addresses) {
        User user = customer.getUser();

        List<AddressInfo> addressInfos = addresses.stream()
                .map(this::toAddressInfo)
                .collect(Collectors.toList());

        return CustomerDetailResponse.builder()
                .userId(user != null ? user.getUserId() : null)
                .username(user != null ? user.getUsername() : null)
                .userEmail(user != null ? user.getEmail() : null)
                .userPhone(user != null ? user.getPhone() : null)
                .userStatus(user != null && user.getStatus() != null ? user.getStatus().name() : null)
                .lastLoginAt(user != null ? user.getLastLoginAt() : null)
                .customerId(customer.getCustomerId())
                .fullName(customer.getFullName())
                .businessName(customer.getBusinessName())
                .customerType(customer.getCustomerType() != null ? customer.getCustomerType().name() : null)
                .email(customer.getEmail())
                .phone(customer.getPhone())
                .taxCode(customer.getTaxCode())
                .status(customer.getStatus() != null ? customer.getStatus().name() : null)
                .createdAt(customer.getCreatedAt())
                .addresses(addressInfos)
                .build();
    }

    private AddressInfo toAddressInfo(CustomerAddress address) {
        // Tạo địa chỉ đầy đủ
        StringBuilder fullAddress = new StringBuilder();
        if (address.getAddressDetail() != null)
            fullAddress.append(address.getAddressDetail());
        if (address.getWard() != null) {
            if (fullAddress.length() > 0)
                fullAddress.append(", ");
            fullAddress.append(address.getWard());
        }
        if (address.getDistrict() != null) {
            if (fullAddress.length() > 0)
                fullAddress.append(", ");
            fullAddress.append(address.getDistrict());
        }
        if (address.getProvince() != null) {
            if (fullAddress.length() > 0)
                fullAddress.append(", ");
            fullAddress.append(address.getProvince());
        }

        return AddressInfo.builder()
                .addressId(address.getAddressId())
                .contactName(address.getContactName())
                .contactPhone(address.getContactPhone())
                .addressDetail(address.getAddressDetail())
                .ward(address.getWard())
                .district(address.getDistrict())
                .province(address.getProvince())
                .fullAddress(fullAddress.toString())
                .isDefault(address.getIsDefault())
                .note(address.getNote())
                .build();
    }
}
