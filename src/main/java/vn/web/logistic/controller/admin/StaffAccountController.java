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
import vn.web.logistic.dto.request.admin.StaffAccountRequest;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.StaffAccountResponse;
import vn.web.logistic.service.StaffAccountService;

@RestController
@RequestMapping("/api/admin/staff-accounts")
@RequiredArgsConstructor
public class StaffAccountController {

    private final StaffAccountService staffAccountService;

    /**
     * GET /api/admin/staff-accounts - Lấy danh sách Staff với phân trang và filter
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<StaffAccountResponse>>> getAllStaffAccounts(
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

        PageResponse<StaffAccountResponse> response = staffAccountService.getAll(status, keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/staff-accounts/{id} - Lấy thông tin chi tiết Staff
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<StaffAccountResponse>> getStaffAccountById(@PathVariable Long id) {
        StaffAccountResponse response = staffAccountService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/staff-accounts/roles - Lấy danh sách tất cả roles
     */
    @GetMapping("/roles")
    public ResponseEntity<ApiResponse<List<String>>> getAllRoles() {
        List<String> roles = staffAccountService.getAllRoles();
        return ResponseEntity.ok(ApiResponse.success(roles));
    }

    /**
     * POST /api/admin/staff-accounts - Tạo Staff Account mới
     */
    @PostMapping
    public ResponseEntity<ApiResponse<StaffAccountResponse>> createStaffAccount(
            @Valid @RequestBody StaffAccountRequest request) {
        StaffAccountResponse response = staffAccountService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Tạo tài khoản nhân viên thành công", response));
    }

    /**
     * PUT /api/admin/staff-accounts/{id} - Cập nhật thông tin Staff
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<StaffAccountResponse>> updateStaffAccount(
            @PathVariable Long id,
            @Valid @RequestBody StaffAccountRequest request) {
        StaffAccountResponse response = staffAccountService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật tài khoản thành công", response));
    }

    /**
     * PUT /api/admin/staff-accounts/{id}/status - Cập nhật trạng thái Staff
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<ApiResponse<StaffAccountResponse>> updateStaffAccountStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String status = body.get("status");
        StaffAccountResponse response = staffAccountService.updateStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật trạng thái thành công", response));
    }

    /**
     * PUT /api/admin/staff-accounts/{id}/reset-password - Đặt lại mật khẩu
     */
    @PutMapping("/{id}/reset-password")
    public ResponseEntity<ApiResponse<Void>> resetPassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String newPassword = body.get("password");
        staffAccountService.resetPassword(id, newPassword);
        return ResponseEntity.ok(ApiResponse.success("Đặt lại mật khẩu thành công", null));
    }
}
