package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.response.CodTransactionResponse;
import vn.web.logistic.service.CodTransactionService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/admin/cod")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class CodTransactionController {

    private final CodTransactionService service;

    // API 1: Lấy danh sách giao dịch COD
    @GetMapping
    public ResponseEntity<Page<CodTransactionResponse>> getList(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to,
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String shipperName,
            @RequestParam(required = false) String status, // collected, settled
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        // Sắp xếp ngày thu tiền giảm dần
        PageRequest pageable = PageRequest.of(page, size, Sort.by("collectedAt").descending());
        return ResponseEntity.ok(service.getCodTransactions(from, to, hubId, shipperName, status, pageable));
    }

    // API 2: Xem tổng công nợ Shipper đang giữ
    // FE gọi API này để hiển thị số to đùng trên Dashboard: "Shipper A đang giữ
    // 5.000.000đ"
    @GetMapping("/stats/holding")
    public ResponseEntity<Map<String, Object>> getHoldingStats(
            @RequestParam(required = false) Long shipperId) {
        BigDecimal totalHolding = service.getTotalHoldingAmount(shipperId);

        Map<String, Object> response = new HashMap<>();
        response.put("shipperId", shipperId);
        response.put("totalHoldingAmount", totalHolding); // Tổng tiền đang giữ (Status = collected)

        return ResponseEntity.ok(response);
    }
}