import 'package:sasha_botique/features/auth/data/api_services/auth_api_service.dart';
import 'package:sasha_botique/features/auth/data/models/login_model.dart';
import 'package:sasha_botique/features/auth/domain/entities/auth_entity.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../../profile/domain/entities/user.dart';


abstract class AuthRemoteDataSource {
  Future<AuthEntity> login(String email, String password);
  Future<AuthEntity> signup(User user, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> resetPassword(String otp, String newPassword,String email);

}

class AuthRemoteDataSourceIml implements AuthRemoteDataSource {
  final AuthService authService;
  AuthRemoteDataSourceIml(this.authService);
  // Dummy data for demonstration

  final _dummyUsers = <String, User>{};
  @override
  Future<AuthEntity> login(String email, String password) async {
    try{
      final response = await authService.login(email, password);
      LoginModel loginModel = LoginModel.fromJson(response);
      return AuthEntity(token: loginModel.payload ?? "", message: loginModel.message??"Successfully Logged in!", success: true);
    }catch(e){
      return AuthEntity(token: null, message: e is AuthException ? e.message   : "Something went wrong", success: false);
    }
  }

  @override
  Future<AuthEntity> signup(User user, String password) async {
    try{
      final response = await authService.signup(user, password);
      LoginModel loginModel = LoginModel.fromJson(response);
      return AuthEntity(token: loginModel.payload ?? "", message: loginModel.message??"Successfully Logged in!", success: true);
    }catch(e){

      return AuthEntity(token: null, message: e is AuthException ? e.message   : "Something went wrong", success: false);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (!email.contains('@')) {
        throw Exception('Invalid email address');
      }
      await authService.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<void> resetPassword(String otp, String newPassword,String email) async {
    try {
      await authService.resetPassword(otp, newPassword,email);
    } catch (e) {
      rethrow;
    }
  }
}
