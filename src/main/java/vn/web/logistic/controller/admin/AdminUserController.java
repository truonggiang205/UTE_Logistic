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
import vn.web.logistic.dto.UserForm;
import vn.web.logistic.entity.UserStatus;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.service.AdminUserService;
import vn.web.logistic.service.HubService;

@Controller
@RequestMapping("/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
public class AdminUserController {

    private final AdminUserService adminUserService;
    private final RoleRepository roleRepository;
    private final HubService hubService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("users", adminUserService.findAll());
        return "admin/users/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        UserForm form = new UserForm();
        form.setStatus(UserStatus.active);
        model.addAttribute("userForm", form);
        model.addAttribute("roles", roleRepository.findAll());
        model.addAttribute("activeHubs", hubService.findAllActive());
        model.addAttribute("userStatuses", UserStatus.values());
        return "admin/users/form";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute("userForm") UserForm userForm, BindingResult bindingResult,
            Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("roles", roleRepository.findAll());
            model.addAttribute("activeHubs", hubService.findAllActive());
            model.addAttribute("userStatuses", UserStatus.values());
            return "admin/users/form";
        }
        try {
            var user = adminUserService.create(userForm);
            redirectAttributes.addFlashAttribute("message", "Tạo user thành công: " + user.getUsername());
            return "redirect:/admin/users";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("roles", roleRepository.findAll());
            model.addAttribute("activeHubs", hubService.findAllActive());
            model.addAttribute("userStatuses", UserStatus.values());
            model.addAttribute("error", ex.getMessage());
            return "admin/users/form";
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        var user = adminUserService.getRequired(id);
        UserForm form = new UserForm();
        form.setUsername(user.getUsername());
        form.setFullName(user.getFullName());
        form.setEmail(user.getEmail());
        form.setPhone(user.getPhone());
        form.setRoleName(user.getRoles().stream().findFirst().map(r -> r.getRoleName()).orElse(""));
        form.setStatus(user.getStatus());
        if (user.getStaff() != null) {
            if (user.getStaff().getHub() != null) {
                form.setHubId(user.getStaff().getHub().getHubId());
            }
            form.setStaffPosition(user.getStaff().getStaffPosition());
        }

        model.addAttribute("user", user);
        model.addAttribute("userForm", form);
        model.addAttribute("roles", roleRepository.findAll());
        model.addAttribute("activeHubs", hubService.findAllActive());
        model.addAttribute("userStatuses", UserStatus.values());
        return "admin/users/form";
    }

    @PostMapping("/{id}/edit")
    public String edit(@PathVariable Long id, @Valid @ModelAttribute("userForm") UserForm userForm,
            BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("user", adminUserService.getRequired(id));
            model.addAttribute("roles", roleRepository.findAll());
            model.addAttribute("activeHubs", hubService.findAllActive());
            model.addAttribute("userStatuses", UserStatus.values());
            return "admin/users/form";
        }
        try {
            adminUserService.update(id, userForm);
            redirectAttributes.addFlashAttribute("message", "Cập nhật user thành công");
            return "redirect:/admin/users";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("user", adminUserService.getRequired(id));
            model.addAttribute("roles", roleRepository.findAll());
            model.addAttribute("activeHubs", hubService.findAllActive());
            model.addAttribute("userStatuses", UserStatus.values());
            model.addAttribute("error", ex.getMessage());
            return "admin/users/form";
        }
    }

    @PostMapping("/{id}/toggle-lock")
    public String toggleLock(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        adminUserService.toggleLock(id);
        redirectAttributes.addFlashAttribute("message", "Đã cập nhật trạng thái user");
        return "redirect:/admin/users";
    }

    @PostMapping("/{id}/reset-password")
    public String resetPassword(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        String temp = adminUserService.resetPassword(id);
        redirectAttributes.addFlashAttribute("message", "Reset mật khẩu thành công. Mật khẩu tạm: " + temp);
        return "redirect:/admin/users";
    }
}
