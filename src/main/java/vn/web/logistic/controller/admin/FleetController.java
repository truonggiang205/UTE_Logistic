package vn.web.logistic.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import vn.web.logistic.dto.request.admin.VehicleRequest;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.VehicleResponse;
import vn.web.logistic.service.VehicleService;

@RestController
@RequestMapping("/api/admin/vehicles")
@RequiredArgsConstructor
public class FleetController {

    private final VehicleService vehicleService;

    /**
     * POST /api/admin/vehicles - Thêm xe mới
     */
    @PostMapping
    public ResponseEntity<ApiResponse<VehicleResponse>> createVehicle(
            @Valid @RequestBody VehicleRequest request) {
        VehicleResponse response = vehicleService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Thêm xe mới thành công", response));
    }

    /**
     * PUT /api/admin/vehicles/{id} - Cập nhật thông tin xe
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<VehicleResponse>> updateVehicle(
            @PathVariable Long id,
            @Valid @RequestBody VehicleRequest request) {
        VehicleResponse response = vehicleService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật xe thành công", response));
    }

    /**
     * GET /api/admin/vehicles - Lấy danh sách xe (có phân trang, lọc theo Hub)
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<VehicleResponse>>> getAllVehicles(
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String plateNumber,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<VehicleResponse> response = vehicleService.getAll(hubId, status, plateNumber, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/vehicles/{id} - Lấy thông tin chi tiết xe
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<VehicleResponse>> getVehicleById(@PathVariable Long id) {
        VehicleResponse response = vehicleService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * DELETE /api/admin/vehicles/{id} - Xóa xe
     * Logic: Nếu xe đang có status "in_transit", chặn và ném lỗi
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteVehicle(@PathVariable Long id) {
        vehicleService.delete(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa xe thành công", null));
    }
}
