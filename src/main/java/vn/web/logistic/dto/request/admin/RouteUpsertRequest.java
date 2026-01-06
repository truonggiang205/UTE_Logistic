package vn.web.logistic.dto.request.admin;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RouteUpsertRequest {

    @NotNull
    private Long fromHubId;

    @NotNull
    private Long toHubId;

    @NotNull
    @Min(1)
    private Integer estimatedTime;

    @Size(max = 255)
    private String description;
}
