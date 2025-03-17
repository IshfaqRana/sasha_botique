// lib/features/payment/data/models/payment_method_hive_model.dart
import 'package:hive/hive.dart';

part 'payment_method_hive_model.g.dart';

@HiveType(typeId: 2) // Assuming 2 is not used yet in your project
class PaymentMethodHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String last4Digits;

  @HiveField(3)
  String cardHolderName;

  @HiveField(4)
  String expiryDate;

  @HiveField(5)
  String country;

  @HiveField(6)
  bool isDefault;

  PaymentMethodHiveModel({
    required this.id,
    required this.type,
    required this.last4Digits,
    required this.cardHolderName,
    required this.expiryDate,
    required this.country,
    required this.isDefault,
  });
}