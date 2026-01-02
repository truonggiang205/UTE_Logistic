package vn.web.logistic.dto.request.outbound;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho chức năng TẠO BAO MỚI (Create Container)
 * Nhập mã bao, loại bao, đích đến
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateContainerRequest {

    /**
     * Mã bao (container code) - unique
     */
    @NotBlank(message = "Mã bao không được để trống")
    private String containerCode;

    /**
     * Loại bao: standard, fragile, frozen, express
     */
    private String containerType;

    /**
     * ID Hub hiện tại (nơi tạo bao)
     */
    @NotNull(message = "Hub hiện tại không được để trống")
    private Long currentHubId;

    /**
     * ID Hub đích (nơi bao sẽ được gửi đến)
     */
    @NotNull(message = "Hub đích không được để trống")
    private Long destinationHubId;
}
