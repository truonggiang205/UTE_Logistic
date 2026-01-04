package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.enums.CodStatus;

import java.util.List;

@Repository
public interface CodTransactionRepository extends JpaRepository<CodTransaction, Long> {

    /**
     * Tìm tất cả giao dịch COD dựa trên khách hàng của đơn hàng.
     * Sử dụng Property Traversal: đi từ CodTransaction -> Request -> Customer.
     */
    List<CodTransaction> findByRequest_CustomerOrderByCollectedAtDesc(Customer customer);

    /**
     * Tìm các giao dịch theo trạng thái (pending, collected, settled).
     */
    List<CodTransaction> findByRequest_CustomerAndStatus(Customer customer, CodStatus status);

    /**
     * Tìm giao dịch của một đơn hàng cụ thể.
     */
    CodTransaction findByRequest_RequestId(Long requestId);
    
    /**
     * Lấy các giao dịch đã thu tiền nhưng chưa đối soát (phục vụ tính toán tiền đang giữ hộ).
     */
    List<CodTransaction> findByRequest_CustomerAndStatusAndSettledAtIsNull(Customer customer, CodStatus status);
}