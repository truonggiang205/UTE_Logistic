package vn.web.logistic.config;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.service.SecurityContextService;

@ControllerAdvice(annotations = Controller.class)
@RequiredArgsConstructor
public class CurrentUserModelAdvice {

    private final SecurityContextService securityContextService;

    @ModelAttribute("currentUserAvatarUrl")
    public String currentUserAvatarUrl() {
        var user = securityContextService.getCurrentUser();
        if (user == null) {
            return null;
        }
        return user.getAvatarUrl();
    }
}
