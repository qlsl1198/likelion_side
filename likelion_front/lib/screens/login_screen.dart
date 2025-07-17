import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // 앱 로고 및 타이틀
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 48,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '스터디 파트너',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '함께 성장하는 학습 파트너를 찾아보세요',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // OAuth 로그인 안내 메시지
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 24,
                  ),
                        const SizedBox(height: 8),
                        Text(
                          'OAuth 계정으로 로그인해주세요',
                            style: TextStyle(
                              fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '개인 이메일 회원가입은 지원하지 않습니다',
                      style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[600],
                      ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 소셜 로그인
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '소셜 계정으로 로그인',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 소셜 로그인 버튼들
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: Icons.g_mobiledata,
                        color: Colors.red,
                        onPressed: () {
                          if (!_isLoading) _handleOAuthLogin('google');
                        },
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (!_isLoading) _handleOAuthLogin('kakao');
                          },
                          icon: Image.asset(
                            'assets/icons/kakao.png',
                            width: 32,
                            height: 32,
                          ),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        icon: Icons.apple,
                        color: Colors.black,
                        onPressed: () {
                          if (!_isLoading) _handleOAuthLogin('apple');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 32),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _handleOAuthLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 가상 OAuth 로그인 - 테스트용 이메일과 이름 사용
      String email;
      String name;
      
      switch (provider) {
        case 'google':
          email = 'test.google@gmail.com';
          name = '구글 테스트 사용자';
          break;
        case 'kakao':
          email = 'test.kakao@kakao.com';
          name = '카카오 테스트 사용자';
          break;
        case 'apple':
          email = 'test.apple@icloud.com';
          name = '애플 테스트 사용자';
          break;
        default:
          email = 'test.user@example.com';
          name = '테스트 사용자';
      }
      
      final success = await _authService.virtualOAuthLogin(provider, email, name);
      
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$provider 가상 로그인 성공!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$provider 가상 로그인에 실패했습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$provider 가상 로그인 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 