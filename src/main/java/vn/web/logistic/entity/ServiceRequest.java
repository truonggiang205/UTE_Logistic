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
@Table(name = "SERVICE_REQUESTS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "customer", "pickupAddress", "deliveryAddress", "serviceType", "currentHub" })
@EqualsAndHashCode(exclude = { "customer", "pickupAddress", "deliveryAddress", "serviceType", "currentHub" })
public class ServiceRequest {

    public enum RequestStatus {
        pending, picked, in_transit, delivered, cancelled, failed
    }

    public enum PaymentStatus {
        unpaid, paid, refunded
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "request_id")
    private Long requestId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pickup_address_id", nullable = false)
    private CustomerAddress pickupAddress;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "delivery_address_id", nullable = false)
    private CustomerAddress deliveryAddress;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_type_id", nullable = false)
    private ServiceType serviceType;

    private LocalDateTime expectedPickupTime;
    private String note;

    @Column(name = "imageOrder", length = 255)
    private String imageOrder;

    // Tên hàng hóa (nullable - an toàn với dữ liệu cũ)
    @Column(name = "item_name", length = 255)
    private String itemName;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('pending','picked','in_transit','delivered','cancelled','failed') DEFAULT 'pending'")
    @Builder.Default
    private RequestStatus status = RequestStatus.pending;

    @Column(columnDefinition = "DECIMAL(10,2)")
    private BigDecimal weight;

    @Column(columnDefinition = "DECIMAL(8,2)")
    private BigDecimal length;

    @Column(columnDefinition = "DECIMAL(8,2)")
    private BigDecimal width;

    @Column(columnDefinition = "DECIMAL(8,2)")
    private BigDecimal height;

    @Column(name = "cod_amount", columnDefinition = "DECIMAL(12,2) DEFAULT 0")
    @Builder.Default
    private BigDecimal codAmount = BigDecimal.ZERO;

    @Column(columnDefinition = "DECIMAL(10,2)")
    private BigDecimal chargeableWeight;

    @Column(columnDefinition = "DECIMAL(12,2)")
    private BigDecimal shippingFee;

    @Column(columnDefinition = "DECIMAL(12,2)")
    private BigDecimal codFee;

    @Column(columnDefinition = "DECIMAL(12,2)")
    private BigDecimal insuranceFee;

    @Column(columnDefinition = "DECIMAL(12,2)")
    private BigDecimal totalPrice;

    @Column(columnDefinition = "DECIMAL(12,2)")
    private BigDecimal receiverPayAmount;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('unpaid','paid','refunded') DEFAULT 'unpaid'")
    @Builder.Default
    private PaymentStatus paymentStatus = PaymentStatus.unpaid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "current_hub_id")
    private Hub currentHub;

    private LocalDateTime createdAt;
}
