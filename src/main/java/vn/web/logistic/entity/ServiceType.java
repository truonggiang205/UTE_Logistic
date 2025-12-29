package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

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

    @Column(name = "service_code", nullable = false, unique = false, length = 20)
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

    /// Các trường mới để khi thay đổi giá dịch vụ ở một thời điểm thì không bị thay
    /// đổi các giá trị của các đơn trước đó
    @Builder.Default
    @Column(name = "is_active")
    private Boolean isActive = true;

    @Builder.Default
    @Column(name = "version")
    private Integer version = 1;

    @Column(name = "effective_from")
    private LocalDateTime effectiveFrom;

    @Column(name = "parent_id")
    private Long parentId; // Dùng để nhóm các version của cùng một loại dịch vụ
}