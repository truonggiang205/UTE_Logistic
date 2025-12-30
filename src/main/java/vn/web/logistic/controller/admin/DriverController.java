package vn.web.logistic.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.DriverRequest;
import vn.web.logistic.dto.response.ApiResponse;
import vn.web.logistic.dto.response.DriverResponse;
import vn.web.logistic.dto.response.PageResponse;
import vn.web.logistic.service.DriverService;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/drivers")
@RequiredArgsConstructor
public class DriverController {

    private final DriverService driverService;

    /**
     * POST /api/admin/drivers - Thêm tài xế mới
     * Logic: Kiểm tra trùng identity_card hoặc license_number
     */
    @PostMapping
    public ResponseEntity<ApiResponse<DriverResponse>> createDriver(
            @Valid @RequestBody DriverRequest request) {
        DriverResponse response = driverService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Thêm tài xế mới thành công", response));
    }

    /**
     * GET /api/admin/drivers - Lấy danh sách tài xế
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<DriverResponse>>> getAllDrivers(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<DriverResponse> response = driverService.getAll(status, keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/drivers/{id} - Lấy thông tin chi tiết tài xế
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<DriverResponse>> getDriverById(@PathVariable Long id) {
        DriverResponse response = driverService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * PUT /api/admin/drivers/{id} - Cập nhật thông tin tài xế
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<DriverResponse>> updateDriver(
            @PathVariable Long id,
            @Valid @RequestBody DriverRequest request) {
        DriverResponse response = driverService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật tài xế thành công", response));
    }

    /**
     * PUT /api/admin/drivers/{id}/status - Cập nhật trạng thái tài xế
     * VD: Khóa tài xế - set status = "inactive"
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<ApiResponse<DriverResponse>> updateDriverStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String status = body.get("status");
        DriverResponse response = driverService.updateStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật trạng thái tài xế thành công", response));
    }
}
