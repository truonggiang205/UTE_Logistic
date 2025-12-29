package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.response.CodTransactionResponse;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.specification.CodTransactionSpecification;
import vn.web.logistic.service.CodTransactionService;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class CodTransactionServiceImpl implements CodTransactionService {

    private final CodTransactionRepository repository;

    // 1. Lấy danh sách giao dịch COD có lọc và phân trang
    @Override
    @Transactional(readOnly = true) // Tối ưu hiệu năng cho thao tác đọc
    public Page<CodTransactionResponse> getCodTransactions(
            LocalDateTime from, LocalDateTime to,
            Long hubId, String shipperName,
            String statusStr,
            Pageable pageable) {

        // Convert chuỗi status sang Enum
        CodTransaction.CodStatus statusEnum = null;
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                statusEnum = CodTransaction.CodStatus.valueOf(statusStr.toLowerCase());
            } catch (IllegalArgumentException e) {
                // Ignore invalid status hoặc log warning tùy ý
            }
        }

        var spec = CodTransactionSpecification.filterCod(from, to, hubId, shipperName, statusEnum);
        return repository.findAll(spec, pageable).map(CodTransactionResponse::fromEntity);
    }

    // 2. Lấy tổng số tiền Shipper đang "cầm" (Nợ) chưa nộp về kho
    // Nếu shipperId = null thì tính tổng toàn bộ hệ thống
    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalHoldingAmount(Long shipperId) {
        BigDecimal total = repository.sumHoldingAmountByShipper(shipperId);
        return total != null ? total : BigDecimal.ZERO;
    }
}