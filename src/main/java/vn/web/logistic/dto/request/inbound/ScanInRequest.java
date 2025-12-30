package vn.web.logistic.dto.request.inbound;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO cho chức năng Quét Nhập (Scan In)
 * Nhân viên kho quét mã đơn hàng để xác nhận hàng đã về kho hiện tại
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScanInRequest {

    /**
     * Danh sách mã đơn hàng cần quét nhập
     */
    @NotEmpty(message = "Danh sách mã đơn không được rỗng")
    private List<Long> requestIds;

    /**
     * ID kho hiện tại (kho nhận hàng)
     */
    @NotNull(message = "Kho hiện tại không được để trống")
    private Long currentHubId;

    /**
     * ID chuyến xe (Optional - nếu nhập từ chuyến xe)
     */
    private Long tripId;

    /**
     * Ghi chú khi nhập kho
     */
    private String note;
}
