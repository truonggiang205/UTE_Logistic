package vn.web.logistic.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.entity.*;
import vn.web.logistic.enums.PaymentStatus;
import vn.web.logistic.enums.RequestStatus;
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
        
        // 2. TÍNH TOÁN PHÍ & TỔNG TIỀN
        boolean isHighValue = "true".equals(recipientInfo.get("isHighValue"));
        request = calculateAllFees(request, isHighValue);
        
        // 3. THIẾT LẬP TRẠNG THÁI MẶC ĐỊNH
        request.setStatus(RequestStatus.pending);
        request.setPaymentStatus(PaymentStatus.unpaid);
        request.setCreatedAt(LocalDateTime.now());

        return requestRepository.save(request);
    }

    @Override
    public ServiceRequest calculateAllFees(ServiceRequest request, boolean isHighValue) {
        // Giả sử logic tính phí dựa trên mẫu ảnh:
        
        // A. Phí Ship: Express (<20kg) mặc định 22k, BBS (>=20kg) mặc định 50k
        BigDecimal shipFee = request.getWeight().compareTo(new BigDecimal("20")) < 0 
                             ? new BigDecimal("22000") : new BigDecimal("50000");
        request.setShippingFee(shipFee);

        // B. Phí COD: Thường là 0.5% số tiền thu hộ (nếu có)
        BigDecimal codFee = request.getCodAmount().multiply(new BigDecimal("0.005"));
        request.setCodFee(codFee);

        // C. Phí bảo hiểm: Nếu là hàng giá trị cao (>= 1,000,000đ)
        BigDecimal insurance = isHighValue 
                               ? request.getCodAmount().multiply(new BigDecimal("0.01")) 
                               : BigDecimal.ZERO;
        request.setInsuranceFee(insurance);

        // D. Tổng Price = Ship + COD fee + Insurance
        BigDecimal total = shipFee.add(codFee).add(insurance);
        request.setTotalPrice(total);
        
        // E. Tiền người nhận phải trả (Tổng COD + Ship nếu khách trả ship)
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
}