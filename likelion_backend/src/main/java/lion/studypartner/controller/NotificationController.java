package lion.studypartner.controller;

import lion.studypartner.dto.NotificationDto;
import lion.studypartner.dto.UserDto;
import lion.studypartner.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class NotificationController {
    
    private final NotificationService notificationService;
    
    // 사용자의 알림 목록 조회
    @GetMapping
    public ResponseEntity<UserDto.ApiResponse<Page<NotificationDto>>> getNotifications(
            Authentication authentication,
            @PageableDefault(size = 20) Pageable pageable) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            Page<NotificationDto> notifications = notificationService.getUserNotifications(userId, pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(notifications));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 읽지 않은 알림 조회
    @GetMapping("/unread")
    public ResponseEntity<UserDto.ApiResponse<List<NotificationDto>>> getUnreadNotifications(
            Authentication authentication) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            List<NotificationDto> notifications = notificationService.getUnreadNotifications(userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success(notifications));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 읽지 않은 알림 개수 조회
    @GetMapping("/unread/count")
    public ResponseEntity<UserDto.ApiResponse<Long>> getUnreadNotificationCount(
            Authentication authentication) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            long count = notificationService.getUnreadNotificationCount(userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success(count));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 알림을 읽음 상태로 변경
    @PutMapping("/{notificationId}/read")
    public ResponseEntity<UserDto.ApiResponse<String>> markAsRead(
            @PathVariable Long notificationId,
            Authentication authentication) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            notificationService.markAsRead(notificationId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("알림을 읽음 처리했습니다.", "success"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 모든 알림을 읽음 상태로 변경
    @PutMapping("/read-all")
    public ResponseEntity<UserDto.ApiResponse<String>> markAllAsRead(
            Authentication authentication) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            notificationService.markAllAsRead(userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("모든 알림을 읽음 처리했습니다.", "success"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 알림 삭제
    @DeleteMapping("/{notificationId}")
    public ResponseEntity<UserDto.ApiResponse<String>> deleteNotification(
            @PathVariable Long notificationId,
            Authentication authentication) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            notificationService.deleteNotification(notificationId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("알림이 삭제되었습니다.", "success"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
} 