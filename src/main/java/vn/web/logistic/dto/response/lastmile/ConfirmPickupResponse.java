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
public class ConfirmPickupResponse {
    private Long taskId;
    private Long requestId;
    private String trackingCode;
    private String taskStatus;
    private String requestStatus;
    private String note;
    private Long actionId;
    private String actionType;
    private LocalDateTime recordedAt;
}
