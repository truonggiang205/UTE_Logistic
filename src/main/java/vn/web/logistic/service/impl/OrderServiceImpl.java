package vn.web.logistic.service.impl;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.entity.*;
import vn.web.logistic.enums.CodStatus;
import vn.web.logistic.enums.PaymentStatus;
import vn.web.logistic.enums.RequestStatus;
import vn.web.logistic.enums.VnpayPaymentStatus;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.OrderService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired private ServiceRequestRepository requestRepository;
    @Autowired private CustomerAddressRepository addressRepository;
    @Autowired private ServiceRequestRepository orderRepository;
    @Autowired private CodTransactionRepository codTransactionRepository;
    @Autowired private VnpayTransactionRepository vnpayTransactionRepository;

    @Override
    @Transactional
    public ServiceRequest createNewOrder(ServiceRequest request, Map<String, String> recipientInfo) {
        Customer customer = request.getCustomer();
        
        // 1. XỬ LÝ LƯU ĐỊA CHỈ NGƯỜI NHẬN
        // Kiểm tra xem địa chỉ này đã có trong sổ địa chỉ của Customer chưa
        String phone = recipientInfo.get("phone");
        String detail = recipientInfo.get("addressDetail");
        
        CustomerAddress deliveryAddress = addressRepository
        	    .findByCustomerAndContactPhoneAndAddressDetail(customer, phone, detail)
        	    .orElseGet(() -> {
        	        CustomerAddress newAddr = CustomerAddress.builder()
        	            .customer(customer)
        	            .contactName(recipientInfo.get("fullName")) 
        	            .contactPhone(phone)                        
        	            .addressDetail(detail)
        	            .ward(recipientInfo.get("ward"))
        	            .district(recipientInfo.get("district"))
        	            .province(recipientInfo.get("province"))
        	            .build();
        	        return addressRepository.save(newAddr);
        	    });

        // Gán địa chỉ đã xử lý vào đơn hàng
        request.setDeliveryAddress(deliveryAddress);
        
     // 2. TÍNH TOÁN PHÍ DỊCH VỤ (Đã loại bỏ isHighValue)
        request = calculateAllFees(request);
        
        // 3. THIẾT LẬP TRẠNG THÁI MẶC ĐỊNH
        request.setStatus(RequestStatus.pending);
        request.setPaymentStatus(PaymentStatus.unpaid);
        request.setCreatedAt(LocalDateTime.now());

        return requestRepository.save(request);
    }

    @Override
    public ServiceRequest calculateAllFees(ServiceRequest request) {
        // Lấy ID loại dịch vụ: 1-Standard, 2-Express, 3-BBS
        Long serviceTypeId = request.getServiceType().getServiceTypeId();
        
        BigDecimal basePrice;
        BigDecimal extraPrice;
        
        // A. Cấu hình bảng giá dựa trên hình ảnh
        if (serviceTypeId == 2) { // EXPRESS
            basePrice = new BigDecimal("35000");
            extraPrice = new BigDecimal("7000");
        } else if (serviceTypeId == 3) { // BBS BULKY
            basePrice = new BigDecimal("150000");
            extraPrice = new BigDecimal("3000");
        } else { // Mặc định là STANDARD (ID=1)
            basePrice = new BigDecimal("20000");
            extraPrice = new BigDecimal("5000");
        }

        // B. Logic tính phí vận chuyển theo công thức:
        // ShippingFee = BasePrice + (ceil(TotalWeight - 1) * ExtraPrice)
        double totalWeight = request.getWeight().doubleValue() * request.getQuantity();
        BigDecimal shippingFee = basePrice;
        
        if (totalWeight > 1) {
            BigDecimal extraWeight = new BigDecimal(Math.ceil(totalWeight - 1));
            shippingFee = shippingFee.add(extraWeight.multiply(extraPrice));
        }
        request.setShippingFee(shippingFee);

        // C. Loại bỏ phí bảo hiểm hàng giá trị cao theo yêu cầu
        request.setInsuranceFee(BigDecimal.ZERO);

        // D. Phí COD: Giữ nguyên 0.5% số tiền thu hộ
        BigDecimal codFee = request.getCodAmount().multiply(new BigDecimal("0.005"));
        request.setCodFee(codFee);

        // E. Tổng phí = Phí Ship + Phí COD (Bảo hiểm đã bằng 0)
        BigDecimal total = shippingFee.add(codFee);
        request.setTotalPrice(total);
        
        // F. Tiền thu người nhận = COD + Tổng phí
        request.setReceiverPayAmount(request.getCodAmount().add(total));

        return request;
    }
    
    @Override
    @Transactional
    public void updatePaymentStatus(String orderId, String statusStr) {
        // 1. Tìm đơn hàng từ database
        ServiceRequest order = orderRepository.findById(Long.parseLong(orderId))
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng ID: " + orderId));

        // 2. Xử lý cập nhật dựa trên giá trị String nhận từ VNPay
        if ("PAID".equalsIgnoreCase(statusStr)) {
            // Sửa lỗi: Sử dụng Enum thay vì String
            order.setPaymentStatus(PaymentStatus.paid); 
            
            // Cập nhật trạng thái đơn hàng sang Chờ xử lý
            order.setStatus(RequestStatus.pending); 
        } else {
            order.setPaymentStatus(PaymentStatus.unpaid);
        }

        orderRepository.save(order);
    }
    
    @Override
    @Transactional
    public void createCodTransaction(ServiceRequest request, String paymentMethod) {
        if (request.getCodAmount() != null && request.getCodAmount().compareTo(BigDecimal.ZERO) > 0) {
            CodTransaction codTxn = CodTransaction.builder()
                    .request(request)
                    .amount(request.getCodAmount())
                    // Sửa: Sử dụng CodStatus thay vì TransactionStatus
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
                // Sửa: Sử dụng VnpayPaymentStatus thay vì PaymentStatus
                // Lưu ý: Tên hằng số có thể là Success hoặc Paid tùy bạn định nghĩa trong Enum
                .paymentStatus(VnpayPaymentStatus.success) 
                .createdAt(LocalDateTime.now())
                .build();
        vnpayTransactionRepository.save(vnpayTxn);
    }
}