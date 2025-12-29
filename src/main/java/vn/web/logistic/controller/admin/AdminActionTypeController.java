package vn.web.logistic.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import vn.web.logistic.dto.ActionTypeForm;
import vn.web.logistic.service.ActionTypeService;

@Controller
@RequestMapping("/admin/action-types")
@PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
public class AdminActionTypeController {

    private final ActionTypeService actionTypeService;

    public AdminActionTypeController(ActionTypeService actionTypeService) {
        this.actionTypeService = actionTypeService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("actionTypes", actionTypeService.findAll());
        return "admin/action-types/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("actionTypeForm", new ActionTypeForm());
        return "admin/action-types/form";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute("actionTypeForm") ActionTypeForm form, BindingResult bindingResult,
            Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "admin/action-types/form";
        }
        try {
            actionTypeService.create(form);
            redirectAttributes.addFlashAttribute("message", "Tạo trạng thái thành công");
            return "redirect:/admin/action-types";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            return "admin/action-types/form";
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        var at = actionTypeService.getRequired(id);
        ActionTypeForm form = new ActionTypeForm();
        form.setActionCode(at.getActionCode());
        form.setActionName(at.getActionName());
        form.setDescription(at.getDescription());
        model.addAttribute("actionType", at);
        model.addAttribute("actionTypeForm", form);
        return "admin/action-types/form";
    }

    @PostMapping("/{id}/edit")
    public String edit(@PathVariable Long id, @Valid @ModelAttribute("actionTypeForm") ActionTypeForm form,
            BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("actionType", actionTypeService.getRequired(id));
            return "admin/action-types/form";
        }
        try {
            actionTypeService.update(id, form);
            redirectAttributes.addFlashAttribute("message", "Cập nhật trạng thái thành công");
            return "redirect:/admin/action-types";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("actionType", actionTypeService.getRequired(id));
            model.addAttribute("error", ex.getMessage());
            return "admin/action-types/form";
        }
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        actionTypeService.delete(id);
        redirectAttributes.addFlashAttribute("message", "Đã xóa trạng thái");
        return "redirect:/admin/action-types";
    }
}
