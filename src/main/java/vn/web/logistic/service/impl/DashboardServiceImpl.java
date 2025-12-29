package vn.web.logistic.service.impl;

import lombok.*;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Nên thêm Transactional
import vn.web.logistic.dto.response.*;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.repository.*;
import vn.web.logistic.repository.projection.*;
import vn.web.logistic.service.DashboardService;

import java.math.BigDecimal;
import java.util.stream.Collectors;
import java.time.*;
import java.util.*;

@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

        private final ServiceRequestRepository serviceRequestRepository;
        private final ShipperTaskRepository shipperTaskRepository;

        /* =========================DASHBOARD=========================== */
        // 1. KPI: Trả về DTO
        @Override
        @Transactional(readOnly = true)
        public DashboardKpiResponse getKpi() {
                return DashboardKpiResponse.builder()
                                .newOrders(serviceRequestRepository.countByStatus(ServiceRequest.RequestStatus.pending))
                                .completedOrders(serviceRequestRepository
                                                .countByStatus(ServiceRequest.RequestStatus.delivered))
                                .incidentCount(serviceRequestRepository
                                                .countByStatusIn(List.of(ServiceRequest.RequestStatus.failed,
                                                                ServiceRequest.RequestStatus.cancelled)))
                                .totalRevenue(serviceRequestRepository
                                                .sumTotalRevenue(ServiceRequest.PaymentStatus.paid))
                                .build();
        }

        // 2. Chart: Trả về DTO chuẩn format
        @Override
        @Transactional(readOnly = true)
        public ChartResponse getRevenueChartData() {
                // 1. Lấy dữ liệu từ DB
                LocalDateTime start = LocalDate.now().minusDays(6).atStartOfDay();
                List<RevenueChartProjection> rawData = serviceRequestRepository.getRevenueLast7Days(
                                start, ServiceRequest.PaymentStatus.paid);

                // 2. Convert List -> Map (Dùng Stream, 1 dòng là xong)
                Map<String, BigDecimal> revenueMap = rawData.stream()
                                .collect(Collectors.toMap(p -> p.getDate().toString(),
                                                RevenueChartProjection::getRevenue));

                // 3. Tạo danh sách 7 ngày liên tục & Map dữ liệu
                // datesUntil: Sinh ra luồng ngày từ A đến B
                List<LocalDate> dateRange = LocalDate.now().minusDays(6)
                                .datesUntil(LocalDate.now().plusDays(1)) // plusDays(1) để lấy cả hôm nay
                                .toList();

                // 4. Trả về kết quả
                return ChartResponse.builder()
                                .labels(dateRange.stream().map(LocalDate::toString).toList()) // List<String> ngày
                                .data(dateRange.stream()
                                                .map(d -> revenueMap.getOrDefault(d.toString(), BigDecimal.ZERO)) // List<BigDecimal>
                                                                                                                  // tiền
                                                .toList())
                                .build();
        }

        // 3. Top Lists
        @Override
        @Transactional(readOnly = true)
        public List<TopPerformerProjection> getTopHubs() {
                // 1. Định nghĩa nhóm trạng thái "Thành công"
                List<ServiceRequest.RequestStatus> successStatuses = List.of(ServiceRequest.RequestStatus.delivered);

                // 2. Định nghĩa nhóm trạng thái "Đang xử lý/Tồn đọng"
                List<ServiceRequest.RequestStatus> pendingStatuses = List.of(
                                ServiceRequest.RequestStatus.pending,
                                ServiceRequest.RequestStatus.picked,
                                ServiceRequest.RequestStatus.in_transit);

                // 3. Gọi Repository: Truyền đủ 3 tham số theo thứ tự
                return serviceRequestRepository.getTopHubs(
                                successStatuses,
                                pendingStatuses,
                                PageRequest.of(0, 5) // Lấy top 5
                );
        }

        @Override
        @Transactional(readOnly = true)
        public List<TopPerformerProjection> getTopShippers() {
                return shipperTaskRepository.getTopShippers(PageRequest.of(0, 5));
        }
}