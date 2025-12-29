package vn.web.logistic.controller.admin;

import java.util.List;

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
import vn.web.logistic.dto.RouteForm;
import vn.web.logistic.service.HubService;
import vn.web.logistic.service.RouteService;

@Controller
@RequestMapping("/admin/routes")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
public class AdminRouteController {

    private final RouteService routeService;
    private final HubService hubService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("routes", routeService.findAll());
        return "admin/routes/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("routeForm", new RouteForm());
        model.addAttribute("activeHubs", hubService.findAllActive());
        return "admin/routes/form";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute("routeForm") RouteForm routeForm, BindingResult bindingResult,
            Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("activeHubs", hubService.findAllActive());
            return "admin/routes/form";
        }
        try {
            routeService.create(routeForm);
            redirectAttributes.addFlashAttribute("message", "Tạo tuyến thành công");
            return "redirect:/admin/routes";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("activeHubs", hubService.findAllActive());
            model.addAttribute("error", ex.getMessage());
            return "admin/routes/form";
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        var route = routeService.getRequired(id);
        RouteForm form = new RouteForm();
        form.setFromHubId(route.getFromHub().getHubId());
        form.setToHubId(route.getToHub().getHubId());
        form.setLeadTime(route.getEstimatedTime());
        form.setDescription(route.getDescription());

        model.addAttribute("route", route);
        model.addAttribute("routeForm", form);
        model.addAttribute("activeHubs", hubService.findAllActive());
        return "admin/routes/form";
    }

    @PostMapping("/{id}/edit")
    public String edit(@PathVariable Long id, @Valid @ModelAttribute("routeForm") RouteForm routeForm,
            BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("route", routeService.getRequired(id));
            model.addAttribute("activeHubs", hubService.findAllActive());
            return "admin/routes/form";
        }
        try {
            routeService.update(id, routeForm);
            redirectAttributes.addFlashAttribute("message", "Cập nhật tuyến thành công");
            return "redirect:/admin/routes";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("route", routeService.getRequired(id));
            model.addAttribute("activeHubs", hubService.findAllActive());
            model.addAttribute("error", ex.getMessage());
            return "admin/routes/form";
        }
    }

    @PostMapping("/{id}/toggle")
    public String toggle(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        routeService.toggleInactive(id);
        redirectAttributes.addFlashAttribute("message", "Đã cập nhật trạng thái tuyến");
        return "redirect:/admin/routes";
    }
}
