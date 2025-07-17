package lion.studypartner.dto;

import lion.studypartner.entity.Study;
import lion.studypartner.entity.StudyMember;
import lion.studypartner.dto.UserDto.UserInfo;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;

@Getter
@Setter
public class StudyDetailResponse {
    
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
    private UserInfo leader;
    private List<StudyMemberDto> members;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isLeader;
    private boolean isMember;

    public boolean isLeader() {
        return isLeader;
    }
    public void setIsLeader(boolean isLeader) {
        this.isLeader = isLeader;
    }
    public boolean isMember() {
        return isMember;
    }
    public void setIsMember(boolean isMember) {
        this.isMember = isMember;
    }
    
    public static StudyDetailResponse from(Study study, Long currentUserId) {
        if (study == null) {
            throw new IllegalArgumentException("Study cannot be null");
        }
        
        StudyDetailResponse response = new StudyDetailResponse();
        response.setId(study.getId());
        response.setTitle(study.getTitle());
        response.setDescription(study.getDescription() != null ? study.getDescription() : "");
        response.setCategory(study.getCategory());
        response.setLocation(study.getLocation());
        response.setMaxParticipants(study.getMaxParticipants());
        response.setCurrentParticipants(study.getCurrentParticipants());
        response.setStatus(study.getStatus());
        response.setStartDate(study.getStartDate());
        response.setEndDate(study.getEndDate());
        response.setStudyType(study.getStudyType());
        response.setMeetingLink(study.getMeetingLink());
        response.setContactInfo(study.getContactInfo());
        
        // 리더 정보 null 체크
        if (study.getLeader() != null) {
            response.setLeader(UserInfo.from(study.getLeader()));
        }
        
        // 멤버 정보 null 체크
        if (study.getMembers() != null) {
            response.setMembers(study.getMembers().stream()
                    .filter(member -> member != null)
                    .map(StudyMemberDto::from)
                    .collect(Collectors.toList()));
        } else {
            response.setMembers(new ArrayList<>());
        }
        
        response.setCreatedAt(study.getCreatedAt());
        response.setUpdatedAt(study.getUpdatedAt());
        
        // 현재 사용자 정보 확인 (null 체크)
        if (currentUserId != null && study.getLeader() != null) {
            response.setIsLeader(study.getLeader().getId().equals(currentUserId));
        } else {
            response.setIsLeader(false);
        }
        
        // 현재 사용자가 멤버인지 확인 (null 체크)
        if (currentUserId != null && study.getMembers() != null) {
            response.setIsMember(study.getMembers().stream()
                    .filter(member -> member != null && member.getUser() != null)
                    .anyMatch(member -> member.getUser().getId().equals(currentUserId)));
        } else {
            response.setIsMember(false);
        }
        
        return response;
    }
    
    @Getter
    @Setter
    public static class StudyMemberDto {
        private Long id;
        private UserInfo user;
        private String role;
        private String status;
        private LocalDateTime joinedAt;
        
        public static StudyMemberDto from(StudyMember member) {
            if (member == null) {
                throw new IllegalArgumentException("StudyMember cannot be null");
            }
            
            StudyMemberDto dto = new StudyMemberDto();
            dto.setId(member.getId());
            
            // 사용자 정보 null 체크
            if (member.getUser() != null) {
                dto.setUser(UserInfo.from(member.getUser()));
            }
            
            dto.setRole(member.getRole());
            dto.setStatus(member.getStatus());
            dto.setJoinedAt(member.getJoinedAt());
            return dto;
        }
    }
} 