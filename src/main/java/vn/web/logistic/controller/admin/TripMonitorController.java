package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.response.ApiResponse;
import vn.web.logistic.dto.response.PageResponse;
import vn.web.logistic.dto.response.TripResponse;
import vn.web.logistic.service.TripMonitorService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/admin/trips")
@RequiredArgsConstructor
public class TripMonitorController {

    private final TripMonitorService tripMonitorService;

    /**
     * GET /api/admin/trips - Lấy danh sách chuyến xe (Read-only)
     * Filter: from_hub_id, to_hub_id, status, date
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<TripResponse>>> getAllTrips(
            @RequestParam(required = false) Long fromHubId,
            @RequestParam(required = false) Long toHubId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<TripResponse> response = tripMonitorService.getAll(fromHubId, toHubId, status, date, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/trips/{id} - Xem chi tiết chuyến xe
     * Response: Thông tin Xe, Tài xế, và danh sách Bao hàng trên xe
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TripResponse>> getTripById(@PathVariable Long id) {
        TripResponse response = tripMonitorService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
