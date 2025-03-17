import 'package:sasha_botique/core/network/network_manager.dart';
import 'package:sasha_botique/features/orders/data/model/promo_code_model.dart';
import 'package:sasha_botique/features/orders/domain/entities/create_order_params.dart';

import '../model/create_order_response_model.dart';
import '../model/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<CreateOrderResponseItem> createOrder(OrderModel order);
  Future<OrderModel> getOrderById(String orderId);
  Future<List<OrderModel>> getAllOrders();
  Future<List<PromoCodeModel>> getAllPromoCodes();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final NetworkManager networkManager;

  OrderRemoteDataSourceImpl({required this.networkManager});

  @override
  // Future<CreateOrderResponseItem> createOrder(OrderModel order) async {
  Future<CreateOrderResponseItem> createOrder(OrderModel order) async {
    try {
      final response = await networkManager.post(
        '/order/create-order',
        data: order.toJson(),
      );

      final responseData = response.data['payload'];
      var res = CreateOrderResponseModel.fromJson(responseData);
      return res.payload ?? CreateOrderResponseItem(success: false, orderId: "", paymentUrl: "");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await networkManager.get('/order/$orderId');
      return OrderModel.fromJson(response.data['payload']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await networkManager.get('/order/all-orders');
      final ordersList = response.data['payload'] as List;
      return ordersList.map((order) => OrderModel.fromJson(order)).toList();
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<PromoCodeModel>> getAllPromoCodes() async {
    try {
      final response = await networkManager.get('/promocode');
      final promoCodes = response.data['payload'] as List;
      return promoCodes.map((code) => PromoCodeModel.fromJson(code)).toList();
    } catch (e) {
      rethrow;
    }
  }
}