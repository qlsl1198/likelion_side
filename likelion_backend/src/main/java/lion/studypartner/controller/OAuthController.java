package lion.studypartner.controller;

import lion.studypartner.dto.UserDto;
import lion.studypartner.service.OAuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users/oauth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class OAuthController {
    
    private final OAuthService oAuthService;
    
    @PostMapping("/login")
    public ResponseEntity<UserDto.ApiResponse<UserDto.LoginResponse>> virtualOAuthLogin(
            @RequestParam String provider,
            @RequestParam String email,
            @RequestParam String name) {
        UserDto.ApiResponse<UserDto.LoginResponse> response = oAuthService.processVirtualOAuthLogin(provider, email, name);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/google")
    public ResponseEntity<String> googleLogin() {
        return ResponseEntity.ok("Google OAuth 로그인 URL을 반환합니다.");
    }
    
    @GetMapping("/kakao")
    public ResponseEntity<String> kakaoLogin() {
        return ResponseEntity.ok("Kakao OAuth 로그인 URL을 반환합니다.");
    }
    
    @PostMapping("/callback")
    public ResponseEntity<UserDto.ApiResponse<UserDto.LoginResponse>> oauthCallback(
            @RequestParam String provider,
            @RequestParam String code) {
        UserDto.ApiResponse<UserDto.LoginResponse> response = oAuthService.processOAuthCallback(provider, code);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/success")
    public ResponseEntity<String> oauthSuccess() {
        return ResponseEntity.ok("OAuth 로그인 성공!");
    }
    
    @GetMapping("/failure")
    public ResponseEntity<String> oauthFailure() {
        return ResponseEntity.badRequest().body("OAuth 로그인 실패!");
    }
} 