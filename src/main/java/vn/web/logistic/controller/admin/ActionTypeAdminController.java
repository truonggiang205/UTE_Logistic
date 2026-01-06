package vn.web.logistic.controller.admin;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import vn.web.logistic.dto.request.admin.ActionTypeUpsertRequest;
import vn.web.logistic.dto.response.admin.ActionTypeAdminResponse;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.repository.ActionTypeRepository;
import vn.web.logistic.repository.ParcelActionRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.service.SecurityContextService;

@RestController
@RequestMapping("/api/admin/action-types")
@RequiredArgsConstructor
public class ActionTypeAdminController {

    private final ActionTypeRepository actionTypeRepository;
    private final ParcelActionRepository parcelActionRepository;
    private final SystemLogRepository systemLogRepository;
    private final SecurityContextService securityContextService;

    @GetMapping
    public ResponseEntity<List<ActionTypeAdminResponse>> getAll() {
        List<ActionTypeAdminResponse> data = actionTypeRepository.findAll().stream()
                .sorted(Comparator.comparing(ActionType::getActionCode, Comparator.nullsLast(String::compareToIgnoreCase)))
                .map(this::toResponse)
                .toList();
        return ResponseEntity.ok(data);
    }

    @PostMapping
    public ResponseEntity<ActionTypeAdminResponse> create(@Valid @RequestBody ActionTypeUpsertRequest request) {
        String code = normalizeCode(request.getActionCode());
        actionTypeRepository.findByActionCode(code).ifPresent(at -> {
            throw new RuntimeException("ActionCode đã tồn tại: " + code);
        });

        ActionType at = ActionType.builder()
                .actionCode(code)
                .actionName(request.getActionName() != null ? request.getActionName().trim() : null)
                .description(request.getDescription() != null ? request.getDescription().trim() : null)
                .build();

        ActionType saved = actionTypeRepository.save(at);
        logAdminAction("ADMIN_CREATE_ACTION_TYPE", "ACTION_TYPE", saved.getActionTypeId());
        return ResponseEntity.ok(toResponse(saved));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ActionTypeAdminResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody ActionTypeUpsertRequest request
    ) {
        ActionType at = actionTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy ActionType"));

        String code = normalizeCode(request.getActionCode());
        actionTypeRepository.findByActionCode(code).ifPresent(existing -> {
            if (!existing.getActionTypeId().equals(id)) {
                throw new RuntimeException("ActionCode đã tồn tại: " + code);
            }
        });

        at.setActionCode(code);
        at.setActionName(request.getActionName() != null ? request.getActionName().trim() : null);
        at.setDescription(request.getDescription() != null ? request.getDescription().trim() : null);

        ActionType saved = actionTypeRepository.save(at);
        logAdminAction("ADMIN_UPDATE_ACTION_TYPE", "ACTION_TYPE", saved.getActionTypeId());
        return ResponseEntity.ok(toResponse(saved));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        if (!actionTypeRepository.existsById(id)) {
            throw new RuntimeException("Không tìm thấy ActionType");
        }

        if (parcelActionRepository.existsByActionType_ActionTypeId(id)) {
            throw new RuntimeException("Không thể xóa ActionType vì đã được sử dụng trong lịch sử đơn hàng");
        }

        actionTypeRepository.deleteById(id);
        logAdminAction("ADMIN_DELETE_ACTION_TYPE", "ACTION_TYPE", id);
        return ResponseEntity.ok().build();
    }

    private ActionTypeAdminResponse toResponse(ActionType at) {
        return ActionTypeAdminResponse.builder()
                .actionTypeId(at.getActionTypeId())
                .actionCode(at.getActionCode())
                .actionName(at.getActionName())
                .description(at.getDescription())
                .build();
    }

    private String normalizeCode(String code) {
        if (code == null) {
            return null;
        }
        return code.trim().toUpperCase();
    }

    private void logAdminAction(String action, String objectType, Long objectId) {
        var actor = securityContextService.getCurrentUser();
        if (actor == null) {
            return;
        }

        systemLogRepository.save(SystemLog.builder()
                .user(actor)
                .action(action)
                .objectType(objectType)
                .objectId(objectId)
                .logTime(LocalDateTime.now())
                .build());
    }
}
