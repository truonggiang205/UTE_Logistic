package vn.web.logistic.dto.response.lastmile;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PickupDelayResponse {
    private Long taskId;
    private Long requestId;
    private String trackingCode;
    private String taskStatus;
    private String requestStatus;
    private String reason;
    private Long actionId;
    private String actionType;
    private LocalDateTime recordedAt;
}
