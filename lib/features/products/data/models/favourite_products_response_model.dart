import 'dart:convert';

import 'package:sasha_botique/features/products/data/models/product_model.dart';

FavouriteProductsResponseModel favouriteProductsResponseModelFromJson(String str) => FavouriteProductsResponseModel.fromJson(json.decode(str));

String favouriteProductsResponseModelToJson(FavouriteProductsResponseModel data) => json.encode(data.toJson());

class FavouriteProductsResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Payload? payload;

  FavouriteProductsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory FavouriteProductsResponseModel.fromJson(Map<String, dynamic> json) => FavouriteProductsResponseModel(
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
  String? id;
  String? user;
  int? v;
  DateTime? createdAt;
  List<ProductModel>? products;
  DateTime? updatedAt;

  Payload({
    this.id,
    this.user,
    this.v,
    this.createdAt,
    this.products,
    this.updatedAt,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    id: json["_id"],
    user: json["user"],
    v: json["__v"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    products: json["items"] == null ? [] : List<ProductModel>.from(json["items"]!.map((x) => ProductModel.fromJson(x))),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "__v": v,
    "createdAt": createdAt?.toIso8601String(),
    "items": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}