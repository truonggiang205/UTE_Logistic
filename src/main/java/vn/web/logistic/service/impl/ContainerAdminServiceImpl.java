package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.dto.response.admin.ContainerResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.entity.Container;
import vn.web.logistic.entity.Container.ContainerStatus;
import vn.web.logistic.entity.ContainerDetail;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.entity.User;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.exception.ResourceNotFoundException;
import vn.web.logistic.repository.ContainerDetailRepository;
import vn.web.logistic.repository.ContainerRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.ContainerAdminService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class ContainerAdminServiceImpl implements ContainerAdminService {

    private final ContainerRepository containerRepository;
    private final ContainerDetailRepository containerDetailRepository;
    private final ServiceRequestRepository serviceRequestRepository;
    private final SystemLogRepository systemLogRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional(readOnly = true)
    public PageResponse<ContainerResponse> searchByCode(String code, Pageable pageable) {
        Page<Container> page = containerRepository.searchByCode(code, pageable);

        List<ContainerResponse> content = page.getContent().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());

        return PageResponse.<ContainerResponse>builder()
                .content(content)
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .first(page.isFirst())
                .last(page.isLast())
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public ContainerResponse getById(Long id) {
        Container container = containerRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId", id));
        return mapToResponse(container);
    }

    @Override
    public ContainerResponse forceUnpack(Long id, Long adminUserId) {
        Container container = containerRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new ResourceNotFoundException("Container", "containerId", id));

        // Validate current status - can only force unpack if not already unpacked
        if (container.getStatus() == ContainerStatus.unpacked) {
            throw new BusinessException("ALREADY_UNPACKED", "Bao hàng đã được xả trước đó");
        }

        // Get admin user for logging
        User adminUser = userRepository.findById(adminUserId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "userId", adminUserId));

        // Update container status to unpacked
        container.setStatus(ContainerStatus.unpacked);
        containerRepository.save(container);

        // Update status of all service requests inside this container
        // Set them to current hub = destination hub so they can continue processing
        List<ContainerDetail> details = containerDetailRepository.findByContainerIdWithRequest(id);
        for (ContainerDetail detail : details) {
            ServiceRequest request = detail.getRequest();
            if (request != null) {
                // Update current hub to container's destination hub
                request.setCurrentHub(container.getDestinationHub());
                serviceRequestRepository.save(request);
            }
        }

        // Log the admin action
        SystemLog logEntry = SystemLog.builder()
                .user(adminUser)
                .action("FORCE_UNPACK_CONTAINER")
                .objectType("CONTAINER")
                .objectId(container.getContainerId())
                .logTime(LocalDateTime.now())
                .build();
        systemLogRepository.save(logEntry);

        log.warn("Admin {} performed FORCE_UNPACK on container {} ({})",
                adminUser.getUsername(), container.getContainerId(), container.getContainerCode());

        return mapToResponse(container);
    }

    private ContainerResponse mapToResponse(Container container) {
        return ContainerResponse.builder()
                .containerId(container.getContainerId())
                .containerCode(container.getContainerCode())
                .type(container.getType().name())
                .weight(container.getWeight())
                .createdAtHubId(container.getCreatedAtHub().getHubId())
                .createdAtHubName(container.getCreatedAtHub().getHubName())
                .destinationHubId(container.getDestinationHub().getHubId())
                .destinationHubName(container.getDestinationHub().getHubName())
                .createdById(container.getCreatedBy().getUserId())
                .createdByName(container.getCreatedBy().getFullName())
                .status(container.getStatus().name())
                .createdAt(container.getCreatedAt())
                .build();
    }
}
