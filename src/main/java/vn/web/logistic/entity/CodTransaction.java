package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import vn.web.logistic.enums.CodStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "COD_TRANSACTIONS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "request", "shipper" })
@EqualsAndHashCode(exclude = { "request", "shipper" })
public class CodTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long codTxId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private ServiceRequest request;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shipper_id")
    private Shipper shipper;

    @Column(nullable = false)
    private BigDecimal amount;

    private LocalDateTime collectedAt;

    private LocalDateTime settledAt;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('collected','settled','pending') DEFAULT 'pending'")
    private CodStatus status = CodStatus.pending;

    @Column(name = "paymentMethod", length = 50)
    private String paymentMethod;
    
    public String getFormattedCollectedAt() {
        return collectedAt != null ? collectedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "---";
    }

    public String getFormattedSettledAt() {
        return settledAt != null ? settledAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "---";
    }
}