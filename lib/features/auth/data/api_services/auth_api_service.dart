import '../../../../core/helper/shared_preferences_service.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/utils/ip_detector.dart';
import '../../../profile/domain/entities/user.dart';

class AuthService {
  final NetworkManager networkManager;
  final SharedPreferencesService preferencesService;
  final String _baseEndpoint = '/account';

  AuthService({
    required this.networkManager,
    required this.preferencesService,
  });

  Future<void> refreshToken() async {
    try {
      final refreshToken = preferencesService.getRefreshToken();
      if (refreshToken == null) {
        throw UnauthorizedException('No refresh token available');
      }

      final response = await networkManager.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      await preferencesService.setUserToken(newAccessToken);
      await preferencesService.setRefreshToken(newRefreshToken);
    } catch (e) {
      await preferencesService.clearUserData();
      throw UnauthorizedException('Session expired. Please log in again.');
    }
  }
  Future<dynamic> login(String email, String password) async {
    try {
      // Get client IP address quickly
      final clientIp = await IPDetector.getQuickIP();
      print('🌐 Auth Debug: Client IP detected: $clientIp');

      final response = await networkManager.post(
        '$_baseEndpoint/login',
        data: {
          'email': email,
          'password': password,
        },
        headers: {
          'clientIp': clientIp,
        },
      );

      return response.data;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<dynamic> signup(User user, String password) async {
    try {
      final userData = {};
      userData['password'] = password;
      userData['title'] = "Mr.";
      userData['email'] = user.email;
      userData['first_name'] = user.firstName;
      userData['last_name'] = user.lastName;
      userData['username'] = user.username;
      userData['mobile_no'] = user.mobileNo;

      final response = await networkManager.post(
        _baseEndpoint,
        data: userData,
      );
      return response.data;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<dynamic> sendPasswordResetEmail(String email) async {
    try {
      final response =await networkManager.post(
        '/account/forget-password',
        data: {'email': email},
      );
      return response.data;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  Future<dynamic> resetPassword(String otp, String newPassword,String email) async {
    try {
      final response = await networkManager.post(
        '$_baseEndpoint/update-password',
        data: {
          'otp': otp,
          'new_password': newPassword,
          'email': email
        },
      );
      return response.data;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  Exception _handleAuthError(dynamic error) {
    if (error is NetworkException) {
      return AuthException(error.message);
    } else if (error is UnauthorizedException) {
      return AuthException('Invalid credentials');
    } else if (error is ServerException) {
      return AuthException('Authentication service unavailable');
    }
    return AuthException('Authentication failed');
  }
}

// auth_exception.dart
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}