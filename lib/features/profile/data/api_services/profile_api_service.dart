// lib/features/profile/data/datasources/profile_api_service.dart
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper/shared_preferences_service.dart';
import '../../../../core/network/network_manager.dart';

class ProfileApiService {
  final NetworkManager networkManager;
  final SharedPreferencesService preferencesService;


  ProfileApiService(this.networkManager,this.preferencesService);

  Future<Map<String, dynamic>> getUserProfile() async {
    // final response = await networkManager.get('/user/profile');
    final token = preferencesService.getUserToken();

    final jwt = JWT.decode(token ?? "");

    // print(jwt.payload);


    return jwt.payload;
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
    final response = await networkManager.post(
      '/account/updateSingleAccount',
      data: userData,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfilePicture(String filePath) async {
    final File file = File(filePath);

    // Create form data for image upload
    final formData = FormData.fromMap({
      'profile_image': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await networkManager.post(
      '/account/updateSingleAccount',
      data: formData,
    );

    return response.data;
  }

  Future<Map<String, dynamic>> changePassword(String newPassword) async {
    final response = await networkManager.post(
      '/account/updateSingleAccount',
      data: {
        'password': newPassword,
      },
    );

    return response.data;
  }
  Future<Map<String, dynamic>> updateUserAddress(String id,Map<String, dynamic> userData,) async {
    try {
    final response = await networkManager.patch(
      '/account/delivery-address/$id',
      data: userData,
    );

    return response.data;
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> addUserAddress(Map<String, dynamic> userData) async {
    try {
    final response = await networkManager.post(
      '/account/delivery-address',
      data: userData,
    );

    return response.data;
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getUserAddress() async {
    try {
      final response = await networkManager.get(
        "/account/delivery-address",
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteUserAddress(String id) async {
    try {
      final response = await networkManager.delete(
        "/account/delivery-address/$id",
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> deleteUser() async {
    try {
      final response = await networkManager.delete(
        "/account/remove-user",
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}