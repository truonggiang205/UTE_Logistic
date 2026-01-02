package vn.web.logistic.controller.manager;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import vn.web.logistic.dto.response.admin.ApiResponse;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.service.ResourceService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

/**
 * ResourceController - Quản lý Tài xế, Xe, Chuyến (cho Manager)
 * Endpoint prefix: /api/manager/resource
 * Sử dụng ResourceService để xử lý business logic (tuân thủ mô hình MVC)
 */
@Slf4j
@RestController
@RequestMapping("/api/manager/resource")
@RequiredArgsConstructor
public class ResourceController {

    private final ResourceService resourceService;

    // ===================== DRIVERS =====================

    /**
     * GET /api/manager/resource/drivers - Lấy tất cả tài xế
     */
    @GetMapping("/drivers")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAllDrivers() {
        log.info("API: Lấy danh sách tất cả tài xế");
        List<Map<String, Object>> result = resourceService.getAllDrivers();
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    /**
     * POST /api/manager/resource/drivers - Thêm tài xế mới
     */
    @PostMapping("/drivers")
    public ResponseEntity<ApiResponse<Map<String, Object>>> createDriver(@RequestBody Map<String, Object> request) {
        log.info("API: Thêm tài xế mới: {}", request);
        try {
            Map<String, Object> result = resourceService.createDriver(request);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Thêm tài xế thành công", result));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * PUT /api/manager/resource/drivers/{id} - Cập nhật tài xế
     */
    @PutMapping("/drivers/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> updateDriver(
            @PathVariable Long id, @RequestBody Map<String, Object> request) {
        log.info("API: Cập nhật tài xế {}: {}", id, request);
        try {
            Map<String, Object> result = resourceService.updateDriver(id, request);
            return ResponseEntity.ok(ApiResponse.success("Cập nhật tài xế thành công", result));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * DELETE /api/manager/resource/drivers/{id} - Xóa tài xế
     */
    @DeleteMapping("/drivers/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteDriver(@PathVariable Long id) {
        log.info("API: Xóa tài xế {}", id);
        try {
            resourceService.deleteDriver(id);
            return ResponseEntity.ok(ApiResponse.success("Xóa tài xế thành công", null));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    // ===================== VEHICLES =====================

    /**
     * GET /api/manager/resource/vehicles - Lấy tất cả xe
     */
    @GetMapping("/vehicles")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAllVehicles() {
        log.info("API: Lấy danh sách tất cả xe");
        List<Map<String, Object>> result = resourceService.getAllVehicles();
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    /**
     * POST /api/manager/resource/vehicles - Thêm xe mới
     */
    @PostMapping("/vehicles")
    public ResponseEntity<ApiResponse<Map<String, Object>>> createVehicle(@RequestBody Map<String, Object> request) {
        log.info("API: Thêm xe mới: {}", request);
        try {
            Map<String, Object> result = resourceService.createVehicle(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Thêm xe thành công", result));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * PUT /api/manager/resource/vehicles/{id} - Cập nhật xe
     */
    @PutMapping("/vehicles/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> updateVehicle(
            @PathVariable Long id, @RequestBody Map<String, Object> request) {
        log.info("API: Cập nhật xe {}: {}", id, request);
        try {
            Map<String, Object> result = resourceService.updateVehicle(id, request);
            return ResponseEntity.ok(ApiResponse.success("Cập nhật xe thành công", result));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * DELETE /api/manager/resource/vehicles/{id} - Xóa xe
     */
    @DeleteMapping("/vehicles/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteVehicle(@PathVariable Long id) {
        log.info("API: Xóa xe {}", id);
        try {
            resourceService.deleteVehicle(id);
            return ResponseEntity.ok(ApiResponse.success("Xóa xe thành công", null));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    // ===================== TRIPS =====================

    /**
     * GET /api/manager/resource/all-trips - Lấy tất cả chuyến xe (bao gồm đã xuất
     * bến)
     */
    @GetMapping("/all-trips")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getAllTrips(
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        log.info("API: Lấy tất cả chuyến xe - hubId: {}, status: {}, startDate: {}, endDate: {}",
                hubId, status, startDate, endDate);

        LocalDateTime start = null;
        LocalDateTime end = null;
        try {
            if (startDate != null && !startDate.isEmpty()) {
                start = LocalDate.parse(startDate).atStartOfDay();
            }
            if (endDate != null && !endDate.isEmpty()) {
                end = LocalDate.parse(endDate).atTime(LocalTime.MAX);
            }
        } catch (Exception ignored) {
        }

        List<Map<String, Object>> result = resourceService.getAllTrips(hubId, status, start, end);
        return ResponseEntity.ok(ApiResponse.success(result));
    }

    /**
     * GET /api/manager/resource/trips/{tripId}/full-detail - Chi tiết chuyến xe đầy
     * đủ (bao gồm đơn hàng)
     */
    @GetMapping("/trips/{tripId}/full-detail")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getTripFullDetail(@PathVariable Long tripId) {
        log.info("API: Lấy chi tiết đầy đủ chuyến xe {}", tripId);
        try {
            Map<String, Object> result = resourceService.getTripFullDetail(tripId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * POST /api/manager/resource/trips/{tripId}/arrive - Xác nhận xe đến bến
     */
    @PostMapping("/trips/{tripId}/arrive")
    public ResponseEntity<ApiResponse<Map<String, Object>>> tripArrival(
            @PathVariable Long tripId,
            @RequestParam(required = false) Long actorId) {

        log.info("API: Xác nhận xe đến bến - tripId: {}, actorId: {}", tripId, actorId);
        try {
            Map<String, Object> result = resourceService.tripArrival(tripId, actorId);
            return ResponseEntity.ok(ApiResponse.success("Xe đã đến bến thành công", result));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * GET /api/manager/resource/orders/{orderId} - Lấy chi tiết đơn hàng
     */
    @GetMapping("/orders/{orderId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getOrderDetail(@PathVariable Long orderId) {
        log.info("API: Lấy chi tiết đơn hàng {}", orderId);
        try {
            Map<String, Object> result = resourceService.getOrderDetail(orderId);
            return ResponseEntity.ok(ApiResponse.success(result));
        } catch (BusinessException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
