import 'package:sasha_botique/features/auth/data/api_services/auth_api_service.dart';

import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<String> signup(User user, String password);
  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceIml implements AuthRemoteDataSource {
  final AuthService authService;
  AuthRemoteDataSourceIml(this.authService);
  // Dummy data for demonstration

  final _dummyUsers = <String, User>{};
  @override
  Future<String> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // await authService.login(email, password);

    // Dummy validation
    if (email == "test@test.com" && password == "password123") {
      return "dummy_token_${DateTime.now().millisecondsSinceEpoch}";
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<String> signup(User user, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _dummyUsers[user.email] = user;
    // await authService.signup(user, password);
    return "";
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // await authService.sendPasswordResetEmail(email);

    // In a real implementation, this would send an actual email
    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }
  }
}
