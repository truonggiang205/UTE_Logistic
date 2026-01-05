package vn.web.logistic.service.customer.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.customer.CustomerPickupOrderForm;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.ParcelAction;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.entity.TrackingCode.TrackingStatus;
import vn.web.logistic.repository.ActionTypeRepository;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.ParcelActionRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ServiceTypeRepository;
import vn.web.logistic.repository.TrackingCodeRepository;
import vn.web.logistic.service.SecurityContextService;
import vn.web.logistic.service.customer.CustomerOrderService;

@Service
@RequiredArgsConstructor
public class CustomerOrderServiceImpl implements CustomerOrderService {

    private final SecurityContextService securityContextService;
    private final CustomerRepository customerRepository;
    private final CustomerAddressRepository customerAddressRepository;
    private final ServiceRequestRepository serviceRequestRepository;
    private final ServiceTypeRepository serviceTypeRepository;
    private final TrackingCodeRepository trackingCodeRepository;
    private final CodTransactionRepository codTransactionRepository;
    private final ActionTypeRepository actionTypeRepository;
    private final ParcelActionRepository parcelActionRepository;

    @Override
    @Transactional
    public ServiceRequest createPickupOrder(CustomerPickupOrderForm form) {
        var actor = securityContextService.getCurrentUser();
        Customer sender = getOrCreateSenderCustomer();

        // Receiver: tạo customer vãng lai theo SĐT (để tái sử dụng địa chỉ)
        Customer receiver = customerRepository.findByPhone(form.getReceiverPhone())
                .orElseGet(() -> customerRepository.save(Customer.builder()
                        .phone(form.getReceiverPhone())
                        .fullName(form.getReceiverName())
                        .customerType(Customer.CustomerType.individual)
                        .status(Customer.CustomerStatus.active)
                        .createdAt(LocalDateTime.now())
                        .build()));

        CustomerAddress pickupAddress = validateAndSaveAddress(sender, CustomerAddress.builder()
                .contactName(form.getSenderName())
                .contactPhone(form.getSenderPhone())
                .addressDetail(form.getPickupAddressDetail())
                .ward(emptyToNull(form.getPickupWard()))
                .district(emptyToNull(form.getPickupDistrict()))
                .province(emptyToNull(form.getPickupProvince()))
                .isDefault(false)
                .build());

        CustomerAddress deliveryAddress = validateAndSaveAddress(receiver, CustomerAddress.builder()
                .contactName(form.getReceiverName())
                .contactPhone(form.getReceiverPhone())
                .addressDetail(form.getDeliveryAddressDetail())
                .ward(emptyToNull(form.getDeliveryWard()))
                .district(emptyToNull(form.getDeliveryDistrict()))
                .province(emptyToNull(form.getDeliveryProvince()))
                .isDefault(false)
                .build());

        ServiceType serviceType = serviceTypeRepository.findById(form.getServiceTypeId())
                .orElseThrow(() -> new RuntimeException("Loại dịch vụ không hợp lệ"));

        BigDecimal length = nvlPositive(form.getLength(), BigDecimal.ONE);
        BigDecimal width = nvlPositive(form.getWidth(), BigDecimal.ONE);
        BigDecimal height = nvlPositive(form.getHeight(), BigDecimal.ONE);
        BigDecimal weight = nvlPositive(form.getWeight(), BigDecimal.ONE);
        BigDecimal codAmount = form.getCodAmount() != null ? form.getCodAmount() : BigDecimal.ZERO;

        BigDecimal dimWeight = length.multiply(width).multiply(height)
                .divide(new BigDecimal("6000"), 2, RoundingMode.HALF_UP);
        BigDecimal chargeableWeight = weight.max(dimWeight);

        BigDecimal shippingFee = calculateShippingFee(serviceType, chargeableWeight);
        BigDecimal codFee = calculateCodFee(serviceType, codAmount);
        BigDecimal insuranceFee = calculateInsuranceFee(serviceType, codAmount);
        BigDecimal totalPrice = shippingFee.add(codFee).add(insuranceFee);

        ServiceRequest.PaymentStatus paymentStatus = parsePaymentStatus(form.getPaymentStatus());

        BigDecimal receiverPayAmount = (paymentStatus == ServiceRequest.PaymentStatus.paid)
                ? codAmount
                : codAmount.add(totalPrice);

        ServiceRequest request = ServiceRequest.builder()
                .customer(sender)
                .pickupAddress(pickupAddress)
                .deliveryAddress(deliveryAddress)
                .serviceType(serviceType)
                .expectedPickupTime(null)
                .note(emptyToNull(form.getNote()))
                .itemName(emptyToNull(form.getItemName()))
                .status(ServiceRequest.RequestStatus.pending) // Chờ shipper lấy hàng
                .weight(weight)
                .length(length)
                .width(width)
                .height(height)
                .codAmount(codAmount)
                .chargeableWeight(chargeableWeight)
                .shippingFee(shippingFee)
                .codFee(codFee)
                .insuranceFee(insuranceFee)
                .totalPrice(totalPrice)
                .receiverPayAmount(receiverPayAmount)
                .paymentStatus(paymentStatus)
                .createdAt(LocalDateTime.now())
                .build();

        ServiceRequest saved = serviceRequestRepository.save(request);

        // Ghi nhận lịch sử: tạo đơn
        actionTypeRepository.findByActionCode("ORDER_CREATED").ifPresent(at -> {
            ParcelAction action = ParcelAction.builder()
                .request(saved)
                .actionType(at)
                .fromHub(null)
                .toHub(null)
                .actor(actor)
                .actionTime(LocalDateTime.now())
                .note("Khách tạo đơn")
                .build();
            parcelActionRepository.save(action);
        });

        // Tracking code
        TrackingCode trackingCode = TrackingCode.builder()
                .request(saved)
                .code(generateTrackingCode(saved.getRequestId()))
                .createdAt(LocalDateTime.now())
                .status(TrackingStatus.active)
                .build();
        trackingCodeRepository.save(trackingCode);

        // COD Transaction (nếu có)
        if (codAmount.compareTo(BigDecimal.ZERO) > 0) {
            CodTransaction codTx = CodTransaction.builder()
                    .request(saved)
                    .amount(receiverPayAmount)
                    .status(CodTransaction.CodStatus.pending)
                    .paymentMethod(null)
                    .shipper(null)
                    .codType(CodTransaction.CodType.delivery_cod)
                    .collectedAt(null)
                    .settledAt(null)
                    .build();
            codTransactionRepository.save(codTx);
        }

        return saved;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ServiceRequest> getMyOrders() {
        Customer customer = getOrCreateSenderCustomer();
        return serviceRequestRepository.findByCustomerIdWithDetails(customer.getCustomerId());
    }

    @Override
    @Transactional(readOnly = true)
    public ServiceRequest getMyOrderOrThrow(Long requestId) {
        Customer customer = getOrCreateSenderCustomer();
        ServiceRequest sr = serviceRequestRepository.findByIdWithDetails(requestId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        if (sr.getCustomer() == null || sr.getCustomer().getCustomerId() == null
                || !sr.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            throw new RuntimeException("Bạn không có quyền xem đơn hàng này");
        }
        return sr;
    }

    @Override
    @Transactional
    public void cancelMyOrder(Long requestId) {
        var actor = securityContextService.getCurrentUser();
        if (actor == null) {
            throw new RuntimeException("Bạn chưa đăng nhập");
        }

        Customer customer = getOrCreateSenderCustomer();

        ServiceRequest sr = serviceRequestRepository.findByIdWithDetails(requestId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        if (sr.getCustomer() == null || sr.getCustomer().getCustomerId() == null
                || !sr.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            throw new RuntimeException("Bạn không có quyền thao tác đơn hàng này");
        }

        if (sr.getStatus() != ServiceRequest.RequestStatus.pending) {
            throw new RuntimeException("Chỉ có thể hủy đơn khi trạng thái còn 'pending'");
        }

        sr.setStatus(ServiceRequest.RequestStatus.cancelled);
        serviceRequestRepository.save(sr);

        // Inactive tracking code (nếu có)
        trackingCodeRepository.findByRequestId(requestId).ifPresent(tc -> {
            tc.setStatus(TrackingStatus.inactive);
            trackingCodeRepository.save(tc);
        });

        // Xóa COD transaction (nếu có) vì đơn đã hủy
        codTransactionRepository.deleteByRequest_RequestId(requestId);

        // Ghi nhận lịch sử: hủy đơn
        actionTypeRepository.findByActionCode("ORDER_CANCELLED").ifPresent(at -> {
            ParcelAction action = ParcelAction.builder()
                    .request(sr)
                    .actionType(at)
                    .fromHub(null)
                    .toHub(null)
                    .actor(actor)
                    .actionTime(LocalDateTime.now())
                    .note("Khách hủy đơn")
                    .build();
            parcelActionRepository.save(action);
        });
    }

    private Customer getOrCreateSenderCustomer() {
        var user = securityContextService.getCurrentUser();
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

    private CustomerAddress validateAndSaveAddress(Customer customer, CustomerAddress address) {
        if (address == null) {
            throw new RuntimeException("Địa chỉ không được để trống");
        }

        String addressDetail = address.getAddressDetail() != null ? address.getAddressDetail() : "";
        String ward = address.getWard() != null ? address.getWard() : "";
        String district = address.getDistrict() != null ? address.getDistrict() : "";
        String province = address.getProvince() != null ? address.getProvince() : "";

        return customerAddressRepository.findByCustomerAndAddressDetailAndWardAndDistrictAndProvince(
                customer, addressDetail, ward, district, province)
                .orElseGet(() -> {
                    address.setCustomer(customer);
                    address.setIsDefault(false);
                    address.setContactName(address.getContactName() != null ? address.getContactName()
                            : customer.getFullName());
                    address.setContactPhone(address.getContactPhone() != null ? address.getContactPhone()
                            : customer.getPhone());
                    address.setAddressDetail(addressDetail);
                    address.setWard(ward);
                    address.setDistrict(district);
                    address.setProvince(province);
                    return customerAddressRepository.save(address);
                });
    }

    private BigDecimal calculateShippingFee(ServiceType st, BigDecimal weight) {
        BigDecimal fee = st.getBaseFee() != null ? st.getBaseFee() : BigDecimal.ZERO;
        if (weight.compareTo(new BigDecimal("2.0")) > 0) {
            BigDecimal extra = weight.subtract(new BigDecimal("2.0"));
            BigDecimal extraPrice = st.getExtraPricePerKg() != null ? st.getExtraPricePerKg() : BigDecimal.ZERO;
            fee = fee.add(extra.multiply(extraPrice));
        }
        return fee.setScale(2, RoundingMode.HALF_UP);
    }

    private BigDecimal calculateCodFee(ServiceType st, BigDecimal codAmount) {
        if (codAmount == null || codAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal codRate = st.getCodRate() != null ? st.getCodRate() : BigDecimal.ZERO;
        BigDecimal codMinFee = st.getCodMinFee() != null ? st.getCodMinFee() : BigDecimal.ZERO;
        return codAmount.multiply(codRate).max(codMinFee).setScale(2, RoundingMode.HALF_UP);
    }

    private BigDecimal calculateInsuranceFee(ServiceType st, BigDecimal codAmount) {
        if (codAmount == null || codAmount.compareTo(new BigDecimal("3000000")) <= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal insRate = st.getInsuranceRate() != null ? st.getInsuranceRate() : BigDecimal.ZERO;
        return codAmount.multiply(insRate).setScale(2, RoundingMode.HALF_UP);
    }

    private ServiceRequest.PaymentStatus parsePaymentStatus(String value) {
        if (value == null) {
            return ServiceRequest.PaymentStatus.unpaid;
        }
        try {
            return ServiceRequest.PaymentStatus.valueOf(value);
        } catch (IllegalArgumentException ex) {
            return ServiceRequest.PaymentStatus.unpaid;
        }
    }

    private String generateTrackingCode(Long requestId) {
        LocalDateTime now = LocalDateTime.now();
        String datePart = String.format("%02d%02d%02d", now.getYear() % 100, now.getMonthValue(), now.getDayOfMonth());
        String uuidPart = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return "LOG" + datePart + "-" + uuidPart + "-" + requestId;
    }

    private BigDecimal nvlPositive(BigDecimal value, BigDecimal fallback) {
        if (value == null) {
            return fallback;
        }
        if (value.compareTo(BigDecimal.ZERO) <= 0) {
            return fallback;
        }
        return value;
    }

    private String emptyToNull(String s) {
        if (s == null) {
            return null;
        }
        String trimmed = s.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
