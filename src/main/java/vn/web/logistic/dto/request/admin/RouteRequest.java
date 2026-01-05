package vn.web.logistic.dto.request.admin;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RouteRequest {

    @NotNull(message = "Hub xuất phát không được để trống")
    private Long fromHubId;

    @NotNull(message = "Hub đích không được để trống")
    private Long toHubId;

    @Positive(message = "Thời gian ước tính phải là số dương")
    private Integer estimatedTime; // phút

    @Size(max = 500, message = "Mô tả không được quá 500 ký tự")
    private String description;
}
