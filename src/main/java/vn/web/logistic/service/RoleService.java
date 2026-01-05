package vn.web.logistic.service;

import java.util.List;

import vn.web.logistic.dto.request.admin.RoleRequest;
import vn.web.logistic.dto.response.admin.RoleResponse;

public interface RoleService {

    // Lấy tất cả Roles
    List<RoleResponse> getAll();

    // Lấy Role theo ID
    RoleResponse getById(Long id);

    // Tạo Role mới
    RoleResponse create(RoleRequest request);

    // Cập nhật Role
    RoleResponse update(Long id, RoleRequest request);

    // Cập nhật trạng thái Role
    RoleResponse updateStatus(Long id, String status);

    // Xóa Role (chỉ xóa được nếu không có user nào đang sử dụng)
    void delete(Long id);
}
