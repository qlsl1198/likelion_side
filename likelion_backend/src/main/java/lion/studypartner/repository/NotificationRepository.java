package lion.studypartner.repository;

import lion.studypartner.entity.Notification;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    
    // 사용자의 모든 알림 조회 (최신순)
    Page<Notification> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);
    
    // 사용자의 읽지 않은 알림 조회
    List<Notification> findByUserIdAndStatusOrderByCreatedAtDesc(Long userId, String status);
    
    // 사용자의 읽지 않은 알림 개수
    long countByUserIdAndStatus(Long userId, String status);
    
    // 특정 스터디와 관련된 알림 조회
    List<Notification> findByStudyIdOrderByCreatedAtDesc(Long studyId);
    
    // 특정 타입의 알림 조회
    List<Notification> findByUserIdAndTypeOrderByCreatedAtDesc(Long userId, String type);
    
    // 알림을 읽음 상태로 변경
    @Modifying
    @Query("UPDATE Notification n SET n.status = 'read', n.readAt = CURRENT_TIMESTAMP WHERE n.id = :id")
    void markAsRead(@Param("id") Long id);
    
    // 사용자의 모든 알림을 읽음 상태로 변경
    @Modifying
    @Query("UPDATE Notification n SET n.status = 'read', n.readAt = CURRENT_TIMESTAMP WHERE n.user.id = :userId")
    void markAllAsRead(@Param("userId") Long userId);
    
    // 오래된 알림 삭제 (30일 이상)
    @Modifying
    @Query("DELETE FROM Notification n WHERE n.createdAt < :date")
    void deleteOldNotifications(@Param("date") java.time.LocalDateTime date);
} 