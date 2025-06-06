import '../../../payment/data/data_model/payment_method_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../profile/data/models/user_address_reponse_model.dart';

class CreateOrderParams {
  final List<ProductModel> items;
  final double totalAmount;
  final String currency;
  final PaymentMethodModel paymentMethod;
  final UserAddressModel deliveryAddress;
  final String promoCode;
  final String email;
  final String name;
  final String phone;

  CreateOrderParams({
    required this.items,
    required this.totalAmount,
    required this.currency,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.promoCode,
    required this.email,
    required this.name,
    required this.phone,
  });
}