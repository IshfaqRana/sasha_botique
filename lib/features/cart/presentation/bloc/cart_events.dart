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

class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int quantity;
  UpdateCartItemQuantity(this.cartItemId, this.quantity);
}

class ClearCart extends CartEvent {}