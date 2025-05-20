import 'package:sasha_botique/features/profile/domain/entities/user_address.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_address_reponse_model.dart';
import '../models/user_model.dart';
import '../source/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUserProfile() async {
    final userModel = await remoteDataSource.getUserProfile();
    return userModel;
  }

  @override
  Future<User> updateUserProfile(User user) async {
    final userModel = UserModel(
      title: user.title,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      mobileNo: user.mobileNo,
      profileImageUrl: user.profileImageUrl,
    );

    return await remoteDataSource.updateUserProfile(userModel);
  }

  @override
  Future<User> updateProfilePicture(String filePath) async {
    return await remoteDataSource.updateProfilePicture(filePath);
  }

  @override
  Future<User> changePassword(String newPassword) async {
    return await remoteDataSource.changePassword(newPassword);
  }

  @override
  Future<List<UserAddress>> getUserAddress() async {
    return await remoteDataSource.getUserAddress();
  }

  @override
  Future<List<UserAddress>> updateUserAddress(String id,UserAddress userAddress) async {
    UserAddressModel userAddressModel = UserAddressModel(
      street: userAddress.street,
      name: userAddress.name,
      instruction: userAddress.instruction,
      phone: userAddress.phone,
      city: userAddress.city,
      state: userAddress.state,
      postalCode: userAddress.postalCode,
      country: userAddress.country,
      isDefault: userAddress.isDefault,
    );
    return await remoteDataSource.updateUserAddress(id,userAddressModel);
  }

  @override
  Future<List<UserAddress>> addAddress(UserAddress userAddress) async {
    UserAddressModel userAddressModel = UserAddressModel(
      street: userAddress.street,
      name: userAddress.name,
      instruction: userAddress.instruction,
      phone: userAddress.phone,
      city: userAddress.city,
      state: userAddress.state,
      postalCode: userAddress.postalCode,
      country: userAddress.country,
      isDefault: userAddress.isDefault,
    );
    return await remoteDataSource.addUserAddress(userAddressModel);
  }

  @override
  Future<List<UserAddress>> deleteAddress(String id) async {

    return await remoteDataSource.deleteUserAddress(id);
  }

  @override
  Future<List<UserAddress>> setDefaultAddress(String id,UserAddress userAddress) async {
    UserAddressModel userAddressModel = UserAddressModel(
      street: userAddress.street,
      name: userAddress.name,
      instruction: userAddress.instruction,
      phone: userAddress.phone,
      city: userAddress.city,
      state: userAddress.state,
      postalCode: userAddress.postalCode,
      country: userAddress.country,
      isDefault: userAddress.isDefault,
    );
    return await remoteDataSource.updateUserAddress(id,userAddressModel);
  }

  @override
  Future<void> deleteUser() async {

    await remoteDataSource.deleteUser();
  }
}
