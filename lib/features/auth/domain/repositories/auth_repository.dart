import '../entities/user.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> signup(User user, String password);
  Future<bool> isAuthenticated();
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);

}