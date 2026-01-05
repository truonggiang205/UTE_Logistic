package vn.web.logistic.controller.admin;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
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
import vn.web.logistic.dto.request.admin.ActionTypeRequest;
import vn.web.logistic.dto.response.admin.ActionTypeResponse;
import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.service.ActionTypeService;

@RestController
@RequestMapping("/api/admin/action-types")
@RequiredArgsConstructor
public class ActionTypeController {

    private final ActionTypeService actionTypeService;

    /**
     * GET /api/admin/action-types/all - Lấy tất cả ActionType (không phân trang)
     */
    @GetMapping("/all")
    public ResponseEntity<List<ActionTypeResponse>> getAllActionTypesSimple() {
        return ResponseEntity.ok(actionTypeService.getAll());
    }

    /**
     * GET /api/admin/action-types - Lấy danh sách ActionType với phân trang và
     * filter
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<ActionTypeResponse>>> getAllActionTypes(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "actionCode") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<ActionTypeResponse> response = actionTypeService.getAll(keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * GET /api/admin/action-types/{id} - Lấy thông tin chi tiết ActionType
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ActionTypeResponse>> getActionTypeById(@PathVariable Long id) {
        ActionTypeResponse response = actionTypeService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * POST /api/admin/action-types - Tạo ActionType mới
     */
    @PostMapping
    public ResponseEntity<ApiResponse<ActionTypeResponse>> createActionType(
            @Valid @RequestBody ActionTypeRequest request) {
        ActionTypeResponse response = actionTypeService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Thêm loại hành động mới thành công", response));
    }

    /**
     * PUT /api/admin/action-types/{id} - Cập nhật thông tin ActionType
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ActionTypeResponse>> updateActionType(
            @PathVariable Long id,
            @Valid @RequestBody ActionTypeRequest request) {
        ActionTypeResponse response = actionTypeService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success("Cập nhật loại hành động thành công", response));
    }

    /**
     * DELETE /api/admin/action-types/{id} - Xóa ActionType
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteActionType(@PathVariable Long id) {
        actionTypeService.delete(id);
        return ResponseEntity.ok(ApiResponse.success("Xóa loại hành động thành công", null));
    }
}
