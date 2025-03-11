import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.title,
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.mobileNo,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      title: json['title'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'mobile_no': mobileNo,
    };
  }
}