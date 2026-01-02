package vn.web.logistic.dto.request.lastmile;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConfirmPickupRequest {

    @NotNull(message = "Task ID không được để trống")
    private Long taskId;

    private String note;
}
