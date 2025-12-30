package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.request.VehicleRequest;
import vn.web.logistic.dto.response.PageResponse;
import vn.web.logistic.dto.response.VehicleResponse;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Vehicle;
import vn.web.logistic.entity.Vehicle.VehicleStatus;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.exception.ResourceNotFoundException;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.VehicleRepository;
import vn.web.logistic.service.VehicleService;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class VehicleServiceImpl implements VehicleService {

    private final VehicleRepository vehicleRepository;
    private final HubRepository hubRepository;

    @Override
    public VehicleResponse create(VehicleRequest request) {
        // Check duplicate plate number
        if (vehicleRepository.existsByPlateNumber(request.getPlateNumber())) {
            throw new BusinessException("DUPLICATE_PLATE", "Biển số xe đã tồn tại trong hệ thống");
        }

        Vehicle vehicle = Vehicle.builder()
                .plateNumber(request.getPlateNumber())
                .vehicleType(request.getVehicleType())
                .loadCapacity(request.getLoadCapacity())
                .status(VehicleStatus.available)
                .build();

        // Set current hub if provided
        if (request.getCurrentHubId() != null) {
            Hub hub = hubRepository.findById(request.getCurrentHubId())
                    .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getCurrentHubId()));
            vehicle.setCurrentHub(hub);
        }

        vehicle = vehicleRepository.save(vehicle);
        log.info("Created new vehicle: {}", vehicle.getPlateNumber());

        return mapToResponse(vehicle);
    }

    @Override
    public VehicleResponse update(Long id, VehicleRequest request) {
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "vehicleId", id));

        // Check duplicate plate number (exclude current vehicle)
        if (vehicleRepository.existsByPlateNumberAndVehicleIdNot(request.getPlateNumber(), id)) {
            throw new BusinessException("DUPLICATE_PLATE", "Biển số xe đã tồn tại trong hệ thống");
        }

        vehicle.setPlateNumber(request.getPlateNumber());
        vehicle.setVehicleType(request.getVehicleType());
        vehicle.setLoadCapacity(request.getLoadCapacity());

        // Update status if provided
        if (request.getStatus() != null) {
            vehicle.setStatus(VehicleStatus.valueOf(request.getStatus()));
        }

        // Update current hub if provided
        if (request.getCurrentHubId() != null) {
            Hub hub = hubRepository.findById(request.getCurrentHubId())
                    .orElseThrow(() -> new ResourceNotFoundException("Hub", "hubId", request.getCurrentHubId()));
            vehicle.setCurrentHub(hub);
        }

        vehicle = vehicleRepository.save(vehicle);
        log.info("Updated vehicle: {}", vehicle.getPlateNumber());

        return mapToResponse(vehicle);
    }

    @Override
    public void delete(Long id) {
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "vehicleId", id));

        // IMPORTANT: Check if vehicle is in transit
        if (vehicle.getStatus() == VehicleStatus.in_transit) {
            throw new BusinessException("VEHICLE_IN_TRANSIT", "Không thể xóa xe đang chạy trên đường");
        }

        vehicleRepository.delete(vehicle);
        log.info("Deleted vehicle: {}", vehicle.getPlateNumber());
    }

    @Override
    @Transactional(readOnly = true)
    public VehicleResponse getById(Long id) {
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "vehicleId", id));
        return mapToResponse(vehicle);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<VehicleResponse> getAll(Long hubId, String status, String plateNumber, Pageable pageable) {
        VehicleStatus vehicleStatus = null;
        if (status != null && !status.isEmpty()) {
            try {
                vehicleStatus = VehicleStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                throw new BusinessException("INVALID_STATUS", "Trạng thái không hợp lệ: " + status);
            }
        }

        Page<Vehicle> page = vehicleRepository.findAllWithFilters(hubId, vehicleStatus, plateNumber, pageable);

        List<VehicleResponse> content = page.getContent().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());

        return PageResponse.<VehicleResponse>builder()
                .content(content)
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .first(page.isFirst())
                .last(page.isLast())
                .build();
    }

    private VehicleResponse mapToResponse(Vehicle vehicle) {
        return VehicleResponse.builder()
                .vehicleId(vehicle.getVehicleId())
                .plateNumber(vehicle.getPlateNumber())
                .vehicleType(vehicle.getVehicleType())
                .loadCapacity(vehicle.getLoadCapacity())
                .currentHubId(vehicle.getCurrentHub() != null ? vehicle.getCurrentHub().getHubId() : null)
                .currentHubName(vehicle.getCurrentHub() != null ? vehicle.getCurrentHub().getHubName() : null)
                .status(vehicle.getStatus().name())
                .createdAt(vehicle.getCreatedAt())
                .build();
    }
}
