package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.TrackingCode;

import java.util.Optional;

@Repository
public interface TrackingCodeRepository extends JpaRepository<TrackingCode, Long> {

    /**
     * Tìm TrackingCode theo mã code
     */
    Optional<TrackingCode> findByCode(String code);

    /**
     * Tìm TrackingCode theo requestId
     */
    @Query("SELECT tc FROM TrackingCode tc WHERE tc.request.requestId = :requestId")
    Optional<TrackingCode> findByRequestId(@Param("requestId") Long requestId);

    /**
     * Tìm TrackingCode theo requestId (derived query)
     */
    Optional<TrackingCode> findByRequest_RequestId(Long requestId);

    /**
     * Xóa TrackingCode theo requestId
     */
    void deleteByRequest_RequestId(Long requestId);

    /**
     * Tìm TrackingCode theo mã code (tìm kiếm LIKE)
     */
    @Query("SELECT tc FROM TrackingCode tc WHERE tc.code LIKE %:keyword%")
    java.util.List<TrackingCode> findByCodeContaining(@Param("keyword") String keyword);
}
