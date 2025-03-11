import 'dart:convert';

import 'package:sasha_botique/features/profile/data/models/user_model.dart';

UserResponseModel userResponseModelFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) => json.encode(data.toJson());

class UserResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  UserModel? userModel;

  UserResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.userModel,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    userModel: json["payload"] == null ? null : UserModel.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": userModel?.toJson(),
  };
}