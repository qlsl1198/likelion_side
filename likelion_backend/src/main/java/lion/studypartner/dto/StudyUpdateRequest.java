package lion.studypartner.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.*;
import java.time.LocalDateTime;

@Getter
@Setter
public class StudyUpdateRequest {
    
    @Size(max = 100, message = "제목은 100자 이하여야 합니다")
    private String title;
    
    @Size(max = 1000, message = "설명은 1000자 이하여야 합니다")
    private String description;
    
    private String category;
    
    private String location;
    
    @Min(value = 1, message = "최대 참가자 수는 1명 이상이어야 합니다")
    @Max(value = 100, message = "최대 참가자 수는 100명 이하여야 합니다")
    private Integer maxParticipants;
    
    private LocalDateTime startDate;
    
    private LocalDateTime endDate;
    
    @Pattern(regexp = "^(online|offline|hybrid)$", message = "스터디 타입은 online, offline, hybrid 중 하나여야 합니다")
    private String studyType;
    
    private String meetingLink;
    
    private String contactInfo;
    
    @Pattern(regexp = "^(recruiting|in_progress|completed|cancelled)$", message = "상태는 recruiting, in_progress, completed, cancelled 중 하나여야 합니다")
    private String status;
} 