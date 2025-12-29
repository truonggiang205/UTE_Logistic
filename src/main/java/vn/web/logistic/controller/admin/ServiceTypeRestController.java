package vn.web.logistic.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.ServiceTypeRequest;
import vn.web.logistic.dto.response.ServiceTypeResponse;
import vn.web.logistic.service.ServiceTypeService;

import java.util.List;

/**
 * Controller quản lý Cấu hình Dịch vụ & Giá (Tài chính)
 * Hỗ trợ Logic Versioning: Sửa giá sẽ tạo bản ghi mới để bảo toàn lịch sử đơn
 * hàng.
 */
@RestController
@RequestMapping("/api/admin/services")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ServiceTypeRestController {

    private final ServiceTypeService service;

    // 1. Lấy danh sách tất cả các phiên bản dịch vụ (cả cũ và mới)
    @GetMapping
    public ResponseEntity<List<ServiceTypeResponse>> getAll() {
        List<ServiceTypeResponse> list = service.getAll();
        return ResponseEntity.ok(list);
    }

    // 2. Lấy chi tiết một phiên bản cụ thể theo ID
    @GetMapping("/{id}")
    public ResponseEntity<ServiceTypeResponse> getById(@PathVariable Long id) {
        // Service sẽ ném RuntimeException nếu không thấy,
        // GlobalExceptionHandler (nếu có) sẽ bắt hoặc dùng try-catch như dưới
        try {
            return ResponseEntity.ok(service.getById(id));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    // 3. Tạo mới một loại dịch vụ (Bản ghi Version 1)
    @PostMapping
    public ResponseEntity<?> create(@Valid @RequestBody ServiceTypeRequest request) {
        try {
            ServiceTypeResponse response = service.create(request);
            return new ResponseEntity<>(response, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            // Trả về lỗi nếu trùng ServiceCode đang Active
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    /**
     * 4. Cập nhật cấu hình/giá (VERSIONING LOGIC)
     * Khi gọi PUT, ID cũ sẽ bị isActive = false, một ID mới sẽ được sinh ra và trả
     * về.
     */
    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id,
            @Valid @RequestBody ServiceTypeRequest request) {
        try {
            ServiceTypeResponse response = service.update(id, request);
            // Trả về 200 OK kèm dữ liệu của phiên bản mới nhất
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    /**
     * 5. Xóa dịch vụ (SOFT DELETE)
     * Không xóa khỏi DB để giữ Integrity cho các đơn hàng cũ, chỉ chuyển isActive =
     * false.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        try {
            service.delete(id);
            return ResponseEntity.ok("Ngưng hoạt động dịch vụ thành công (Soft Delete)");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}