import '../entities/user_address.dart';
import '../repositories/profile_repository.dart';

class SetDefaultAddress {
  final ProfileRepository repository;

  SetDefaultAddress(this.repository);

  Future<List<UserAddress>> call(String id,UserAddress address) {
    return repository.setDefaultAddress(id,address);
  }
}