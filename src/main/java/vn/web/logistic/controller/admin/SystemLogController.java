package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.LogFilterRequest;
import vn.web.logistic.dto.response.MonitorStatsResponse;
import vn.web.logistic.dto.response.WarningResponse;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.service.SystemLogService;

@RestController
@RequestMapping("/api/v1/monitoring")
@RequiredArgsConstructor
public class SystemLogController {

    private final SystemLogService monitoringService;

    // API lấy dữ liệu cho bảng Log (Grid Table)
    @PostMapping("/logs")
    public ResponseEntity<Page<SystemLog>> getLogs(
            @RequestBody LogFilterRequest filterRequest,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {

        Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(monitoringService.getLogs(filterRequest, pageable));
    }

    // API lấy dữ liệu thống kê (Dashboard header)
    @PostMapping("/stats")
    public ResponseEntity<MonitorStatsResponse> getStats(@RequestBody LogFilterRequest filterRequest) {
        return ResponseEntity.ok(monitoringService.getStatistics(filterRequest));
    }

    // API Cảnh báo rủi ro (Cho Dashboard Widget màu đỏ)
    @GetMapping("/risks")
    public ResponseEntity<WarningResponse> getRiskWarnings() {
        return ResponseEntity.ok(monitoringService.getRiskWarnings());
    }
}