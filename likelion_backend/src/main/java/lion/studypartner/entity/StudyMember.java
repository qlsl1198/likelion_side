package lion.studypartner.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "study_members")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class StudyMember {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_id", nullable = false)
    private Study study;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(nullable = false)
    private String role = "member"; // leader, member
    
    @Column(nullable = false)
    private String status = "active"; // active, inactive, banned
    
    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime joinedAt;
    
    @Column
    private LocalDateTime leftAt;
} 