package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ActionType;

@Repository
public interface ActionTypeRepository extends JpaRepository<ActionType, Long> {

    // Tìm action type theo code
    Optional<ActionType> findByActionCode(String actionCode);
}
