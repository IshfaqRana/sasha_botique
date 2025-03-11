import '../../../features/cart/domain/entity/cart_item.dart';
import '../../../features/cart/presentation/bloc/cart_bloc.dart';

abstract class ICartCommunicationService {
  void addToCart(String productId, int quantity, String name, String imageURL, double price, String collection, String size);
  void removeFromCart(String productId);
}

class CartCommunicationService implements ICartCommunicationService {
  final CartBloc _cartBloc;

  CartCommunicationService(this._cartBloc);

  @override
  void addToCart(String productId, int quantity, String name, String imageURL, double price, String collection,String size) {
    _cartBloc.add(AddCartItem(CartItem(
      id: DateTime.now().toString(),
      productId: productId,
      quantity: quantity,
      name: name,
      collection: collection,
      price: price,
      imageUrl: imageURL,
      size: size
    )));
  }

  @override
  void removeFromCart(String productId) {
    _cartBloc.add(RemoveCartItem(productId));
  }
}
