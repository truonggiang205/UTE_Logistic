package vn.web.logistic.repository.specification;

import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import vn.web.logistic.entity.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CodTransactionSpecification {

    public static Specification<CodTransaction> filterCod(
            LocalDateTime startDate, LocalDateTime endDate, Long hubId, String shipperName,
            CodTransaction.CodStatus status) {

        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            // 1. Lọc thời gian: Dùng Trực tiếp root.get
            if (startDate != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("collectedAt"), startDate));
            }
            if (endDate != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("collectedAt"), endDate));
            }

            // 2. Lọc Trạng thái: Quan trọng nhất
            if (status != null) {
                predicates.add(cb.equal(root.get("status"), status));
            }

            // 3. Lọc Hub & Shipper Name: DÙNG LEFT JOIN
            if (hubId != null) {
                predicates.add(cb.equal(root.join("shipper", JoinType.LEFT)
                        .join("hub", JoinType.LEFT)
                        .get("hubId"), hubId));
            }

            if (shipperName != null && !shipperName.isEmpty()) {
                predicates.add(cb.like(cb.lower(root.join("shipper", JoinType.LEFT)
                        .join("user", JoinType.LEFT)
                        .get("fullName")),
                        "%" + shipperName.toLowerCase() + "%"));
            }

            // PHẢI CÓ DÒNG NÀY: Nối tất cả bằng AND
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}