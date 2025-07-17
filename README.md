# 스터디 파트너 (Study Partner)

> 스터디 그룹 매칭 및 관리 플랫폼

스터디 파트너는 사용자들이 효율적으로 스터디 그룹을 찾고, 만들고, 참여할 수 있는 웹 기반 매칭 플랫폼입니다.

## 📋 프로젝트 개요

### 🎯 목적
- 같은 목표를 가진 스터디 멤버들을 쉽게 찾을 수 있는 플랫폼 제공
- 체계적인 스터디 관리 및 커뮤니케이션 도구 제공
- 위치 기반 오프라인 스터디 및 온라인 스터디 모두 지원

### ✨ 주요 기능
- **사용자 관리**: OAuth 로그인, 프로필 관리
- **스터디 관리**: 스터디 생성, 검색, 참여, 관리
- **실시간 채팅**: 스터디 그룹 내 커뮤니케이션
- **알림 시스템**: 스터디 관련 실시간 알림
- **위치 기반 서비스**: 지도를 통한 오프라인 스터디 장소 확인

## 🏗 시스템 아키텍처

```
┌─────────────────┐    HTTP/REST API    ┌─────────────────┐
│                 │ ◄─────────────────► │                 │
│  Flutter Web    │                     │  Spring Boot    │
│  (Frontend)     │                     │  (Backend)      │
│                 │                     │                 │
│  - UI/UX        │                     │  - REST API     │
│  - State Mgmt   │                     │  - Business     │
│  - Routing      │                     │  - Security     │
│  - HTTP Client  │                     │  - Database     │
└─────────────────┘                     └─────────────────┘
                                                │
                                                ▼
                                        ┌─────────────────┐
                                        │   H2 Database   │
                                        │  (In-Memory)    │
                                        └─────────────────┘
```

## 🛠 기술 스택

### 백엔드 (likelion_backend)
- **Framework**: Spring Boot 2.7.18
- **Language**: Java 14
- **Database**: H2 (In-Memory)
- **ORM**: Spring Data JPA
- **Security**: Spring Security + JWT
- **Build Tool**: Gradle

### 프론트엔드 (likelion_front)
- **Framework**: Flutter 3.27.1
- **Language**: Dart 3.2.3
- **HTTP Client**: Dio
- **Routing**: GoRouter
- **UI**: Material Design 3
- **Platform**: Web (Chrome, Safari, Firefox)

## 🚀 빠른 시작

### 필수 요구사항
- **백엔드**: Java 14+, Gradle 7.0+
- **프론트엔드**: Flutter SDK 3.27.1+, Dart SDK 3.2.3+
- **브라우저**: Chrome (개발 권장)

### 1. 프로젝트 클론
```bash
git clone <repository-url>
cd project8
```

### 2. 백엔드 서버 실행
```bash
cd likelion_backend
./gradlew bootRun
```
서버가 http://localhost:8080 에서 실행됩니다.

### 3. 프론트엔드 실행
```bash
cd likelion_front
flutter pub get
flutter run -d web-server --web-port 3000
```
웹 애플리케이션이 http://localhost:3000 에서 실행됩니다.

### 4. 애플리케이션 접속
브라우저에서 http://localhost:3000 으로 접속하여 애플리케이션을 사용할 수 있습니다.

## 📱 주요 화면

### 🏠 홈 화면
- 추천 스터디 목록 조회
- 카테고리별 스터디 필터링
- 스터디 검색 기능

### 🔐 로그인/회원가입
- OAuth 소셜 로그인 (Google, Kakao 등)
- 사용자 프로필 설정

### 📚 스터디 관리
- 스터디 생성 및 설정
- 스터디 상세 정보 조회
- 스터디 참여 신청 및 관리

### 💬 채팅
- 스터디 그룹 내 실시간 채팅
- 파일 공유 및 링크 공유

### 📍 지도
- 오프라인 스터디 장소 확인
- 위치 기반 스터디 검색

## 📚 API 문서

### 주요 엔드포인트

