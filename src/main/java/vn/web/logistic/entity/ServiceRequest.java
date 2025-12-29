package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@Entity
@Table(name = "SERVICE_REQUESTS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "customer", "pickupAddress", "deliveryAddress", "serviceType", "currentHub" })
@EqualsAndHashCode(exclude = { "customer", "pickupAddress", "deliveryAddress", "serviceType", "currentHub" })
public class ServiceRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private RequestStatus status = RequestStatus.pending;

    @Column(columnDefinition = "DECIMAL(10,2)")
    private BigDecimal weight;

    @Column(columnDefinition = "DECIMAL(8,2)")
    private BigDecimal length;

    @Column(columnDefinition = "DECIMAL(8,2)")
    private BigDecimal width;

    @Column(columnDefinition = "DECIMAL(8,2)")
    private BigDecimal height;

    @Column(name = "cod_amount", columnDefinition = "DECIMAL(12,2)")
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
    @Column(nullable = false, length = 20)
    private PaymentStatus paymentStatus = PaymentStatus.unpaid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "current_hub_id")
    private Hub currentHub;

    private LocalDateTime createdAt;
}

enum RequestStatus {
    pending, picked, in_transit, delivered, cancelled, failed
}

enum PaymentStatus {
    unpaid, paid, refunded
}