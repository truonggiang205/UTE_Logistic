package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "SUPPORT_TICKETS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SupportTicket {

    public enum TicketStatus {
        pending,
        processing,
        resolved
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ticket_id")
    private Long ticketId;

    // Liên kết với khách hàng gửi khiếu nại
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    // Liên kết với đơn hàng cụ thể cần hỗ trợ
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = true)
    private ServiceRequest serviceRequest;

    @Column(nullable = false, length = 255)
    private String subject;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String message;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('pending','processing','resolved') DEFAULT 'pending'")
    @Builder.Default
    private TicketStatus status = TicketStatus.pending;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    public void prePersist() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
    }

}