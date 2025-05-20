import '../../../payment/data/data_model/payment_method_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../profile/data/models/user_address_reponse_model.dart';
import '../entities/create_order_params.dart';
import '../entities/create_order_response.dart';
import '../entities/order.dart';
import '../entities/promo_code_entity.dart';

abstract class OrderRepository {
  Future<CreateOrderModel> createOrder({
    required CreateOrderParams params,
  });
  Future<CreateOrderModel> updatePaymentURL(
    String params,
  );

  Future<Order> getOrderById(String orderId);
  Future<List<Order>> getAllOrders();
  Future< List<PromoCode>> getPromoCodes();

}