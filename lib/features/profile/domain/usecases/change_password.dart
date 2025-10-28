import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class ChangePassword {
  final ProfileRepository repository;

  ChangePassword(this.repository);

  Future<User> call(String currentPassword, String newPassword) async {
    return await repository.changePassword(currentPassword, newPassword);
  }
}