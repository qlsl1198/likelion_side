package lion.studypartner.dto;

import lion.studypartner.entity.Notification;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class NotificationDto {
    
    private Long id;
    private String title;
    private String message;
    private String type;
    private String status;
    private Long studyId;
    private String studyTitle;
    private String relatedUrl;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;
    
    public static NotificationDto from(Notification notification) {
        NotificationDto dto = new NotificationDto();
        dto.setId(notification.getId());
        dto.setTitle(notification.getTitle());
        dto.setMessage(notification.getMessage());
        dto.setType(notification.getType());
        dto.setStatus(notification.getStatus());
        dto.setRelatedUrl(notification.getRelatedUrl());
        dto.setCreatedAt(notification.getCreatedAt());
        dto.setReadAt(notification.getReadAt());
        
        if (notification.getStudy() != null) {
            dto.setStudyId(notification.getStudy().getId());
            dto.setStudyTitle(notification.getStudy().getTitle());
        }
        
        return dto;
    }
} 