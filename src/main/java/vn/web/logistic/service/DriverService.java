package vn.web.logistic.service;

import org.springframework.data.domain.Pageable;
import vn.web.logistic.dto.request.DriverRequest;
import vn.web.logistic.dto.response.DriverResponse;
import vn.web.logistic.dto.response.PageResponse;

public interface DriverService {

    DriverResponse create(DriverRequest request);

    DriverResponse update(Long id, DriverRequest request);

    DriverResponse updateStatus(Long id, String status);

    DriverResponse getById(Long id);

    PageResponse<DriverResponse> getAll(String status, String keyword, Pageable pageable);
}
