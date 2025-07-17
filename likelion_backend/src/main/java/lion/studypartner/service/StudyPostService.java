package lion.studypartner.service;

import lion.studypartner.dto.StudyPostDto;
import lion.studypartner.dto.UserDto;
import lion.studypartner.entity.Study;
import lion.studypartner.entity.StudyPost;
import lion.studypartner.entity.User;
import lion.studypartner.repository.StudyPostRepository;
import lion.studypartner.repository.StudyRepository;
import lion.studypartner.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class StudyPostService {
    
    private final StudyPostRepository studyPostRepository;
    private final StudyRepository studyRepository;
    private final UserRepository userRepository;
    
    // 게시글 생성
    public StudyPostDto.PostResponse createPost(Long studyId, StudyPostDto.CreateRequest request, Long authorId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new RuntimeException("스터디를 찾을 수 없습니다."));
        
        User author = userRepository.findById(authorId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
        
        StudyPost post = new StudyPost();
        post.setStudy(study);
        post.setAuthor(author);
        post.setTitle(request.getTitle());
        post.setContent(request.getContent());
        post.setType(request.getType());
        
        StudyPost savedPost = studyPostRepository.save(post);
        return convertToPostResponse(savedPost);
    }
    
    // 게시글 수정
    public StudyPostDto.PostResponse updatePost(Long postId, StudyPostDto.UpdateRequest request, Long userId) {
        StudyPost post = studyPostRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));
        
        // 작성자만 수정 가능
        if (!post.getAuthor().getId().equals(userId)) {
            throw new RuntimeException("게시글을 수정할 권한이 없습니다.");
        }
        
        if (request.getTitle() != null) post.setTitle(request.getTitle());
        if (request.getContent() != null) post.setContent(request.getContent());
        if (request.getType() != null) post.setType(request.getType());
        
        StudyPost updatedPost = studyPostRepository.save(post);
        return convertToPostResponse(updatedPost);
    }
    
    // 게시글 상세 조회
    @Transactional(readOnly = true)
    public StudyPostDto.PostResponse getPost(Long postId) {
        StudyPost post = studyPostRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));
        
        return convertToPostResponse(post);
    }
    
    // 스터디의 게시글 목록 조회
    @Transactional(readOnly = true)
    public Page<StudyPostDto.PostListResponse> getStudyPosts(Long studyId, Pageable pageable) {
        Page<StudyPost> posts = studyPostRepository.findByStudyIdAndStatus(studyId, "active", pageable);
        return posts.map(this::convertToPostListResponse);
    }
    
    // 스터디의 특정 타입 게시글 조회
    @Transactional(readOnly = true)
    public Page<StudyPostDto.PostListResponse> getStudyPostsByType(Long studyId, String type, Pageable pageable) {
        Page<StudyPost> posts = studyPostRepository.findByStudyIdAndType(studyId, type, pageable);
        return posts.map(this::convertToPostListResponse);
    }
    
    // 게시글 검색
    @Transactional(readOnly = true)
    public Page<StudyPostDto.PostListResponse> searchPosts(String keyword, Pageable pageable) {
        Page<StudyPost> posts = studyPostRepository.findByKeyword(keyword, pageable);
        return posts.map(this::convertToPostListResponse);
    }
    
    // 게시글 삭제
    public void deletePost(Long postId, Long userId) {
        StudyPost post = studyPostRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));
        
        // 작성자만 삭제 가능
        if (!post.getAuthor().getId().equals(userId)) {
            throw new RuntimeException("게시글을 삭제할 권한이 없습니다.");
        }
        
        post.setStatus("deleted");
        studyPostRepository.save(post);
    }
    
    // DTO 변환 메서드들
    private StudyPostDto.PostResponse convertToPostResponse(StudyPost post) {
        return StudyPostDto.PostResponse.builder()
                .id(post.getId())
                .title(post.getTitle())
                .content(post.getContent())
                .type(post.getType())
                .status(post.getStatus())
                .author(convertToUserInfo(post.getAuthor()))
                .createdAt(post.getCreatedAt())
                .updatedAt(post.getUpdatedAt())
                .build();
    }
    
    private StudyPostDto.PostListResponse convertToPostListResponse(StudyPost post) {
        return StudyPostDto.PostListResponse.builder()
                .id(post.getId())
                .title(post.getTitle())
                .type(post.getType())
                .status(post.getStatus())
                .author(convertToUserInfo(post.getAuthor()))
                .createdAt(post.getCreatedAt())
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
} 