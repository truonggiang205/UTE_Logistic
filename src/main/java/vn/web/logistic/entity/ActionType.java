package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ACTION_TYPES")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ActionType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "action_type_id")
    private Long actionTypeId;

    @Column(name = "action_code", nullable = false, unique = true, length = 20)
    private String actionCode;

    @Column(name = "action_name", nullable = false, length = 100)
    private String actionName;

    private String description;
}