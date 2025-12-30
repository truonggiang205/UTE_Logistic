package vn.web.logistic.repository.specification;

import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.StringUtils;

import vn.web.logistic.dto.request.admin.LogFilterRequest;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.entity.User;

import java.util.ArrayList;
import java.util.List;

public class SystemLogSpecification {

    public static Specification<SystemLog> filter(LogFilterRequest request) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            // 1. Lọc theo khoảng thời gian (From - To)
            if (request.getFromDate() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("logTime"), request.getFromDate()));
            }
            if (request.getToDate() != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("logTime"), request.getToDate()));
            }

            // 2. Lọc theo Username hoặc FullName (Join bảng User)
            if (StringUtils.hasText(request.getUsername())) {
                Join<SystemLog, User> userJoin = root.join("user", JoinType.LEFT);
                String pattern = "%" + request.getUsername().toLowerCase() + "%";
                predicates.add(cb.or(
                        cb.like(cb.lower(userJoin.get("username")), pattern),
                        cb.like(cb.lower(userJoin.get("fullName")), pattern)));
            }

            // 3. Lọc theo Action (Ví dụ: "CREATE", "UPDATE")
            if (StringUtils.hasText(request.getAction())) {
                predicates.add(cb.like(cb.lower(root.get("action")), "%" + request.getAction().toLowerCase() + "%"));
            }

            // 4. Lọc theo Object Type (Ví dụ: "PARCEL", "USER")
            if (StringUtils.hasText(request.getObjectType())) {
                predicates.add(cb.equal(root.get("objectType"), request.getObjectType()));
            }

            // Sắp xếp mặc định: Mới nhất lên đầu
            query.orderBy(cb.desc(root.get("logTime")));

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}