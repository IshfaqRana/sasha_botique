part of 'cart_bloc.dart';


abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;

  CartLoaded(this.items) : total = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
