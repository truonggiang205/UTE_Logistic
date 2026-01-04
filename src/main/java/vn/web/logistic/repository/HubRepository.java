package vn.web.logistic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Hub;
import vn.web.logistic.enums.HubLevel;
import vn.web.logistic.enums.HubStatus;

@Repository
public interface HubRepository extends JpaRepository<Hub, Long> {
    // Lấy toàn bộ danh sách bưu cục/kho
	List<Hub> findByProvinceAndHubLevelAndStatus(String province, HubLevel level, HubStatus status);
}