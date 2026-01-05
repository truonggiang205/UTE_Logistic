package vn.web.logistic.service;

import java.util.List;

import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.request.admin.HubRequest;
import vn.web.logistic.dto.response.admin.HubFilterResponse;
import vn.web.logistic.dto.response.admin.HubResponse;
import vn.web.logistic.dto.response.admin.PageResponse;

public interface HubService {

    // Lấy danh sách Hub cho dropdown/filter (chỉ active)
    List<HubFilterResponse> getHubsForFilter();

    // Lấy danh sách Hub với phân trang và tìm kiếm
    PageResponse<HubResponse> getAll(String status, String hubLevel, String keyword, Pageable pageable);

    // Lấy thông tin Hub theo ID
    HubResponse getById(Long id);

    // Tạo Hub mới
    HubResponse create(HubRequest request);

    // Cập nhật Hub
    HubResponse update(Long id, HubRequest request);

    // Cập nhật trạng thái Hub (active/inactive)
    HubResponse updateStatus(Long id, String status);
}