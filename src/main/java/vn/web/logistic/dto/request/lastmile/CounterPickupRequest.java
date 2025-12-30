package vn.web.logistic.dto.request.lastmile;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// DTO Request cho chức năng 4: Khách nhận tại quầy (Counter Pickup)
// Khách đến trực tiếp bưu cục lấy hàng (không qua Shipper)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CounterPickupRequest {

    // ID đơn hàng khách đến nhận
    @NotNull(message = "Request ID không được để trống")
    private Long requestId;

    // CMND/CCCD của khách nhận hàng (để xác minh)
    @NotBlank(message = "Số CMND/CCCD không được để trống")
    private String customerIdCard;

    // ID Hub hiện tại (nơi khách đến nhận)
    @NotNull(message = "Hub ID không được để trống")
    private Long currentHubId;
}
