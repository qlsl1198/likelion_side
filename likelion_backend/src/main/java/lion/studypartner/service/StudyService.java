package lion.studypartner.service;

import lion.studypartner.dto.*;
import lion.studypartner.entity.Study;
import lion.studypartner.entity.StudyMember;
import lion.studypartner.entity.User;
import lion.studypartner.repository.StudyMemberRepository;
import lion.studypartner.repository.StudyRepository;
import lion.studypartner.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class StudyService {
    
    private final StudyRepository studyRepository;
    private final StudyMemberRepository studyMemberRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;
    
    // 스터디 생성 (기존 DTO)
    public StudyDto.StudyResponse createStudy(StudyDto.CreateRequest request, Long leaderId) {
        User leader = userRepository.findById(leaderId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        Study study = new Study();
        study.setTitle(request.getTitle());
        study.setDescription(request.getDescription());
        study.setCategory(request.getCategory());
        study.setLocation(request.getLocation());
        study.setMaxParticipants(request.getMaxParticipants());
        study.setStartDate(request.getStartDate());
        study.setEndDate(request.getEndDate());
        study.setStudyType(request.getStudyType());
        study.setMeetingLink(request.getMeetingLink());
        study.setContactInfo(request.getContactInfo());
        study.setLeader(leader);
        
        Study savedStudy = studyRepository.save(study);
        
        // 리더를 멤버로 추가
        StudyMember leaderMember = new StudyMember();
        leaderMember.setStudy(savedStudy);
        leaderMember.setUser(leader);
        leaderMember.setRole("leader");
        leaderMember.setStatus("active");
        studyMemberRepository.save(leaderMember);
        
        return convertToStudyResponse(savedStudy);
    }
    
    // 스터디 생성 (새로운 DTO)
    public StudyDto.StudyResponse createStudy(StudyCreateRequest request, Long leaderId) {
        User leader = userRepository.findById(leaderId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        Study study = new Study();
        study.setTitle(request.getTitle());
        study.setDescription(request.getDescription());
        study.setCategory(request.getCategory());
        study.setLocation(request.getLocation());
        study.setMaxParticipants(request.getMaxParticipants());
        study.setStartDate(request.getStartDate());
        study.setEndDate(request.getEndDate());
        study.setStudyType(request.getStudyType());
        study.setMeetingLink(request.getMeetingLink());
        study.setContactInfo(request.getContactInfo());
        study.setLeader(leader);
        
        Study savedStudy = studyRepository.save(study);
        
        // 리더를 멤버로 추가
        StudyMember leaderMember = new StudyMember();
        leaderMember.setStudy(savedStudy);
        leaderMember.setUser(leader);
        leaderMember.setRole("leader");
        leaderMember.setStatus("active");
        studyMemberRepository.save(leaderMember);
        
        return convertToStudyResponse(savedStudy);
    }
    
    // 스터디 수정 (기존 DTO)
    public StudyDto.StudyResponse updateStudy(Long studyId, StudyDto.UpdateRequest request, Long userId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        // 리더만 수정 가능
        if (!study.getLeader().getId().equals(userId)) {
            throw new RuntimeException("스터디를 수정할 권한이 없습니다.");
        }
        
        if (request.getTitle() != null) study.setTitle(request.getTitle());
        if (request.getDescription() != null) study.setDescription(request.getDescription());
        if (request.getCategory() != null) study.setCategory(request.getCategory());
        if (request.getLocation() != null) study.setLocation(request.getLocation());
        if (request.getMaxParticipants() != null) study.setMaxParticipants(request.getMaxParticipants());
        if (request.getStartDate() != null) study.setStartDate(request.getStartDate());
        if (request.getEndDate() != null) study.setEndDate(request.getEndDate());
        if (request.getStudyType() != null) study.setStudyType(request.getStudyType());
        if (request.getMeetingLink() != null) study.setMeetingLink(request.getMeetingLink());
        if (request.getContactInfo() != null) study.setContactInfo(request.getContactInfo());
        if (request.getStatus() != null) study.setStatus(request.getStatus());
        
        Study updatedStudy = studyRepository.save(study);
        return convertToStudyResponse(updatedStudy);
    }
    
    // 스터디 수정 (새로운 DTO)
    public StudyDto.StudyResponse updateStudy(Long studyId, StudyUpdateRequest request, Long userId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        // 리더만 수정 가능
        if (!study.getLeader().getId().equals(userId)) {
            throw new RuntimeException("스터디를 수정할 권한이 없습니다.");
        }
        
        if (request.getTitle() != null) study.setTitle(request.getTitle());
        if (request.getDescription() != null) study.setDescription(request.getDescription());
        if (request.getCategory() != null) study.setCategory(request.getCategory());
        if (request.getLocation() != null) study.setLocation(request.getLocation());
        if (request.getMaxParticipants() != null) study.setMaxParticipants(request.getMaxParticipants());
        if (request.getStartDate() != null) study.setStartDate(request.getStartDate());
        if (request.getEndDate() != null) study.setEndDate(request.getEndDate());
        if (request.getStudyType() != null) study.setStudyType(request.getStudyType());
        if (request.getMeetingLink() != null) study.setMeetingLink(request.getMeetingLink());
        if (request.getContactInfo() != null) study.setContactInfo(request.getContactInfo());
        if (request.getStatus() != null) study.setStatus(request.getStatus());
        
        Study updatedStudy = studyRepository.save(study);
        return convertToStudyResponse(updatedStudy);
    }
    
    // 스터디 상세 조회 (기존)
    @Transactional(readOnly = true)
    public StudyDto.StudyResponse getStudy(Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        return convertToStudyResponse(study);
    }
    
    // 스터디 상세 조회 (새로운 DTO)
    @Transactional(readOnly = true)
    public StudyDetailResponse getStudyDetail(Long studyId, Long currentUserId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        return StudyDetailResponse.from(study, currentUserId);
    }
    
    // 스터디 목록 조회
    @Transactional(readOnly = true)
    public Page<StudyDto.StudyListResponse> getStudyList(Pageable pageable) {
        Page<Study> studies = studyRepository.findAll(pageable);
        return studies.map(this::convertToStudyListResponse);
    }
    
    // 스터디 검색
    @Transactional(readOnly = true)
    public Page<StudyDto.StudyListResponse> searchStudies(StudyDto.SearchRequest request, Pageable pageable) {
        Page<Study> studies = studyRepository.findBySearchCriteria(
                request.getCategory(),
                request.getLocation(),
                request.getStudyType(),
                request.getStatus(),
                request.getKeyword(),
                pageable
        );
        return studies.map(this::convertToStudyListResponse);
    }
    
    // 스터디 참여
    public StudyDto.StudyResponse joinStudy(Long studyId, Long userId) {
        // 입력 검증
        if (studyId == null || userId == null) {
            throw new IllegalArgumentException("스터디 ID와 사용자 ID는 필수입니다.");
        }
        
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        // 자기 자신이 만든 스터디에 참여하려는 경우 방지
        if (study.getLeader().getId().equals(userId)) {
            throw new RuntimeException("자신이 만든 스터디에는 참여할 수 없습니다.");
        }
        
        // 이미 참여 중인지 확인
        if (studyMemberRepository.findByStudyIdAndUserIdAndStatus(studyId, userId, "active").isPresent()) {
            throw new RuntimeException("이미 참여 중인 스터디입니다.");
        }
        
        // 스터디 상태 확인
        if (!"active".equals(study.getStatus())) {
            throw new RuntimeException("현재 참여할 수 없는 스터디입니다.");
        }
        
        // 스터디가 가득 찼는지 확인
        if (study.isFull()) {
            throw new RuntimeException("스터디 정원이 가득 찼습니다. (현재 " + study.getCurrentParticipants() + "/" + study.getMaxParticipants() + ")");
        }
        
        // 스터디 시작 날짜 확인
        if (study.getStartDate().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("이미 시작된 스터디에는 참여할 수 없습니다.");
        }
        
        try {
            // 스터디 멤버 추가
            StudyMember member = new StudyMember();
            member.setStudy(study);
            member.setUser(user);
            member.setRole("member");
            member.setStatus("active");
            studyMemberRepository.save(member);
            
            // 현재 참여자 수 증가
            study.setCurrentParticipants(study.getCurrentParticipants() + 1);
            studyRepository.save(study);
            
            // 스터디 리더에게 알림 생성 (NotificationService 사용)
            try {
                notificationService.createStudyJoinNotification(studyId, userId);
            } catch (Exception e) {
                // 알림 생성 실패는 메인 로직에 영향을 주지 않음
                System.err.println("알림 생성 실패: " + e.getMessage());
            }
            
            return convertToStudyResponse(study);
            
        } catch (Exception e) {
            throw new RuntimeException("스터디 참여 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    // 스터디 탈퇴
    public void leaveStudy(Long studyId, Long userId) {
        // 입력 검증
        if (studyId == null || userId == null) {
            throw new IllegalArgumentException("스터디 ID와 사용자 ID는 필수입니다.");
        }
        
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        StudyMember member = studyMemberRepository.findByStudyIdAndUserIdAndStatus(studyId, userId, "active")
                .orElseThrow(() -> new RuntimeException("참여 중인 스터디가 아닙니다."));
        
        // 리더는 탈퇴할 수 없음
        if ("leader".equals(member.getRole()) || "LEADER".equals(member.getRole())) {
            throw new RuntimeException("스터디 리더는 탈퇴할 수 없습니다. 스터디를 삭제하거나 리더를 변경해주세요.");
        }
        
        try {
            // 멤버 상태를 비활성화로 변경
            member.setStatus("inactive");
            member.setLeftAt(LocalDateTime.now());
            studyMemberRepository.save(member);
            
            // 현재 참여자 수 감소 (0 이하로 내려가지 않도록 보호)
            int currentParticipants = Math.max(0, study.getCurrentParticipants() - 1);
            study.setCurrentParticipants(currentParticipants);
            studyRepository.save(study);
            
            // 스터디 리더에게 알림 생성 (NotificationService 사용)
            try {
                notificationService.createStudyLeaveNotification(studyId, userId);
            } catch (Exception e) {
                // 알림 생성 실패는 메인 로직에 영향을 주지 않음
                System.err.println("알림 생성 실패: " + e.getMessage());
            }
            
        } catch (Exception e) {
            throw new RuntimeException("스터디 탈퇴 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    // 사용자가 참여 중인 스터디 목록
    @Transactional(readOnly = true)
    public Page<StudyDto.StudyListResponse> getMyStudies(Long userId, Pageable pageable) {
        Page<Study> studies = studyRepository.findByMemberId(userId, pageable);
        return studies.map(this::convertToStudyListResponse);
    }
    
    // 스터디 삭제
    public void deleteStudy(Long studyId, Long userId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        // 리더만 삭제 가능
        if (!study.getLeader().getId().equals(userId)) {
            throw new RuntimeException("스터디를 삭제할 권한이 없습니다.");
        }
        
        studyRepository.delete(study);
    }
    
    // DTO 변환 메서드들
    private StudyDto.StudyResponse convertToStudyResponse(Study study) {
        List<StudyDto.StudyMemberResponse> memberResponses = study.getMembers().stream()
                .map(this::convertToStudyMemberResponse)
                .collect(Collectors.toList());
        
        return StudyDto.StudyResponse.builder()
                .id(study.getId())
                .title(study.getTitle())
                .description(study.getDescription())
                .category(study.getCategory())
                .location(study.getLocation())
                .maxParticipants(study.getMaxParticipants())
                .currentParticipants(study.getCurrentParticipants())
                .status(study.getStatus())
                .startDate(study.getStartDate())
                .endDate(study.getEndDate())
                .studyType(study.getStudyType())
                .meetingLink(study.getMeetingLink())
                .contactInfo(study.getContactInfo())
                .leader(convertToUserInfo(study.getLeader()))
                .members(memberResponses)
                .createdAt(study.getCreatedAt())
                .updatedAt(study.getUpdatedAt())
                .build();
    }
    
    private StudyDto.StudyListResponse convertToStudyListResponse(Study study) {
        return StudyDto.StudyListResponse.builder()
                .id(study.getId())
                .title(study.getTitle())
                .category(study.getCategory())
                .location(study.getLocation())
                .maxParticipants(study.getMaxParticipants())
                .currentParticipants(study.getCurrentParticipants())
                .status(study.getStatus())
                .startDate(study.getStartDate())
                .endDate(study.getEndDate())
                .studyType(study.getStudyType())
                .leader(convertToUserInfo(study.getLeader()))
                .createdAt(study.getCreatedAt())
                .build();
    }
    
    private StudyDto.StudyMemberResponse convertToStudyMemberResponse(StudyMember member) {
        return StudyDto.StudyMemberResponse.builder()
                .id(member.getId())
                .user(convertToUserInfo(member.getUser()))
                .role(member.getRole())
                .status(member.getStatus())
                .joinedAt(member.getJoinedAt())
                .build();
    }
    
    private UserDto.UserInfo convertToUserInfo(User user) {
        return UserDto.UserInfo.builder()
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
    
    // 사용자 참여 상태 확인
    public boolean isUserJoined(Long studyId, Long userId) {
        return studyMemberRepository.findByStudyIdAndUserId(studyId, userId)
                .filter(member -> "active".equals(member.getStatus()))
                .isPresent();
    }
} 