import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetAllOrdersUseCase {
  final OrderRepository repository;

  GetAllOrdersUseCase(this.repository);

  Future<List<Order>> call() {
    return repository.getAllOrders();
  }
}