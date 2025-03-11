import 'package:sasha_botique/features/profile/domain/entities/user_address.dart';

import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User> getUserProfile();
  Future<User> updateUserProfile(User user);
  Future<User> updateProfilePicture(String filePath);
  Future<User> changePassword(String newPassword);
  Future<List<UserAddress>> getUserAddress();
  Future<List<UserAddress>> updateUserAddress(String id,UserAddress userAddress);
  Future<List<UserAddress>> addAddress(UserAddress address);
  Future<List<UserAddress>> setDefaultAddress(String id,UserAddress address);
  Future<List<UserAddress>> deleteAddress(String id);
}