package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.VnpayTransaction;

@Repository
public interface VnpayTransactionRepository extends
                JpaRepository<VnpayTransaction, Long>,
                JpaSpecificationExecutor<VnpayTransaction> {
        // Cần cái này để filter động
        // JpaSpecificationExecutor: Là cái giúp phân trang khi filter
}