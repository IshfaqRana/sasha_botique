import '../entity/cart_item.dart';
import '../repository/cart_repository.dart';

class GetCartItemsUsecase {
  final CartRepository repository;

  GetCartItemsUsecase(this.repository);

  Future<List<CartItem>> call() {
    return repository.getCartItems();
  }
}