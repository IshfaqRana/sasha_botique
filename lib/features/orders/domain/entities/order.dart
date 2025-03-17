import '../../../payment/data/data_model/payment_method_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../profile/data/models/user_address_reponse_model.dart';

class Order {
  final String id;
  final List<ProductModel> items;
  final double totalAmount;
  final PaymentMethodModel paymentMethod;
  final UserAddressModel deliveryAddress;
  final String promoCode;
  final double discountAmount;
  final String currency;
  final String email;
  final String name;
  final String phone;
  final String status;
  final String revolutOrderId;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String paymentUrl; // Store payment URL for pending payments

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.promoCode,
    required this.discountAmount,
    required this.currency,
    required this.email,
    required this.name,
    required this.phone,
    required this.status,
    required this.revolutOrderId,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.paymentUrl = '',
  });

  bool get isPending => paymentStatus == 'pending';
  bool get isCompleted => paymentStatus == 'completed';
  bool get isDelivered => status == 'delivered';
}