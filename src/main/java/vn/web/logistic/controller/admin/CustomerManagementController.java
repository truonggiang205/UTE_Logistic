package vn.web.logistic.controller.admin;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.CustomerDetailResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.service.CustomerManagementService;

@RestController
@RequestMapping("/api/admin/customers")
@RequiredArgsConstructor
public class CustomerManagementController {

    private final CustomerManagementService customerManagementService;

    /**
     * GET /api/admin/customers - Lấy danh sách Customer với phân trang và filter
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<CustomerDetailResponse>>> getAllCustomers(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<CustomerDetailResponse> response = customerManagementService.getAll(status, keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/customers/{id} - Lấy thông tin chi tiết Customer + tất cả địa
     * chỉ
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CustomerDetailResponse>> getCustomerById(@PathVariable Long id) {
        CustomerDetailResponse response = customerManagementService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/customers/by-user/{userId} - Lấy thông tin Customer theo User
     * ID
     */
    @GetMapping("/by-user/{userId}")
    public ResponseEntity<ApiResponse<CustomerDetailResponse>> getCustomerByUserId(@PathVariable Long userId) {
        CustomerDetailResponse response = customerManagementService.getByUserId(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
