import 'package:dartz/dartz.dart';

import '../entities/user_address.dart';
import '../repositories/profile_repository.dart';

class UpdateUserAddress {
  final ProfileRepository repository;

  UpdateUserAddress(this.repository);

  Future<List<UserAddress>> call(String id,UserAddress address) {
    return repository.updateUserAddress(id,address);
  }
}