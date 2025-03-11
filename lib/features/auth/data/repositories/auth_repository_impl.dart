import 'package:sasha_botique/features/auth/domain/entities/auth_entity.dart';


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
      await localDataSource.saveToken(authEntity.token ?? "");
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
    return token != null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteUserInfo();
  }
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await remoteDataSource.sendPasswordResetEmail(email);
  }
}

