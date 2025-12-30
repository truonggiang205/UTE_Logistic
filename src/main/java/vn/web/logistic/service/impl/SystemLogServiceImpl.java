package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.dto.request.admin.LogFilterRequest;
import vn.web.logistic.dto.request.admin.ReportRequest;
import vn.web.logistic.dto.request.admin.ReportType;
import vn.web.logistic.dto.response.admin.HighDebtShipperDTO;
import vn.web.logistic.dto.response.admin.MonitorStatsResponse;
import vn.web.logistic.dto.response.admin.WarningResponse;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.repository.specification.SystemLogSpecification;
import vn.web.logistic.service.SystemLogService;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SystemLogServiceImpl implements SystemLogService {

        private final SystemLogRepository logRepository;
        private final ServiceRequestRepository requestRepository;
        private final CodTransactionRepository codRepository;

        // Cấu hình
        private static final int STUCK_DAYS_THRESHOLD = 3;
        // Mức cảnh báo COD 3 tầng:
        // 1. Nợ > 10 triệu VÀ quá 2 ngày
        // 2. HOẶC Nợ > 2 triệu VÀ quá 3 ngày
        // 3. HOẶC chưa nộp COD quá 7 ngày (bất kể số tiền)
        private static final BigDecimal HIGH_DEBT_LIMIT = new BigDecimal("10000000"); // 10 Triệu VNĐ
        private static final BigDecimal MEDIUM_DEBT_LIMIT = new BigDecimal("2000000"); // 2 Triệu VNĐ
        private static final int HIGH_DEBT_DAYS = 2; // 2 ngày cho mức 10 triệu
        private static final int MEDIUM_DEBT_DAYS = 3; // 3 ngày cho mức 2 triệu
        private static final int OVERDUE_DAYS = 7; // 7 ngày chưa nộp COD
        private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        @Override
        @Transactional(readOnly = true)
        public Page<SystemLog> getLogs(LogFilterRequest request, Pageable pageable) {
                Specification<SystemLog> spec = SystemLogSpecification.filter(request);
                return logRepository.findAll(spec, pageable);
        }

        @Override
        @Transactional(readOnly = true)
        public MonitorStatsResponse getStatistics(LogFilterRequest request) {
                Specification<SystemLog> spec = SystemLogSpecification.filter(request);
                long totalLogs = logRepository.count(spec);

                if (totalLogs == 0) {
                        return MonitorStatsResponse.builder()
                                        .totalLogs(0)
                                        .activeUsersCount(0)
                                        .topAction("N/A")
                                        .mostActiveUser("N/A")
                                        .build();
                }

                List<SystemLog> logs = logRepository.findAll(spec);

                long activeUsers = logs.stream()
                                .filter(l -> l.getUser() != null)
                                .map(l -> l.getUser().getUserId())
                                .distinct()
                                .count();

                String topAction = logs.stream()
                                .collect(Collectors.groupingBy(SystemLog::getAction, Collectors.counting()))
                                .entrySet().stream()
                                .max(Map.Entry.comparingByValue())
                                .map(Map.Entry::getKey)
                                .orElse("N/A");

                String mostActiveUser = logs.stream()
                                .filter(l -> l.getUser() != null)
                                .collect(Collectors.groupingBy(l -> l.getUser().getUsername(), Collectors.counting()))
                                .entrySet().stream()
                                .max(Map.Entry.comparingByValue())
                                .map(Map.Entry::getKey)
                                .orElse("N/A");

                return MonitorStatsResponse.builder()
                                .totalLogs(totalLogs)
                                .activeUsersCount(activeUsers)
                                .topAction(topAction)
                                .mostActiveUser(mostActiveUser)
                                .build();
        }

        @Override
        @Transactional(readOnly = true)
        public WarningResponse getRiskWarnings() {
                // 1. Logic tìm đơn treo (Stuck Orders)
                LocalDateTime stuckThreshold = LocalDateTime.now().minusDays(STUCK_DAYS_THRESHOLD);
                List<RequestStatus> finishedStatuses = Arrays.asList(
                                RequestStatus.delivered,
                                RequestStatus.cancelled,
                                RequestStatus.failed);

                List<ServiceRequest> stuckRequests = requestRepository.findStuckOrders(finishedStatuses,
                                stuckThreshold);

                List<WarningResponse.StuckOrderDTO> stuckOrderDTOS = stuckRequests.stream()
                                .map(req -> WarningResponse.StuckOrderDTO.builder()
                                                .requestId(req.getRequestId())
                                                .currentStatus(req.getStatus().name())
                                                .createdTime(req.getCreatedAt())
                                                .daysStuck(ChronoUnit.DAYS.between(req.getCreatedAt(),
                                                                LocalDateTime.now()))
                                                .build())
                                .toList();

                // 2. Logic tìm Shipper nợ COD theo 3 mức độ:
                LocalDateTime twoDaysAgo = LocalDateTime.now().minusDays(HIGH_DEBT_DAYS);
                LocalDateTime threeDaysAgo = LocalDateTime.now().minusDays(MEDIUM_DEBT_DAYS);
                LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(OVERDUE_DAYS);

                // Query 3 mức và merge kết quả (loại bỏ trùng lặp theo shipperId)
                Set<Long> seenShipperIds = new HashSet<>();
                List<HighDebtShipperDTO> debtShippers = new java.util.ArrayList<>();

                // Mức 1: Nợ > 10 triệu VÀ quá 2 ngày
                codRepository.findHighDebtOver10M(HIGH_DEBT_LIMIT, twoDaysAgo)
                                .forEach(dto -> {
                                        if (seenShipperIds.add(dto.getShipperId())) {
                                                debtShippers.add(dto);
                                        }
                                });

                // Mức 2: Nợ > 2 triệu VÀ quá 3 ngày
                codRepository.findMediumDebtOver2M(MEDIUM_DEBT_LIMIT, threeDaysAgo)
                                .forEach(dto -> {
                                        if (seenShipperIds.add(dto.getShipperId())) {
                                                debtShippers.add(dto);
                                        }
                                });

                // Mức 3: Chưa nộp COD quá 7 ngày (bất kể số tiền)
                codRepository.findOverdueOver7Days(sevenDaysAgo)
                                .forEach(dto -> {
                                        if (seenShipperIds.add(dto.getShipperId())) {
                                                debtShippers.add(dto);
                                        }
                                });

                return WarningResponse.builder()
                                .stuckOrders(stuckOrderDTOS)
                                .debtShippers(debtShippers)
                                .build();
        }

        @Override
        public ByteArrayInputStream exportReport(ReportRequest request) {
                try (Workbook workbook = new XSSFWorkbook();
                                ByteArrayOutputStream out = new ByteArrayOutputStream()) {

                        Sheet sheet = workbook.createSheet(request.getType().name());

                        // --- TẠO HEADER ---
                        Row headerRow = sheet.createRow(0);
                        String[] columns = getHeadersByType(request.getType());

                        CellStyle headerStyle = workbook.createCellStyle();
                        Font font = workbook.createFont();
                        font.setBold(true);
                        headerStyle.setFont(font);

                        for (int i = 0; i < columns.length; i++) {
                                Cell cell = headerRow.createCell(i);
                                cell.setCellValue(columns[i]);
                                cell.setCellStyle(headerStyle);
                        }

                        // --- ĐỔ DỮ LIỆU ---
                        int rowIdx = 1;

                        switch (request.getType()) {
                                case REVENUE:
                                        // TODO: Nên dùng Repository tìm theo request.getFromDate() và toDate() thay vì
                                        // findAll()
                                        List<ServiceRequest> orders = requestRepository.findAll();
                                        for (ServiceRequest order : orders) {
                                                Row row = sheet.createRow(rowIdx++);
                                                row.createCell(0).setCellValue(order.getRequestId());
                                                row.createCell(1)
                                                                .setCellValue(order.getTotalPrice() != null
                                                                                ? order.getTotalPrice().doubleValue()
                                                                                : 0);
                                                row.createCell(2).setCellValue(formatDate(order.getCreatedAt()));
                                        }
                                        break;

                                case COD_DEBT:
                                        // Lấy tất cả giao dịch COD (Thực tế nên lọc theo trạng thái 'pending')
                                        List<CodTransaction> cods = codRepository.findAll();
                                        for (CodTransaction cod : cods) {
                                                Row row = sheet.createRow(rowIdx++);
                                                // Kiểm tra null để tránh lỗi NullPointerException
                                                String shipperName = (cod.getShipper() != null
                                                                && cod.getShipper().getUser() != null)
                                                                                ? cod.getShipper().getUser()
                                                                                                .getFullName()
                                                                                : "Unknown";
                                                String phone = (cod.getShipper() != null
                                                                && cod.getShipper().getUser() != null)
                                                                                ? cod.getShipper().getUser().getPhone()
                                                                                : "";

                                                row.createCell(0).setCellValue(shipperName);
                                                row.createCell(1)
                                                                .setCellValue(cod.getAmount() != null
                                                                                ? cod.getAmount().doubleValue()
                                                                                : 0);
                                                row.createCell(2).setCellValue(phone);
                                        }
                                        break;

                                case HUB_PERFORMANCE:
                                        // Logic giả lập hoặc gọi Repo
                                        // Ví dụ: List<HubStats> stats = hubRepository.getStats();
                                        Row row = sheet.createRow(rowIdx++);
                                        row.createCell(0).setCellValue("Hub Ha Noi (Demo)");
                                        row.createCell(1).setCellValue(150);
                                        row.createCell(2).setCellValue("98%");
                                        break;
                        }

                        // Auto-size cột cho đẹp
                        for (int i = 0; i < columns.length; i++) {
                                sheet.autoSizeColumn(i);
                        }

                        workbook.write(out);
                        return new ByteArrayInputStream(out.toByteArray());

                } catch (IOException e) {
                        throw new RuntimeException("Lỗi xuất Excel: " + e.getMessage());
                }
        }

        // Helper: Format ngày tháng an toàn
        private String formatDate(LocalDateTime date) {
                return date != null ? date.format(DATE_FORMATTER) : "";
        }

        private String[] getHeadersByType(ReportType type) {
                switch (type) {
                        case REVENUE:
                                return new String[] { "ID Đơn", "Doanh thu", "Ngày tạo" };
                        case HUB_PERFORMANCE:
                                return new String[] { "Tên Hub", "Số lượng hàng", "Hiệu suất" };
                        case COD_DEBT:
                                return new String[] { "Shipper", "Tiền nợ", "SĐT" };
                        default:
                                return new String[] {};
                }
        }
}