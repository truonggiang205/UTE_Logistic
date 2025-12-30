package vn.web.logistic.service;

import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.response.admin.ContainerResponse;
import vn.web.logistic.dto.response.admin.PageResponse;

public interface ContainerAdminService {

    PageResponse<ContainerResponse> searchByCode(String code, Pageable pageable);

    ContainerResponse getById(Long id);

    ContainerResponse forceUnpack(Long id, Long adminUserId);
}
