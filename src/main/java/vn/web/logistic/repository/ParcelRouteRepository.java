package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ParcelRoute;
import vn.web.logistic.entity.ParcelRoute.ParcelRouteStatus;

@Repository
public interface ParcelRouteRepository extends JpaRepository<ParcelRoute, Long> {

        // 1. Tìm tất cả các chặng của một đơn hàng cụ thể
        List<ParcelRoute> findByRequest_RequestId(Long requestId);

        // 2. Tìm theo requestId và status
        List<ParcelRoute> findByRequest_RequestIdAndStatus(Long requestId, ParcelRouteStatus status);

        // 3. Tìm ParcelRoute theo requestId và toHub của Route (dùng cho
        // processInterHubInbound)
        @Query("SELECT pr FROM ParcelRoute pr " +
                        "LEFT JOIN FETCH pr.route r " +
                        "LEFT JOIN FETCH r.toHub " +
                        "WHERE pr.request.requestId = :requestId AND r.toHub.hubId = :toHubId")
        Optional<ParcelRoute> findByRequestIdAndRouteToHubId(@Param("requestId") Long requestId,
                        @Param("toHubId") Long toHubId);

        // 4. Tìm ParcelRoute đang ở trạng thái in_progress cho một request
        @Query("SELECT pr FROM ParcelRoute pr WHERE pr.request.requestId = :requestId AND pr.status = 'in_progress'")
        Optional<ParcelRoute> findInProgressByRequestId(@Param("requestId") Long requestId);

        // 5. Xóa tất cả ParcelRoute của một đơn hàng
        void deleteByRequest_RequestId(Long requestId);
}