package lion.studypartner.controller;

import lion.studypartner.dto.UserDto;
import lion.studypartner.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {
    
    private final UserService userService;
    
    @PostMapping("/register")
    public ResponseEntity<UserDto.ApiResponse<UserDto.LoginResponse>> register(
            @RequestBody UserDto.RegisterRequest request) {
        return ResponseEntity.badRequest()
            .body(UserDto.ApiResponse.error("개인 이메일 회원가입은 지원하지 않습니다. OAuth 로그인을 이용해주세요."));
    }
    
    @PostMapping("/login")
    public ResponseEntity<UserDto.ApiResponse<UserDto.LoginResponse>> login(
            @RequestBody UserDto.LoginRequest request) {
        return ResponseEntity.badRequest()
            .body(UserDto.ApiResponse.error("개인 이메일 로그인은 지원하지 않습니다. OAuth 로그인을 이용해주세요."));
    }
    
    @GetMapping("/me")
    public ResponseEntity<UserDto.ApiResponse<UserDto.UserInfo>> getUserInfo(
            @RequestHeader("Authorization") String token) {
        try {
            // JWT에서 이메일 추출 (Bearer 제거)
            String jwt = token.replace("Bearer ", "");
            String email = userService.extractEmailFromToken(jwt); // JwtService에서 이메일 추출 메서드 사용
            UserDto.ApiResponse<UserDto.UserInfo> response = userService.getUserInfo(email);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error("유저 정보를 불러올 수 없습니다: " + e.getMessage()));
        }
    }
    
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Study Partner API is running!");
    }
} 