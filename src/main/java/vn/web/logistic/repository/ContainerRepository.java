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
}
