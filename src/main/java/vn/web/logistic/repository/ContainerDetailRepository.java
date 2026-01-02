package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Container;
import vn.web.logistic.entity.ContainerDetail;

import java.util.List;

@Repository
public interface ContainerDetailRepository extends JpaRepository<ContainerDetail, Long> {

    List<ContainerDetail> findByContainerContainerId(Long containerId);

    @Query("SELECT cd FROM ContainerDetail cd JOIN FETCH cd.request r WHERE cd.container.containerId = :containerId")
    List<ContainerDetail> findByContainerIdWithRequest(@Param("containerId") Long containerId);

    // optional helper
    List<ContainerDetail> findByRequestRequestId(Long requestId);

    // Xóa tất cả ContainerDetail của một đơn hàng
    void deleteByRequest_RequestId(Long requestId);

    @Query("SELECT c FROM Container c " +
            "WHERE c.createdAtHub.hubId = :hubId " +
            "AND c.status IN :statuses")
    List<Container> findByHubAndStatuses(
            @Param("hubId") Long hubId,
            @Param("statuses") List<Container.ContainerStatus> statuses);
}
