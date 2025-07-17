package lion.studypartner.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.*;
import java.time.LocalDateTime;

@Getter
@Setter
public class StudyCreateRequest {
    
    @NotBlank(message = "제목은 필수입니다")
    @Size(max = 100, message = "제목은 100자 이하여야 합니다")
    private String title;
    
    @Size(max = 1000, message = "설명은 1000자 이하여야 합니다")
    private String description;
    
    @NotBlank(message = "카테고리는 필수입니다")
    private String category;
    
    @NotBlank(message = "위치는 필수입니다")
    private String location;
    
    @NotNull(message = "최대 참가자 수는 필수입니다")
    @Min(value = 1, message = "최대 참가자 수는 1명 이상이어야 합니다")
    @Max(value = 100, message = "최대 참가자 수는 100명 이하여야 합니다")
    private Integer maxParticipants;
    
    @NotNull(message = "시작 날짜는 필수입니다")
    private LocalDateTime startDate;
    
    @NotNull(message = "종료 날짜는 필수입니다")
    private LocalDateTime endDate;
    
    @NotBlank(message = "스터디 타입은 필수입니다")
    @Pattern(regexp = "^(online|offline|hybrid)$", message = "스터디 타입은 online, offline, hybrid 중 하나여야 합니다")
    private String studyType;
    
    private String meetingLink;
    
    private String contactInfo;
} 