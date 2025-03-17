// To parse this JSON data, do
//
//     final getItemsResponseModel = getItemsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:sasha_botique/features/products/data/models/product_model.dart';

GetItemsResponseModel getItemsResponseModelFromJson(String str) => GetItemsResponseModel.fromJson(json.decode(str));

String getItemsResponseModelToJson(GetItemsResponseModel data) => json.encode(data.toJson());

class GetItemsResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Payload? payload;

  GetItemsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory GetItemsResponseModel.fromJson(Map<String, dynamic> json) => GetItemsResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class Payload {
  int? totalItems;
  String? currentPage;
  int? totalPages;
  List<ProductModel>? products;

  Payload({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.products,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    totalItems: json["totalItems"],
    currentPage: json["currentPage"].toString(),
    totalPages: json["totalPages"],
    products: json["items"] == null ? [] : List<ProductModel>.from(json["items"]!.map((x) => ProductModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "items": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}


