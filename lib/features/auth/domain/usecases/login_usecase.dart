import 'package:sasha_botique/features/auth/domain/entities/auth_entity.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthEntity> call(String email, String password) async {
    return repository.login(email, password);
  }
}