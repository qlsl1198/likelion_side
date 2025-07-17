import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../models/study.dart';

class StudyCreateScreen extends StatefulWidget {
  const StudyCreateScreen({super.key});

  @override
  State<StudyCreateScreen> createState() => _StudyCreateScreenState();
}

class _StudyCreateScreenState extends State<StudyCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _contactInfoController = TextEditingController();
  
  String _selectedCategory = '개발';
  String _selectedStudyType = 'online';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final List<String> _categories = [
    '개발', '어학', '데이터', '디자인', '마케팅', '기타'
  ];

  final List<String> _studyTypes = [
    'online', 'offline', 'hybrid'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxParticipantsController.dispose();
    _meetingLinkController.dispose();
    _contactInfoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _createStudy() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시작일과 종료일을 선택해주세요.')),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('종료일은 시작일 이후여야 합니다.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final studyData = StudyCreateRequest(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        location: _locationController.text,
        maxParticipants: int.parse(_maxParticipantsController.text),
        startDate: _startDate!,
        endDate: _endDate!,
        studyType: _selectedStudyType,
        meetingLink: _meetingLinkController.text.isNotEmpty ? _meetingLinkController.text : null,
        contactInfo: _contactInfoController.text.isNotEmpty ? _contactInfoController.text : null,
      );

      final apiService = ApiService();
      final response = await apiService.createStudy(studyData.toJson());

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('스터디가 성공적으로 생성되었습니다.')),
          );
          
          // 홈 화면으로 이동하면서 새로고침 신호 전송
          context.go('/home?refresh=true');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? '스터디 생성에 실패했습니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 스터디 만들기'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: '스터디 제목 *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '제목을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 설명
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: '스터디 설명',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // 카테고리
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: '카테고리 *',
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // 위치
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: '위치 *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '위치를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 최대 참가자 수
                    TextFormField(
                      controller: _maxParticipantsController,
                      decoration: const InputDecoration(
                        labelText: '최대 참가자 수 *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '최대 참가자 수를 입력해주세요.';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number < 1) {
                          return '1 이상의 숫자를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 스터디 타입
                    DropdownButtonFormField<String>(
                      value: _selectedStudyType,
                      decoration: const InputDecoration(
                        labelText: '스터디 타입 *',
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: _studyTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type == 'online' ? '온라인' : 
                            type == 'offline' ? '오프라인' : '하이브리드',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStudyType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // 시작일
                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '시작일 *',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _startDate != null
                              ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                              : '날짜를 선택하세요',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 종료일
                    InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '종료일 *',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _endDate != null
                              ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                              : '날짜를 선택하세요',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 미팅 링크 (온라인/하이브리드인 경우)
                    if (_selectedStudyType != 'offline') ...[
                      TextFormField(
                        controller: _meetingLinkController,
                        decoration: const InputDecoration(
                          labelText: '미팅 링크',
                          border: OutlineInputBorder(),
                          hintText: 'Zoom, Google Meet 링크 등',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 연락처
                    TextFormField(
                      controller: _contactInfoController,
                      decoration: const InputDecoration(
                        labelText: '연락처',
                        border: OutlineInputBorder(),
                        hintText: '카카오톡 ID, 전화번호 등',
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 생성 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _createStudy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '스터디 생성',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 