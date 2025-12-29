package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "SERVICE_TYPES")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServiceType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "service_type_id")
    private Long serviceTypeId;

    @Column(name = "service_code", nullable = false, unique = true, length = 20)
    private String serviceCode;

    @Column(name = "service_name", nullable = false, length = 100)
    private String serviceName;

    @Builder.Default
    @Column(name = "base_fee", columnDefinition = "DECIMAL(12,2) DEFAULT 0")
    private BigDecimal baseFee = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "extra_price_per_kg", columnDefinition = "DECIMAL(12,2) DEFAULT 0")
    private BigDecimal extraPricePerKg = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "cod_rate", columnDefinition = "DECIMAL(5,4) DEFAULT 0")
    private BigDecimal codRate = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "cod_min_fee", columnDefinition = "DECIMAL(12,2) DEFAULT 0")
    private BigDecimal codMinFee = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "insurance_rate", columnDefinition = "DECIMAL(5,4) DEFAULT 0")
    private BigDecimal insuranceRate = BigDecimal.ZERO;

    private String description;
}