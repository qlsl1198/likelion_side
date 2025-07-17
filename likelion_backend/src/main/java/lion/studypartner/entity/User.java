package lion.studypartner.entity;

import javax.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(nullable = false)
    private String password;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String nickname;
    
    @Column(name = "birth_date")
    private LocalDateTime birthDate;
    
    @Column(name = "occupation")
    private String occupation;
    
    @Column(name = "education_level")
    private String educationLevel;
    
    @Column(name = "status")
    private String status;
    
    @Column(name = "provider")
    private String provider; // "google", "kakao", "naver" 등
    
    @Column(name = "provider_id")
    private String providerId; // OAuth 제공자의 고유 ID
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
} 