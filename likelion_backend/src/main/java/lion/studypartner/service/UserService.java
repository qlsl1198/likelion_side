package lion.studypartner.service;

import lion.studypartner.dto.UserDto;
import lion.studypartner.entity.User;
import lion.studypartner.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    
    public UserDto.ApiResponse<UserDto.LoginResponse> register(UserDto.RegisterRequest request) {
        // 이메일 중복 확인
        if (userRepository.existsByEmail(request.getEmail())) {
            return UserDto.ApiResponse.error("이미 존재하는 이메일입니다.");
        }
        
        // 닉네임 중복 확인
        if (userRepository.existsByNickname(request.getNickname())) {
            return UserDto.ApiResponse.error("이미 존재하는 닉네임입니다.");
        }
        
        // 사용자 생성
        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setName(request.getName());
        user.setNickname(request.getNickname());
        user.setBirthDate(request.getBirthDate());
        user.setOccupation(request.getOccupation());
        user.setEducationLevel(request.getEducationLevel());
        user.setStatus(request.getStatus());
        
        User savedUser = userRepository.save(user);
        
        // JWT 토큰 생성
        String token = jwtService.generateToken(savedUser.getEmail());
        
        // 응답 생성
        UserDto.UserInfo userInfo = new UserDto.UserInfo(
            savedUser.getId(),
            savedUser.getEmail(),
            savedUser.getName(),
            savedUser.getNickname(),
            savedUser.getBirthDate(),
            savedUser.getOccupation(),
            savedUser.getEducationLevel(),
            savedUser.getStatus()
        );
        
        UserDto.LoginResponse loginResponse = new UserDto.LoginResponse(token, userInfo);
        
        return UserDto.ApiResponse.success("회원가입이 완료되었습니다.", loginResponse);
    }
    
    public UserDto.ApiResponse<UserDto.LoginResponse> login(UserDto.LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
            .orElse(null);
        
        if (user == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return UserDto.ApiResponse.error("이메일 또는 비밀번호가 올바르지 않습니다.");
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
        
        return UserDto.ApiResponse.success("로그인이 완료되었습니다.", loginResponse);
    }
    
    public UserDto.ApiResponse<UserDto.UserInfo> getUserInfo(String email) {
        User user = userRepository.findByEmail(email)
            .orElse(null);
        
        if (user == null) {
            return UserDto.ApiResponse.error("사용자를 찾을 수 없습니다.");
        }
        
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
        
        return UserDto.ApiResponse.success(userInfo);
    }

    public String extractEmailFromToken(String token) {
        return jwtService.extractEmail(token);
    }
} 