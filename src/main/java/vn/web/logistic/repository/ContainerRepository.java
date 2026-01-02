package vn.web.logistic.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Container;
import vn.web.logistic.entity.Container.ContainerStatus;

import java.util.List;
import java.util.Optional;

@Repository
public interface ContainerRepository extends JpaRepository<Container, Long> {

        @Query("SELECT c FROM Container c " +
                        "LEFT JOIN FETCH c.createdAtHub " +
                        "LEFT JOIN FETCH c.destinationHub " +
                        "LEFT JOIN FETCH c.createdBy " +
                        "WHERE c.containerId = :containerId")
        Optional<Container> findByIdWithDetails(@Param("containerId") Long containerId);

        @Query("SELECT c FROM Container c " +
                        "LEFT JOIN FETCH c.createdAtHub " +
                        "LEFT JOIN FETCH c.destinationHub " +
                        "WHERE c.containerCode LIKE %:code%")
        Page<Container> searchByCode(@Param("code") String code, Pageable pageable);

        @Modifying
        @Query("UPDATE Container c SET c.status = :status WHERE c.containerId = :containerId")
        int updateStatus(@Param("containerId") Long containerId, @Param("status") ContainerStatus status);

        boolean existsByContainerCode(String containerCode);

        /**
         * Tìm containers theo status và destination hub
         * Dùng cho chức năng Gate Out - lấy containers sẵn sàng để nạp lên xe
         */
        @Query("SELECT c FROM Container c " +
                        "LEFT JOIN FETCH c.createdAtHub " +
                        "LEFT JOIN FETCH c.destinationHub " +
                        "WHERE c.status = :status " +
                        "AND c.destinationHub.hubId = :toHubId " +
                        "ORDER BY c.createdAt DESC")
        java.util.List<Container> findByStatusAndDestinationHub(
                        @Param("status") ContainerStatus status,
                        @Param("toHubId") Long toHubId);

        /**
         * Tìm containers theo status
         */
        @Query("SELECT c FROM Container c " +
                        "WHERE c.createdAtHub.hubId = :hubId " +
                        "AND c.status IN :statuses")
        List<Container> findByHubAndStatuses(
                        @Param("hubId") Long hubId,
                        @Param("statuses") List<Container.ContainerStatus> statuses);

        /**
         * Tìm containers sẵn sàng xếp xe (status = closed và chưa nằm trong chuyến xe
         * nào)
         */
        @Query("SELECT c FROM Container c " +
                        "LEFT JOIN FETCH c.createdAtHub " +
                        "LEFT JOIN FETCH c.destinationHub " +
                        "WHERE c.createdAtHub.hubId = :hubId " +
                        "AND c.status = :status " +
                        "AND NOT EXISTS (SELECT 1 FROM TripContainer tc WHERE tc.container = c) " +
                        "ORDER BY c.createdAt ASC")
        List<Container> findContainersReadyForLoadingByStatus(
                        @Param("hubId") Long hubId,
                        @Param("status") Container.ContainerStatus status);

        /**
         * Tìm containers sẵn sàng xếp xe - gọi từ service với status CLOSED
         */
        default List<Container> findContainersReadyForLoading(Long hubId) {
                return findContainersReadyForLoadingByStatus(hubId, Container.ContainerStatus.closed);
        }
}
