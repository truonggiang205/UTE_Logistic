package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import vn.web.logistic.entity.*;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.ManagerPageService;

import java.util.List;

/**
 * Implementation của ManagerPageService
 * Cung cấp dữ liệu cho các trang Manager
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ManagerPageServiceImpl implements ManagerPageService {

    private final HubRepository hubRepository;
    private final ServiceTypeRepository serviceTypeRepository;
    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;
    private final TripRepository tripRepository;
    private final ServiceRequestRepository serviceRequestRepository;
    private final TrackingCodeRepository trackingCodeRepository;

    @Override
    public List<Hub> getAllHubs() {
        log.debug("Service: Lấy danh sách tất cả Hub");
        return hubRepository.findAll();
    }

    @Override
    public List<ServiceType> getActiveServiceTypes() {
        log.debug("Service: Lấy danh sách loại dịch vụ đang hoạt động");
        return serviceTypeRepository.findAllByIsActiveTrue();
    }

    @Override
    public List<Vehicle> getAllVehicles() {
        log.debug("Service: Lấy danh sách tất cả xe");
        return vehicleRepository.findAll();
    }

    @Override
    public List<Driver> getAllDrivers() {
        log.debug("Service: Lấy danh sách tất cả tài xế");
        return driverRepository.findAll();
    }

    @Override
    public List<Trip> getTripsByStatus(Trip.TripStatus status) {
        log.debug("Service: Lấy danh sách chuyến xe theo trạng thái: {}", status);
        return tripRepository.findAllWithFilters(
                null, null, status, null, null,
                Pageable.unpaged()).getContent();
    }

    @Override
    public ServiceRequest getOrderById(Long requestId) {
        log.debug("Service: Lấy thông tin đơn hàng: {}", requestId);
        return serviceRequestRepository.findById(requestId)
                .orElseThrow(() -> new BusinessException("Đơn hàng không tồn tại: " + requestId));
    }

    @Override
    public TrackingCode getTrackingCodeByRequestId(Long requestId) {
        log.debug("Service: Lấy tracking code cho đơn hàng: {}", requestId);
        return trackingCodeRepository.findByRequest_RequestId(requestId).orElse(null);
    }
}
