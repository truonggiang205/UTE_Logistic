package vn.web.logistic.service;

import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.response.admin.CustomerDetailResponse;
import vn.web.logistic.dto.response.admin.PageResponse;

public interface CustomerManagementService {

    // Lấy danh sách Customer với phân trang và filter
    PageResponse<CustomerDetailResponse> getAll(String status, String keyword, Pageable pageable);

    // Lấy thông tin chi tiết Customer theo ID (bao gồm tất cả địa chỉ)
    CustomerDetailResponse getById(Long customerId);

    // Lấy thông tin chi tiết Customer theo User ID
    CustomerDetailResponse getByUserId(Long userId);
}
