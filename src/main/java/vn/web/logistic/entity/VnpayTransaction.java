package vn.web.logistic.entity;

import jakarta.persistence.*;

import lombok.*;
import vn.web.logistic.enums.VnpayPaymentStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "VNPAY_TRANSACTIONS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = "request")
@EqualsAndHashCode(exclude = "request")
public class VnpayTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long vnpayTxId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private ServiceRequest request;

    @Column(columnDefinition = "DECIMAL(12,2)")
    private BigDecimal amount;

    @Column(name = "vnp_txn_ref", length = 100)
    private String vnpTxnRef;

    @Column(name = "vnp_transaction_no", length = 100)
    private String vnpTransactionNo;

    @Column(name = "vnp_response_code", length = 10)
    private String vnpResponseCode;

    @Column(name = "vnp_order_info", length = 255)
    private String vnpOrderInfo;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('pending','success','failed') DEFAULT 'pending'")
    private VnpayPaymentStatus paymentStatus = VnpayPaymentStatus.pending;

    private LocalDateTime paidAt;

    private LocalDateTime createdAt;
    
    public String getFormattedCreatedAt() {
        if (this.createdAt == null) return "---";
        return this.createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
