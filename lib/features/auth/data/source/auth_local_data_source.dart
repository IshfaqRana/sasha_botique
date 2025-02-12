import '../../../../core/helper/shared_preferences_service.dart';

class AuthLocalDataSource {
  final SharedPreferencesService preferencesService;
  AuthLocalDataSource(this.preferencesService);

  Future<void> saveToken(String token) async {
    await preferencesService.setUserToken(token);
  }

  Future<String?> getToken() async {
    return preferencesService.getUserToken();
  }
  Future<void> deleteUserInfo() async {
     preferencesService.clearUserData();
  }

}