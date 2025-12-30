package vn.web.logistic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ParcelAction;

@Repository
public interface ParcelActionRepository extends JpaRepository<ParcelAction, Long> {

    // Tìm tất cả actions của một request, sắp xếp theo thời gian mới nhất
    List<ParcelAction> findByRequest_RequestIdOrderByActionTimeDesc(Long requestId);

    // Tìm tất cả actions của một request
    List<ParcelAction> findByRequest_RequestId(Long requestId);
}
