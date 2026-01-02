package vn.web.logistic.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * Service interface cho chức năng quản lý tài nguyên (Tài xế, Xe, Chuyến)
 * Dành cho Manager
 */
public interface ResourceService {

    // ===================== DRIVERS =====================

    /**
     * Lấy danh sách tất cả tài xế
     */
    List<Map<String, Object>> getAllDrivers();

    /**
     * Tạo tài xế mới
     */
    Map<String, Object> createDriver(Map<String, Object> request);

    /**
     * Cập nhật thông tin tài xế
     */
    Map<String, Object> updateDriver(Long id, Map<String, Object> request);

    /**
     * Xóa tài xế
     */
    void deleteDriver(Long id);

    // ===================== VEHICLES =====================

    /**
     * Lấy danh sách tất cả xe
     */
    List<Map<String, Object>> getAllVehicles();

    /**
     * Tạo xe mới
     */
    Map<String, Object> createVehicle(Map<String, Object> request);

    /**
     * Cập nhật thông tin xe
     */
    Map<String, Object> updateVehicle(Long id, Map<String, Object> request);

    /**
     * Xóa xe
     */
    void deleteVehicle(Long id);

    // ===================== TRIPS =====================

    /**
     * Lấy tất cả chuyến xe với filter
     */
    List<Map<String, Object>> getAllTrips(Long hubId, String status, LocalDateTime start, LocalDateTime end);

    /**
     * Lấy chi tiết đầy đủ chuyến xe
     */
    Map<String, Object> getTripFullDetail(Long tripId);

    /**
     * Xác nhận xe đến bến
     */
    Map<String, Object> tripArrival(Long tripId, Long actorId);

    // ===================== ORDERS =====================

    /**
     * Lấy chi tiết đơn hàng
     */
    Map<String, Object> getOrderDetail(Long orderId);
}
