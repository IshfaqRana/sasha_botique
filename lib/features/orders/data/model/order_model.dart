import '../../../payment/data/data_model/payment_method_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../profile/data/models/user_address_reponse_model.dart';
import '../../domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required String id,
    required List<ProductModel> items,
    required double totalAmount,
    required PaymentMethodModel paymentMethod,
    required UserAddressModel deliveryAddress,
    required String promoCode,
    required double discountAmount,
    required String currency,
    required String email,
    required String phone,
    required String name,
    required String status,
    required String revolutOrderId,
    required String paymentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    String paymentUrl = '',
  }) : super(
    id: id,
    items: items,
    totalAmount: totalAmount,
    paymentMethod: paymentMethod,
    deliveryAddress: deliveryAddress,
    promoCode: promoCode,
    discountAmount: discountAmount,
    currency: currency,
    email: email,
    phone: phone,
    name: name,
    status: status,
    revolutOrderId: revolutOrderId,
    paymentStatus: paymentStatus,
    createdAt: createdAt,
    updatedAt: updatedAt,
    paymentUrl: paymentUrl,
  );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      items: (json['items'] as List?)?.map((item) => ProductModel.fromJson(item)).toList() ?? [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: PaymentMethodModel.fromJson(json['paymentMethod'] ?? {}),
      deliveryAddress: UserAddressModel.fromJson(json['deliveryAddress'] ?? {}),
      promoCode: json['promoCode'] ?? '',
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      email: json['email'] ?? '',
      name: "",
      phone:  "",
      status: json['status'] ?? '',
      revolutOrderId: json['revolutOrderId'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => {'_id': item.id, 'price': item.price}).toList(),
      'totalAmount': totalAmount,
      'currency': currency,
      'paymentMethod': {
        'type': paymentMethod.type,
        'last4_digits': paymentMethod.last4Digits,
        'card_holder_name': paymentMethod.cardHolderName,
        'expiry_date': paymentMethod.expiryDate,
        'country': paymentMethod.country,
        'is_default': paymentMethod.isDefault,
      },
      'deliveryAddress': {
        'full_name': name,
        'address_line_1': deliveryAddress.street,
        'city': deliveryAddress.city,
        'postal_code': deliveryAddress.postalCode,
        'country': deliveryAddress.country,
        'phone_number': phone,
        'is_default': deliveryAddress.isDefault,
      },
      'promoCode': promoCode,
      'email': email,
    };
  }
}