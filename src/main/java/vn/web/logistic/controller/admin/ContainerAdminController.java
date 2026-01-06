package vn.web.logistic.controller.admin;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.ContainerResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.service.ContainerAdminService;
import vn.web.logistic.service.SecurityContextService;

@Slf4j
@RestController
@RequestMapping("/api/admin/containers")
@RequiredArgsConstructor
public class ContainerAdminController {

    private final ContainerAdminService containerAdminService;
    private final SecurityContextService securityContextService;

    /**
     * GET /api/admin/containers - Tìm kiếm bao hàng (Search by code)
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<ContainerResponse>>> searchContainers(
            @RequestParam(required = false, defaultValue = "") String code,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<ContainerResponse> response = containerAdminService.searchByCode(code, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/containers/{id} - Lấy chi tiết bao hàng
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ContainerResponse>> getContainerById(@PathVariable Long id) {
        ContainerResponse response = containerAdminService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * POST /api/admin/containers/{id}/force-unpack - Xả bao cưỡng chế
     * Logic: Admin buộc set status thành "unpacked" và cập nhật trạng thái các đơn
     * hàng bên trong
     * Log: Ghi lại log Admin đã thực hiện hành động này
     */
    @PostMapping("/{id}/force-unpack")
    public ResponseEntity<ApiResponse<ContainerResponse>> forceUnpackContainer(@PathVariable Long id) {
        // Lấy admin user ID từ SecurityContextService
        Long adminUserId = securityContextService.getCurrentUserId();
        if (adminUserId == null) {
            log.warn("Không tìm thấy user trong SecurityContext, sử dụng ID mặc định = 1");
            adminUserId = 1L;
        }

        ContainerResponse response = containerAdminService.forceUnpack(id, adminUserId);
        return ResponseEntity.ok(ApiResponse.success("Xả bao cưỡng chế thành công", response));
    }
}
