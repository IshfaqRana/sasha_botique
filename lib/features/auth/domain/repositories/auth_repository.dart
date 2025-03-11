import 'package:sasha_botique/features/auth/domain/entities/auth_entity.dart';

import '../../../profile/domain/entities/user.dart';


abstract class AuthRepository {
  Future<AuthEntity> login(String email, String password);
  Future<AuthEntity> signup(User user, String password);
  Future<bool> isAuthenticated();
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);
}