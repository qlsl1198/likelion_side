/// 홈 화면
/// 
/// 사용자의 스터디 목록과 추천 스터디를 표시하는 메인 화면입니다.
/// 우측 하단의 만들기 버튼을 통해 새로운 스터디를 생성할 수 있습니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'profile_screen.dart';
import '../widgets/location_selector.dart';
import 'study_search_screen.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import 'chat_screen.dart';
import 'notification_screen.dart';

/// 홈 화면 위젯
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 정적 데이터는 fallback으로 유지
  final List<Map<String, dynamic>> _fallbackRecommendedStudies = [
    {
      'title': '🚀 Flutter 실전 프로젝트 스터디',
      'category': '개발',
      'members': 6,
      'maxMembers': 8,
      'location': '서울 강남구',
      'schedule': '매주 토요일 14:00-17:00',
      'description': '실제 앱 출시를 목표로 하는 Flutter 개발 스터디입니다. 기획부터 배포까지 전 과정을 함께 경험해보세요.',
      'image': 'https://example.com/flutter.jpg',
    },
    {
      'title': '💬 영어 회화 마스터 클래스',
      'category': '어학',
      'members': 4,
      'maxMembers': 6,
      'location': '서울 홍대',
      'schedule': '매주 화, 목 19:00-20:30',
      'description': '원어민 튜터와 함께하는 실전 영어 회화 스터디. 일상 대화부터 비즈니스 영어까지 체계적으로 학습합니다.',
      'image': 'https://example.com/english.jpg',
    },
    {
      'title': '📊 데이터 분석 with Python',
      'category': '데이터',
      'members': 5,
      'maxMembers': 7,
      'location': '서울 강남구',
      'schedule': '매주 일요일 10:00-13:00',
      'description': 'Python을 활용한 데이터 분석 기법을 배우고 실제 프로젝트에 적용해보는 스터디입니다.',
      'image': 'https://example.com/data.jpg',
    },
    {
      'title': '🎨 UI/UX 디자인 워크샵',
      'category': '디자인',
      'members': 3,
      'maxMembers': 5,
      'location': '서울 서초구',
      'schedule': '매주 수요일 19:00-21:00',
      'description': 'Figma를 활용한 실무 중심의 UI/UX 디자인 스터디. 포트폴리오 제작까지 함께합니다.',
      'image': 'https://example.com/design.jpg',
    },
    {
      'title': '📈 디지털 마케팅 전략 스터디',
      'category': '마케팅',
      'members': 4,
      'maxMembers': 6,
      'location': '서울 마포구',
      'schedule': '매주 금요일 18:00-20:00',
      'description': 'SNS 마케팅부터 퍼포먼스 마케팅까지, 실전 디지털 마케팅 전략을 함께 공부합니다.',
      'image': 'https://example.com/marketing.jpg',
    },
  ];

  final List<Map<String, dynamic>> _fallbackMyStudies = [
    {
      'title': '🔥 코딩테스트 정복하기',
      'category': '개발',
      'members': 5,
      'maxMembers': 6,
      'location': '서울 강남구',
      'schedule': '매주 화, 목 20:00-22:00',
      'description': '백준, 프로그래머스 문제를 체계적으로 풀어보는 알고리즘 스터디입니다.',
      'image': 'https://example.com/algorithm.jpg',
    },
    {
      'title': '📚 TOEIC 900점 달성 스터디',
      'category': '어학',
      'members': 6,
      'maxMembers': 8,
      'location': '서울 서초구',
      'schedule': '매주 월, 수, 금 18:30-20:00',
      'description': '체계적인 학습 계획으로 TOEIC 900점 달성을 목표로 하는 집중 스터디입니다.',
      'image': 'https://example.com/toeic.jpg',
    },
    {
      'title': '💼 취업 준비 스터디',
      'category': '취업',
      'members': 4,
      'maxMembers': 6,
      'location': '서울 종로구',
      'schedule': '매주 토요일 13:00-16:00',
      'description': '자기소개서 첨삭부터 면접 준비까지, 취업 성공을 위한 종합 스터디입니다.',
      'image': 'https://example.com/job.jpg',
    },
  ];

  // 실제 API 데이터를 저장할 변수들
  List<Map<String, dynamic>> _recommendedStudies = [];
  List<Map<String, dynamic>> _myStudies = [];
  bool _isLoading = false;
  bool _hasError = false;

  int _selectedIndex = 0;
  String _currentLocation = '서울특별시';
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadSelectedLocation();
    _loadStudyData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // URL 파라미터에서 refresh 확인
    final uri = GoRouterState.of(context).uri;
    if (uri.queryParameters['refresh'] == 'true') {
      // 새로고침 실행
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshStudyData();
        // URL에서 refresh 파라미터 제거
        if (mounted) {
          context.go('/home');
        }
      });
    }
  }

  // 스터디 데이터 로드
  Future<void> _loadStudyData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // 전체 스터디 목록 조회 (추천 스터디용)
      final allStudiesResponse = await _apiService.getStudies();
      
      // 내 스터디 목록 조회
      final myStudiesResponse = await _apiService.getMyStudies();

      if (allStudiesResponse['success'] == true) {
        final studiesData = allStudiesResponse['data'];
        if (studiesData is Map && studiesData['content'] is List) {
          setState(() {
            _recommendedStudies = (studiesData['content'] as List).map((study) {
              return {
                'id': study['id'],
                'title': study['title'] ?? '제목 없음',
                'category': study['category'] ?? '기타',
                'members': study['currentParticipants'] ?? 0,
                'maxMembers': study['maxParticipants'] ?? 1,
                'location': study['location'] ?? '위치 미정',
                'schedule': _formatSchedule(study['startDate'], study['endDate']),
                'description': study['description'] ?? '설명이 없습니다.',
                'image': 'https://example.com/default.jpg',
              };
            }).toList();
          });
        }
      }

      if (myStudiesResponse['success'] == true) {
        final myStudiesData = myStudiesResponse['data'];
        if (myStudiesData is Map && myStudiesData['content'] is List) {
          setState(() {
            _myStudies = (myStudiesData['content'] as List).map((study) {
              return {
                'id': study['id'],
                'title': study['title'] ?? '제목 없음',
                'category': study['category'] ?? '기타',
                'members': study['currentParticipants'] ?? 0,
                'maxMembers': study['maxParticipants'] ?? 1,
                'location': study['location'] ?? '위치 미정',
                'schedule': _formatSchedule(study['startDate'], study['endDate']),
                'description': study['description'] ?? '설명이 없습니다.',
                'image': 'https://example.com/default.jpg',
              };
            }).toList();
          });
        }
      }

      // API 데이터가 없으면 fallback 데이터 사용
      if (_recommendedStudies.isEmpty) {
        setState(() {
          _recommendedStudies = _fallbackRecommendedStudies;
        });
      }
      if (_myStudies.isEmpty) {
        setState(() {
          _myStudies = _fallbackMyStudies;
        });
      }

    } catch (e) {
      print('스터디 데이터 로드 실패: $e');
      setState(() {
        _hasError = true;
        // 에러 시 fallback 데이터 사용
        _recommendedStudies = _fallbackRecommendedStudies;
        _myStudies = _fallbackMyStudies;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 날짜 형식 변환
  String _formatSchedule(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) {
      return '일정 미정';
    }
    
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      
      return '${start.month}/${start.day} - ${end.month}/${end.day}';
    } catch (e) {
      return '일정 미정';
    }
  }

  // 새로고침 메서드
  Future<void> _refreshStudyData() async {
    await _loadStudyData();
  }

  Future<void> _loadSelectedLocation() async {
    final location = await LocationService.getSelectedLocation();
    setState(() {
      _currentLocation = location;
    });
  }

  List<Widget> get _screens => [
    HomeContent(
      currentLocation: _currentLocation,
      onLocationChanged: _onLocationChanged,
      recommendedStudies: _recommendedStudies,
      myStudies: _myStudies,
      isLoading: _isLoading,
      onRefresh: _refreshStudyData,
    ),
    const StudySearchScreen(),
    const ChatScreen(),
    const NotificationScreen(),
    const ProfileScreen(email: 'user@email.com'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onLocationChanged(String location) async {
    setState(() {
      _currentLocation = location;
    });
    await LocationService.saveSelectedLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '스터디 파트너',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              context.push('/search');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          context.push('/study/create');
        },
        backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class HomeContent extends StatelessWidget {
  final String currentLocation;
  final Function(String) onLocationChanged;
  final List<Map<String, dynamic>> recommendedStudies;
  final List<Map<String, dynamic>> myStudies;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  
  const HomeContent({
    super.key,
    required this.currentLocation,
    required this.onLocationChanged,
    required this.recommendedStudies,
    required this.myStudies,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 지역 선택
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
              child: LocationSelector(
                        currentLocation: currentLocation,
                        onLocationChanged: onLocationChanged,
                      ),
            ),
            
            // 검색바
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: InkWell(
              onTap: () {
                context.push('/search');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Text(
                      '스터디 검색하기',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
            
          // 내 스터디 섹션
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '내 스터디',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/my-studies');
                      },
                      child: Text(
                        '전체보기',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (myStudies.isEmpty)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_add,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '참여 중인 스터디가 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                context.push('/study/create');
                              },
                              child: const Text('새 스터디 만들기'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                        itemCount: myStudies.length,
                    itemBuilder: (context, index) {
                          final study = myStudies[index];
                      return GestureDetector(
                        onTap: () {
                              context.push('/study/detail/${study['id']}');
                        },
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                  // 이미지 영역
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Center(
                                  child: Icon(
                                        _getCategoryIcon(study['category']),
                                    size: 40,
                                        color: Colors.blue[600],
                                  ),
                                ),
                              ),
                                  // 내용 영역
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                            study['title'] ?? '제목 없음',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                        ),
                                            maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                            study['schedule'] ?? '일정 미정',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                              fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[50],
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  study['category'] ?? '기타',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.blue[600],
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${study['members'] ?? 0}/${study['maxMembers'] ?? 1}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
            
          // 추천 스터디 섹션
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '추천 스터디',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/recommended-studies');
                      },
                      child: Text(
                        '전체보기',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                      itemCount: recommendedStudies.length,
                  itemBuilder: (context, index) {
                        final study = recommendedStudies[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                                blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Row(
                                children: [
                                  Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                          study['title'] ?? '제목 없음',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                              child: Text(
                                                study['category'] ?? '기타',
                                                style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                              '${study['members'] ?? 0}/${study['maxMembers'] ?? 1}명',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(study['category']),
                                      color: Colors.blue[600],
                                      size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                    study['location'] ?? '위치 미정',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                    study['schedule'] ?? '일정 미정',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              if (study['description'] != null && study['description'].isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  study['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                      context.push('/study/detail/${study['id']}');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        side: const BorderSide(color: Colors.blue),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('상세보기'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                      context.push('/study/detail/${study['id']}');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('참여하기'),
                                    ),
                                  ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  // 카테고리별 아이콘 반환
  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case '개발':
        return Icons.code;
      case '어학':
        return Icons.language;
      case '데이터':
        return Icons.analytics;
      case '디자인':
        return Icons.design_services;
      case '마케팅':
        return Icons.campaign;
      case '취업':
        return Icons.work;
      default:
        return Icons.book;
    }
  }
} 