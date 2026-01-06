package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.SupportTicket;
import vn.web.logistic.entity.Customer;
import java.util.List;

@Repository
public interface SupportTicketRepository extends JpaRepository<SupportTicket, Long> {
    // Lấy danh sách khiếu nại của một khách hàng cụ thể
    List<SupportTicket> findByCustomerOrderByCreatedAtDesc(Customer customer);
}