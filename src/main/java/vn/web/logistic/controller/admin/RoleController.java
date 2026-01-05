package vn.web.logistic.controller.admin;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.admin.RoleRequest;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.RoleResponse;
import vn.web.logistic.service.RoleService;

@RestController
@RequestMapping("/api/admin/roles")
@RequiredArgsConstructor
public class RoleController {

    private final RoleService roleService;

    /**
     * GET /api/admin/roles - Lấy tất cả Roles
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<RoleResponse>>> getAllRoles() {
        List<RoleResponse> roles = roleService.getAll();
        return ResponseEntity.ok(ApiResponse.success(roles));
    }

    /**
     * GET /api/admin/roles/{id} - Lấy thông tin chi tiết Role
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RoleResponse>> getRoleById(@PathVariable Long id) {
        RoleResponse response = roleService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * POST /api/admin/roles - Tạo Role mới
     */
    @PostMapping
    public ResponseEntity<ApiResponse<RoleResponse>> createRole(
            @Valid @RequestBody RoleRequest request) {
        RoleResponse response = roleService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Tạo role mới thành công", response));
    }

    /**
     * PUT /api/admin/roles/{id} - Cập nhật thông tin Role
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RoleResponse>> updateRole(
            @PathVariable Long id,
            @Valid @RequestBody RoleRequest request) {
        RoleResponse response = roleService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật role thành công", response));
    }

    /**
     * PUT /api/admin/roles/{id}/status - Cập nhật trạng thái Role
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<ApiResponse<RoleResponse>> updateRoleStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String status = body.get("status");
        RoleResponse response = roleService.updateStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật trạng thái thành công", response));
    }

    /**
     * DELETE /api/admin/roles/{id} - Xóa Role
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteRole(@PathVariable Long id) {
        roleService.delete(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa role thành công", null));
    }
}
