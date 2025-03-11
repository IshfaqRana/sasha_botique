import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfilePicture {
  final ProfileRepository repository;

  UpdateProfilePicture(this.repository);

  Future<User> call(String filePath) async {
    return await repository.updateProfilePicture(filePath);
  }
}