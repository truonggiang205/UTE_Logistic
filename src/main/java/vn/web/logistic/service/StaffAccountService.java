package vn.web.logistic.service;

import java.util.List;

import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.request.admin.StaffAccountRequest;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.StaffAccountResponse;

public interface StaffAccountService {

    // Lấy danh sách Staff với phân trang và filter
    PageResponse<StaffAccountResponse> getAll(String status, String keyword, Pageable pageable);

    // Lấy thông tin Staff theo ID
    StaffAccountResponse getById(Long id);

    // Lấy tất cả Roles (để hiển thị trong form)
    List<String> getAllRoles();

    // Tạo Staff Account mới
    StaffAccountResponse create(StaffAccountRequest request);

    // Cập nhật Staff Account
    StaffAccountResponse update(Long id, StaffAccountRequest request);

    // Cập nhật trạng thái Staff Account
    StaffAccountResponse updateStatus(Long id, String status);

    // Đặt lại mật khẩu
    void resetPassword(Long id, String newPassword);
}
