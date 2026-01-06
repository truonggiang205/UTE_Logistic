package vn.web.logistic.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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

    public enum CustomerType {
        individual, business
    }

    public enum CustomerStatus {
        active, inactive
    }
}