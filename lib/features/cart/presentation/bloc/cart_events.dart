part of 'cart_bloc.dart';

abstract class CartEvent {}

class LoadCartItems extends CartEvent {}

class AddCartItem extends CartEvent {
  final CartItem item;
  AddCartItem(this.item);
}

class RemoveCartItem extends CartEvent {
  final String cartItemId;
  RemoveCartItem(this.cartItemId);
}
class AddProductToCart extends CartEvent {
  final Product product;
  final int quantity;
  final String size;

  AddProductToCart({
    required this.product,
    required this.quantity,
    required this.size,
  });

  @override
  List<Object> get props => [product, quantity, size];
}


class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int quantity;

  UpdateCartItemQuantity({
    required this.cartItemId,
    required this.quantity,
  });

  List<Object> get props => [cartItemId, quantity];
}


class ClearCart extends CartEvent {}