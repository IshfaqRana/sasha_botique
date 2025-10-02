import 'package:sasha_botique/features/auth/domain/entities/auth_entity.dart';


import '../../../../core/network/network_exceptions.dart';
import '../../../profile/domain/entities/user.dart';
import '../source/auth_local_data_source.dart';
import '../source/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<AuthEntity> login(String email, String password) async {
    final authEntity = await remoteDataSource.login(email, password);
    if(authEntity.success) {
      final token = authEntity.token ?? "";
      await localDataSource.saveToken(token);
      print('🔐 Auth Debug: Token saved after login - ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
    } else {
      print('🔐 Auth Debug: Login failed, no token to save');
    }
    return authEntity;
  }

  @override
  Future<AuthEntity> signup(User user, String password) async {
    final authEntity =  await remoteDataSource.signup(user, password);
    if(authEntity.success) {
      await localDataSource.saveToken(authEntity.token ?? "");
    }
    return authEntity;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    final isAuth = token != null && token.isNotEmpty;
    print('🔍 Auth Check Debug: Token exists: $isAuth, Token length: ${token?.length ?? 0}');
    return isAuth;
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteUserInfo();
  }
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> resetPassword({
    required String otp,
    required String newPassword,
    required String email
  }) async {
      try {
        await remoteDataSource.resetPassword(otp, newPassword, email);
      } catch(e) {
        rethrow;
      }
  }
}

