package vn.web.logistic.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.web.logistic.dto.response.CodTransactionResponse;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public interface CodTransactionService {

    // Lấy danh sách giao dịch COD có lọc và phân trang
    Page<CodTransactionResponse> getCodTransactions(
            LocalDateTime from,
            LocalDateTime to,
            Long hubId,
            String shipperName,
            String statusStr,
            Pageable pageable);

    // Lấy tổng số tiền Shipper đang "cầm" (Nợ) chưa nộp về kho.
    // Nếu shipperId = null thì tính tổng toàn bộ hệ thống.
    BigDecimal getTotalHoldingAmount(Long shipperId);
}