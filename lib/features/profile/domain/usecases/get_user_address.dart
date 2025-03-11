import '../entities/user_address.dart';
import '../repositories/profile_repository.dart';

class GetUserAddress {
  final ProfileRepository repository;

  GetUserAddress(this.repository);

  Future<List<UserAddress>> call() async {
    return await repository.getUserAddress();
  }
}