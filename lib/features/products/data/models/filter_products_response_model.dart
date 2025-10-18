import 'dart:convert';
import 'package:sasha_botique/features/products/data/models/product_model.dart';

FilterProductsResponseModel filterProductsResponseModelFromJson(String str) =>
    FilterProductsResponseModel.fromJson(json.decode(str));

String filterProductsResponseModelToJson(FilterProductsResponseModel data) =>
    json.encode(data.toJson());

class FilterProductsResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  FilterPayload? payload;

  FilterProductsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory FilterProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      FilterProductsResponseModel(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        payload: json["payload"] == null
            ? null
            : FilterPayload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "payload": payload?.toJson(),
      };
}

class FilterPayload {
  int? totalItems;
  int? currentPage;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPrevPage;
  List<ProductModel>? items;
  List<String>? appliedFilters;
  String? sortBy;
  String? sortOrder;

  FilterPayload({
    this.totalItems,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.items,
    this.appliedFilters,
    this.sortBy,
    this.sortOrder,
  });

  factory FilterPayload.fromJson(Map<String, dynamic> json) => FilterPayload(
        totalItems: json["totalItems"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        hasNextPage: json["hasNextPage"],
        hasPrevPage: json["hasPrevPage"],
        items: json["items"] == null
            ? []
            : List<ProductModel>.from(
                json["items"]!.map((x) => ProductModel.fromJson(x))),
        appliedFilters: json["appliedFilters"] == null
            ? []
            : List<String>.from(json["appliedFilters"]!.map((x) => x)),
        sortBy: json["sortBy"],
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "hasNextPage": hasNextPage,
        "hasPrevPage": hasPrevPage,
        "items":
            items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "appliedFilters": appliedFilters == null
            ? []
            : List<dynamic>.from(appliedFilters!.map((x) => x)),
        "sortBy": sortBy,
        "sortOrder": sortOrder,
      };
}
