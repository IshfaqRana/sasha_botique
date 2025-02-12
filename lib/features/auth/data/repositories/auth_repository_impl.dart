import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import '../source/auth_local_data_source.dart';
import '../source/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<String> login(String email, String password) async {
    final token = await remoteDataSource.login(email, password);
    await localDataSource.saveToken(token);
    return token;
  }

  @override
  Future<void> signup(User user, String password) async {
    await remoteDataSource.signup(user, password);
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

