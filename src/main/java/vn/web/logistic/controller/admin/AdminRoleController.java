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
import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.RoleForm;
import vn.web.logistic.entity.RoleStatus;
import vn.web.logistic.service.RoleService;

@Controller
@RequestMapping("/admin/roles")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
public class AdminRoleController {

    private final RoleService roleService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("roles", roleService.findAll());
        return "admin/roles/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        RoleForm form = new RoleForm();
        form.setStatus(RoleStatus.active);
        model.addAttribute("roleForm", form);
        model.addAttribute("roleStatuses", RoleStatus.values());
        return "admin/roles/form";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute("roleForm") RoleForm roleForm, BindingResult bindingResult,
            Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("roleStatuses", RoleStatus.values());
            return "admin/roles/form";
        }
        try {
            roleService.create(roleForm);
            redirectAttributes.addFlashAttribute("message", "Tạo role thành công");
            return "redirect:/admin/roles";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("roleStatuses", RoleStatus.values());
            model.addAttribute("error", ex.getMessage());
            return "admin/roles/form";
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        var role = roleService.getRequired(id);
        RoleForm form = new RoleForm();
        form.setRoleName(role.getRoleName());
        form.setDescription(role.getDescription());
        form.setStatus(role.getStatus());
        model.addAttribute("role", role);
        model.addAttribute("roleForm", form);
        model.addAttribute("roleStatuses", RoleStatus.values());
        return "admin/roles/form";
    }

    @PostMapping("/{id}/edit")
    public String edit(@PathVariable Long id, @Valid @ModelAttribute("roleForm") RoleForm roleForm,
            BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("role", roleService.getRequired(id));
            model.addAttribute("roleStatuses", RoleStatus.values());
            return "admin/roles/form";
        }
        try {
            roleService.update(id, roleForm);
            redirectAttributes.addFlashAttribute("message", "Cập nhật role thành công");
            return "redirect:/admin/roles";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("role", roleService.getRequired(id));
            model.addAttribute("roleStatuses", RoleStatus.values());
            model.addAttribute("error", ex.getMessage());
            return "admin/roles/form";
        }
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            roleService.delete(id);
            redirectAttributes.addFlashAttribute("message", "Đã xóa role");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
        }
        return "redirect:/admin/roles";
    }
}
