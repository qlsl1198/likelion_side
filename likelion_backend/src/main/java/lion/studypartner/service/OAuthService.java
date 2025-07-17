package lion.studypartner.service;

import lion.studypartner.dto.UserDto;
import lion.studypartner.entity.User;
import lion.studypartner.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class OAuthService {
    
    private final UserRepository userRepository;
    private final JwtService jwtService;
    
    public UserDto.ApiResponse<UserDto.LoginResponse> processVirtualOAuthLogin(String provider, String email, String name) {
        try {
            // 가상 OAuth 사용자 정보 생성
            OAuthUserInfo oauthUserInfo = new OAuthUserInfo(
                email,
                name,
                name, // 닉네임은 이름과 동일하게 설정
                provider,
                "virtual_provider_id_" + System.currentTimeMillis()
            );
            
            // 기존 사용자 확인
            User existingUser = userRepository.findByEmail(email)
                .orElse(null);
            
            User user;
            if (existingUser != null) {
                // 기존 사용자 로그인
                user = existingUser;
            } else {
                // 새 사용자 생성
                user = createNewOAuthUser(oauthUserInfo);
            }
            
            // JWT 토큰 생성
            String token = jwtService.generateToken(user.getEmail());
            
            // 응답 생성
            UserDto.UserInfo userInfo = new UserDto.UserInfo(
                user.getId(),
                user.getEmail(),
                user.getName(),
                user.getNickname(),
                user.getBirthDate(),
                user.getOccupation(),
                user.getEducationLevel(),
                user.getStatus()
            );
            
            UserDto.LoginResponse loginResponse = new UserDto.LoginResponse(token, userInfo);
            
            return UserDto.ApiResponse.success("가상 OAuth 로그인이 완료되었습니다.", loginResponse);
            
        } catch (Exception e) {
            return UserDto.ApiResponse.error("가상 OAuth 로그인 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    public UserDto.ApiResponse<UserDto.LoginResponse> processOAuthCallback(String provider, String code) {
        try {
            // OAuth 제공자별로 사용자 정보를 가져오는 로직
            OAuthUserInfo oauthUserInfo = getOAuthUserInfo(provider, code);
            
            // 기존 사용자 확인
            User existingUser = userRepository.findByProviderAndProviderId(provider, oauthUserInfo.getProviderId())
                .orElse(null);
            
            User user;
            if (existingUser != null) {
                // 기존 사용자 로그인
                user = existingUser;
            } else {
                // 새 사용자 생성
                user = createNewOAuthUser(oauthUserInfo);
            }
            
            // JWT 토큰 생성
            String token = jwtService.generateToken(user.getEmail());
            
            // 응답 생성
            UserDto.UserInfo userInfo = new UserDto.UserInfo(
                user.getId(),
                user.getEmail(),
                user.getName(),
                user.getNickname(),
                user.getBirthDate(),
                user.getOccupation(),
                user.getEducationLevel(),
                user.getStatus()
            );
            
            UserDto.LoginResponse loginResponse = new UserDto.LoginResponse(token, userInfo);
            
            return UserDto.ApiResponse.success("OAuth 로그인이 완료되었습니다.", loginResponse);
            
        } catch (Exception e) {
            return UserDto.ApiResponse.error("OAuth 로그인 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    private OAuthUserInfo getOAuthUserInfo(String provider, String code) {
        // 실제 OAuth API 호출 로직 (임시 구현)
        // Google, Kakao 등의 OAuth API를 호출하여 사용자 정보를 가져옴
        return new OAuthUserInfo(
            "test@example.com",
            "테스트 사용자",
            "test_nickname",
            provider,
            "provider_id_" + System.currentTimeMillis()
        );
    }
    
    private User createNewOAuthUser(OAuthUserInfo oauthUserInfo) {
        User user = new User();
        user.setEmail(oauthUserInfo.getEmail());
        user.setName(oauthUserInfo.getName());
        user.setNickname(oauthUserInfo.getNickname());
        user.setProvider(oauthUserInfo.getProvider());
        user.setProviderId(oauthUserInfo.getProviderId());
        user.setPassword(""); // OAuth 사용자는 비밀번호가 없음
        user.setStatus("active");
        
        return userRepository.save(user);
    }
    
    // OAuth 사용자 정보를 담는 내부 클래스
    private static class OAuthUserInfo {
        private final String email;
        private final String name;
        private final String nickname;
        private final String provider;
        private final String providerId;
        
        public OAuthUserInfo(String email, String name, String nickname, String provider, String providerId) {
            this.email = email;
            this.name = name;
            this.nickname = nickname;
            this.provider = provider;
            this.providerId = providerId;
        }
        
        public String getEmail() { return email; }
        public String getName() { return name; }
        public String getNickname() { return nickname; }
        public String getProvider() { return provider; }
        public String getProviderId() { return providerId; }
    }
} 