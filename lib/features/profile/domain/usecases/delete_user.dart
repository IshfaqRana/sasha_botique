import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class DeleteUser {
  final ProfileRepository repository;

  DeleteUser(this.repository);

  Future<void> call() async {
    return await repository.deleteUser();
  }
}