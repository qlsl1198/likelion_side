package lion.studypartner.repository;

import lion.studypartner.entity.Study;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface StudyRepository extends JpaRepository<Study, Long> {
    
    // 카테고리별 스터디 조회
    Page<Study> findByCategory(String category, Pageable pageable);
    
    // 위치별 스터디 조회
    Page<Study> findByLocationContaining(String location, Pageable pageable);
    
    // 스터디 타입별 조회
    Page<Study> findByStudyType(String studyType, Pageable pageable);
    
    // 상태별 스터디 조회
    Page<Study> findByStatus(String status, Pageable pageable);
    
    // 리더별 스터디 조회
    Page<Study> findByLeaderId(Long leaderId, Pageable pageable);
    
    // 제목 또는 설명으로 검색
    @Query("SELECT s FROM Study s WHERE s.title LIKE %:keyword% OR s.description LIKE %:keyword%")
    Page<Study> findByKeyword(@Param("keyword") String keyword, Pageable pageable);
    
    // 복합 검색
    @Query("SELECT s FROM Study s WHERE " +
           "(:category IS NULL OR s.category = :category) AND " +
           "(:location IS NULL OR s.location LIKE %:location%) AND " +
           "(:studyType IS NULL OR s.studyType = :studyType) AND " +
           "(:status IS NULL OR s.status = :status) AND " +
           "(:keyword IS NULL OR s.title LIKE %:keyword% OR s.description LIKE %:keyword%)")
    Page<Study> findBySearchCriteria(
            @Param("category") String category,
            @Param("location") String location,
            @Param("studyType") String studyType,
            @Param("status") String status,
            @Param("keyword") String keyword,
            Pageable pageable
    );
    
    // 모집 중인 스터디 조회
    Page<Study> findByStatusAndStartDateAfter(String status, LocalDateTime startDate, Pageable pageable);
    
    // 사용자가 참여 중인 스터디 조회
    @Query("SELECT s FROM Study s JOIN s.members m WHERE m.user.id = :userId AND m.status = 'active'")
    Page<Study> findByMemberId(@Param("userId") Long userId, Pageable pageable);
    
    // 최근 생성된 스터디 조회
    Page<Study> findByOrderByCreatedAtDesc(Pageable pageable);
    
    // 인기 스터디 조회 (참여자 수 기준)
    Page<Study> findByOrderByCurrentParticipantsDesc(Pageable pageable);
} 