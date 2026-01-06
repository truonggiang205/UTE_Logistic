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

    // Lấy danh sách lịch sử hành động của một đơn hàng, sắp xếp theo thời gian giảm dần
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

    boolean existsByActionType_ActionTypeId(Long actionTypeId);

    // Xóa tất cả hành động của một đơn hàng
    void deleteByRequest_RequestId(Long requestId);

    // Tìm tất cả actions của một request, sắp xếp theo thời gian mới nhất
    List<ParcelAction> findByRequest_RequestIdOrderByActionTimeDesc(Long requestId);

    // Tìm tất cả actions của một request
    List<ParcelAction> findByRequest_RequestId(Long requestId);

    // Hub gốc của đơn (toHub của action PICKED_UP đầu tiên)
    @Query("SELECT pa.toHub FROM ParcelAction pa " +
            "WHERE pa.request.requestId = :requestId " +
            "AND pa.actionType.actionCode = 'PICKED_UP' " +
            "ORDER BY pa.actionTime ASC")
    List<Hub> findOriginHubCandidatesByRequestId(@Param("requestId") Long requestId);

    default Optional<Hub> findOriginHubByRequestId(Long requestId) {
        List<Hub> hubs = findOriginHubCandidatesByRequestId(requestId);
        return hubs == null || hubs.isEmpty() ? Optional.empty() : Optional.ofNullable(hubs.get(0));
    }
}
