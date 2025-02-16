import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/cart/domain/usecases/add_to_cart.dart';
import 'package:sasha_botique/features/cart/domain/usecases/clear_cart_item.dart';
import 'package:sasha_botique/features/cart/domain/usecases/remove_from_cart.dart';

import '../../domain/entity/cart_item.dart';
import '../../domain/repository/cart_repository.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';

part 'cart_events.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUsecase getCartItemsUsecase;
  final AddToCartItemUseCase addToCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;


  CartBloc({required this.getCartItemsUsecase, required this.clearCartUseCase,required this.removeFromCartUseCase, required this.addToCartItemUseCase}) : super(CartInitial()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<AddCartItem>(_onAddCartItem);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCartItems(LoadCartItems event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await getCartItemsUsecase();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Failed to load cart items'));
    }
  }

  Future<void> _onAddCartItem(AddCartItem event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());
      try {
        await addToCartItemUseCase(event.item);
        final items = await getCartItemsUsecase();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError('Failed to add item to cart'));
      }
    }
  }

  Future<void> _onRemoveCartItem(RemoveCartItem event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());
      try {
        await removeFromCartUseCase(event.cartItemId);
        final items = await getCartItemsUsecase();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError('Failed to remove item from cart'));
      }
    }
  }

  Future<void> _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());
      try {
        // await repository.updateQuantity(event.cartItemId, event.quantity);
        final items = await getCartItemsUsecase();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError('Failed to update quantity'));
      }
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await clearCartUseCase();
      emit(CartLoaded([]));
    } catch (e) {
      emit(CartError('Failed to clear cart'));
    }
  }
}