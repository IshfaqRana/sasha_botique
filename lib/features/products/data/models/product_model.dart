import '../../domain/entities/products.dart';

// To parse this JSON data, do
//
//     final productModelResponse = productModelResponseFromJson(jsonString);

import 'dart:convert';

ProductModelResponse productModelResponseFromJson(String str) => ProductModelResponse.fromJson(json.decode(str));

String productModelResponseToJson(ProductModelResponse data) => json.encode(data.toJson());

class ProductModelResponse {
  bool? status;
  int? statusCode;
  String? message;
  List<ProductModel>? products;

  ProductModelResponse({
    this.status,
    this.statusCode,
    this.message,
    this.products,
  });

  factory ProductModelResponse.fromJson(Map<String, dynamic> json) => ProductModelResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        products: json["payload"] == null ? [] : List<ProductModel>.from(json["payload"]!.map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "payload": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

SingleProductModelResponse singleProductModelResponseFromJson(String str) => SingleProductModelResponse.fromJson(json.decode(str));

String singleProductModelResponseToJson(SingleProductModelResponse data) => json.encode(data.toJson());

class SingleProductModelResponse {
  bool? status;
  int? statusCode;
  String? message;
  ProductModel? product;

  SingleProductModelResponse({
    this.status,
    this.statusCode,
    this.message,
    this.product,
  });

  factory SingleProductModelResponse.fromJson(Map<String, dynamic> json) => SingleProductModelResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        product:  ProductModel.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "payload": product?.toJson()
      };
}

class ProductModel extends Product {
  ProductModel({
    required bool isBasics,
    required String id,
    required String name,
    required double price,
    List<String>? imageUrl,
    required String category,
    String? gender,
    bool? isPopular,
    bool? isOnSale,
    List<String>? colors,
    List<String>? sizes,
    String? productType,
    String? season,
    String? fitType,
    String? brandName,
    String? collection,
    bool? isDeleted,
    dynamic deletedAt,
    bool? isUpdated,
    String? updatedAt,
    String? createdAt,
    int? v,
    String? description,
  }) : super(
          isBasics: isBasics,
          id: id,
          name: name,
          price: price,
          imageUrl: imageUrl ?? [],
          category: category,
          gender: gender ?? "women",
          isPopular: isPopular ?? false,
          isOnSale: isOnSale ?? false,
          colors: colors ?? [],
          sizes: sizes ?? [],
          productType: productType ?? "",
          season: season ?? "",
          fitType: fitType ?? "",
          brandName: brandName ?? "",
          collection: collection ?? "",
          createdAt: createdAt ?? "",
          description: description ?? "",
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        isBasics: json["is_basics"] ?? false,
        id: json["_id"],
        name: json["name"],
        price: (json["price"] as int).toDouble(),
        imageUrl: json["imageUrl"] == null ? [] : List<String>.from(json["imageUrl"]!.map((x) => x)),
        category: json["category"],
        gender: json["gender"] ?? "women",
        isPopular: json["is_popular"] ?? false,
        isOnSale: json["is_on_sale"] ?? false,
        colors: json["colors"] == null ? [] : List<String>.from(json["colors"]!.map((x) => x)),
        sizes: json["sizes"] == null ? [] : List<String>.from(json["sizes"]!.map((x) => x)),
        productType: json["product_type"],
        season: json["season"],
        fitType: json["fit_type"],
        brandName: json["brand_name"],
        collection: json["collection"],
        isDeleted: json["isDeleted"],
        deletedAt: json["deletedAt"],
        isUpdated: json["isUpdated"],
        updatedAt: json["updatedAt"],
        createdAt: json["createdAt"],
        v: json["__v"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "is_basics": isBasics,
        "_id": id,
        "name": name,
        "price": price,
        "imageUrl": imageUrl == null ? [] : List<dynamic>.from(imageUrl.map((x) => x)),
        "category": category,
        "gender": gender,
        "is_popular": isPopular,
        "is_on_sale": isOnSale,
        "colors": colors == null ? [] : List<dynamic>.from(colors.map((x) => x)),
        "sizes": sizes == null ? [] : List<dynamic>.from(sizes.map((x) => x)),
        "product_type": productType,
        "season": season,
        "fit_type": fitType,
        "brand_name": brandName,
        "collection": collection,
        // "isDeleted": isDeleted,
        // "deletedAt": deletedAt,
        // "isUpdated": isUpdated,
        // "updatedAt": updatedAt,
        "createdAt": createdAt,
        // "__v": v,
        "description": description,
      };
}
//
// class ProductModel extends Product {
//   ProductModel({
//     required String id,
//     required String name,
//     required double price,
//     required String imageUrl,
//     required String category,
//     bool isWishlisted = false,
//     bool isPopular = false,
//     bool isOnSale = false,
//     double? salePrice,
//     required DateTime createdAt,
//     required String gender,
//     required List<String> colors,
//     required List<String> sizes,
//     required String productType,
//     required String season,
//     required String fitType,
//     required String brand,
//   }) : super(
//           id: id,
//           name: name,
//           price: price,
//           imageUrl: imageUrl,
//           category: category,
//           isWishlisted: isWishlisted,
//           isPopular: isPopular,
//           isOnSale: isOnSale,
//           salePrice: salePrice,
//           createdAt: createdAt,
//           gender: gender,
//           colors: colors,
//           sizes: sizes,
//           productType: productType,
//           season: season,
//           fitType: fitType,
//           brand: brand,
//         );
//
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'],
//       name: json['name'],
//       price: json['price'].toDouble(),
//       imageUrl: json['imageUrl'],
//       category: json['category'],
//       isWishlisted: json['isWishlisted'] ?? false,
//       isPopular: json['isPopular'] ?? false,
//       isOnSale: json['isOnSale'] ?? false,
//       salePrice: json['salePrice']?.toDouble(),
//       createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//       gender: json['gender'] ?? 'unisex',
//       colors: List<String>.from(json['colors'] ?? []),
//       sizes: List<String>.from(json['sizes'] ?? []),
//       productType: json['productType'] ?? '',
//       season: json['season'] ?? '',
//       fitType: json['fitType'] ?? '',
//       brand: json['brand'] ?? '',
//     );
//   }
// }
