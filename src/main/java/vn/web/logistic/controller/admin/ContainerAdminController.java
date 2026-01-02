package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.ContainerResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.ContainerAdminService;

@Slf4j
@RestController
@RequestMapping("/api/admin/containers")
@RequiredArgsConstructor
public class ContainerAdminController {

    private final ContainerAdminService containerAdminService;
    private final UserRepository userRepository;

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
    public ResponseEntity<ApiResponse<ContainerResponse>> forceUnpackContainer(
            @PathVariable Long id) {

        // Get admin user ID from Spring Security
        Long adminUserId = getCurrentUserId();

        ContainerResponse response = containerAdminService.forceUnpack(id, adminUserId);
        return ResponseEntity.ok(ApiResponse.success("Xả bao cưỡng chế thành công", response));
    }

    // ===================================================================
    // HELPER METHODS - Spring Security Authentication
    // ===================================================================

    /**
     * Lấy User hiện tại từ Spring Security
     */
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }

        String email = authentication.getName();
        return userRepository.findByEmail(email).orElse(null);
    }

    /**
     * Lấy UserId hiện tại từ Spring Security
     */
    private Long getCurrentUserId() {
        User user = getCurrentUser();
        if (user != null) {
            return user.getUserId();
        }
        log.warn("Không tìm thấy user trong SecurityContext, sử dụng ID mặc định = 1");
        return 1L;
    }
}
