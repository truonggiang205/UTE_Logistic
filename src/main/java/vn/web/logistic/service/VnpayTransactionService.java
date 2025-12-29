package vn.web.logistic.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.web.logistic.dto.response.VnpayReconciliationResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.time.LocalDateTime;

public interface VnpayTransactionService {

        // Lấy danh sách giao dịch VNPAY có lọc và phân trang (dùng cho Table hiển thị)
        Page<VnpayReconciliationResponse> getTransactions(
                        LocalDateTime from,
                        LocalDateTime to,
                        Long hubId,
                        String customerName,
                        Pageable pageable);

        // Xuất danh sách giao dịch ra file Excel (dùng cho nút Export)
        ByteArrayInputStream exportToExcel(
                        LocalDateTime from,
                        LocalDateTime to,
                        Long hubId,
                        String customerName) throws IOException;

}