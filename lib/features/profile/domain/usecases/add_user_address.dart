import 'package:dartz/dartz.dart';

import '../entities/user_address.dart';
import '../repositories/profile_repository.dart';

class AddUserAddress {
  final ProfileRepository repository;

  AddUserAddress(this.repository);

  Future<List<UserAddress>> call(UserAddress address) {
    return repository.addAddress(address);
  }
}