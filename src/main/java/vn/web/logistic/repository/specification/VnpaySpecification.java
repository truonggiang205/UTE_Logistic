package vn.web.logistic.repository.specification;

import jakarta.persistence.criteria.Join;
import org.springframework.data.jpa.domain.Specification;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.VnpayTransaction;

import java.time.LocalDateTime;
import java.util.ArrayList;

public class VnpaySpecification {
    public static Specification<VnpayTransaction> filterTransactions(
            LocalDateTime startDate,
            LocalDateTime endDate,
            Long hubId,
            String customerName) {

        return (root, query, cb) -> {
            var predicates = new ArrayList<jakarta.persistence.criteria.Predicate>();

            // 1. Filter theo startDate (Từ ngày)
            if (startDate != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("paidAt"), startDate));
            }

            // 2. Filter theo endDate (Đến ngày)
            if (endDate != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("paidAt"), endDate));
            }

            // 3. Chỉ JOIN khi cần thiết (Để lọc Hub hoặc Customer)
            if (hubId != null || (customerName != null && !customerName.isEmpty())) {
                Join<VnpayTransaction, ServiceRequest> requestJoin = root.join("request");

                // Lọc theo Hub
                if (hubId != null) {
                    Join<ServiceRequest, Hub> hubJoin = requestJoin.join("currentHub");
                    predicates.add(cb.equal(hubJoin.get("hubId"), hubId));
                }

                // Lọc theo Tên khách hàng
                if (customerName != null && !customerName.isEmpty()) {
                    Join<ServiceRequest, Customer> customerJoin = requestJoin.join("customer");
                    predicates.add(cb.like(cb.lower(customerJoin.get("fullName")),
                            "%" + customerName.toLowerCase() + "%"));
                }
            }

            return cb.and(predicates.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };
    }
}