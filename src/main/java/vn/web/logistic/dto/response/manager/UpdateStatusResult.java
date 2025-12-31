package vn.web.logistic.dto.response.manager;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateStatusResult {
    private boolean success;
    private String message;
    private String errorCode; // PENDING_COD, ACTIVE_TASKS, etc.
}
