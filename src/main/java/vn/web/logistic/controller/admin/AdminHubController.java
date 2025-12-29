package vn.web.logistic.controller.admin;

import java.util.Arrays;

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
import vn.web.logistic.dto.HubForm;
import vn.web.logistic.entity.HubLevel;
import vn.web.logistic.service.HubService;

@Controller
@RequestMapping("/admin/hubs")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
public class AdminHubController {

    private final HubService hubService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("hubs", hubService.findAll());
        return "admin/hubs/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("hubForm", new HubForm());
        model.addAttribute("levels", Arrays.asList(HubLevel.values()));
        return "admin/hubs/form";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute("hubForm") HubForm hubForm, BindingResult bindingResult, Model model,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("levels", Arrays.asList(HubLevel.values()));
            return "admin/hubs/form";
        }
        hubService.create(hubForm);
        redirectAttributes.addFlashAttribute("message", "Tạo hub thành công");
        return "redirect:/admin/hubs";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        var hub = hubService.getRequired(id);
        HubForm form = new HubForm();
        form.setHubName(hub.getHubName());
        form.setAddress(hub.getAddress());
        form.setWard(hub.getWard());
        form.setDistrict(hub.getDistrict());
        form.setProvince(hub.getProvince());
        form.setHubLevel(hub.getHubLevel());
        form.setContactPhone(hub.getContactPhone());
        form.setEmail(hub.getEmail());

        model.addAttribute("hub", hub);
        model.addAttribute("hubForm", form);
        model.addAttribute("levels", Arrays.asList(HubLevel.values()));
        return "admin/hubs/form";
    }

    @PostMapping("/{id}/edit")
    public String edit(@PathVariable Long id, @Valid @ModelAttribute("hubForm") HubForm hubForm,
            BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("hub", hubService.getRequired(id));
            model.addAttribute("levels", Arrays.asList(HubLevel.values()));
            return "admin/hubs/form";
        }
        hubService.update(id, hubForm);
        redirectAttributes.addFlashAttribute("message", "Cập nhật hub thành công");
        return "redirect:/admin/hubs";
    }

    @PostMapping("/{id}/toggle-lock")
    public String toggleLock(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        hubService.toggleLock(id);
        redirectAttributes.addFlashAttribute("message", "Đã cập nhật trạng thái hub");
        return "redirect:/admin/hubs";
    }
}
