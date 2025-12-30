package vn.web.logistic.service;

import org.springframework.data.domain.Pageable;
import vn.web.logistic.dto.response.PageResponse;
import vn.web.logistic.dto.response.TripResponse;

import java.time.LocalDate;

public interface TripMonitorService {

    PageResponse<TripResponse> getAll(Long fromHubId, Long toHubId, String status, LocalDate date, Pageable pageable);

    TripResponse getById(Long id);
}
