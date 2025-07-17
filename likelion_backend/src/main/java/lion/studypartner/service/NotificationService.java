package lion.studypartner.service;

import lion.studypartner.dto.NotificationDto;
import lion.studypartner.entity.Notification;
import lion.studypartner.entity.Study;
import lion.studypartner.entity.User;
import lion.studypartner.repository.NotificationRepository;
import lion.studypartner.repository.StudyRepository;
import lion.studypartner.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class NotificationService {
    
    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final StudyRepository studyRepository;
    
    // 알림 생성
    public Notification createNotification(Long userId, String title, String message, String type, Long studyId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        Notification notification = new Notification();
        notification.setUser(user);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setStatus("unread");
        
        if (studyId != null) {
            Study study = studyRepository.findById(studyId)
                    .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
            notification.setStudy(study);
        }
        
        return notificationRepository.save(notification);
    }
    
    // 스터디 참여 알림 생성
    public void createStudyJoinNotification(Long studyId, Long userId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        // 스터디 리더에게 알림
        String title = "새로운 멤버 참여";
        String message = user.getName() + "님이 '" + study.getTitle() + "' 스터디에 참여했습니다.";
        
        createNotification(study.getLeader().getId(), title, message, "study_join", studyId);
    }
    
    // 스터디 탈퇴 알림 생성
    public void createStudyLeaveNotification(Long studyId, Long userId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        // 스터디 리더에게 알림
        String title = "멤버 탈퇴";
        String message = user.getName() + "님이 '" + study.getTitle() + "' 스터디에서 탈퇴했습니다.";
        
        createNotification(study.getLeader().getId(), title, message, "study_leave", studyId);
    }
    
    // 스터디 업데이트 알림 생성
    public void createStudyUpdateNotification(Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        // 모든 멤버에게 알림
        study.getMembers().forEach(member -> {
            if (!"leader".equals(member.getRole())) {
                String title = "스터디 정보 업데이트";
                String message = "'" + study.getTitle() + "' 스터디 정보가 업데이트되었습니다.";
                
                createNotification(member.getUser().getId(), title, message, "study_update", studyId);
            }
        });
    }
    
    // 스터디 취소 알림 생성
    public void createStudyCancelNotification(Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        // 모든 멤버에게 알림
        study.getMembers().forEach(member -> {
            if (!"leader".equals(member.getRole())) {
                String title = "스터디 취소";
                String message = "'" + study.getTitle() + "' 스터디가 취소되었습니다.";
                
                createNotification(member.getUser().getId(), title, message, "study_cancel", studyId);
            }
        });
    }
    
    // 사용자의 알림 목록 조회
    @Transactional(readOnly = true)
    public Page<NotificationDto> getUserNotifications(Long userId, Pageable pageable) {
        Page<Notification> notifications = notificationRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
        return notifications.map(NotificationDto::from);
    }
    
    // 사용자의 읽지 않은 알림 조회
    @Transactional(readOnly = true)
    public List<NotificationDto> getUnreadNotifications(Long userId) {
        List<Notification> notifications = notificationRepository.findByUserIdAndStatusOrderByCreatedAtDesc(userId, "unread");
        return notifications.stream().map(NotificationDto::from).collect(java.util.stream.Collectors.toList());
    }
    
    // 읽지 않은 알림 개수 조회
    @Transactional(readOnly = true)
    public long getUnreadNotificationCount(Long userId) {
        return notificationRepository.countByUserIdAndStatus(userId, "unread");
    }
    
    // 알림을 읽음 상태로 변경
    public void markAsRead(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("알림을 찾을 수 없습니다."));
        
        // 본인의 알림만 읽음 처리 가능
        if (!notification.getUser().getId().equals(userId)) {
            throw new RuntimeException("알림을 읽을 권한이 없습니다.");
        }
        
        notificationRepository.markAsRead(notificationId);
    }
    
    // 모든 알림을 읽음 상태로 변경
    public void markAllAsRead(Long userId) {
        notificationRepository.markAllAsRead(userId);
    }
    
    // 오래된 알림 삭제 (30일 이상)
    public void deleteOldNotifications() {
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        notificationRepository.deleteOldNotifications(thirtyDaysAgo);
    }

    public void deleteNotification(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("알림을 찾을 수 없습니다."));
        if (!notification.getUser().getId().equals(userId)) {
            throw new RuntimeException("본인 소유의 알림만 삭제할 수 있습니다.");
        }
        notificationRepository.delete(notification);
    }
} 