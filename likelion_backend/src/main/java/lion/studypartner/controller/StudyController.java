package lion.studypartner.controller;

import lion.studypartner.dto.*;
import lion.studypartner.service.StudyService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import lion.studypartner.service.UserService;

@RestController
@RequestMapping("/api/studies")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class StudyController {
    
    private final StudyService studyService;
    private final UserService userService;
    
    // 스터디 생성
    @PostMapping
    public ResponseEntity<UserDto.ApiResponse<StudyDto.StudyResponse>> createStudy(
            @RequestBody StudyCreateRequest request,
            Authentication authentication) {
        try {
            // 인증 토큰 검증
            if (authentication == null || authentication.getName() == null) {
                return ResponseEntity.status(401).body(UserDto.ApiResponse.error("인증이 필요합니다."));
            }
            
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.status(401).body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다. 다시 로그인해 주세요."));
            }
            
            Long userId = userResponse.getData().getId();
            StudyDto.StudyResponse response = studyService.createStudy(request, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("스터디가 생성되었습니다.", response));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error("잘못된 요청입니다: " + e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(UserDto.ApiResponse.error("스터디 생성 중 오류가 발생했습니다."));
        }
    }
    
    // 스터디 수정
    @PutMapping("/{studyId}")
    public ResponseEntity<UserDto.ApiResponse<StudyDto.StudyResponse>> updateStudy(
            @PathVariable Long studyId,
            @RequestBody StudyUpdateRequest request,
            Authentication authentication) {
        try {
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.badRequest().body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다."));
            }
            
            Long userId = userResponse.getData().getId();
            StudyDto.StudyResponse response = studyService.updateStudy(studyId, request, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("스터디가 수정되었습니다.", response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 스터디 상세 조회
    @GetMapping("/{studyId}")
    public ResponseEntity<UserDto.ApiResponse<StudyDetailResponse>> getStudy(
            @PathVariable Long studyId,
            Authentication authentication) {
        try {
            // 인증 토큰 검증
            if (authentication == null || authentication.getName() == null) {
                return ResponseEntity.status(401).body(UserDto.ApiResponse.error("인증이 필요합니다."));
            }
            
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.status(401).body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다. 다시 로그인해 주세요."));
            }
            
            Long userId = userResponse.getData().getId();
            StudyDetailResponse response = studyService.getStudyDetail(studyId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(UserDto.ApiResponse.error("존재하지 않는 스터디입니다."));
        } catch (RuntimeException e) {
            // 스터디를 찾을 수 없는 경우
            if (e.getMessage().contains("스터디를 찾을 수 없습니다")) {
                return ResponseEntity.status(404).body(UserDto.ApiResponse.error("스터디를 찾을 수 없습니다."));
            }
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(UserDto.ApiResponse.error("서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."));
        }
    }
    
    // 스터디 목록 조회
    @GetMapping
    public ResponseEntity<UserDto.ApiResponse<Page<StudyDto.StudyListResponse>>> getStudyList(
            @PageableDefault(size = 10) Pageable pageable) {
        try {
            Page<StudyDto.StudyListResponse> response = studyService.getStudyList(pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(UserDto.ApiResponse.error("스터디 목록을 불러오는 중 오류가 발생했습니다."));
        }
    }
    
    // 스터디 검색
    @GetMapping("/search")
    public ResponseEntity<UserDto.ApiResponse<Page<StudyDto.StudyListResponse>>> searchStudies(
            @ModelAttribute StudyDto.SearchRequest request,
            @PageableDefault(size = 10) Pageable pageable) {
        try {
            Page<StudyDto.StudyListResponse> response = studyService.searchStudies(request, pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 스터디 참여
    @PostMapping("/{studyId}/join")
    public ResponseEntity<UserDto.ApiResponse<StudyDto.StudyResponse>> joinStudy(
            @PathVariable Long studyId,
            Authentication authentication) {
        try {
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.badRequest().body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다."));
            }
            
            Long userId = userResponse.getData().getId();
            StudyDto.StudyResponse response = studyService.joinStudy(studyId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("스터디에 참여했습니다.", response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 스터디 탈퇴
    @PostMapping("/{studyId}/leave")
    public ResponseEntity<UserDto.ApiResponse<String>> leaveStudy(
            @PathVariable Long studyId,
            Authentication authentication) {
        try {
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.badRequest().body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다."));
            }
            
            Long userId = userResponse.getData().getId();
            studyService.leaveStudy(studyId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("스터디에서 탈퇴했습니다.", "success"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 내가 참여 중인 스터디 목록
    @GetMapping("/my-studies")
    public ResponseEntity<UserDto.ApiResponse<Page<StudyDto.StudyListResponse>>> getMyStudies(
            Authentication authentication,
            @PageableDefault(size = 10) Pageable pageable) {
        try {
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.badRequest().body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다."));
            }
            
            Long userId = userResponse.getData().getId();
            Page<StudyDto.StudyListResponse> response = studyService.getMyStudies(userId, pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 스터디 삭제
    @DeleteMapping("/{studyId}")
    public ResponseEntity<UserDto.ApiResponse<String>> deleteStudy(
            @PathVariable Long studyId,
            Authentication authentication) {
        try {
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.badRequest().body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다."));
            }
            
            Long userId = userResponse.getData().getId();
            studyService.deleteStudy(studyId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("스터디가 삭제되었습니다.", "success"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 카테고리별 스터디 조회
    @GetMapping("/category/{category}")
    public ResponseEntity<UserDto.ApiResponse<Page<StudyDto.StudyListResponse>>> getStudiesByCategory(
            @PathVariable String category,
            @PageableDefault(size = 10) Pageable pageable) {
        try {
            Page<StudyDto.StudyListResponse> response = studyService.searchStudies(
                    StudyDto.SearchRequest.builder().category(category).build(), pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 위치별 스터디 조회
    @GetMapping("/location/{location}")
    public ResponseEntity<UserDto.ApiResponse<Page<StudyDto.StudyListResponse>>> getStudiesByLocation(
            @PathVariable String location,
            @PageableDefault(size = 10) Pageable pageable) {
        try {
            Page<StudyDto.StudyListResponse> response = studyService.searchStudies(
                    StudyDto.SearchRequest.builder().location(location).build(), pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 스터디 참여 상태 확인
    @GetMapping("/{studyId}/join-status")
    public ResponseEntity<UserDto.ApiResponse<Boolean>> getJoinStatus(
            @PathVariable Long studyId,
            Authentication authentication) {
        try {
            // 인증 토큰 검증
            if (authentication == null || authentication.getName() == null) {
                return ResponseEntity.status(401).body(UserDto.ApiResponse.error("인증이 필요합니다."));
            }
            
            // JWT 토큰에서 이메일을 추출한 후 사용자 ID를 찾음
            String email = authentication.getName();
            
            // UserService를 통해 이메일로 사용자 정보 조회
            UserDto.ApiResponse<UserDto.UserInfo> userResponse = userService.getUserInfo(email);
            if (!userResponse.isSuccess()) {
                return ResponseEntity.status(401).body(UserDto.ApiResponse.error("사용자 정보를 찾을 수 없습니다. 다시 로그인해 주세요."));
            }
            
            Long userId = userResponse.getData().getId();
            boolean isJoined = studyService.isUserJoined(studyId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("참여 상태 조회 성공", isJoined));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(UserDto.ApiResponse.error("참여 상태 조회 중 오류가 발생했습니다."));
        }
    }
} 