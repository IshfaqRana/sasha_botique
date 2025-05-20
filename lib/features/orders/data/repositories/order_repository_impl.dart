import 'package:sasha_botique/features/orders/domain/entities/create_order_response.dart';
import 'package:sasha_botique/features/orders/domain/entities/promo_code_entity.dart';

import '../../../payment/data/data_model/payment_method_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../profile/data/models/user_address_reponse_model.dart';
import '../../domain/entities/create_order_params.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../model/create_order_response_model.dart';
import '../model/order_model.dart';
import '../source/order_remote_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<CreateOrderModel> createOrder({
    required CreateOrderParams params,
  }) async {

      try {
        final orderModel = OrderModel(
          id: '',
          items: params.items,
          totalAmount: params.totalAmount,
          currency: params.currency,
          paymentMethod: params.paymentMethod,
          deliveryAddress: params.deliveryAddress,
          promoCode: params.promoCode,
          email: params.email,
          status: '',
          revolutOrderId: '',
          paymentStatus: '',
          discountAmount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(), phone: params.phone, name: params.name,
        );

        final result = await remoteDataSource.createOrder(orderModel);
        return result;
      } catch (e) {
        rethrow;
      }

  }

  @override
  Future<Order> getOrderById(String orderId) async {

      try {
        final result = await remoteDataSource.getOrderById(orderId);
        return result;
      } catch (e) {
        rethrow;
      }

  }

  @override
  Future<List<Order>> getAllOrders() async {

      try {
        final result = await remoteDataSource.getAllOrders();
        return result;
      } catch (e) {
        rethrow;
      }

  }

  @override
  Future<List<PromoCode>> getPromoCodes() async {
    try {
      final result = await remoteDataSource.getAllPromoCodes();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreateOrderModel> updatePaymentURL(String orderID) async {
   try{
     final result = await remoteDataSource.updatePaymentUrl(orderID);
     return result;
   } catch (e) {
     rethrow;
   }
  }
}