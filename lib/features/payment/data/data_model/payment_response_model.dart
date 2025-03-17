// To parse this JSON data, do
//
//     final paymentResponseModel = paymentResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:sasha_botique/features/payment/data/data_model/payment_method_model.dart';

PaymentResponseModel paymentResponseModelFromJson(String str) => PaymentResponseModel.fromJson(json.decode(str));

String paymentResponseModelToJson(PaymentResponseModel data) => json.encode(data.toJson());

class PaymentResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  List<PaymentMethodModel>? payload;

  PaymentResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) => PaymentResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? [] : List<PaymentMethodModel>.from(json["payload"]!.map((x) => PaymentMethodModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload == null ? [] : List<dynamic>.from(payload!.map((x) => x.toJson())),
  };
}


UpdatePaymentResponseModel updatePaymentResponseModelFromJson(String str) => UpdatePaymentResponseModel.fromJson(json.decode(str));

String updatePaymentResponseModelToJson(UpdatePaymentResponseModel data) => json.encode(data.toJson());

class UpdatePaymentResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  PaymentMethodModel? payload;

  UpdatePaymentResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory UpdatePaymentResponseModel.fromJson(Map<String, dynamic> json) => UpdatePaymentResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : PaymentMethodModel.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}
