import 'package:flutter/foundation.dart';
import '../di/injections.dart';
import '../helper/shared_preferences_service.dart';

class DebugHelper {
  static void logAuthStatus() {
    if (kDebugMode) {
      final prefsService = getIt<SharedPreferencesService>();
      final token = prefsService.getUserToken();

      print('🔐 DEBUG: Token Status');
      print('Token exists: ${token != null}');
      if (token != null) {
        print('Token length: ${token.length}');
        print('Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
      }
      print('🔐 DEBUG: End Token Status');
    }
  }

  static void logApiRequest(String endpoint, Map<String, dynamic>? headers) {
    if (kDebugMode) {
      print('📡 DEBUG: API Request');
      print('Endpoint: $endpoint');
      print('Has Auth Header: ${headers?.containsKey('Authorization') ?? false}');
      if (headers?.containsKey('Authorization') == true) {
        final auth = headers!['Authorization'] as String;
        print('Auth Header: ${auth.substring(0, auth.length > 30 ? 30 : auth.length)}...');
      }
      print('📡 DEBUG: End API Request');
    }
  }
}