package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.dto.response.admin.ContainerSimpleResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.TripResponse;
import vn.web.logistic.entity.Trip;
import vn.web.logistic.entity.Trip.TripStatus;
import vn.web.logistic.entity.TripContainer;
import vn.web.logistic.entity.TripContainer.TripContainerStatus;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.exception.ResourceNotFoundException;
import vn.web.logistic.repository.TripContainerRepository;
import vn.web.logistic.repository.TripRepository;
import vn.web.logistic.service.TripMonitorService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class TripMonitorServiceImpl implements TripMonitorService {

    private final TripRepository tripRepository;
    private final TripContainerRepository tripContainerRepository;

    @Override
    public PageResponse<TripResponse> getAll(Long fromHubId, Long toHubId, String status, LocalDate date,
            Pageable pageable) {
        TripStatus tripStatus = null;
        if (status != null && !status.isEmpty()) {
            try {
                tripStatus = TripStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                throw new BusinessException("INVALID_STATUS", "Trạng thái không hợp lệ: " + status);
            }
        }

        LocalDateTime startDate = null;
        LocalDateTime endDate = null;
        if (date != null) {
            startDate = date.atStartOfDay();
            endDate = date.atTime(LocalTime.MAX);
        }

        Page<Trip> page = tripRepository.findAllWithFilters(fromHubId, toHubId, tripStatus, startDate, endDate,
                pageable);

        List<TripResponse> content = page.getContent().stream()
                .map(trip -> mapToResponse(trip, false))
                .collect(Collectors.toList());

        return PageResponse.<TripResponse>builder()
                .content(content)
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .first(page.isFirst())
                .last(page.isLast())
                .build();
    }

    @Override
    public TripResponse getById(Long id) {
        Trip trip = tripRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new ResourceNotFoundException("Trip", "tripId", id));
        return mapToResponse(trip, true);
    }

    private TripResponse mapToResponse(Trip trip, boolean includeContainers) {
        TripResponse.TripResponseBuilder builder = TripResponse.builder()
                .tripId(trip.getTripId())
                .tripCode(trip.getTripCode())
                .vehicleId(trip.getVehicle().getVehicleId())
                .plateNumber(trip.getVehicle().getPlateNumber())
                .vehicleType(trip.getVehicle().getVehicleType())
                .driverId(trip.getDriver().getDriverId())
                .driverName(trip.getDriver().getFullName())
                .driverPhone(trip.getDriver().getPhoneNumber())
                .fromHubId(trip.getFromHub().getHubId())
                .fromHubName(trip.getFromHub().getHubName())
                .toHubId(trip.getToHub().getHubId())
                .toHubName(trip.getToHub().getHubName())
                .departedAt(trip.getDepartedAt())
                .arrivedAt(trip.getArrivedAt())
                .status(trip.getStatus().name())
                .createdAt(trip.getCreatedAt());

        // Include containers if detail view
        if (includeContainers) {
            List<TripContainer> tripContainers = tripContainerRepository
                    .findByTripIdAndStatus(trip.getTripId(), TripContainerStatus.loaded);

            List<ContainerSimpleResponse> containers = tripContainers.stream()
                    .map(tc -> ContainerSimpleResponse.builder()
                            .containerId(tc.getContainer().getContainerId())
                            .containerCode(tc.getContainer().getContainerCode())
                            .type(tc.getContainer().getType().name())
                            .weight(tc.getContainer().getWeight())
                            .status(tc.getContainer().getStatus().name())
                            .destinationHubName(tc.getContainer().getDestinationHub().getHubName())
                            .build())
                    .collect(Collectors.toList());

            builder.containers(containers);
        }

        return builder.build();
    }
}
