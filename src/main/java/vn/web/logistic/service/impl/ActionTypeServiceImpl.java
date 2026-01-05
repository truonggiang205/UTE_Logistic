package vn.web.logistic.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.admin.ActionTypeRequest;
import vn.web.logistic.dto.response.admin.ActionTypeResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.repository.ActionTypeRepository;
import vn.web.logistic.service.ActionTypeService;

@Slf4j
@Service
@RequiredArgsConstructor
public class ActionTypeServiceImpl implements ActionTypeService {

    private final ActionTypeRepository actionTypeRepository;

    @Override
    public List<ActionTypeResponse> getAll() {
        return actionTypeRepository.findAllByOrderByActionCodeAsc().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public PageResponse<ActionTypeResponse> getAll(String keyword, Pageable pageable) {
        Page<ActionType> page = actionTypeRepository.findWithFilters(keyword, pageable);

        List<ActionTypeResponse> content = page.getContent().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());

        return PageResponse.<ActionTypeResponse>builder()
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
    public ActionTypeResponse getById(Long id) {
        ActionType actionType = actionTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy loại hành động với ID: " + id));
        return toResponse(actionType);
    }

    @Override
    @Transactional
    public ActionTypeResponse create(ActionTypeRequest request) {
        // Chuẩn hóa mã code thành chữ in hoa
        String normalizedCode = request.getActionCode().toUpperCase().trim();

        // Kiểm tra trùng mã code
        if (actionTypeRepository.findByActionCodeIgnoreCase(normalizedCode).isPresent()) {
            throw new RuntimeException("Mã hành động đã tồn tại: " + normalizedCode);
        }

        ActionType actionType = ActionType.builder()
                .actionCode(normalizedCode)
                .actionName(request.getActionName().trim())
                .description(request.getDescription())
                .build();

        actionType = actionTypeRepository.save(actionType);
        log.info("Created new ActionType: {} - {} (ID: {})",
                actionType.getActionCode(), actionType.getActionName(), actionType.getActionTypeId());

        return toResponse(actionType);
    }

    @Override
    @Transactional
    public ActionTypeResponse update(Long id, ActionTypeRequest request) {
        ActionType actionType = actionTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy loại hành động với ID: " + id));

        // Chuẩn hóa mã code
        String normalizedCode = request.getActionCode().toUpperCase().trim();

        // Kiểm tra trùng mã code với ActionType khác
        actionTypeRepository.findByActionCodeIgnoreCase(normalizedCode)
                .ifPresent(existing -> {
                    if (!existing.getActionTypeId().equals(id)) {
                        throw new RuntimeException("Mã hành động đã tồn tại: " + normalizedCode);
                    }
                });

        actionType.setActionCode(normalizedCode);
        actionType.setActionName(request.getActionName().trim());
        actionType.setDescription(request.getDescription());

        actionType = actionTypeRepository.save(actionType);
        log.info("Updated ActionType ID: {} -> {}", id, actionType.getActionCode());

        return toResponse(actionType);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        ActionType actionType = actionTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy loại hành động với ID: " + id));

        // TODO: Có thể cần kiểm tra xem ActionType này có đang được sử dụng không trước
        // khi xóa

        actionTypeRepository.delete(actionType);
        log.info("Deleted ActionType: {} (ID: {})", actionType.getActionCode(), id);
    }

    // =============== Helper Methods ===============

    private ActionTypeResponse toResponse(ActionType actionType) {
        return ActionTypeResponse.builder()
                .actionTypeId(actionType.getActionTypeId())
                .actionCode(actionType.getActionCode())
                .actionName(actionType.getActionName())
                .description(actionType.getDescription())
                .build();
    }
}
