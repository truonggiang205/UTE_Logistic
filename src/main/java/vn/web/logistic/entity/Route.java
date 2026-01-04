package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.*;

@Entity
@Table(name = "ROUTES")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "fromHub", "toHub" })
@EqualsAndHashCode(exclude = { "fromHub", "toHub" })
public class Route {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long routeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "from_hub_id", nullable = false)
    private Hub fromHub;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "to_hub_id", nullable = false)
    private Hub toHub;

    private Integer estimatedTime;

    private String description;
}