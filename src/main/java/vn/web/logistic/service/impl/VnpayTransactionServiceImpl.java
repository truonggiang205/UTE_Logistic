package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.dto.response.admin.VnpayReconciliationResponse;
import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.repository.VnpayTransactionRepository;
import vn.web.logistic.repository.specification.VnpaySpecification;
import vn.web.logistic.service.VnpayTransactionService;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VnpayTransactionServiceImpl implements VnpayTransactionService {

        private final VnpayTransactionRepository repository;

        // Tạo constant format ngày để tối ưu hiệu năng (tránh tạo mới trong vòng lặp)
        private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        // Lấy danh sách giao dịch VNPAY có lọc và phân trang
        @Override
        @Transactional(readOnly = true)
        public Page<VnpayReconciliationResponse> getTransactions(
                        LocalDateTime from, LocalDateTime to, Long hubId, String customerName, Pageable pageable) {

                var spec = VnpaySpecification.filterTransactions(from, to, hubId, customerName);
                Page<VnpayTransaction> rawData = repository.findAll(spec, pageable);
                return rawData.map(VnpayReconciliationResponse::fromEntity);
        }

        // Xuất danh sách giao dịch ra file Excel
        @Override
        public ByteArrayInputStream exportToExcel(
                        LocalDateTime from, LocalDateTime to, Long hubId, String customerName) throws IOException {

                var spec = VnpaySpecification.filterTransactions(from, to, hubId, customerName);

                // Lấy toàn bộ dữ liệu (không phân trang) để xuất Excel
                List<VnpayReconciliationResponse> dataList = repository.findAll(spec)
                                .stream()
                                .map(VnpayReconciliationResponse::fromEntity)
                                .collect(Collectors.toList());

                // Phần code tạo Excel
                try (Workbook workbook = new XSSFWorkbook();
                                ByteArrayOutputStream out = new ByteArrayOutputStream()) {

                        Sheet sheet = workbook.createSheet("Doi_Soat_VNPAY");

                        // --- HEADER ---
                        Row headerRow = sheet.createRow(0);
                        String[] headers = {
                                        "Mã GD VNPAY", "Mã Đơn", "Khách Hàng", "Hub",
                                        "Giá Trị Đơn", "Thực Nhận", "Chênh Lệch",
                                        "Trạng Thái", "Ngày TT"
                        };

                        // Style cho Header (In đậm)
                        CellStyle headerStyle = workbook.createCellStyle();
                        Font font = workbook.createFont();
                        font.setBold(true);
                        headerStyle.setFont(font);

                        for (int i = 0; i < headers.length; i++) {
                                Cell cell = headerRow.createCell(i);
                                cell.setCellValue(headers[i]);
                                cell.setCellStyle(headerStyle);
                        }

                        // --- DATA ---
                        int rowIdx = 1;
                        for (VnpayReconciliationResponse item : dataList) {
                                Row row = sheet.createRow(rowIdx++);

                                row.createCell(0).setCellValue(item.getVnpTxnRef());
                                row.createCell(1).setCellValue(item.getOrderCode());
                                row.createCell(2).setCellValue(item.getCustomerName());
                                row.createCell(3).setCellValue(item.getHubName());

                                // Xử lý số (tránh null)
                                row.createCell(4).setCellValue(
                                                item.getOrderValue() != null ? item.getOrderValue().doubleValue() : 0);
                                row.createCell(5).setCellValue(
                                                item.getPaidAmount() != null ? item.getPaidAmount().doubleValue() : 0);
                                row.createCell(6)
                                                .setCellValue(item.getDiscrepancy() != null
                                                                ? item.getDiscrepancy().doubleValue()
                                                                : 0);

                                row.createCell(7).setCellValue(item.getReconciliationStatus());

                                // Xử lý ngày
                                String dateStr = (item.getPaidAt() != null) ? item.getPaidAt().format(DATE_FORMATTER)
                                                : "";
                                row.createCell(8).setCellValue(dateStr);
                        }

                        // Auto-size cột cho đẹp
                        for (int i = 0; i < headers.length; i++) {
                                sheet.autoSizeColumn(i);
                        }

                        workbook.write(out);
                        return new ByteArrayInputStream(out.toByteArray());
                }

        }
}