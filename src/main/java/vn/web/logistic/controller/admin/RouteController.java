package vn.web.logistic.controller.admin;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.admin.RouteRequest;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.RouteAdminResponse;
import vn.web.logistic.service.RouteService;

@RestController
@RequestMapping("/api/admin/routes")
@RequiredArgsConstructor
public class RouteController {

    private final RouteService routeService;

    /**
     * GET /api/admin/routes/all - Lấy tất cả Route (không phân trang, cho dropdown)
     */
    @GetMapping("/all")
    public ResponseEntity<List<RouteAdminResponse>> getAllRoutesSimple() {
        return ResponseEntity.ok(routeService.getAll());
    }

    /**
     * GET /api/admin/routes - Lấy danh sách Route với phân trang và filter
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<RouteAdminResponse>>> getAllRoutes(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "routeId") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<RouteAdminResponse> response = routeService.getAll(keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/routes/{id} - Lấy thông tin chi tiết Route
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RouteAdminResponse>> getRouteById(@PathVariable Long id) {
        RouteAdminResponse response = routeService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * POST /api/admin/routes - Tạo Route mới
     */
    @PostMapping
    public ResponseEntity<ApiResponse<RouteAdminResponse>> createRoute(
            @Valid @RequestBody RouteRequest request) {
        RouteAdminResponse response = routeService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Thêm tuyến vận chuyển mới thành công", response));
    }

    /**
     * PUT /api/admin/routes/{id} - Cập nhật thông tin Route
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RouteAdminResponse>> updateRoute(
            @PathVariable Long id,
            @Valid @RequestBody RouteRequest request) {
        RouteAdminResponse response = routeService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật tuyến vận chuyển thành công", response));
    }

    /**
     * DELETE /api/admin/routes/{id} - Xóa Route
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteRoute(@PathVariable Long id) {
        routeService.delete(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa tuyến vận chuyển thành công", null));
    }
}
