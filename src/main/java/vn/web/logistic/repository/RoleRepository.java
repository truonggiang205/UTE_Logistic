package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
<<<<<<< HEAD
    Optional<Role> findByRoleName(String roleName);
=======

    Optional<Role> findByRoleName(String roleName);

    boolean existsByRoleName(String roleName);
>>>>>>> refs/heads/fea/test-security
}
