package vn.web.logistic.controller.manager;

import java.util.HashMap;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.CreateShipperRequest;
import vn.web.logistic.dto.response.manager.ShipperInfoDTO;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.ShipperManagementService;

@RestController
@RequestMapping("/api/manager/shippers")
@RequiredArgsConstructor
public class ShipperManagementController {

    private static final int DEFAULT_PAGE_SIZE = 6;

    private final ShipperManagementService shipperManagementService;
    private final UserRepository userRepository;

    // Lấy danh sách shipper với filter, search, phân trang
    @GetMapping
    public ResponseEntity<?> getAllShippers(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "6") int size) {

        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        Long hubId = getHubIdFromUser(currentUser);
        if (hubId == null) {
            return ResponseEntity.badRequest().body(createErrorResponse("Không tìm thấy Hub"));
        }
        if (size <= 0 || size > 50)
            size = DEFAULT_PAGE_SIZE;

        Page<ShipperInfoDTO> shipperPage = shipperManagementService.getShippers(hubId, status, keyword, page, size);
        Map<String, Object> stats = shipperManagementService.getHubShipperStatistics(hubId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", shipperPage.getContent());
        response.put("count", shipperPage.getNumberOfElements());
        response.put("totalElements", shipperPage.getTotalElements());
        response.put("totalPages", shipperPage.getTotalPages());
        response.put("currentPage", shipperPage.getNumber());
        response.put("pageSize", shipperPage.getSize());
        response.put("hasNext", shipperPage.hasNext());
        response.put("hasPrevious", shipperPage.hasPrevious());
        response.put("stats", stats);

        return ResponseEntity.ok(response);
    }

    // Cập nhật status shipper
    @PutMapping("/{shipperId}/status")
    public ResponseEntity<?> updateShipperStatus(
            @PathVariable Long shipperId,
            @RequestBody Map<String, String> request) {

        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        String status = request.get("status");
        if (status == null || status.isEmpty()) {
            return ResponseEntity.badRequest().body(createErrorResponse("Thiếu status"));
        }

        var result = shipperManagementService.updateShipperStatus(shipperId, status);

        Map<String, Object> response = new HashMap<>();
        response.put("success", result.isSuccess());
        response.put("message", result.getMessage());
        if (result.getErrorCode() != null) {
            response.put("errorCode", result.getErrorCode());
        }

        if (result.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Tạo mới Shipper kèm Account
    @PostMapping
    public ResponseEntity<?> createShipper(
            @Valid @RequestBody CreateShipperRequest request,
            BindingResult bindingResult) {

        // Kiểm tra validation errors từ annotations
        if (bindingResult.hasErrors()) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Dữ liệu không hợp lệ");

            Map<String, String> fieldErrors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(error -> {
                fieldErrors.put(error.getField(), error.getDefaultMessage());
            });
            response.put("errors", fieldErrors);

            return ResponseEntity.badRequest().body(response);
        }

        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        Long hubId = getHubIdFromUser(currentUser);
        if (hubId == null) {
            return ResponseEntity.badRequest().body(createErrorResponse("Không tìm thấy Hub"));
        }

        // Check trùng username/email/phone
        Map<String, String> fieldErrors = new HashMap<>();
        if (shipperManagementService.isUsernameExists(request.getUsername())) {
            fieldErrors.put("username", "Tên đăng nhập đã tồn tại");
        }
        if (shipperManagementService.isEmailExists(request.getEmail())) {
            fieldErrors.put("email", "Email đã được sử dụng");
        }
        if (shipperManagementService.isPhoneExists(request.getPhone())) {
            fieldErrors.put("phone", "Số điện thoại đã được sử dụng");
        }
        if (!fieldErrors.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Dữ liệu không hợp lệ");
            response.put("errors", fieldErrors);
            return ResponseEntity.badRequest().body(response);
        }

        ShipperInfoDTO newShipper = shipperManagementService.createShipper(request, hubId);

        if (newShipper == null) {
            return ResponseEntity.badRequest().body(createErrorResponse("Không thể tạo shipper. Vui lòng thử lại."));
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Tạo shipper thành công! Thông tin đăng nhập: " + request.getUsername());
        response.put("data", newShipper);

        return ResponseEntity.ok(response);
    }

    private User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof UserDetails) {
            String username = ((UserDetails) auth.getPrincipal()).getUsername();
            return userRepository.findByEmail(username).orElse(null);
        }
        return null;
    }

    private Long getHubIdFromUser(User user) {
        if (user.getStaff() != null && user.getStaff().getHub() != null) {
            return user.getStaff().getHub().getHubId();
        }
        if (user.getShipper() != null && user.getShipper().getHub() != null) {
            return user.getShipper().getHub().getHubId();
        }
        return null;
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        return error;
    }
}
