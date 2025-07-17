package lion.studypartner.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

public class StudyPostDto {
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CreateRequest {
        private String title;
        private String content;
        private String type;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UpdateRequest {
        private String title;
        private String content;
        private String type;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PostResponse {
        private Long id;
        private String title;
        private String content;
        private String type;
        private String status;
        private UserDto.UserInfo author;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PostListResponse {
        private Long id;
        private String title;
        private String type;
        private String status;
        private UserDto.UserInfo author;
        private LocalDateTime createdAt;
    }
} 