package vn.web.logistic.dto.request.lastmile;

import java.util.List;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// DTO Request cho chức năng 1: Phân công Shipper (giao hàng)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AssignTaskRequest {

    @NotNull(message = "Shipper ID không được để trống")
    private Long shipperId;

    @NotEmpty(message = "Danh sách đơn hàng không được để trống")
    private List<Long> requestIds;
}
