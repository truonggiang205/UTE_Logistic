package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.core.io.InputStreamResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.response.VnpayReconciliationResponse;
import vn.web.logistic.service.VnpayTransactionService;

import java.io.IOException;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/admin/transactions")
@CrossOrigin(origins = "*") // Cho phép Frontend (React/Vue/Angular) gọi API
@RequiredArgsConstructor
public class VnpayTransactionController {

        private final VnpayTransactionService service;

        // 1. API LẤY DANH SÁCH & PHÂN TRANG
        @GetMapping
        public ResponseEntity<Page<VnpayReconciliationResponse>> getTransactions(
                        // Các tham số lọc (Filter)
                        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
                        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to,
                        @RequestParam(required = false) Long hubId,
                        @RequestParam(required = false) String customerName,

                        // Các tham số phân trang (Pagination)
                        @RequestParam(defaultValue = "0") int page, // Trang số mấy (Mặc định trang 0)
                        @RequestParam(defaultValue = "10") int size // Số dòng mỗi trang (Mặc định 10)
        ) {
                // Tạo đối tượng phân trang:
                // - Lấy trang 'page', số lượng 'size'
                // - Tự động sắp xếp ngày thanh toán (paidAt) giảm dần (Mới nhất lên đầu)
                PageRequest pageable = PageRequest.of(page, size, Sort.by("paidAt").descending());

                // Gọi Service
                Page<VnpayReconciliationResponse> result = service.getTransactions(from, to, hubId, customerName,
                                pageable);

                return ResponseEntity.ok(result);
        }

        // 2. API XUẤT BÁO CÁO EXCEL
        @GetMapping("/export")
        public ResponseEntity<InputStreamResource> exportExcel(
                        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
                        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to,
                        @RequestParam(required = false) Long hubId,
                        @RequestParam(required = false) String customerName) throws IOException {

                // Gọi Service lấy luồng dữ liệu file
                var stream = service.exportToExcel(from, to, hubId, customerName);

                // Tạo Header để trình duyệt hiểu đây là file cần tải xuống
                HttpHeaders headers = new HttpHeaders();
                headers.add("Content-Disposition",
                                "attachment; filename=doi-soat-vnpay_" + System.currentTimeMillis() + ".xlsx");

                return ResponseEntity
                                .ok()
                                .headers(headers)
                                .contentType(
                                                MediaType.parseMediaType(
                                                                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                                .body(new InputStreamResource(stream));
        }
}