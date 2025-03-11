import '../entities/user_address.dart';
import 'package:dartz/dartz.dart';

import '../repositories/profile_repository.dart';

class DeleteUserAddress {
  final ProfileRepository repository;

  DeleteUserAddress(this.repository);

  Future<List<UserAddress>> call(String id) {
    return repository.deleteAddress(id);
  }
}