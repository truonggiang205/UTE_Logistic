package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.web.logistic.entity.ActionType;

public interface ActionTypeRepository extends JpaRepository<ActionType, Long> {
    Optional<ActionType> findByActionCode(String actionCode);
    boolean existsByActionCode(String actionCode);
}
