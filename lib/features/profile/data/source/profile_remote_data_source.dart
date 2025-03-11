// lib/features/profile/data/datasources/profile_remote_data_source.dart
import 'package:sasha_botique/features/profile/data/models/user_response_model.dart';

import '../api_services/profile_api_service.dart';
import '../models/update_user_address_response_model.dart';
import '../models/user_address_reponse_model.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(UserModel userModel);
  Future<UserModel> updateProfilePicture(String filePath);
  Future<UserModel> changePassword(String newPassword);
  Future<List<UserAddressModel>> getUserAddress();
  Future<List<UserAddressModel>> updateUserAddress(String id,UserAddressModel userAddress);
  Future<List<UserAddressModel>> addUserAddress(UserAddressModel userAddress);
  Future<List<UserAddressModel>> deleteUserAddress(String id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<UserModel> getUserProfile() async {
    final Map<String, dynamic> response = await apiService.getUserProfile();
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> updateUserProfile(UserModel userModel) async {
    try {
      final response = await apiService.updateUserProfile(userModel.toJson());
      UserResponseModel userResponseModel = UserResponseModel.fromJson(response);
      return userResponseModel.userModel ?? UserModel(title: "Mr", firstName: "", lastName: "", username: "", email: "", mobileNo: "");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfilePicture(String filePath) async {
    try {
      final response = await apiService.updateProfilePicture(filePath);
      UserResponseModel userResponseModel = UserResponseModel.fromJson(response);
      return userResponseModel.userModel ?? UserModel(title: "Mr", firstName: "", lastName: "", username: "", email: "", mobileNo: "");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> changePassword(String newPassword) async {
    try {
      final response = await apiService.changePassword(newPassword);
      UserResponseModel userResponseModel = UserResponseModel.fromJson(response);
      return userResponseModel.userModel ?? UserModel(title: "Mr", firstName: "", lastName: "", username: "", email: "", mobileNo: "");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserAddressModel>> getUserAddress() async {
    try {
      final response = await apiService.getUserAddress();
      UpdateUserAddressResponseModel userResponseModel = UpdateUserAddressResponseModel.fromJson(response);
      return userResponseModel.payload ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserAddressModel>> updateUserAddress(String id, UserAddressModel userAddress, ) async {
    try {
      final response = await apiService.updateUserAddress(id,userAddress.toJson());
      UserAddressResponseModel updateUserAddressResponseModel = UserAddressResponseModel.fromJson(response);
      return [updateUserAddressResponseModel.payload ?? UserAddressModel(street: '', city: '', state: '', postalCode: '', country: '', isDefault: false)] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserAddressModel>> addUserAddress(UserAddressModel userAddress) async {
    try {
      final response = await apiService.addUserAddress(userAddress.toJson());
      UpdateUserAddressResponseModel updateUserAddressResponseModel = UpdateUserAddressResponseModel.fromJson(response);
      return updateUserAddressResponseModel.payload ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserAddressModel>> deleteUserAddress(String id) async {
    try {
      final response = await apiService.deleteUserAddress(id);
      UpdateUserAddressResponseModel updateUserAddressResponseModel = UpdateUserAddressResponseModel.fromJson(response);
      return updateUserAddressResponseModel.payload ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
