class PromoCode {
  final String id;
  final String code;
  final double discount;
  final DateTime expiresAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromoCode({
    required this.id,
    required this.code,
    required this.discount,
    required this.expiresAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}