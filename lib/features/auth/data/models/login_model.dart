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

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    String? token;

    if (json["payload"] != null) {
      if (json["payload"] is String) {
        // Direct string token
        token = json["payload"];
      } else if (json["payload"] is Map) {
        // Check if it's a nested structure {"jwt": {"jwt": "token"}}
        final payloadMap = json["payload"] as Map<String, dynamic>;
        if (payloadMap["jwt"] != null) {
          if (payloadMap["jwt"] is String) {
            // {"jwt": "token"}
            token = payloadMap["jwt"];
          } else if (payloadMap["jwt"] is Map) {
            // {"jwt": {"jwt": "token"}}
            final jwtMap = payloadMap["jwt"] as Map<String, dynamic>;
            token = jwtMap["jwt"];
          }
        }
      }
    }

    return LoginModel(
      status: json["status"],
      statusCode: json["statusCode"],
      message: json["message"],
      payload: token,
    );
  }

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
