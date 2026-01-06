package vn.web.logistic.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import vn.web.logistic.dto.request.admin.BroadcastEmailRequest;
import vn.web.logistic.dto.response.admin.BroadcastEmailResponse;
import vn.web.logistic.service.SecurityContextService;
import vn.web.logistic.service.impl.BroadcastEmailService;

@RestController
@RequestMapping(path = "/api/admin/broadcast", produces = MediaType.APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class AdminBroadcastController {

    private final BroadcastEmailService broadcastEmailService;
    private final SecurityContextService securityContextService;

    @PostMapping(path = "/email", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<BroadcastEmailResponse> broadcastEmail(@Valid @RequestBody BroadcastEmailRequest request) {
        var actor = securityContextService.getCurrentUser();
        if (actor == null) {
            throw new RuntimeException("Bạn chưa đăng nhập");
        }
        return ResponseEntity.ok(broadcastEmailService.broadcast(actor, request));
    }
}
