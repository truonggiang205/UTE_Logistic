package vn.web.logistic.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.CodTransaction.CodStatus;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.PaymentStatus;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.entity.TrackingCode.TrackingStatus;
import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.entity.VnpayTransaction.VnpayPaymentStatus;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ServiceTypeRepository;
import vn.web.logistic.repository.TrackingCodeRepository;
import vn.web.logistic.repository.VnpayTransactionRepository;
import vn.web.logistic.service.OrderService;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final ServiceRequestRepository requestRepository;
    private final CustomerAddressRepository addressRepository;
    private final CustomerRepository customerRepository;
    private final ServiceTypeRepository serviceTypeRepository;
    private final CodTransactionRepository codTransactionRepository;
    private final VnpayTransactionRepository vnpayTransactionRepository;
    private final TrackingCodeRepository trackingCodeRepository;

    /**
     * TẠO ĐƠN HÀNG TỪ CUSTOMER (ONLINE ORDER)
     * Đây là luồng khi khách hàng đặt đơn trực tuyến từ trang web.
     * 
     * LOGIC TƯƠNG TỰ createDropOffOrder TRONG InboundServiceImpl:
     * - Trạng thái: pending (chờ lấy hàng) thay vì picked
     * - Địa chỉ người nhận: customer_id thuộc về người gửi (sender)
     * - Nếu địa chỉ mới -> Tạo mới địa chỉ cho người nhận
     */
    @Override
    @Transactional
    public ServiceRequest createNewOrder(ServiceRequest order, Map<String, String> recipientInfo) {
        // --- BƯỚC 1: QUẢN LÝ THÔNG TIN KHÁCH HÀNG & ĐỊA CHỈ ---
        Customer sender = order.getCustomer();

        // Xử lý địa chỉ lấy hàng (Pickup Address) - giữ nguyên, không thay đổi
        // Pickup address đã được set từ controller, chỉ cần validate và lấy lại từ DB
        CustomerAddress pickupAddr = order.getPickupAddress();
        // Không gọi validateAndSaveAddress cho pickup để tránh thay đổi isDefault

        // Xử lý địa chỉ giao hàng (Delivery Address)
        // Kiểm tra nếu địa chỉ đã tồn tại (tất cả các trường giống nhau) thì dùng lại
        CustomerAddress deliveryAddr = buildDeliveryAddressFromInfo(sender, recipientInfo);

        // Tìm địa chỉ đã tồn tại với cùng thông tin
        CustomerAddress existingDeliveryAddr = addressRepository
                .findByCustomerAndContactPhoneAndAddressDetailAndWardAndDistrictAndProvince(
                        sender,
                        deliveryAddr.getContactPhone(),
                        deliveryAddr.getAddressDetail(),
                        deliveryAddr.getWard(),
                        deliveryAddr.getDistrict(),
                        deliveryAddr.getProvince())
                .orElse(null);

        if (existingDeliveryAddr != null) {
            // Địa chỉ đã tồn tại, dùng lại, không tạo mới
            deliveryAddr = existingDeliveryAddr;
        } else {
            // Địa chỉ chưa tồn tại, tạo mới
            deliveryAddr.setCustomer(sender);
            deliveryAddr.setIsDefault(false);
            deliveryAddr = addressRepository.save(deliveryAddr);
        }

        // --- BƯỚC 2: TÍNH TOÁN KỸ THUẬT VÀ TÀI CHÍNH ---
        ServiceType st = serviceTypeRepository.findById(order.getServiceType().getServiceTypeId())
                .orElseThrow(() -> new RuntimeException("Loại dịch vụ không hợp lệ"));

        // Xử lý giá trị mặc định để tránh lỗi Null
        BigDecimal length = order.getLength() != null ? order.getLength() : BigDecimal.ONE;
        BigDecimal width = order.getWidth() != null ? order.getWidth() : BigDecimal.ONE;
        BigDecimal height = order.getHeight() != null ? order.getHeight() : BigDecimal.ONE;
        BigDecimal weight = order.getWeight() != null ? order.getWeight() : BigDecimal.ONE;
        BigDecimal codAmount = order.getCodAmount() != null ? order.getCodAmount() : BigDecimal.ZERO;
        String itemName = order.getItemName() != null ? order.getItemName() : "Hàng hóa";
        String note = order.getNote() != null ? order.getNote() : "";
        String imageOrder = order.getImageOrder(); // Có thể null

        // Công thức tính trọng lượng quy đổi (Volumetric Weight)
        BigDecimal dimWeight = length.multiply(width).multiply(height)
                .divide(new BigDecimal("6000"), 2, RoundingMode.HALF_UP);
        BigDecimal chargeableWeight = weight.max(dimWeight);

        // Tính toán các loại phí dựa trên cấu hình ServiceType
        BigDecimal shippingFee = calculateShippingFee(st, chargeableWeight);
        BigDecimal codFee = calculateCodFee(st, codAmount);
        BigDecimal insFee = calculateInsuranceFee(st, codAmount);
        BigDecimal totalPrice = shippingFee.add(codFee).add(insFee); // Tổng phí logistics

        // --- BƯỚC 3: XÁC ĐỊNH TRẠNG THÁI THANH TOÁN VÀ SỐ TIỀN NGƯỜI NHẬN TRẢ ---
        // paymentStatus mặc định là unpaid (người nhận trả sau)
        ServiceRequest.PaymentStatus paymentStatus = order.getPaymentStatus() != null
                ? order.getPaymentStatus()
                : ServiceRequest.PaymentStatus.unpaid;

        // Tính receiver_pay_amount: Số tiền shipper cần thu của người nhận
        // = codAmount (tiền hàng) + phí ship (nếu người nhận trả sau)
        BigDecimal receiverPayAmount;
        if (paymentStatus == ServiceRequest.PaymentStatus.paid) {
            // Người gửi đã trả phí ship -> Người nhận chỉ trả tiền hàng COD
            receiverPayAmount = codAmount;
        } else {
            // Người nhận trả sau -> Người nhận trả cả phí ship + tiền hàng COD
            receiverPayAmount = codAmount.add(totalPrice);
        }

        // --- BƯỚC 4: LẤP ĐẦY ĐẦY ĐỦ DỮ LIỆU ĐƠN HÀNG (SERVICE_REQUEST) ---
        order.setCustomer(sender);
        order.setPickupAddress(pickupAddr);
        order.setDeliveryAddress(deliveryAddr);
        order.setServiceType(st);
        // Giữ lại currentHub nếu đã được set từ controller, nếu không thì để null
        // (Khi customer chọn Hub từ form, controller sẽ set currentHub trước khi gọi
        // service)
        order.setStatus(ServiceRequest.RequestStatus.pending); // PENDING - Chờ lấy hàng
        order.setPaymentStatus(paymentStatus);
        order.setCreatedAt(LocalDateTime.now());
        // Thông tin hàng hóa
        order.setItemName(itemName);
        order.setWeight(weight);
        order.setLength(length);
        order.setWidth(width);
        order.setHeight(height);
        order.setChargeableWeight(chargeableWeight);
        order.setCodAmount(codAmount);
        order.setNote(note);
        order.setImageOrder(imageOrder);
        // Thông tin tài chính
        order.setShippingFee(shippingFee);
        order.setCodFee(codFee);
        order.setInsuranceFee(insFee);
        order.setTotalPrice(totalPrice);
        order.setReceiverPayAmount(receiverPayAmount);

        ServiceRequest savedOrder = requestRepository.save(order);

        // --- BƯỚC 5: TẠO COD_TRANSACTION (KHI CÓ TIỀN CẦN THU) ---
        // Tạo COD Transaction khi receiverPayAmount > 0
        if (receiverPayAmount.compareTo(BigDecimal.ZERO) > 0) {
            CodTransaction codTx = CodTransaction.builder()
                    .request(savedOrder)
                    .amount(receiverPayAmount)
                    .status(CodTransaction.CodStatus.pending)
                    .paymentMethod(null) // NULL vì chưa giao, chưa biết khách trả bằng gì
                    .shipper(null) // NULL vì chưa phân công shipper
                    .codType(CodTransaction.CodType.delivery_cod)
                    .collectedAt(null) // Chưa thu
                    .settledAt(null) // Chưa quyết toán
                    .build();
            codTransactionRepository.save(codTx);
        }

        // --- BƯỚC 6: TẠO MÃ VẬN ĐƠN (TRACKING CODE) ---
        // Sử dụng UUID để đảm bảo tính duy nhất
        String trackingCodeStr = generateTrackingCode(savedOrder.getRequestId());
        TrackingCode trackingCode = TrackingCode.builder()
                .request(savedOrder)
                .code(trackingCodeStr)
                .createdAt(LocalDateTime.now())
                .status(TrackingStatus.active)
                .build();
        trackingCodeRepository.save(trackingCode);

        return savedOrder;
    }

    // ==================== HELPER METHODS (Theo chuẩn InboundServiceImpl)
    // ====================

    /**
     * Sinh mã vận đơn duy nhất
     * Format: LOG + năm(2 số) + tháng + ngày + UUID(8 ký tự) + requestId
     * Ví dụ: LOG260101-A1B2C3D4-123
     */
    private String generateTrackingCode(Long requestId) {
        LocalDateTime now = LocalDateTime.now();
        String datePart = String.format("%02d%02d%02d",
                now.getYear() % 100, now.getMonthValue(), now.getDayOfMonth());
        String uuidPart = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return "LOG" + datePart + "-" + uuidPart + "-" + requestId;
    }

    /**
     * Tự động tìm hoặc tạo mới khách hàng để tránh trùng số điện thoại
     */
    private Customer findOrCreateCustomer(String phone, String fullName) {
        if (phone == null || phone.isEmpty()) {
            // Nếu không có SĐT, tạo customer mới không có phone
            return customerRepository.save(Customer.builder()
                    .phone(null)
                    .fullName(fullName != null ? fullName : "Khách mới")
                    .customerType(Customer.CustomerType.individual)
                    .status(Customer.CustomerStatus.active)
                    .createdAt(LocalDateTime.now())
                    .build());
        }
        return customerRepository.findByPhone(phone)
                .orElseGet(() -> customerRepository.save(Customer.builder()
                        .phone(phone)
                        .fullName(fullName != null ? fullName : "Khách mới")
                        .customerType(Customer.CustomerType.individual)
                        .status(Customer.CustomerStatus.active)
                        .createdAt(LocalDateTime.now())
                        .build()));
    }

    /**
     * Xây dựng đối tượng CustomerAddress từ recipientInfo
     */
    private CustomerAddress buildDeliveryAddressFromInfo(Customer receiver, Map<String, String> recipientInfo) {
        return CustomerAddress.builder()
                .customer(receiver)
                .contactName(recipientInfo.get("fullName"))
                .contactPhone(recipientInfo.get("phone"))
                .addressDetail(recipientInfo.get("addressDetail") != null ? recipientInfo.get("addressDetail") : "")
                .ward(recipientInfo.get("ward") != null ? recipientInfo.get("ward") : "")
                .district(recipientInfo.get("district") != null ? recipientInfo.get("district") : "")
                .province(recipientInfo.get("province") != null ? recipientInfo.get("province") : "")
                .isDefault(false)
                .build();
    }

    /**
     * Kiểm tra địa chỉ, nếu khách đã dùng rồi thì lấy lại, nếu chưa thì lưu mới
     */
    private CustomerAddress validateAndSaveAddress(Customer customer, CustomerAddress address) {
        if (address == null) {
            return null;
        }

        String addressDetail = address.getAddressDetail() != null ? address.getAddressDetail() : "";
        String ward = address.getWard() != null ? address.getWard() : "";
        String district = address.getDistrict() != null ? address.getDistrict() : "";
        String province = address.getProvince() != null ? address.getProvince() : "";

        return addressRepository.findByCustomerAndAddressDetailAndWardAndDistrictAndProvince(
                customer, addressDetail, ward, district, province)
                .orElseGet(() -> {
                    address.setCustomer(customer);
                    address.setIsDefault(false);
                    address.setContactName(address.getContactName() != null
                            ? address.getContactName()
                            : customer.getFullName());
                    address.setContactPhone(address.getContactPhone() != null
                            ? address.getContactPhone()
                            : customer.getPhone());
                    address.setAddressDetail(addressDetail);
                    address.setWard(ward);
                    address.setDistrict(district);
                    address.setProvince(province);
                    return addressRepository.save(address);
                });
    }

    /**
     * Tính cước vận chuyển (2kg đầu giá cố định, mỗi kg sau cộng thêm tiền)
     */
    private BigDecimal calculateShippingFee(ServiceType st, BigDecimal weight) {
        BigDecimal fee = st.getBaseFee() != null ? st.getBaseFee() : BigDecimal.ZERO;
        if (weight.compareTo(new BigDecimal("2.0")) > 0) {
            BigDecimal extra = weight.subtract(new BigDecimal("2.0"));
            BigDecimal extraPrice = st.getExtraPricePerKg() != null ? st.getExtraPricePerKg()
                    : BigDecimal.ZERO;
            fee = fee.add(extra.multiply(extraPrice));
        }
        return fee.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Tính phí thu hộ (COD) dựa trên % giá trị hàng
     */
    private BigDecimal calculateCodFee(ServiceType st, BigDecimal codAmount) {
        if (codAmount == null || codAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal codRate = st.getCodRate() != null ? st.getCodRate() : BigDecimal.ZERO;
        BigDecimal codMinFee = st.getCodMinFee() != null ? st.getCodMinFee() : BigDecimal.ZERO;
        return codAmount.multiply(codRate).max(codMinFee).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Tính phí bảo hiểm hàng hóa (thường áp dụng cho hàng giá trị cao > 3tr)
     */
    private BigDecimal calculateInsuranceFee(ServiceType st, BigDecimal codAmount) {
        if (codAmount == null || codAmount.compareTo(new BigDecimal("3000000")) <= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal insRate = st.getInsuranceRate() != null ? st.getInsuranceRate() : BigDecimal.ZERO;
        return codAmount.multiply(insRate).setScale(2, RoundingMode.HALF_UP);
    }

    // ==================== INTERFACE METHODS (LEGACY SUPPORT) ====================

    @Override
    public ServiceRequest calculateAllFees(ServiceRequest request) {
        ServiceType st = request.getServiceType();

        BigDecimal weight = request.getWeight() != null ? request.getWeight() : BigDecimal.ONE;
        BigDecimal codAmount = request.getCodAmount() != null ? request.getCodAmount() : BigDecimal.ZERO;

        BigDecimal shippingFee = calculateShippingFee(st, weight);
        BigDecimal codFee = calculateCodFee(st, codAmount);
        BigDecimal insFee = calculateInsuranceFee(st, codAmount);
        BigDecimal totalPrice = shippingFee.add(codFee).add(insFee);

        request.setShippingFee(shippingFee);
        request.setCodFee(codFee);
        request.setInsuranceFee(insFee);
        request.setTotalPrice(totalPrice);
        request.setReceiverPayAmount(codAmount.add(totalPrice));

        return request;
    }

    @Override
    @Transactional
    public void updatePaymentStatus(String orderId, String statusStr) {
        ServiceRequest order = requestRepository.findById(Long.parseLong(orderId))
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng ID: " + orderId));

        if ("PAID".equalsIgnoreCase(statusStr)) {
            order.setPaymentStatus(PaymentStatus.paid);
            order.setStatus(RequestStatus.pending);
        } else {
            order.setPaymentStatus(PaymentStatus.unpaid);
        }

        requestRepository.save(order);
    }

    @Override
    @Transactional
    public void createCodTransaction(ServiceRequest request, String paymentMethod) {
        if (request.getCodAmount() != null && request.getCodAmount().compareTo(BigDecimal.ZERO) > 0) {
            CodTransaction codTxn = CodTransaction.builder()
                    .request(request)
                    .amount(request.getCodAmount())
                    .status(CodStatus.pending)
                    .paymentMethod(paymentMethod)
                    .collectedAt(LocalDateTime.now())
                    .build();
            codTransactionRepository.save(codTxn);
        }
    }

    @Override
    @Transactional
    public void createVnpayTransaction(ServiceRequest request) {
        VnpayTransaction vnpayTxn = VnpayTransaction.builder()
                .request(request)
                .amount(request.getTotalPrice())
                .paymentStatus(VnpayPaymentStatus.success)
                .createdAt(LocalDateTime.now())
                .build();
        vnpayTransactionRepository.save(vnpayTxn);
    }
}