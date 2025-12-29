package vn.web.logistic.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.ActionTypeForm;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.repository.ActionTypeRepository;

@Service
@RequiredArgsConstructor
public class ActionTypeService {

    private final ActionTypeRepository actionTypeRepository;

    @Transactional(readOnly = true)
    public List<ActionType> findAll() {
        return actionTypeRepository.findAll();
    }

    @Transactional(readOnly = true)
    public ActionType getRequired(Long id) {
        return actionTypeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ActionType not found: " + id));
    }

    @Transactional
    public ActionType create(ActionTypeForm form) {
        if (actionTypeRepository.existsByActionCode(form.getActionCode())) {
            throw new IllegalArgumentException("Action code đã tồn tại");
        }

        ActionType at = ActionType.builder()
                .actionCode(form.getActionCode())
                .actionName(form.getActionName())
                .description(form.getDescription())
                .build();

        return actionTypeRepository.save(at);
    }

    @Transactional
    public ActionType update(Long id, ActionTypeForm form) {
        ActionType at = getRequired(id);

        if (!at.getActionCode().equalsIgnoreCase(form.getActionCode())
                && actionTypeRepository.existsByActionCode(form.getActionCode())) {
            throw new IllegalArgumentException("Action code đã tồn tại");
        }

        at.setActionCode(form.getActionCode());
        at.setActionName(form.getActionName());
        at.setDescription(form.getDescription());
        return actionTypeRepository.save(at);
    }

    @Transactional
    public void delete(Long id) {
        actionTypeRepository.deleteById(id);
    }
}
