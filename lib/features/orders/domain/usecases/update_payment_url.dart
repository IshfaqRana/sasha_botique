import '../entities/create_order_response.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class UpdatePaymentUrlUseCase {
  final OrderRepository repository;

  UpdatePaymentUrlUseCase(this.repository);

  Future<CreateOrderModel> call(String orderId) {
    return repository.updatePaymentURL(orderId);
  }
}