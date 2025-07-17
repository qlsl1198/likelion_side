package lion.studypartner.repository;

import lion.studypartner.entity.StudyMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudyMemberRepository extends JpaRepository<StudyMember, Long> {
    
    // 스터디의 모든 멤버 조회
    List<StudyMember> findByStudyId(Long studyId);
    
    // 스터디의 활성 멤버 조회
    List<StudyMember> findByStudyIdAndStatus(Long studyId, String status);
    
    // 사용자가 참여 중인 스터디 멤버십 조회
    List<StudyMember> findByUserId(Long userId);
    
    // 사용자가 특정 스터디에 참여 중인지 확인
    Optional<StudyMember> findByStudyIdAndUserId(Long studyId, Long userId);
    
    // 사용자가 특정 스터디에 활성 멤버로 참여 중인지 확인
    Optional<StudyMember> findByStudyIdAndUserIdAndStatus(Long studyId, Long userId, String status);
    
    // 스터디의 멤버 수 조회
    @Query("SELECT COUNT(sm) FROM StudyMember sm WHERE sm.study.id = :studyId AND sm.status = 'active'")
    Long countActiveMembersByStudyId(@Param("studyId") Long studyId);
    
    // 사용자가 리더인 스터디 멤버십 조회
    List<StudyMember> findByUserIdAndRole(Long userId, String role);
} 