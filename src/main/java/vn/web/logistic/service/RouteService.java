package vn.web.logistic.service;

import java.util.List;

import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.request.admin.RouteRequest;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.RouteAdminResponse;

public interface RouteService {

    // Lấy tất cả Route (không phân trang, cho các view đơn giản)
    List<RouteAdminResponse> getAll();

    // Lấy danh sách Route với phân trang và tìm kiếm
    PageResponse<RouteAdminResponse> getAll(String keyword, Pageable pageable);

    // Lấy thông tin Route theo ID
    RouteAdminResponse getById(Long id);

    // Tạo Route mới
    RouteAdminResponse create(RouteRequest request);

    // Cập nhật Route
    RouteAdminResponse update(Long id, RouteRequest request);

    // Xóa Route
    void delete(Long id);
}
