package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import vn.web.logistic.dto.response.admin.HubFilterResponse;
import vn.web.logistic.service.HubService;

import java.util.List;

@RestController
@RequestMapping("/api/admin/hubs")
@RequiredArgsConstructor
public class HubController {

    private final HubService hubService;

    @GetMapping("/filter")
    public ResponseEntity<List<HubFilterResponse>> getHubsForFilter() {
        return ResponseEntity.ok(hubService.getHubsForFilter());
    }
}