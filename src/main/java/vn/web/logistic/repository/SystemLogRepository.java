package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.SystemLog;

@Repository
public interface SystemLogRepository extends JpaRepository<SystemLog, Long>, JpaSpecificationExecutor<SystemLog> {
    // JpaSpecificationExecutor hỗ trợ tìm kiếm động
}