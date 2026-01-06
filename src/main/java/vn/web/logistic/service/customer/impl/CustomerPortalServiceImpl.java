package vn.web.logistic.service.customer.impl;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.customer.CustomerAddressForm;
import vn.web.logistic.dto.request.customer.CustomerProfileForm;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.SecurityContextService;
import vn.web.logistic.service.FileUploadService;
import vn.web.logistic.service.customer.CustomerPortalService;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class CustomerPortalServiceImpl implements CustomerPortalService {

    private final SecurityContextService securityContextService;
    private final CustomerRepository customerRepository;
    private final CustomerAddressRepository customerAddressRepository;
    private final UserRepository userRepository;
    private final FileUploadService fileUploadService;

    @Override
    @Transactional
    public Customer getOrCreateCurrentCustomer() {
        User user = securityContextService.getCurrentUser();
        if (user == null) {
            throw new RuntimeException("Bạn chưa đăng nhập");
        }

        return customerRepository.findByUserUserId(user.getUserId())
                .orElseGet(() -> customerRepository.save(Customer.builder()
                        .user(user)
                        .fullName(user.getFullName())
                        .email(user.getEmail())
                        .phone(user.getPhone())
                        .customerType(Customer.CustomerType.individual)
                        .status(Customer.CustomerStatus.active)
                        .createdAt(LocalDateTime.now())
                        .build()));
    }

    @Override
    @Transactional(readOnly = true)
    public Customer getCurrentCustomerOrThrow() {
        return getOrCreateCurrentCustomer();
    }

    @Override
    @Transactional(readOnly = true)
    public List<CustomerAddress> getCurrentCustomerAddresses() {
        Customer customer = getCurrentCustomerOrThrow();
        return customerAddressRepository.findByCustomerCustomerId(customer.getCustomerId());
    }

    @Override
    @Transactional
    public CustomerAddress addAddress(CustomerAddressForm form) {
        Customer customer = getCurrentCustomerOrThrow();

        if (form.isMakeDefault()) {
            clearDefault(customer.getCustomerId());
        }

        CustomerAddress address = CustomerAddress.builder()
                .customer(customer)
            .contactName(emptyToNull(form.getContactName()))
            .contactPhone(emptyToNull(form.getContactPhone()))
            .addressDetail(emptyToNull(form.getAddressDetail()))
            .ward(emptyToNull(form.getWard()))
            .district(emptyToNull(form.getDistrict()))
            .province(emptyToNull(form.getProvince()))
            .note(emptyToNull(form.getNote()))
                .isDefault(form.isMakeDefault())
                .build();

        return customerAddressRepository.save(address);
    }

    @Override
    @Transactional
    public void setDefaultAddress(Long addressId) {
        Customer customer = getCurrentCustomerOrThrow();
        CustomerAddress addr = customerAddressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy địa chỉ"));

        if (addr.getCustomer() == null || !addr.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            throw new RuntimeException("Bạn không có quyền thao tác địa chỉ này");
        }

        clearDefault(customer.getCustomerId());
        addr.setIsDefault(true);
        customerAddressRepository.save(addr);
    }

    @Override
    @Transactional
    public void deleteAddress(Long addressId) {
        Customer customer = getCurrentCustomerOrThrow();
        CustomerAddress addr = customerAddressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy địa chỉ"));

        if (addr.getCustomer() == null || !addr.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            throw new RuntimeException("Bạn không có quyền thao tác địa chỉ này");
        }

        customerAddressRepository.delete(addr);
    }

    @Override
    @Transactional
    public void updateProfile(CustomerProfileForm form) {
        User user = securityContextService.getCurrentUser();
        if (user == null) {
            throw new RuntimeException("Bạn chưa đăng nhập");
        }

        user.setFullName(form.getFullName());
        user.setPhone(form.getPhone());
        if (form.getEmail() != null && !form.getEmail().isBlank()) {
            user.setEmail(form.getEmail());
        }
        userRepository.save(user);

        Customer customer = getOrCreateCurrentCustomer();
        customer.setFullName(form.getFullName());
        customer.setPhone(form.getPhone());
        if (form.getEmail() != null && !form.getEmail().isBlank()) {
            customer.setEmail(form.getEmail());
        }
        customerRepository.save(customer);
    }

    @Override
    @Transactional
    public String updateAvatar(MultipartFile avatarFile) {
        User user = securityContextService.getCurrentUser();
        if (user == null) {
            throw new RuntimeException("Bạn chưa đăng nhập");
        }

        // Xóa avatar cũ nếu là file upload local
        if (user.getAvatarUrl() != null && !user.getAvatarUrl().isBlank()) {
            try {
                if (user.getAvatarUrl().startsWith("/uploads/customers/")) {
                    String relativePath = user.getAvatarUrl().replaceFirst("^/uploads/", "");
                    fileUploadService.deleteImage(relativePath);
                }
            } catch (Exception ignored) {
                // Không fail toàn bộ chỉ vì xóa ảnh cũ lỗi
            }
        }

        String newAvatarPath = fileUploadService.uploadImage(avatarFile, "customers");
        user.setAvatarUrl("/uploads/" + newAvatarPath);
        userRepository.save(user);

        return user.getAvatarUrl();
    }

    private void clearDefault(Long customerId) {
        customerAddressRepository.clearDefaultForCustomer(customerId);
    }

    private String emptyToNull(String s) {
        if (s == null) {
            return null;
        }
        String trimmed = s.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
