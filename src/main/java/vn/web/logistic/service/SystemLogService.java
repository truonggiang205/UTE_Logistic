package vn.web.logistic.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.web.logistic.dto.request.LogFilterRequest;
import vn.web.logistic.dto.request.ReportRequest; // Import mới
import vn.web.logistic.dto.response.MonitorStatsResponse;
import vn.web.logistic.dto.response.WarningResponse;
import vn.web.logistic.entity.SystemLog;
import java.io.ByteArrayInputStream; // Import mới

public interface SystemLogService {

    // 1. Logs
    Page<SystemLog> getLogs(LogFilterRequest request, Pageable pageable);

    // 2. Stats
    MonitorStatsResponse getStatistics(LogFilterRequest request);

    // 3. Risk Warning (Đã làm ở bước trước)
    WarningResponse getRiskWarnings();

    // 4. Export Report (Thêm mới vào đây)
    ByteArrayInputStream exportReport(ReportRequest request);
}