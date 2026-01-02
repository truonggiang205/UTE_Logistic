package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.ParcelAction;

import java.util.List;

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

    // Xóa tất cả hành động của một đơn hàng
    void deleteByRequest_RequestId(Long requestId);

    //// [MẶC ĐỊNH] save(ParcelAction entity): Ghi lại một bước di chuyển của đơn
    //// hàng vào log.
    ///
}
