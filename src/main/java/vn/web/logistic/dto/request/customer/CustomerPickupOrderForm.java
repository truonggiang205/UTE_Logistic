package vn.web.logistic.dto.request.customer;

import java.math.BigDecimal;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CustomerPickupOrderForm {

    // ===== Sender (pickup) =====
    @NotBlank(message = "Tên người gửi không được để trống")
    @Size(max = 100)
    private String senderName;

    @NotBlank(message = "SĐT người gửi không được để trống")
    @Size(max = 20)
    private String senderPhone;

    @NotBlank(message = "Địa chỉ lấy hàng không được để trống")
    @Size(max = 255)
    private String pickupAddressDetail;

    @Size(max = 50)
    private String pickupWard;

    @Size(max = 50)
    private String pickupDistrict;

    @Size(max = 50)
    private String pickupProvince;

    // ===== Receiver (delivery) =====
    @NotBlank(message = "Tên người nhận không được để trống")
    @Size(max = 100)
    private String receiverName;

    @NotBlank(message = "SĐT người nhận không được để trống")
    @Size(max = 20)
    private String receiverPhone;

    @NotBlank(message = "Địa chỉ giao hàng không được để trống")
    @Size(max = 255)
    private String deliveryAddressDetail;

    @Size(max = 50)
    private String deliveryWard;

    @Size(max = 50)
    private String deliveryDistrict;

    @Size(max = 50)
    private String deliveryProvince;

    // ===== Parcel info =====
    @NotNull(message = "Vui lòng chọn loại dịch vụ")
    private Long serviceTypeId;

    @Size(max = 255)
    private String itemName;

    @DecimalMin(value = "0.01", message = "Khối lượng phải > 0")
    private BigDecimal weight;

    @DecimalMin(value = "0.01", message = "Chiều dài phải > 0")
    private BigDecimal length;

    @DecimalMin(value = "0.01", message = "Chiều rộng phải > 0")
    private BigDecimal width;

    @DecimalMin(value = "0.01", message = "Chiều cao phải > 0")
    private BigDecimal height;

    @DecimalMin(value = "0", message = "COD không hợp lệ")
    private BigDecimal codAmount;

    // paid: người gửi trả phí ship | unpaid: người nhận trả phí ship
    @NotBlank(message = "Vui lòng chọn hình thức thanh toán")
    private String paymentStatus;

    @Size(max = 500)
    private String note;
}
