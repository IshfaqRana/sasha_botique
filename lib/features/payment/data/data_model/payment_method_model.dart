import '../../domain/entities/payment_method.dart';
import 'payment_method_hive_model.dart';

class PaymentMethodModel extends PaymentMethod {
  PaymentMethodModel({
    required String id,
    required String type,
    required String last4Digits,
    required String cardHolderName,
    required String expiryDate,
    required String country,
    required bool isDefault,
  }) : super(
    id: id,
    type: type,
    last4Digits: last4Digits,
    cardHolderName: cardHolderName,
    expiryDate: expiryDate,
    country: country,
    isDefault: isDefault,
  );

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      last4Digits: json['last4_digits'] ?? '',
      cardHolderName: json['card_holder_name'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'last4_digits': last4Digits,
      'card_holder_name': cardHolderName,
      'expiry_date': expiryDate,
      'country': country,
      'is_default': isDefault,
    };
  }

  factory PaymentMethodModel.fromHiveModel(PaymentMethodHiveModel hiveModel) {
    return PaymentMethodModel(
      id: hiveModel.id,
      type: hiveModel.type,
      last4Digits: hiveModel.last4Digits,
      cardHolderName: hiveModel.cardHolderName,
      expiryDate: hiveModel.expiryDate,
      country: hiveModel.country,
      isDefault: hiveModel.isDefault,
    );
  }

  PaymentMethodHiveModel toHiveModel() {
    return PaymentMethodHiveModel(
      id: id,
      type: type,
      last4Digits: last4Digits,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      country: country,
      isDefault: isDefault,
    );
  }
}