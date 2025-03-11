import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<User> call(User user) async {
    return await repository.updateUserProfile(user);
  }
}