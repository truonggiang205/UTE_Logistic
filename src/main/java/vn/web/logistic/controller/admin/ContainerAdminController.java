package vn.web.logistic.controller.admin;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.ContainerResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.entity.User;
import vn.web.logistic.service.ContainerAdminService;

@RestController
@RequestMapping("/api/admin/containers")
@RequiredArgsConstructor
public class ContainerAdminController {

    private final ContainerAdminService containerAdminService;

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
            @PathVariable Long id,
            HttpSession session) {

        // Get admin user ID from session
        Long adminUserId = getAdminUserIdFromSession(session);

        ContainerResponse response = containerAdminService.forceUnpack(id, adminUserId);
        return ResponseEntity.ok(ApiResponse.success("Xả bao cưỡng chế thành công", response));
    }

    /**
     * Helper method to get admin user ID from session
     */
    private Long getAdminUserIdFromSession(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return user.getUserId();
        }
        // Fallback for testing or when no session
        return 1L; // Default admin ID
    }
}
