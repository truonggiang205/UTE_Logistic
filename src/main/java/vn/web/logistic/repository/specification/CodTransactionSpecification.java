package vn.web.logistic.repository.specification;

import jakarta.persistence.criteria.Join;
import org.springframework.data.jpa.domain.Specification;
import vn.web.logistic.entity.*;

import java.time.LocalDateTime;

public class CodTransactionSpecification {

    public static Specification<CodTransaction> filterCod(
            LocalDateTime startDate,
            LocalDateTime endDate,
            Long hubId,
            String shipperName,
            CodTransaction.CodStatus status) { // Thêm lọc theo trạng thái (vd: chỉ xem tiền đang giữ)

        return (root, query, cb) -> {
            var predicates = cb.conjunction();

            // 1. Filter theo thời gian thu tiền (collectedAt)
            if (startDate != null && endDate != null) {
                predicates.getExpressions().add(cb.between(root.get("collectedAt"), startDate, endDate));
            }

            // Join bảng Shipper
            Join<CodTransaction, Shipper> shipperJoin = root.join("shipper");

            // 2. Filter theo Hub (của Shipper)
            if (hubId != null) {
                Join<Shipper, Hub> hubJoin = shipperJoin.join("hub");
                predicates.getExpressions().add(cb.equal(hubJoin.get("hubId"), hubId));
            }

            // 3. Filter theo tên Shipper (Join tiếp sang bảng User)
            if (shipperName != null && !shipperName.isEmpty()) {
                Join<Shipper, User> userJoin = shipperJoin.join("user");
                predicates.getExpressions().add(
                        cb.like(cb.lower(userJoin.get("fullName")), "%" + shipperName.toLowerCase() + "%"));
            }

            // 4. Filter theo trạng thái (Collected: Đang giữ tiền / Settled: Đã nộp)
            if (status != null) {
                predicates.getExpressions().add(cb.equal(root.get("status"), status));
            }

            return predicates;
        };
    }
}