#### 사용자 관리
- `POST /api/users/oauth/login` - OAuth 로그인
- `GET /api/users/profile` - 사용자 프로필 조회
- `PUT /api/users/profile` - 사용자 프로필 수정

#### 스터디 관리
- `GET /api/studies` - 스터디 목록 조회
- `POST /api/studies` - 스터디 생성
- `GET /api/studies/{id}` - 스터디 상세 조회
- `PUT /api/studies/{id}` - 스터디 수정
- `POST /api/studies/{id}/join` - 스터디 참여
- `DELETE /api/studies/{id}/leave` - 스터디 탈퇴

#### 알림
- `GET /api/notifications` - 알림 목록 조회
- `PUT /api/notifications/{id}/read` - 알림 읽음 처리

자세한 API 문서는 각 서비스의 README를 참조하세요:
- [백엔드 API 문서](./likelion_backend/README.md)
- [프론트엔드 가이드](./likelion_front/README.md)

## 🗂 프로젝트 구조

```
project8/
├── likelion_backend/          # Spring Boot 백엔드
│   ├── src/main/java/lion/studypartner/
│   │   ├── config/           # 보안 설정
│   │   ├── controller/       # REST API 컨트롤러
│   │   ├── dto/             # 데이터 전송 객체
│   │   ├── entity/          # JPA 엔티티
│   │   ├── repository/      # 데이터 접근 계층
│   │   └── service/         # 비즈니스 로직
│   ├── src/main/resources/
│   │   └── application.properties
│   └── build.gradle
├── likelion_front/           # Flutter 웹 프론트엔드
│   ├── lib/
│   │   ├── models/          # 데이터 모델
│   │   ├── screens/         # 화면 위젯
│   │   ├── services/        # API 서비스
│   │   ├── widgets/         # 재사용 위젯
│   │   ├── router.dart      # 라우팅 설정
│   │   └── main.dart        # 앱 진입점
│   └── pubspec.yaml
└── README.md                # 이 파일
```

## 🔧 개발 환경 설정

### 백엔드 개발
1. IntelliJ IDEA 또는 Eclipse 설치
2. Java 14 SDK 설정
3. Gradle 빌드 도구 설정
4. H2 데이터베이스 콘솔: http://localhost:8080/h2-console

### 프론트엔드 개발
1. Flutter SDK 설치
2. VS Code + Flutter 확장 설치 (권장)
3. Chrome 브라우저 설치
4. Flutter 웹 지원 활성화: `flutter config --enable-web`

## 🚀 배포

### 백엔드 배포
```bash
cd likelion_backend
./gradlew build
java -jar build/libs/study-partner-*.jar
```

### 프론트엔드 배포
```bash
cd likelion_front
flutter build web
# build/web 디렉토리를 웹 서버에 배포
```

## 🤝 기여하기

1. 프로젝트를 Fork 합니다
2. 새로운 기능 브랜치를 생성합니다 (`git checkout -b feature/새기능`)
3. 변경사항을 커밋합니다 (`git commit -am '새 기능 추가'`)
4. 브랜치에 Push 합니다 (`git push origin feature/새기능`)
5. Pull Request를 생성합니다

### 개발 규칙
- 코드 스타일: 각 프로젝트의 기본 포맷터 사용
- 커밋 메시지: 한국어로 명확하게 작성
- 테스트: 새로운 기능 추가 시 테스트 코드 작성

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 📞 문의

프로젝트에 대한 질문이나 제안사항이 있으시면 다음을 통해 연락해 주세요:

- 이슈 등록: [GitHub Issues](https://github.com/qlsl1198/likelion_side/issues)
- 이메일: qlsl1198@gmail.com

## 🔄 업데이트 로그

### v1.0.0 (2024-01-XX)
- 기본 스터디 매칭 기능 구현
- OAuth 로그인 시스템 구현
- 실시간 채팅 기능 추가
- 지도 기반 위치 서비스 구현

---

**Made with ❤️ by LikeLion Team** 