// To parse this JSON data, do
//
//     final createOrderResponseModel = createOrderResponseModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/create_order_response.dart';

CreateOrderResponseModel createOrderResponseModelFromJson(String str) => CreateOrderResponseModel.fromJson(json.decode(str));

String createOrderResponseModelToJson(CreateOrderResponseModel data) => json.encode(data.toJson());

class CreateOrderResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  CreateOrderResponseItem? payload;

  CreateOrderResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) => CreateOrderResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : CreateOrderResponseItem.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class CreateOrderResponseItem extends CreateOrderModel {

  CreateOrderResponseItem({
  required bool success,
  required String orderId,
  required String paymentUrl,
  }) : super(
    success: success,
    orderId: orderId,
    paymentUrl: paymentUrl,
  );

  factory CreateOrderResponseItem.fromJson(Map<String, dynamic> json) => CreateOrderResponseItem(
    success: json["success"],
    orderId: json["orderId"],
    paymentUrl: json["paymentUrl"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "orderId": orderId,
    "paymentUrl": paymentUrl,
  };
}
