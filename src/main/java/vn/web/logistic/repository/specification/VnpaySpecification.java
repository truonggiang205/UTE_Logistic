package vn.web.logistic.repository.specification;

import jakarta.persistence.criteria.Join;
import org.springframework.data.jpa.domain.Specification;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.VnpayTransaction;

import java.time.LocalDateTime;

public class VnpaySpecification {
    public static Specification<VnpayTransaction> filterTransactions(
            LocalDateTime startDate,
            LocalDateTime endDate,
            Long hubId,
            String customerName) {

        return (root, query, cb) -> {
            var predicates = cb.conjunction();

            // 1. Filter theo thời gian thanh toán (paidAt)
            if (startDate != null && endDate != null) {
                predicates.getExpressions().add(cb.between(root.get("paidAt"), startDate, endDate));
            }

            // Join bảng ServiceRequest để lấy thông tin Hub và Customer
            // (Vì bảng VnpayTransaction chỉ có request_id chứ không có hub_id trực tiếp)
            Join<VnpayTransaction, ServiceRequest> requestJoin = root.join("request");

            // 2. Filter theo Hub (Hub hiện tại của đơn hàng)
            if (hubId != null) {
                Join<ServiceRequest, Hub> hubJoin = requestJoin.join("currentHub");
                predicates.getExpressions().add(cb.equal(hubJoin.get("hubId"), hubId));
            }

            // 3. Filter theo User (Tên khách hàng - tìm gần đúng, không phân biệt hoa
            // thường)
            if (customerName != null && !customerName.isEmpty()) {
                Join<ServiceRequest, Customer> customerJoin = requestJoin.join("customer");
                predicates.getExpressions().add(
                        cb.like(cb.lower(customerJoin.get("fullName")), "%" + customerName.toLowerCase() + "%"));
            }

            return predicates;
        };
    }
}