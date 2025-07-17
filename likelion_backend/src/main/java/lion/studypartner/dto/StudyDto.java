package lion.studypartner.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

public class StudyDto {
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CreateRequest {
        private String title;
        private String description;
        private String category;
        private String location;
        private Integer maxParticipants;
        private LocalDateTime startDate;
        private LocalDateTime endDate;
        private String studyType;
        private String meetingLink;
        private String contactInfo;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UpdateRequest {
        private String title;
        private String description;
        private String category;
        private String location;
        private Integer maxParticipants;
        private LocalDateTime startDate;
        private LocalDateTime endDate;
        private String studyType;
        private String meetingLink;
        private String contactInfo;
        private String status;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StudyResponse {
        private Long id;
        private String title;
        private String description;
        private String category;
        private String location;
        private Integer maxParticipants;
        private Integer currentParticipants;
        private String status;
        private LocalDateTime startDate;
        private LocalDateTime endDate;
        private String studyType;
        private String meetingLink;
        private String contactInfo;
        private UserDto.UserInfo leader;
        private List<StudyMemberResponse> members;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StudyMemberResponse {
        private Long id;
        private UserDto.UserInfo user;
        private String role;
        private String status;
        private LocalDateTime joinedAt;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StudyListResponse {
        private Long id;
        private String title;
        private String category;
        private String location;
        private Integer maxParticipants;
        private Integer currentParticipants;
        private String status;
        private LocalDateTime startDate;
        private LocalDateTime endDate;
        private String studyType;
        private UserDto.UserInfo leader;
        private LocalDateTime createdAt;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class JoinRequest {
        private String message;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SearchRequest {
        private String keyword;
        private String category;
        private String location;
        private String studyType;
        private String status;
    }
} 