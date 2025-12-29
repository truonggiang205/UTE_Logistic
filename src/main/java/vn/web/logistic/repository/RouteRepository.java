package vn.web.logistic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import vn.web.logistic.entity.Route;

public interface RouteRepository extends JpaRepository<Route, Long> {

    @Query("select r from Route r join fetch r.fromHub fh join fetch r.toHub th order by r.routeId desc")
    List<Route> findAllWithHubs();
}
