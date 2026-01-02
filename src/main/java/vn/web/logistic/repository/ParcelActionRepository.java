package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.ParcelAction;

@Repository
public interface ParcelActionRepository extends JpaRepository<ParcelAction, Long> {

    // Lấy danh sách lịch sử hành động của một đơn hàng, sắp xếp theo thời gian giảm
    // dần
    @Query("SELECT pa FROM ParcelAction pa " +
            "LEFT JOIN FETCH pa.actionType " +
            "LEFT JOIN FETCH pa.fromHub " +
            "LEFT JOIN FETCH pa.toHub " +
            "LEFT JOIN FETCH pa.actor " +
            "WHERE pa.request.requestId = :requestId " +
            "ORDER BY pa.actionTime DESC")
    List<ParcelAction> findByRequestIdWithDetails(@Param("requestId") Long requestId);

    // Đếm số hành động của một đơn hàng
    long countByRequestRequestId(Long requestId);

    // Tìm Hub gốc của đơn hàng (từ action PICKED_UP đầu tiên)
    // Hub gốc là toHub của action PICKED_UP (hub mà hàng được đưa vào sau khi
    // pickup)
    @Query("SELECT pa.toHub FROM ParcelAction pa " +
            "WHERE pa.request.requestId = :requestId " +
            "AND pa.actionType.actionCode = 'PICKED_UP' " +
            "ORDER BY pa.actionTime ASC " +
            "LIMIT 1")
    Optional<Hub> findOriginHubByRequestId(@Param("requestId") Long requestId);
}
