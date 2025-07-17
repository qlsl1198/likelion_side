/// 스터디 상세 화면
/// 
/// 스터디의 상세 정보를 표시하고 참여 요청을 할 수 있는 화면입니다.
/// 스터디 정보, 멤버 목록, 일정 등을 확인할 수 있습니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../models/study.dart';
import 'package:dio/dio.dart';

class StudyDetailScreen extends StatefulWidget {
  final int studyId;

  const StudyDetailScreen({
    super.key,
    required this.studyId,
  });

  @override
  State<StudyDetailScreen> createState() => _StudyDetailScreenState();
}

class _StudyDetailScreenState extends State<StudyDetailScreen> {
  Study? _study;
  bool _isLoading = true;
  bool _isJoining = false;
  bool _isLeaving = false;
  bool _isJoined = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadStudyDetail();
  }

  Future<void> _loadStudyDetail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _apiService.getStudyDetail(widget.studyId);
      
      if (response['success'] == true && response['data'] != null) {
        setState(() {
          _study = Study.fromJson(response['data']);
        });
        
        // 참여 상태 확인
        await _checkJoinStatus();
        
        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception(response['message'] ?? '스터디 정보를 불러올 수 없습니다.');
      }
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      String errorMessage;
      if (e.response?.statusCode == 400) {
        errorMessage = '잘못된 요청입니다. 스터디 정보를 확인해 주세요.';
      } else if (e.response?.statusCode == 401) {
        errorMessage = '로그인이 필요합니다. 다시 로그인해 주세요.';
      } else if (e.response?.statusCode == 404) {
        errorMessage = '스터디를 찾을 수 없습니다.';
        // 404 에러 시 홈으로 리디렉션
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: '홈으로',
                textColor: Colors.white,
                onPressed: () => context.go('/home'),
              ),
            ),
          );
          // 3초 후 자동으로 홈으로 이동
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              context.go('/home');
            }
          });
        }
        return;
      } else if (e.response?.statusCode == 500) {
        errorMessage = '서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';
      } else {
        errorMessage = '네트워크 오류가 발생했습니다. 연결을 확인하고 다시 시도해 주세요.';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '재시도',
              textColor: Colors.white,
              onPressed: () => _loadStudyDetail(),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        String errorMessage;
        if (e is DioException) {
          if (e.response?.statusCode == 400) {
            final responseData = e.response?.data;
            if (responseData != null && responseData['message'] != null) {
              errorMessage = responseData['message'];
            } else {
              errorMessage = '이미 참여 중인 스터디이거나 참여할 수 없는 상태입니다.';
            }
          } else if (e.response?.statusCode == 401) {
            errorMessage = '로그인이 필요합니다. 다시 로그인해 주세요.';
          } else if (e.response?.statusCode == 404) {
            errorMessage = '스터디를 찾을 수 없습니다.';
          } else {
            errorMessage = '네트워크 오류가 발생했습니다. 다시 시도해 주세요.';
          }
        } else {
          errorMessage = '스터디 참여 중 오류가 발생했습니다: $e';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isJoining = false;
      });
    }
  }

  Future<void> _checkJoinStatus() async {
    try {
      final response = await _apiService.checkJoinStatus(widget.studyId);
      
      if (response['success'] == true) {
        setState(() {
          _isJoined = response['data'] ?? false;
        });
      }
    } catch (e) {
      // 참여 상태 확인 실패 시 기본값 false 유지
      setState(() {
        _isJoined = false;
      });
    }
  }

  Future<void> _joinStudy() async {
    if (_study == null) return;

    setState(() {
      _isJoining = true;
    });

    try {
      final response = await _apiService.joinStudy(widget.studyId);
      
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('스터디에 성공적으로 참여했습니다.'),
              backgroundColor: Colors.green,
            ),
          );
          
          // 참여 상태 업데이트
          setState(() {
            _isJoined = true;
          });
          
          // 홈 화면으로 이동하면서 새로고침 신호 전송
          context.go('/home?refresh=true');
        }
      } else {
        throw Exception(response['message'] ?? '스터디 참여에 실패했습니다.');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage;
        if (e is DioException) {
          if (e.response?.statusCode == 400) {
            final responseData = e.response?.data;
            if (responseData != null && responseData['message'] != null) {
              errorMessage = responseData['message'];
            } else {
              errorMessage = '이미 참여 중인 스터디이거나 참여할 수 없는 상태입니다.';
            }
          } else if (e.response?.statusCode == 401) {
            errorMessage = '로그인이 필요합니다. 다시 로그인해 주세요.';
          } else if (e.response?.statusCode == 404) {
            errorMessage = '스터디를 찾을 수 없습니다.';
          } else {
            errorMessage = '네트워크 오류가 발생했습니다. 다시 시도해 주세요.';
          }
        } else {
          errorMessage = '스터디 참여 중 오류가 발생했습니다: $e';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isJoining = false;
      });
    }
  }

  Future<void> _leaveStudy() async {
    if (_study == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('스터디 탈퇴'),
        content: const Text('정말로 이 스터디에서 탈퇴하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLeaving = true;
    });

    try {
      final response = await _apiService.leaveStudy(widget.studyId);
      
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('스터디에서 탈퇴했습니다.'),
              backgroundColor: Colors.orange,
            ),
          );
          
          // 참여 상태 업데이트
          setState(() {
            _isJoined = false;
          });
          
          // 홈 화면으로 이동하면서 새로고침 신호 전송
          context.go('/home?refresh=true');
        }
      } else {
        throw Exception(response['message'] ?? '스터디 탈퇴에 실패했습니다.');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage;
        if (e is DioException) {
          if (e.response?.statusCode == 400) {
            final responseData = e.response?.data;
            if (responseData != null && responseData['message'] != null) {
              errorMessage = responseData['message'];
            } else {
              errorMessage = '탈퇴할 수 없는 상태입니다.';
            }
          } else if (e.response?.statusCode == 401) {
            errorMessage = '로그인이 필요합니다. 다시 로그인해 주세요.';
          } else if (e.response?.statusCode == 404) {
            errorMessage = '스터디를 찾을 수 없습니다.';
          } else {
            errorMessage = '네트워크 오류가 발생했습니다. 다시 시도해 주세요.';
          }
        } else {
          errorMessage = '스터디 탈퇴 중 오류가 발생했습니다: $e';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLeaving = false;
      });
    }
  }

  Future<void> _deleteStudy() async {
    if (_study == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('스터디 삭제'),
        content: const Text('정말로 이 스터디를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await _apiService.deleteStudy(widget.studyId);
      
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('스터디가 삭제되었습니다.')),
          );
          context.pop();
        }
      } else {
        throw Exception(response['message'] ?? '스터디 삭제에 실패했습니다.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_study?.title ?? '스터디 상세'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_study?.isLeader == true)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // TODO: 스터디 수정 화면으로 이동
                    break;
                  case 'delete':
                    _deleteStudy();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('수정'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('삭제'),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _study == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '스터디를 찾을 수 없습니다.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _loadStudyDetail(),
                            child: const Text('새로고침'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => context.pop(),
                            child: const Text('돌아가기'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadStudyDetail,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStudyHeader(),
                        _buildStudyInfo(),
                        _buildMemberList(),
                        _buildSchedule(),
                        _buildDescription(),
                        const SizedBox(height: 100), // 하단 버튼 공간
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildStudyHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _study!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _study!.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _study!.status == 'recruiting' ? '모집중' : 
                  _study!.status == 'in_progress' ? '진행중' : 
                  _study!.status == 'completed' ? '완료' : '취소',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.people, '참가자', '${_study!.currentParticipants}/${_study!.maxParticipants}명'),
          const Divider(),
          _buildInfoRow(Icons.location_on, '위치', _study!.location),
          const Divider(),
          _buildInfoRow(Icons.computer, '타입', 
            _study!.studyType == 'online' ? '온라인' : 
            _study!.studyType == 'offline' ? '오프라인' : '하이브리드'),
          if (_study!.meetingLink != null) ...[
            const Divider(),
            _buildInfoRow(Icons.link, '미팅 링크', _study!.meetingLink!),
          ],
          if (_study!.contactInfo != null) ...[
            const Divider(),
            _buildInfoRow(Icons.contact_phone, '연락처', _study!.contactInfo!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberList() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '멤버',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_study!.members.length}명',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _study!.members.length,
            itemBuilder: (context, index) {
              final member = _study!.members[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    member.user.name[0],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                title: Text(member.user.name),
                subtitle: Text(member.role == 'leader' ? '스터디장' : '멤버'),
                trailing: member.role == 'leader' 
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '스터디장',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSchedule() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '일정',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '시작일: ${_study!.startDate.year}-${_study!.startDate.month.toString().padLeft(2, '0')}-${_study!.startDate.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '종료일: ${_study!.endDate.year}-${_study!.endDate.month.toString().padLeft(2, '0')}-${_study!.endDate.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '스터디 소개',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _study!.description.isNotEmpty ? _study!.description : '스터디 설명이 없습니다.',
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_study == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_study!.isLeader) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _isLeaving ? null : _leaveStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLeaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('스터디 삭제'),
              ),
            ),
          ] else if (_isJoined) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _isLeaving ? null : _leaveStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLeaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('참여 취소'),
              ),
            ),
          ] else if (_study!.status == 'active' && !_study!.isFull()) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _isJoining ? null : _joinStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isJoining
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('스터디 참여'),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(_study!.isFull() ? '모집 완료' : '참여 불가'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StudyRoomScreen extends StatelessWidget {
  const StudyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스터디방'),
      ),
      body: const Center(
        child: Text('스터디방 화면'),
      ),
    );
  }
} 