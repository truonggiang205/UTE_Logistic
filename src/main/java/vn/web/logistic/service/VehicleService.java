package vn.web.logistic.service;

import org.springframework.data.domain.Pageable;
import vn.web.logistic.dto.request.VehicleRequest;
import vn.web.logistic.dto.response.PageResponse;
import vn.web.logistic.dto.response.VehicleResponse;

public interface VehicleService {

    VehicleResponse create(VehicleRequest request);

    VehicleResponse update(Long id, VehicleRequest request);

    void delete(Long id);

    VehicleResponse getById(Long id);

    PageResponse<VehicleResponse> getAll(Long hubId, String status, String plateNumber, Pageable pageable);
}
