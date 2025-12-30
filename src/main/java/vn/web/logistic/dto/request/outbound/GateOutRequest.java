package vn.web.logistic.dto.request.outbound;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO cho chức năng XUẤT BẾN (Gate Out)
 * Xác nhận xe xuất bến, gán container vào trip và cập nhật trạng thái
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GateOutRequest {

    /**
     * ID chuyến xe (Trip)
     * Trip phải có status = 'loading'
     */
    @NotNull(message = "Chuyến xe không được để trống")
    private Long tripId;

    /**
     * Danh sách ID các container cần xuất
     * Container phải có status = 'closed' và cùng destination với trip
     */
    @NotEmpty(message = "Danh sách container không được rỗng")
    private List<Long> containerIds;

    /**
     * Ghi chú khi xuất bến
     */
    private String note;
}
