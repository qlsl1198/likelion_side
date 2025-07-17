package lion.studypartner.service;

import lion.studypartner.entity.Study;
import lion.studypartner.entity.StudyMember;
import lion.studypartner.entity.User;
import lion.studypartner.repository.StudyMemberRepository;
import lion.studypartner.repository.StudyRepository;
import lion.studypartner.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class DataInitializationService implements CommandLineRunner {

    private final UserRepository userRepository;
    private final StudyRepository studyRepository;
    private final StudyMemberRepository studyMemberRepository;

    @Override
    public void run(String... args) throws Exception {
        if (studyRepository.count() < 15) {
            log.info("초기 데이터 생성을 시작합니다...");
            // 기존 데이터 모두 삭제
            studyMemberRepository.deleteAll();
            studyRepository.deleteAll();
            userRepository.deleteAll();
            createInitialData();
            log.info("초기 데이터 생성이 완료되었습니다.");
        }
    }

    private void createInitialData() {
        // 예시 사용자 생성
        User user1 = createUser("admin@studypartner.com", "관리자", "admin", "google");
        User user2 = createUser("john@example.com", "김철수", "철수", "kakao");
        User user3 = createUser("jane@example.com", "박영희", "영희", "google");
        User user4 = createUser("mike@example.com", "이민수", "민수", "kakao");
        User user5 = createUser("sarah@example.com", "최지영", "지영", "google");
        User user6 = createUser("david@example.com", "김대석", "대석", "google");
        User user7 = createUser("lisa@example.com", "이수연", "수연", "kakao");
        User user8 = createUser("alex@example.com", "박준형", "준형", "google");

        // 예시 스터디 생성 (20개)
        createStudy(user1, "Java 기초부터 심화까지", "프로그래밍", "온라인", 
                "Java 프로그래밍을 처음 시작하는 분들을 위한 스터디입니다. 기초 문법부터 객체지향 프로그래밍까지 차근차근 배워보아요!", 
                "https://zoom.us/j/123456789", "java.study@gmail.com");

        createStudy(user2, "토익 900점 달성 스터디", "어학", "오프라인", 
                "토익 900점을 목표로 하는 스터디입니다. 매주 모의고사를 풀고 오답노트를 작성해요. 함께 목표를 달성해봅시다!", 
                "", "toeic900@study.com");

        createStudy(user3, "React 실전 프로젝트", "프로그래밍", "하이브리드", 
                "React를 이용한 실전 프로젝트를 진행합니다. 포트폴리오 제작과 취업 준비를 함께 해요!", 
                "https://discord.gg/reactstudy", "react.project@gmail.com");

        createStudy(user4, "공인회계사 1차 대비", "자격증", "오프라인", 
                "공인회계사 1차 시험을 준비하는 스터디입니다. 회계학, 경영학 등 전 과목을 체계적으로 공부해요.", 
                "", "cpa.study@naver.com");

        createStudy(user5, "데이터 분석 입문", "프로그래밍", "온라인", 
                "Python을 이용한 데이터 분석 기초를 배우는 스터디입니다. 실제 데이터를 활용한 프로젝트도 진행해요!", 
                "https://meet.google.com/abc-defg-hij", "data.analysis@study.org");

        createStudy(user1, "영어 회화 마스터", "어학", "오프라인", 
                "영어 회화 실력 향상을 위한 스터디입니다. 매주 다양한 주제로 토론하고 발표 연습을 해요.", 
                "", "english.speaking@gmail.com");

        createStudy(user2, "정보처리기사 실기 대비", "자격증", "하이브리드", 
                "정보처리기사 실기 시험을 준비하는 스터디입니다. 기출문제 풀이와 실습 위주로 진행해요.", 
                "https://zoom.us/j/987654321", "engineer.study@outlook.com");

        createStudy(user3, "독서 토론 모임", "기타", "오프라인", 
                "한 달에 한 권씩 책을 읽고 토론하는 모임입니다. 다양한 장르의 책을 함께 읽어보아요!", 
                "", "book.discussion@reading.com");

        createStudy(user4, "UI/UX 디자인 스터디", "디자인", "온라인", 
                "UI/UX 디자인 원리와 실무를 배우는 스터디입니다. Figma, Adobe XD 등 도구 사용법도 익혀요.", 
                "https://discord.gg/uiuxdesign", "design.study@creative.com");

        createStudy(user5, "스타트업 창업 준비", "기타", "하이브리드", 
                "스타트업 창업을 준비하는 분들을 위한 스터디입니다. 사업계획서 작성부터 투자 유치까지!", 
                "https://meet.google.com/startup-study", "startup.prep@business.co.kr");

        // 추가 스터디들
        createStudy(user1, "Python 머신러닝 마스터", "프로그래밍", "온라인", 
                "Python을 이용한 머신러닝 기초부터 실전까지! 데이터 분석과 AI 모델 구축을 배워보세요.", 
                "https://meet.google.com/python-ml", "ml.study@tech.com");

        createStudy(user2, "TOEIC 850점 달성", "어학", "오프라인", 
                "체계적인 학습 계획으로 TOEIC 850점을 목표로 하는 스터디입니다. 매주 모의고사 진행!", 
                "", "toeic850@lang.co.kr");

        createStudy(user3, "Node.js 백엔드 개발", "프로그래밍", "하이브리드", 
                "Node.js와 Express를 활용한 백엔드 개발 실무 스터디. 실제 프로젝트를 통해 학습합니다.", 
                "https://meet.google.com/nodejs-backend", "nodejs.dev@coding.net");

        createStudy(user4, "컴활 1급 실기 대비", "자격증", "오프라인", 
                "컴퓨터활용능력 1급 실기시험 대비 집중 스터디. 실무 중심의 엑셀, 액세스 활용법!", 
                "", "computer.cert@exam.co.kr");

        createStudy(user5, "디자인 포트폴리오 제작", "디자인", "하이브리드", 
                "취업을 위한 디자인 포트폴리오 제작 스터디. 피드백과 멘토링을 통해 완성도 높은 포트폴리오를!", 
                "https://meet.google.com/design-portfolio", "portfolio.design@creative.com");

        createStudy(user1, "블록체인 기초부터 실전", "프로그래밍", "온라인", 
                "블록체인 기술의 이해부터 스마트 컨트랙트 개발까지. Web3 시대를 준비하는 개발자 스터디!", 
                "https://meet.google.com/blockchain-dev", "blockchain@future.tech");

        createStudy(user2, "일본어 JLPT N2 대비", "어학", "오프라인", 
                "일본어능력시험 N2 합격을 목표로 하는 스터디. 문법, 어휘, 독해, 청해 모든 영역 대비!", 
                "", "jlpt.n2@japan.study");

        createStudy(user3, "투자 포트폴리오 스터디", "기타", "하이브리드", 
                "주식, 부동산, 펀드 등 다양한 투자 상품을 분석하고 포트폴리오를 구성하는 스터디.", 
                "https://meet.google.com/investment-study", "invest.portfolio@money.co.kr");

        createStudy(user4, "영화 제작 워크샵", "기타", "하이브리드", 
                "단편 영화 제작을 통해 영상 기획, 촬영, 편집까지 전 과정을 경험하는 실습 중심 스터디.", 
                "https://meet.google.com/film-workshop", "film.making@creative.studio");

        createStudy(user5, "게임 개발 입문", "프로그래밍", "온라인", 
                "Unity를 이용한 게임 개발 기초 스터디. 2D/3D 게임 제작의 전 과정을 체험해보세요!", 
                "https://meet.google.com/game-dev", "game.development@unity.co.kr");

        log.info("=== 총 20개의 스터디 데이터 생성 완료 ===");
    }

    private User createUser(String email, String name, String nickname, String provider) {
        User user = new User();
        user.setEmail(email);
        user.setName(name);
        user.setNickname(nickname);
        user.setProvider(provider);
        user.setProviderId(provider + "_" + System.currentTimeMillis());
        user.setPassword("");
        user.setStatus("active");
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    private Study createStudy(User leader, String title, String category, String studyType, 
                             String description, String meetingLink, String contactInfo) {
        Study study = new Study();
        study.setTitle(title);
        study.setCategory(category);
        study.setStudyType(studyType);
        study.setDescription(description);
        study.setLocation(studyType.equals("온라인") ? "온라인" : "서울시 강남구");
        study.setMeetingLink(meetingLink);
        study.setContactInfo(contactInfo);
        study.setMaxParticipants(studyType.equals("오프라인") ? 6 : 10);
        study.setCurrentParticipants(1);
        study.setStartDate(LocalDateTime.now().plusDays(7));
        study.setEndDate(LocalDateTime.now().plusDays(90));
        study.setLeader(leader);
        study.setStatus("active");
        study.setCreatedAt(LocalDateTime.now());
        study.setUpdatedAt(LocalDateTime.now());
        
        Study savedStudy = studyRepository.save(study);
        
        // 스터디 리더를 멤버로 추가
        StudyMember member = new StudyMember();
        member.setStudy(savedStudy);
        member.setUser(leader);
        member.setRole("LEADER");
        member.setStatus("active");
        member.setJoinedAt(LocalDateTime.now());
        studyMemberRepository.save(member);
        
        return savedStudy;
    }
} 