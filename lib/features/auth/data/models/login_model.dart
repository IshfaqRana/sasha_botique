// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? status;
  int? statusCode;
  String? message;
  String? payload;

  LoginModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : (json["payload"].runtimeType ==  String ? json["payload"] : Payload.fromJson(json["payload"]).jwt),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload,
  };
}

class Payload {
  String? jwt;

  Payload({
    this.jwt,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    jwt: json["jwt"],
  );

  Map<String, dynamic> toJson() => {
    "jwt": jwt,
  };
}
