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
    required super.name,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    required super.isDefault,
    required super.phone,
    required super.instruction,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) => UserAddressModel(
    street: json["address_line_1"],
    city: json["city"],
    state: json["state"],
    postalCode: json["postal_code"],
    country: json["country"],
    isDefault: json["is_default"],
    name: json["full_name"],
    phone: json["phone_number"],
    instruction: json["delivery_instructions"],
  );

  Map<String, dynamic> toJson() => {
    "address_line_1": street,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "country": country,
    "is_default": isDefault,
    "full_name":name,
    "phone_number":phone,
    "delivery_instructions":instruction,
  };
}
