// To parse this JSON data, do
//
//     final userAddressResponseModel = userAddressResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:sasha_botique/features/profile/data/models/user_address_reponse_model.dart';

UpdateUserAddressResponseModel userAddressResponseModelFromJson(String str) => UpdateUserAddressResponseModel.fromJson(json.decode(str));

String userAddressResponseModelToJson(UpdateUserAddressResponseModel data) => json.encode(data.toJson());

class UpdateUserAddressResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  List<UserAddressModel>? payload;

  UpdateUserAddressResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory UpdateUserAddressResponseModel.fromJson(Map<String, dynamic> json) => UpdateUserAddressResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? [] : List<UserAddressModel>.from(json["payload"]!.map((x) => UserAddressModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload == null ? [] : List<dynamic>.from(payload!.map((x) => x.toJson())),
  };
}
