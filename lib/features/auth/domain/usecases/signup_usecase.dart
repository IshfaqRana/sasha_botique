import 'package:sasha_botique/features/auth/domain/entities/auth_entity.dart';

import '../../../profile/domain/entities/user.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<AuthEntity> call(User user, String password) async {
    return repository.signup(user, password);
  }
}