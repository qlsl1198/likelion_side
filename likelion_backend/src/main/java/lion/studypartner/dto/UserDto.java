package lion.studypartner.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

public class UserDto {
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RegisterRequest {
        private String email;
        private String password;
        private String name;
        private String nickname;
        private LocalDateTime birthDate;
        private String occupation;
        private String educationLevel;
        private String status;
    }
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LoginRequest {
        private String email;
        private String password;
    }
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LoginResponse {
        private String token;
        private UserInfo user;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserInfo {
        private Long id;
        private String email;
        private String name;
        private String nickname;
        private LocalDateTime birthDate;
        private String occupation;
        private String educationLevel;
        private String status;
        
        public static UserInfo from(lion.studypartner.entity.User user) {
            if (user == null) {
                throw new IllegalArgumentException("User cannot be null");
            }
            
            return UserInfo.builder()
                    .id(user.getId())
                    .email(user.getEmail())
                    .name(user.getName())
                    .nickname(user.getNickname())
                    .birthDate(user.getBirthDate())
                    .occupation(user.getOccupation())
                    .educationLevel(user.getEducationLevel())
                    .status(user.getStatus())
                    .build();
        }
    }
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ApiResponse<T> {
        private boolean success;
        private String message;
        private T data;
        
        public static <T> ApiResponse<T> success(T data) {
            return new ApiResponse<>(true, "성공", data);
        }
        
        public static <T> ApiResponse<T> success(String message, T data) {
            return new ApiResponse<>(true, message, data);
        }
        
        public static <T> ApiResponse<T> error(String message) {
            return new ApiResponse<>(false, message, null);
        }
    }
} 