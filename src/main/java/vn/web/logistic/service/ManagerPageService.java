package vn.web.logistic.service;

import vn.web.logistic.entity.*;

import java.util.List;

/**
 * Service interface cho việc chuẩn bị dữ liệu cho các trang Manager
 */
public interface ManagerPageService {

    /**
     * Lấy tất cả Hub
     */
    List<Hub> getAllHubs();

    /**
     * Lấy tất cả loại dịch vụ đang hoạt động
     */
    List<ServiceType> getActiveServiceTypes();

    /**
     * Lấy tất cả xe
     */
    List<Vehicle> getAllVehicles();

    /**
     * Lấy tất cả tài xế
     */
    List<Driver> getAllDrivers();

    /**
     * Lấy các chuyến xe theo trạng thái
     */
    List<Trip> getTripsByStatus(Trip.TripStatus status);

    /**
     * Lấy thông tin đơn hàng theo ID
     */
    ServiceRequest getOrderById(Long requestId);

    /**
     * Lấy tracking code theo request ID
     */
    TrackingCode getTrackingCodeByRequestId(Long requestId);
}
