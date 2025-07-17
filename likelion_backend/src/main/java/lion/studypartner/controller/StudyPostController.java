package lion.studypartner.controller;

import lion.studypartner.dto.StudyPostDto;
import lion.studypartner.dto.UserDto;
import lion.studypartner.service.StudyPostService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/studies/{studyId}/posts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class StudyPostController {
    
    private final StudyPostService studyPostService;
    
    // 게시글 생성
    @PostMapping
    public ResponseEntity<UserDto.ApiResponse<StudyPostDto.PostResponse>> createPost(
            @PathVariable Long studyId,
            @RequestBody StudyPostDto.CreateRequest request,
            Authentication authentication) {
        try {
            Long authorId = Long.parseLong(authentication.getName());
            StudyPostDto.PostResponse response = studyPostService.createPost(studyId, request, authorId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("게시글이 작성되었습니다.", response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 게시글 수정
    @PutMapping("/{postId}")
    public ResponseEntity<UserDto.ApiResponse<StudyPostDto.PostResponse>> updatePost(
            @PathVariable Long studyId,
            @PathVariable Long postId,
            @RequestBody StudyPostDto.UpdateRequest request,
            Authentication authentication) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            StudyPostDto.PostResponse response = studyPostService.updatePost(postId, request, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("게시글이 수정되었습니다.", response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 게시글 상세 조회
    @GetMapping("/{postId}")
    public ResponseEntity<UserDto.ApiResponse<StudyPostDto.PostResponse>> getPost(
            @PathVariable Long studyId,
            @PathVariable Long postId) {
        try {
            StudyPostDto.PostResponse response = studyPostService.getPost(postId);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 스터디의 게시글 목록 조회
    @GetMapping
    public ResponseEntity<UserDto.ApiResponse<Page<StudyPostDto.PostListResponse>>> getStudyPosts(
            @PathVariable Long studyId,
            @PageableDefault(size = 10) Pageable pageable) {
        try {
            Page<StudyPostDto.PostListResponse> response = studyPostService.getStudyPosts(studyId, pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 스터디의 특정 타입 게시글 조회
    @GetMapping("/type/{type}")
    public ResponseEntity<UserDto.ApiResponse<Page<StudyPostDto.PostListResponse>>> getStudyPostsByType(
            @PathVariable Long studyId,
            @PathVariable String type,
            @PageableDefault(size = 10) Pageable pageable) {
        try {
            Page<StudyPostDto.PostListResponse> response = studyPostService.getStudyPostsByType(studyId, type, pageable);
            return ResponseEntity.ok(UserDto.ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
    
    // 게시글 삭제
    @DeleteMapping("/{postId}")
    public ResponseEntity<UserDto.ApiResponse<String>> deletePost(
            @PathVariable Long studyId,
            @PathVariable Long postId,
            Authentication authentication) {
        try {
            Long userId = Long.parseLong(authentication.getName());
            studyPostService.deletePost(postId, userId);
            return ResponseEntity.ok(UserDto.ApiResponse.success("게시글이 삭제되었습니다.", "success"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(UserDto.ApiResponse.error(e.getMessage()));
        }
    }
} 