# 스터디 파트너 백엔드 API

스터디 파트너 매칭 서비스의 백엔드 API 서버입니다.

## 📋 프로젝트 개요

스터디 파트너는 사용자들이 스터디 그룹을 만들고 참여할 수 있는 매칭 플랫폼입니다. 이 백엔드 API는 사용자 관리, 스터디 관리, 알림 시스템 등의 핵심 기능을 제공합니다.

## 🛠 기술 스택

- **Framework**: Spring Boot 2.7.18
- **Language**: Java 14
- **Database**: H2 (In-Memory)
- **ORM**: Spring Data JPA
- **Security**: Spring Security + JWT
- **Build Tool**: Gradle
- **Documentation**: Swagger (추후 추가 예정)

## 📦 주요 의존성

```gradle
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-security'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'io.jsonwebtoken:jjwt:0.9.1'
    runtimeOnly 'com.h2database:h2'
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
}
```

## 🚀 설치 및 실행

### 필수 요구사항

- Java 14 이상
- Gradle 7.0 이상

### 실행 방법

1. **프로젝트 클론**
   ```bash
   git clone <repository-url>
   cd likelion_backend
   ```

2. **의존성 설치 및 빌드**
   ```bash
   ./gradlew build
   ```

3. **서버 실행**
   ```bash
   ./gradlew bootRun
   ```

4. **서버 확인**
   - 서버 주소: http://localhost:8080
   - H2 콘솔: http://localhost:8080/h2-console
   - 헬스체크: http://localhost:8080/api/users/health

## 🏗 프로젝트 구조

```
src/main/java/lion/studypartner/
├── config/              # 설정 파일
│   ├── SecurityConfig.java
│   └── JwtAuthenticationFilter.java
├── controller/          # REST 컨트롤러
│   ├── UserController.java
│   ├── StudyController.java
│   ├── StudyPostController.java
│   ├── NotificationController.java
│   └── OAuthController.java
├── dto/                 # 데이터 전송 객체
│   ├── UserDto.java
│   ├── StudyDto.java
│   ├── StudyPostDto.java
│   └── NotificationDto.java
├── entity/              # JPA 엔티티
│   ├── User.java
│   ├── Study.java
│   ├── StudyMember.java
│   ├── StudyPost.java
│   └── Notification.java
├── repository/          # 데이터 접근 계층
│   ├── UserRepository.java
│   ├── StudyRepository.java
│   ├── StudyMemberRepository.java
│   ├── StudyPostRepository.java
│   └── NotificationRepository.java
├── service/             # 비즈니스 로직
│   ├── UserService.java
│   ├── StudyService.java
│   ├── StudyPostService.java
│   ├── NotificationService.java
│   ├── OAuthService.java
│   ├── JwtService.java
│   └── CustomUserDetailsService.java
└── StudyPartnerApplication.java
```

## 🔐 인증 및 보안

### JWT 토큰 인증
- 모든 API 요청에는 JWT 토큰이 필요합니다 (일부 공개 엔드포인트 제외)
- 토큰은 헤더에 `Authorization: Bearer <token>` 형식으로 전송

### OAuth 로그인 지원
- Google OAuth 로그인 지원
- 가상 OAuth 로그인 (테스트용)

## 📡 API 엔드포인트

### 사용자 관리
- `GET /api/users/health` - 서버 상태 확인
- `POST /api/users/oauth/login` - OAuth 로그인
- `POST /api/users/oauth/callback` - OAuth 콜백

### 스터디 관리
- `GET /api/studies` - 스터디 목록 조회
- `POST /api/studies` - 스터디 생성
- `GET /api/studies/{id}` - 스터디 상세 조회
- `PUT /api/studies/{id}` - 스터디 수정
- `DELETE /api/studies/{id}` - 스터디 삭제
- `GET /api/studies/my-studies` - 내 스터디 목록 조회
- `POST /api/studies/{id}/join` - 스터디 참여
- `POST /api/studies/{id}/leave` - 스터디 탈퇴
- `GET /api/studies/{id}/join-status` - 스터디 참여 상태 확인

### 알림 관리
- `GET /api/notifications` - 알림 목록 조회
- `POST /api/notifications/{id}/read` - 알림 읽음 처리

## 🗄 데이터베이스 스키마

### User (사용자)
- `id` (PK): 사용자 ID
- `email`: 이메일 (고유)
- `name`: 이름
- `nickname`: 닉네임
- `password`: 비밀번호
- `provider`: OAuth 제공자
- `provider_id`: OAuth 제공자 ID
- `birth_date`: 생년월일
- `occupation`: 직업
- `education_level`: 학력
- `status`: 상태
- `created_at`, `updated_at`: 생성/수정 시간

### Study (스터디)
- `id` (PK): 스터디 ID
- `title`: 제목
- `description`: 설명
- `category`: 카테고리
- `location`: 위치
- `study_type`: 스터디 유형
- `max_participants`: 최대 참여자 수
- `current_participants`: 현재 참여자 수
- `start_date`, `end_date`: 시작/종료 날짜
- `contact_info`: 연락처
- `meeting_link`: 미팅 링크
- `status`: 상태
- `leader_id` (FK): 리더 ID
- `created_at`, `updated_at`: 생성/수정 시간

### StudyMember (스터디 멤버)
- `id` (PK): 멤버 ID
- `study_id` (FK): 스터디 ID
- `user_id` (FK): 사용자 ID
- `role`: 역할 (leader/member)
- `status`: 상태 (active/inactive)
- `joined_at`: 참여 시간
- `left_at`: 탈퇴 시간

### Notification (알림)
- `id` (PK): 알림 ID
- `user_id` (FK): 사용자 ID
- `study_id` (FK): 스터디 ID (선택적)
- `type`: 알림 유형
- `title`: 제목
- `message`: 메시지
- `status`: 상태
- `related_url`: 관련 URL
- `created_at`: 생성 시간
- `read_at`: 읽은 시간

## 🔧 설정

### 환경 변수
```properties
# JWT 설정
jwt.secret=studyPartnerSecretKey2024ForJWTTokenGeneration

# 데이터베이스 설정 (H2)
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.username=sa
spring.datasource.password=

# JPA 설정
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
```

## 🧪 테스트

```bash
# 단위 테스트 실행
./gradlew test

# 통합 테스트 실행
./gradlew integrationTest
```

## 📝 개발 노트

### 주요 기능
1. **사용자 인증**: JWT 기반 인증 시스템
2. **스터디 관리**: CRUD 작업 및 참여/탈퇴 기능
3. **알림 시스템**: 스터디 참여/탈퇴 시 자동 알림
4. **예외 처리**: 포괄적인 예외 처리 및 에러 응답

### 보안 고려사항
- JWT 토큰 기반 인증
- CORS 설정
- 입력 데이터 검증
- SQL 인젝션 방지 (JPA 사용)

### 성능 최적화
- JPA 쿼리 최적화
- 페이징 처리
- 인덱스 활용

## 🤝 기여 방법

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 📞 문의

프로젝트에 대한 문의사항이 있으시면 이슈를 등록해주세요.
