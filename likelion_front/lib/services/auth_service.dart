import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  final ApiService _apiService = ApiService();
  
  // 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }
  
  // 로그인
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      if (response['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['data']['token']);
        await prefs.setString('user_email', response['data']['user']['email']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  // 회원가입
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.register(userData);
      
      if (response['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['data']['token']);
        await prefs.setString('user_email', response['data']['user']['email']);
        return true;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
  
  // 로그아웃
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_email');
  }
  
  // 토큰 가져오기
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  // 사용자 이메일 가져오기
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
  
  // 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final response = await _apiService.getUserInfo();
      if (response['success'] == true) {
        return response['data'];
      }
      return null;
    } catch (e) {
      print('Get user info error: $e');
      return null;
    }
  }
  
  // OAuth 로그인
  Future<bool> oauthLogin(String provider) async {
    try {
      final response = await _apiService.oauthLogin(provider);
      
      if (response['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['data']['token']);
        await prefs.setString('user_email', response['data']['user']['email']);
        return true;
      }
      return false;
    } catch (e) {
      print('OAuth login error: $e');
      return false;
    }
  }
  
  // 가상 OAuth 로그인
  Future<bool> virtualOAuthLogin(String provider, String email, String name) async {
    try {
      final response = await _apiService.virtualOAuthLogin(provider, email, name);
      
      if (response['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['data']['token']);
        await prefs.setString('user_email', response['data']['user']['email']);
        return true;
      }
      return false;
    } catch (e) {
      print('Virtual OAuth login error: $e');
      return false;
    }
  }
} 