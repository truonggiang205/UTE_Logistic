package vn.web.logistic.controller.admin;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
import vn.web.logistic.dto.request.admin.HubRequest;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.HubFilterResponse;
import vn.web.logistic.dto.response.admin.HubResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.service.HubService;

@RestController
@RequestMapping("/api/admin/hubs")
@RequiredArgsConstructor
public class HubController {

    private final HubService hubService;

    /**
     * GET /api/admin/hubs/filter - Lấy danh sách Hub cho dropdown/filter (chỉ
     * active)
     */
    @GetMapping("/filter")
    public ResponseEntity<List<HubFilterResponse>> getHubsForFilter() {
        return ResponseEntity.ok(hubService.getHubsForFilter());
    }

    /**
     * GET /api/admin/hubs - Lấy danh sách Hub với phân trang và filter
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<HubResponse>>> getAllHubs(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String hubLevel,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<HubResponse> response = hubService.getAll(status, hubLevel, keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/hubs/{id} - Lấy thông tin chi tiết Hub
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<HubResponse>> getHubById(@PathVariable Long id) {
        HubResponse response = hubService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * POST /api/admin/hubs - Tạo Hub mới
     */
    @PostMapping
    public ResponseEntity<ApiResponse<HubResponse>> createHub(
            @Valid @RequestBody HubRequest request) {
        HubResponse response = hubService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Thêm Hub mới thành công", response));
    }

    /**
     * PUT /api/admin/hubs/{id} - Cập nhật thông tin Hub
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<HubResponse>> updateHub(
            @PathVariable Long id,
            @Valid @RequestBody HubRequest request) {
        HubResponse response = hubService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật Hub thành công", response));
    }

    /**
     * PUT /api/admin/hubs/{id}/status - Cập nhật trạng thái Hub (active/inactive)
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<ApiResponse<HubResponse>> updateHubStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String status = body.get("status");
        HubResponse response = hubService.updateStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật trạng thái Hub thành công", response));
    }
}