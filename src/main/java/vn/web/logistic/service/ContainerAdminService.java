package vn.web.logistic.service;

import org.springframework.data.domain.Pageable;
import vn.web.logistic.dto.response.ContainerResponse;
import vn.web.logistic.dto.response.PageResponse;

public interface ContainerAdminService {

    PageResponse<ContainerResponse> searchByCode(String code, Pageable pageable);

    ContainerResponse getById(Long id);

    ContainerResponse forceUnpack(Long id, Long adminUserId);
}
