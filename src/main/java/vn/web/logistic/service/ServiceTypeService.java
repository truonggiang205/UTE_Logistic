package vn.web.logistic.service;

import vn.web.logistic.dto.request.admin.ServiceTypeRequest;
import vn.web.logistic.dto.response.admin.ServiceTypeResponse;

import java.util.List;

public interface ServiceTypeService {

    // 1. Lấy tất cả và convert sang Response DTO
    List<ServiceTypeResponse> getAll();

    // 2. Lấy chi tiết
    ServiceTypeResponse getById(Long id);

    // 3. Tạo mới (Nhận Request -> Lưu Entity -> Trả về Response)
    ServiceTypeResponse create(ServiceTypeRequest request);

    // 4. Cập nhật
    ServiceTypeResponse update(Long id, ServiceTypeRequest request);

    // 5. Xóa
    void delete(Long id);
}