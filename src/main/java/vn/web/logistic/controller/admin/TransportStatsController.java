package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import vn.web.logistic.dto.response.ApiResponse;
import vn.web.logistic.dto.response.TransportReportResponse;
import vn.web.logistic.dto.response.TransportStatsResponse;
import vn.web.logistic.service.TransportStatsService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/admin/stats")
@RequiredArgsConstructor
public class TransportStatsController {

    private final TransportStatsService transportStatsService;

    /**
     * GET /api/admin/stats/transport - Trả về số liệu dashboard vận tải
     * Response:
     * - totalVehicles: Tổng số xe
     * - activeVehicles: Số xe đang status "in_transit"
     * - availableVehicles: Số xe đang status "available"
     * - loadFactor: Tính trung bình % lấp đầy tải trọng
     */
    @GetMapping("/transport")
    public ResponseEntity<ApiResponse<TransportStatsResponse>> getTransportStats() {
        TransportStatsResponse response = transportStatsService.getTransportStats();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/stats/transport-report - Trả về báo cáo vận tải theo ngày
     * Query params:
     * - fromDate: Ngày bắt đầu (yyyy-MM-dd)
     * - toDate: Ngày kết thúc (yyyy-MM-dd)
     * Response:
     * - dailyStats: Danh sách thống kê theo từng ngày
     */
    @GetMapping("/transport-report")
    public ResponseEntity<ApiResponse<TransportReportResponse>> getTransportReport(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        TransportReportResponse response = transportStatsService.getTransportReport(fromDate, toDate);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
