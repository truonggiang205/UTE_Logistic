package vn.web.logistic.dto.request.outbound;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO cho chức năng ĐÓNG BAO (Consolidate)
 * Gom nhiều đơn hàng lẻ vào một container để vận chuyển
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsolidateRequest {

    /**
     * Danh sách ID các đơn hàng cần đóng vào container
     * Đơn phải có status = 'picked' hoặc 'failed' (hàng hoàn)
     */
    @NotEmpty(message = "Danh sách đơn hàng không được rỗng")
    private List<Long> requestIds;

    /**
     * ID Hub đích (nơi container sẽ được gửi đến)
     */
    @NotNull(message = "Hub đích không được để trống")
    private Long toHubId;

    /**
     * ID Hub hiện tại (nơi tạo container)
     */
    @NotNull(message = "Hub hiện tại không được để trống")
    private Long currentHubId;

    /**
     * Loại container: standard, fragile, frozen, express
     */
    private String containerType;

    /**
     * Ghi chú cho container
     */
    private String note;
}
