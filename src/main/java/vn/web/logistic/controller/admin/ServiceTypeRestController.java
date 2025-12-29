package vn.web.logistic.controller.admin;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.ServiceTypeRequest;
import vn.web.logistic.dto.response.ServiceTypeResponse;
import vn.web.logistic.service.ServiceTypeService;

import java.util.List;

@RestController
@RequestMapping("/admin/services")
@CrossOrigin(origins = "*")
public class ServiceTypeRestController {

    @Autowired
    private ServiceTypeService service;

    @GetMapping
    public ResponseEntity<List<ServiceTypeResponse>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ServiceTypeResponse> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(service.getById(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    // @Valid: Kích hoạt kiểm tra dữ liệu (NotNull, Min, Max...) trong DTO
    public ResponseEntity<?> create(@Valid @RequestBody ServiceTypeRequest request) {
        try {
            ServiceTypeResponse response = service.create(request);
            return new ResponseEntity<>(response, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id,
            @Valid @RequestBody ServiceTypeRequest request) {
        try {
            ServiceTypeResponse response = service.update(id, request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            service.delete(id);
            return ResponseEntity.ok("Xóa thành công");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Không thể xóa: Dữ liệu đang được sử dụng.");
        }
    }
}