package vn.web.logistic.dto.response.admin;

import lombok.Builder;
import lombok.Data;
import java.util.List;
import java.math.BigDecimal;

@Data
@Builder
public class ChartResponse {
    private List<String> labels; // Trục hoành (Ngày)
    private List<BigDecimal> data; // Trục tung (Doanh thu)
}