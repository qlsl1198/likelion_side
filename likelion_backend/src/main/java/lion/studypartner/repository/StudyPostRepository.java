package lion.studypartner.repository;

import lion.studypartner.entity.StudyPost;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface StudyPostRepository extends JpaRepository<StudyPost, Long> {
    
    // 스터디의 모든 게시글 조회
    Page<StudyPost> findByStudyId(Long studyId, Pageable pageable);
    
    // 스터디의 활성 게시글 조회
    Page<StudyPost> findByStudyIdAndStatus(Long studyId, String status, Pageable pageable);
    
    // 스터디의 특정 타입 게시글 조회
    Page<StudyPost> findByStudyIdAndType(Long studyId, String type, Pageable pageable);
    
    // 작성자별 게시글 조회
    Page<StudyPost> findByAuthorId(Long authorId, Pageable pageable);
    
    // 제목으로 검색
    Page<StudyPost> findByTitleContaining(String title, Pageable pageable);
    
    // 내용으로 검색
    Page<StudyPost> findByContentContaining(String content, Pageable pageable);
    
    // 제목 또는 내용으로 검색
    @Query("SELECT sp FROM StudyPost sp WHERE sp.title LIKE %:keyword% OR sp.content LIKE %:keyword%")
    Page<StudyPost> findByKeyword(@Param("keyword") String keyword, Pageable pageable);
    
    // 스터디의 최근 게시글 조회
    Page<StudyPost> findByStudyIdOrderByCreatedAtDesc(Long studyId, Pageable pageable);
    
    // 공지사항 조회
    Page<StudyPost> findByStudyIdAndTypeOrderByCreatedAtDesc(Long studyId, String type, Pageable pageable);
} 