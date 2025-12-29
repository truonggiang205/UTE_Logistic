package vn.web.logistic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import vn.web.logistic.entity.Hub;

public interface HubRepository extends JpaRepository<Hub, Long> {

    @Query("select h from Hub h where h.status = 'active' order by h.hubName asc")
    List<Hub> findAllActiveOrderByName();
}
