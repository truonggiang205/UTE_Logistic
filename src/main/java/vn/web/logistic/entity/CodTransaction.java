package vn.web.logistic.entity;

import java.math.BigDecimal;
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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

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

    public enum CodType {
        delivery_cod, return_fee
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_type", columnDefinition = "ENUM('delivery_cod','return_fee') DEFAULT 'delivery_cod'")
    @Builder.Default
    private CodType codType = CodType.delivery_cod;

    @Column(name = "paymentMethod", length = 50)
    private String paymentMethod;
}
