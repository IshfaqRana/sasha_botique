import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<User> call() async {
    return await repository.getUserProfile();
  }
}