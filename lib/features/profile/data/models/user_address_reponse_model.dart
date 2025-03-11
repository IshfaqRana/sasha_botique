// To parse this JSON data, do
//
//     final userAddressResponseModel = userAddressResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:sasha_botique/features/profile/domain/entities/user_address.dart';

UserAddressResponseModel userAddressResponseModelFromJson(String str) => UserAddressResponseModel.fromJson(json.decode(str));

String userAddressResponseModelToJson(UserAddressResponseModel data) => json.encode(data.toJson());

class UserAddressResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  UserAddressModel? payload;

  UserAddressResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory UserAddressResponseModel.fromJson(Map<String, dynamic> json) => UserAddressResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : UserAddressModel.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class UserAddressModel extends UserAddress {

  UserAddressModel({
    required super.street,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    required super.isDefault,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) => UserAddressModel(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    postalCode: json["postal_code"],
    country: json["country"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "country": country,
    "is_default": isDefault,
  };
}
