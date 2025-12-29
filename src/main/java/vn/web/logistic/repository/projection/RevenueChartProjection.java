package vn.web.logistic.repository.projection;

import java.math.BigDecimal;
import java.time.LocalDate;

// Interface này giúp Spring tự động map cột "date" và "revenue" từ SQL vào đây
public interface RevenueChartProjection {
    LocalDate getDate(); // alias: date

    BigDecimal getRevenue(); // alias: revenue
}
