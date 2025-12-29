package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "COD_TRANSACTIONS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "request", "shipper" })
@EqualsAndHashCode(exclude = { "request", "shipper" })
public class CodTransaction {

    public enum CodStatus {
        collected, settled, pending
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cod_tx_id")
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
    @Builder.Default
    private CodStatus status = CodStatus.pending;

    @Column(name = "paymentMethod", length = 50)
    private String paymentMethod;
}
