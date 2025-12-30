package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.response.TransportReportResponse;
import vn.web.logistic.dto.response.TransportStatsResponse;
import vn.web.logistic.entity.Driver.DriverStatus;
import vn.web.logistic.entity.Trip.TripStatus;
import vn.web.logistic.entity.Vehicle.VehicleStatus;
import vn.web.logistic.repository.DriverRepository;
import vn.web.logistic.repository.TripContainerRepository;
import vn.web.logistic.repository.TripRepository;
import vn.web.logistic.repository.VehicleRepository;
import vn.web.logistic.service.TransportStatsService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class TransportStatsServiceImpl implements TransportStatsService {

    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;
    private final TripRepository tripRepository;
    private final TripContainerRepository tripContainerRepository;

    @Override
    public TransportStatsResponse getTransportStats() {
        // Vehicle stats
        long totalVehicles = vehicleRepository.countAllVehicles();
        long activeVehicles = vehicleRepository.countByStatus(VehicleStatus.in_transit);
        long availableVehicles = vehicleRepository.countByStatus(VehicleStatus.available);
        long maintenanceVehicles = vehicleRepository.countByStatus(VehicleStatus.maintenance);

        // Driver stats
        long totalDrivers = driverRepository.count();
        long activeDrivers = driverRepository.countByStatus(DriverStatus.active);

        // Trip stats
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
        long totalTripsToday = tripRepository.countTripsToday(startOfDay, endOfDay);
        long ongoingTrips = tripRepository.countByStatusIn(Arrays.asList(TripStatus.loading, TripStatus.on_way));

        // Calculate load factor (% fill of active vehicles)
        BigDecimal loadFactor = calculateLoadFactor();

        return TransportStatsResponse.builder()
                .totalVehicles(totalVehicles)
                .activeVehicles(activeVehicles)
                .availableVehicles(availableVehicles)
                .maintenanceVehicles(maintenanceVehicles)
                .loadFactor(loadFactor)
                .totalDrivers(totalDrivers)
                .activeDrivers(activeDrivers)
                .totalTripsToday(totalTripsToday)
                .ongoingTrips(ongoingTrips)
                .build();
    }

    /**
     * Calculate load factor = (Total weight of containers on active trips) / (Total
     * load capacity of those vehicles)
     * Returns percentage (0-100)
     */
    private BigDecimal calculateLoadFactor() {
        try {
            // Get total weight of containers on vehicles that are in_transit
            BigDecimal totalWeight = tripContainerRepository.sumWeightOfActiveTrips();
            if (totalWeight == null) {
                totalWeight = BigDecimal.ZERO;
            }

            // Get total load capacity of vehicles that are in_transit
            BigDecimal totalCapacity = vehicleRepository.sumLoadCapacityByStatus(VehicleStatus.in_transit);
            if (totalCapacity == null || totalCapacity.compareTo(BigDecimal.ZERO) == 0) {
                return BigDecimal.ZERO;
            }

            // Calculate percentage
            return totalWeight.multiply(BigDecimal.valueOf(100))
                    .divide(totalCapacity, 2, RoundingMode.HALF_UP);

        } catch (Exception e) {
            log.error("Error calculating load factor: {}", e.getMessage());
            return BigDecimal.ZERO;
        }
    }

    @Override
    public TransportReportResponse getTransportReport(LocalDate fromDate, LocalDate toDate) {
        List<TransportReportResponse.DailyStats> dailyStats = new ArrayList<>();

        // Iterate through each day in the range
        LocalDate currentDate = fromDate;
        while (!currentDate.isAfter(toDate)) {
            LocalDateTime startOfDay = currentDate.atStartOfDay();
            LocalDateTime endOfDay = currentDate.atTime(LocalTime.MAX);

            // Count trips for this day
            long tripCount = tripRepository.countTripsToday(startOfDay, endOfDay);

            // Count completed trips
            long completedCount = tripRepository.countByStatusAndCreatedAtBetween(
                    TripStatus.completed, startOfDay, endOfDay);

            // Count ongoing trips (loading or on_way)
            long ongoingCount = tripRepository.countByStatusInAndCreatedAtBetween(
                    Arrays.asList(TripStatus.loading, TripStatus.on_way), startOfDay, endOfDay);

            // Get total weight for this day
            BigDecimal totalWeight = tripContainerRepository.sumWeightByTripCreatedAtBetween(startOfDay, endOfDay);
            if (totalWeight == null) {
                totalWeight = BigDecimal.ZERO;
            }

            dailyStats.add(TransportReportResponse.DailyStats.builder()
                    .date(currentDate.toString())
                    .tripCount(tripCount)
                    .totalWeight(totalWeight)
                    .completedCount(completedCount)
                    .ongoingCount(ongoingCount)
                    .build());

            currentDate = currentDate.plusDays(1);
        }

        return TransportReportResponse.builder()
                .dailyStats(dailyStats)
                .build();
    }
}
