package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.request.LogFilterRequest;
import vn.web.logistic.dto.request.ReportRequest;
import vn.web.logistic.dto.request.ReportType; // Import Enum
import vn.web.logistic.dto.response.MonitorStatsResponse;
import vn.web.logistic.dto.response.WarningResponse;
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
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SystemLogServiceImpl implements SystemLogService {

        private final SystemLogRepository logRepository;
        private final ServiceRequestRepository requestRepository;
        private final CodTransactionRepository codRepository;

        // Cấu hình
        private static final int STUCK_DAYS_THRESHOLD = 3;
        private static final BigDecimal MAX_DEBT_LIMIT = new BigDecimal("5000000"); // 5 Triệu VNĐ
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
                LocalDateTime threeDaysAgo = LocalDateTime.now().minusDays(STUCK_DAYS_THRESHOLD);
                List<RequestStatus> finishedStatuses = Arrays.asList(
                                RequestStatus.delivered,
                                RequestStatus.cancelled,
                                RequestStatus.failed);

                List<ServiceRequest> stuckRequests = requestRepository.findStuckOrders(finishedStatuses, threeDaysAgo);

                List<WarningResponse.StuckOrderDTO> stuckOrderDTOS = stuckRequests.stream()
                                .map(req -> WarningResponse.StuckOrderDTO.builder()
                                                .requestId(req.getRequestId())
                                                .currentStatus(req.getStatus().name())
                                                .createdTime(req.getCreatedAt())
                                                .daysStuck(ChronoUnit.DAYS.between(req.getCreatedAt(),
                                                                LocalDateTime.now()))
                                                .build())
                                .toList();

                // 2. Logic tìm Shipper nợ quá hạn mức
                List<WarningResponse.HighDebtShipperDTO> debtShippers = codRepository
                                .findHighDebtShippers(MAX_DEBT_LIMIT);

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