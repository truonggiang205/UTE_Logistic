package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "CUSTOMERS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "customer_id")
    private Long customerId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = true, unique = true) // Có thể null với khách vãng lai
    private User user;

    @Column(name = "full_name", length = 150)
    private String fullName; // Thêm trường fullName để lưu tên khách hàng vãng lai/có userid

    @Column(name = "business_name", length = 150)
    private String businessName;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('individual','business') DEFAULT 'individual'")
    @Builder.Default
    private CustomerType customerType = CustomerType.individual;

    @Column(length = 100)
    private String email;

    @Column(length = 20)
    private String phone;

    @Column(name = "tax_code", length = 30)
    private String taxCode;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('active','inactive') DEFAULT 'active'")
    @Builder.Default
    private CustomerStatus status = CustomerStatus.active;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    public void prePersist() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
    }
}

enum CustomerType {
    individual, business
}

enum CustomerStatus {
    active, inactive
}