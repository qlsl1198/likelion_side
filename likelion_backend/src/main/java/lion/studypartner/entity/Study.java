package lion.studypartner.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "studies")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class Study {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(nullable = false)
    private String category;
    
    @Column(nullable = false)
    private String location;
    
    @Column(nullable = false)
    private Integer maxParticipants;
    
    @Column(nullable = false)
    private Integer currentParticipants = 0;
    
    @Column(nullable = false)
    private String status = "recruiting"; // recruiting, in_progress, completed, cancelled
    
    @Column(nullable = false)
    private LocalDateTime startDate;
    
    @Column(nullable = false)
    private LocalDateTime endDate;
    
    @Column(nullable = false)
    private String studyType; // online, offline, hybrid
    
    @Column
    private String meetingLink;
    
    @Column
    private String contactInfo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "leader_id", nullable = false)
    private User leader;
    
    @OneToMany(mappedBy = "study", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<StudyMember> members = new ArrayList<>();
    
    @OneToMany(mappedBy = "study", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<StudyPost> posts = new ArrayList<>();
    
    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    
    // 편의 메서드
    public void addMember(StudyMember member) {
        members.add(member);
        member.setStudy(this);
        currentParticipants++;
    }
    
    public void removeMember(StudyMember member) {
        members.remove(member);
        member.setStudy(null);
        currentParticipants--;
    }
    
    public boolean isFull() {
        return currentParticipants >= maxParticipants;
    }
    
    public boolean canJoin() {
        return status.equals("recruiting") && !isFull();
    }
} 