package vn.web.logistic.service;

import java.util.List;

import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.request.admin.ActionTypeRequest;
import vn.web.logistic.dto.response.admin.ActionTypeResponse;
import vn.web.logistic.dto.response.admin.PageResponse;

public interface ActionTypeService {

    // Lấy tất cả ActionType (không phân trang, cho dropdown)
    List<ActionTypeResponse> getAll();

    // Lấy danh sách ActionType với phân trang và tìm kiếm
    PageResponse<ActionTypeResponse> getAll(String keyword, Pageable pageable);

    // Lấy thông tin ActionType theo ID
    ActionTypeResponse getById(Long id);

    // Tạo ActionType mới
    ActionTypeResponse create(ActionTypeRequest request);

    // Cập nhật ActionType
    ActionTypeResponse update(Long id, ActionTypeRequest request);

    // Xóa ActionType
    void delete(Long id);
}
