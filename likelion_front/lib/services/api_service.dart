import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  static const String baseUrlEmulator = 'http://10.0.2.2:8080/api';
  
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl, // 웹용 localhost URL 사용
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // 인터셉터 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 토큰이 있으면 헤더에 추가
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        print('=== API Error Details ===');
        print('Message: ${error.message}');
        print('Status Code: ${error.response?.statusCode}');
        print('Response Data: ${error.response?.data}');
        print('Request URL: ${error.requestOptions.uri}');
        print('Request Method: ${error.requestOptions.method}');
        print('========================');
        handler.next(error);
      },
    ));
  }
  
  // 회원가입
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/users/register', data: userData);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 로그인
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/users/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 사용자 정보 조회
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _dio.get('/users/me');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 헬스 체크
  Future<String> healthCheck() async {
    try {
      final response = await _dio.get('/users/health');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // OAuth 로그인
  Future<Map<String, dynamic>> oauthLogin(String provider) async {
    try {
      // 임시로 테스트용 응답을 반환
      // 실제로는 OAuth 제공자의 인증 코드를 받아서 백엔드로 전송
      final response = await _dio.post('/users/oauth/callback', data: {
        'provider': provider,
        'code': 'test_code_${DateTime.now().millisecondsSinceEpoch}',
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 가상 OAuth 로그인
  Future<Map<String, dynamic>> virtualOAuthLogin(String provider, String email, String name) async {
    try {
      final response = await _dio.post('/users/oauth/login', queryParameters: {
        'provider': provider,
        'email': email,
        'name': name,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 스터디 목록 조회
  Future<Map<String, dynamic>> getStudyList({int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get('/studies', queryParameters: {
        'page': page,
        'size': size,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 스터디 상세 조회
  Future<Map<String, dynamic>> getStudyDetail(int studyId) async {
    try {
      final response = await _dio.get('/studies/$studyId');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('스터디를 찾을 수 없습니다. (ID: $studyId)');
      } else if (e.response?.statusCode == 401) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else {
        throw Exception('스터디 정보를 불러오는 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('네트워크 오류가 발생했습니다: $e');
    }
  }
  
  // 스터디 생성
  Future<Map<String, dynamic>> createStudy(Map<String, dynamic> studyData) async {
    try {
      final response = await _dio.post('/studies', data: studyData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('잘못된 요청입니다. 입력 정보를 확인해주세요.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else {
        throw Exception('스터디 생성 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('네트워크 오류가 발생했습니다: $e');
    }
  }
  
  // 스터디 수정
  Future<Map<String, dynamic>> updateStudy(int studyId, Map<String, dynamic> studyData) async {
    try {
      final response = await _dio.put('/studies/$studyId', data: studyData);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 스터디 참여
  Future<Map<String, dynamic>> joinStudy(int studyId) async {
    try {
      final response = await _dio.post('/studies/$studyId/join');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 스터디 탈퇴
  Future<Map<String, dynamic>> leaveStudy(int studyId) async {
    try {
      final response = await _dio.post('/studies/$studyId/leave');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 내가 참여 중인 스터디 목록
  Future<Map<String, dynamic>> getMyStudies({int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get('/studies/my-studies', queryParameters: {
        'page': page,
        'size': size,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 스터디 검색
  Future<Map<String, dynamic>> searchStudies({
    String? category,
    String? location,
    String? studyType,
    String? status,
    String? keyword,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };
      
      if (category != null) queryParams['category'] = category;
      if (location != null) queryParams['location'] = location;
      if (studyType != null) queryParams['studyType'] = studyType;
      if (status != null) queryParams['status'] = status;
      if (keyword != null) queryParams['keyword'] = keyword;
      
      final response = await _dio.get('/studies/search', queryParameters: queryParams);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 스터디 삭제
  Future<Map<String, dynamic>> deleteStudy(int studyId) async {
    try {
      final response = await _dio.delete('/studies/$studyId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 알림 목록 조회
  Future<Map<String, dynamic>> getNotifications({int page = 0, int size = 20}) async {
    try {
      final response = await _dio.get('/notifications', queryParameters: {
        'page': page,
        'size': size,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 읽지 않은 알림 조회
  Future<Map<String, dynamic>> getUnreadNotifications() async {
    try {
      final response = await _dio.get('/notifications/unread');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 읽지 않은 알림 개수 조회
  Future<Map<String, dynamic>> getUnreadNotificationCount() async {
    try {
      final response = await _dio.get('/notifications/unread/count');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 알림 읽음 처리
  Future<Map<String, dynamic>> markNotificationAsRead(int notificationId) async {
    try {
      final response = await _dio.put('/notifications/$notificationId/read');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // 모든 알림 읽음 처리
  Future<Map<String, dynamic>> markAllNotificationsAsRead() async {
    try {
      final response = await _dio.put('/notifications/read-all');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 프로필 수정
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.put('/users/me', data: profileData);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 비밀번호 변경
  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await _dio.put('/users/me/password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 회원 탈퇴
  Future<Map<String, dynamic>> withdrawUser() async {
    try {
      final response = await _dio.delete('/users/me');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 알림 설정 저장
  Future<Map<String, dynamic>> saveNotificationSettings(Map<String, dynamic> settings) async {
    try {
      final response = await _dio.put('/users/me/notification-settings', data: settings);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 알림 설정 불러오기
  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final response = await _dio.get('/users/me/notification-settings');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 채팅 메시지 불러오기 (임시)
  Future<List<Map<String, dynamic>>> fetchChatMessages(String roomId) async {
    // 실제로는 await _dio.get('/chat/$roomId/messages') 등으로 구현
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'sender': '김철수',
        'message': '안녕하세요! 오늘 스터디 시작할까요?',
        'time': '10:00',
        'isMe': false,
      },
      {
        'sender': '나',
        'message': '네, 시작하겠습니다!',
        'time': '10:01',
        'isMe': true,
      },
    ];
  }

  // 투두 불러오기 (임시)
  Future<List<Map<String, dynamic>>> fetchTodos(String roomId) async {
    // 실제로는 await _dio.get('/chat/$roomId/todos') 등으로 구현
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'title': 'Flutter 기본 위젯 학습',
        'deadline': '2024-03-20',
        'assignee': '김철수',
        'isCompleted': false,
      },
      {
        'title': '알고리즘 문제 풀이',
        'deadline': '2024-03-22',
        'assignee': '전체',
        'isCompleted': true,
      },
    ];
  }

  // 스터디 참여 상태 확인
  Future<Map<String, dynamic>> checkJoinStatus(int studyId) async {
    try {
      final response = await _dio.get('/studies/$studyId/join-status');
      return response.data;
    } catch (e) {
      print('참여 상태 확인 실패: $e');
      rethrow;
    }
  }

  // 스터디 목록 조회
  Future<Map<String, dynamic>> getStudies() async {
    try {
      final response = await _dio.get('/studies');
      return response.data;
    } catch (e) {
      print('스터디 목록 조회 실패: $e');
      rethrow;
    }
  }
} 