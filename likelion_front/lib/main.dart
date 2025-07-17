/// 스터디 파트너 앱의 메인 파일
/// 
/// 이 파일은 앱의 진입점이며, 라우팅 설정과 테마 설정을 포함합니다.
/// Go Router를 사용하여 화면 간 네비게이션을 관리합니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/map_screen.dart';
import 'screens/follow_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_room_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/study_search_screen.dart';
import 'screens/study_detail_screen.dart';
import 'screens/user_info_screen.dart';
import 'screens/study_create_screen.dart';

/// 앱의 진입점
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 웹 환경에서 포인터 이벤트 오류 방지
  if (kIsWeb) {
    // Flutter 웹에서 HTML 렌더러 사용 시 포인터 이벤트 안정성 향상
    WidgetsFlutterBinding.ensureInitialized();
    
    // 시스템 UI 오버레이 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
  
  // 환경 변수 파일 로딩 (실패 시 기본값 사용)
  try {
    await dotenv.load(fileName: "assets/config.env");
  } catch (e) {
    // 환경 변수 파일을 찾을 수 없습니다. 기본값을 설정합니다.
    print('Config file not found, using default values: $e');
    
    // 기본값 설정
    dotenv.env.addAll({
      'API_BASE_URL': 'http://localhost:8080',
      'APP_NAME': 'Study Partner',
      'APP_VERSION': '1.0.0',
      'ENABLE_CHAT': 'true',
      'ENABLE_MAPS': 'true',
      'ENABLE_NOTIFICATIONS': 'true',
    });
  }
  
  runApp(const MyApp());
}

/// 앱의 라우팅 설정
/// 
/// 각 화면에 대한 경로와 화면 빌더를 정의합니다.
/// 초기 경로는 로그인 화면('/login')으로 설정됩니다.
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const StudySearchScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/chat/study/:id',
      builder: (context, state) => ChatRoomScreen(
        roomId: state.pathParameters['id']!,
        type: 'study',
        title: '스터디 채팅방',
      ),
    ),
    GoRoute(
      path: '/chat/personal/:id',
      builder: (context, state) => ChatRoomScreen(
        roomId: state.pathParameters['id']!,
        type: 'personal',
        title: '개인 채팅방',
      ),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const ProfileEditScreen(),
    ),
    GoRoute(
      path: '/notifications/settings',
      builder: (context, state) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/follow',
      builder: (context, state) => const FollowScreen(),
    ),
    GoRoute(
      path: '/study/detail/:id',
      builder: (context, state) {
        try {
          final studyId = int.parse(state.pathParameters['id']!);
          if (studyId <= 0) {
            throw FormatException('Invalid study ID');
          }
          return StudyDetailScreen(studyId: studyId);
        } catch (e) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('오류'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '잘못된 스터디 ID입니다',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${state.pathParameters['id']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('홈으로 돌아가기'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: '/study/create',
      builder: (context, state) => const StudyCreateScreen(),
    ),
    GoRoute(
      path: '/user/info',
      builder: (context, state) => const UserInfoScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('페이지 오류'),
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              '페이지를 찾을 수 없습니다',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '요청하신 페이지가 존재하지 않거나 이동되었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '경로: ${state.uri.path}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home, size: 18),
                      label: const Text('홈으로', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('뒤로', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    ),
  ),
);

/// 앱의 루트 위젯
/// 
/// MaterialApp.router를 사용하여 라우팅을 설정하고,
/// 앱의 테마를 정의합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // API URL 설정
    final apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';
    return MaterialApp.router(
      title: '스터디 파트너',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      routerConfig: _router,
      builder: (context, child) {
        // 환경 변수 값이 잘 불러와지는지 확인용 (실제 앱에서는 삭제 가능)
        return Stack(
          children: [
            if (child != null) child,
            Positioned(
              bottom: 10,
              left: 10,
              child: Text('API_URL: $apiUrl',
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
