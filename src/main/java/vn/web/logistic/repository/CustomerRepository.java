package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.web.logistic.entity.Customer;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
}
