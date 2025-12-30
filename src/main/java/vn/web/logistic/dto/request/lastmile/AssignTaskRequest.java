package vn.web.logistic.dto.request.lastmile;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

// DTO Request cho chức năng 1: Phân công Shipper (Assign Task)
// Manager chọn danh sách đơn hàng và gán cho một Shipper đi giao
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AssignTaskRequest {

    // ID của Shipper được phân công
    @NotNull(message = "Shipper ID không được để trống")
    private Long shipperId;

    // Danh sách ID các đơn hàng cần giao
    @NotNull(message = "Danh sách đơn hàng không được để trống")
    @Size(min = 1, message = "Phải có ít nhất 1 đơn hàng")
    private List<Long> requestIds;
}
