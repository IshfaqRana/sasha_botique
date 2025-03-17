import '../../domain/entities/promo_code_entity.dart';

class PromoCodeModel extends PromoCode {
  PromoCodeModel({
    required String id,
    required String code,
    required double discount,
    required DateTime expiresAt,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    code: code,
    discount: discount,
    expiresAt: expiresAt,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['_id'],
      code: json['code'],
      discount: (json['discount'] as num).toDouble(),
      expiresAt: DateTime.parse(json['expiresAt']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'discount': discount,
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}