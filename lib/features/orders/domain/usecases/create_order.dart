import '../entities/create_order_params.dart';
import '../entities/create_order_response.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<CreateOrderModel> call(CreateOrderParams params) {
    return repository.createOrder(
     params: params,
    );
  }
}