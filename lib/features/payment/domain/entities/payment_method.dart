// lib/features/payment/domain/entities/payment_method.dart
class PaymentMethod {
  final String id;
  final String type;
  final String last4Digits;
  final String cardHolderName;
  final String expiryDate;
  final String country;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4Digits,
    required this.cardHolderName,
    required this.expiryDate,
    required this.country,
    required this.isDefault,
  });
}