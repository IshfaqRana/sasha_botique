import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/cart/domain/usecases/add_to_cart.dart';
import 'package:sasha_botique/features/cart/domain/usecases/clear_cart_item.dart';
import 'package:sasha_botique/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:uuid/uuid.dart';

import '../../../products/domain/entities/products.dart';
import '../../domain/entity/cart_item.dart';
import '../../domain/repository/cart_repository.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/update_cart_item_quantity_usecase.dart';

part 'cart_events.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUsecase getCartItemsUsecase;
  final AddToCartItemUseCase addToCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase; // Added this



  CartBloc({required this.getCartItemsUsecase, required this.clearCartUseCase,required this.removeFromCartUseCase, required this.addToCartItemUseCase,    required this.updateCartItemQuantityUseCase, // Added this
  }) : super(CartInitial()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<AddCartItem>(_onAddCartItem);
    on<AddProductToCart>(_onAddProductToCart); // New handler
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

  // New method to handle product-to-cart conversion
  Future<void> _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      // Check if item with same product ID and size already exists
      final currentItems = await getCartItemsUsecase();
      final existingItemIndex = currentItems.indexWhere(
              (item) => item.productId == event.product.id && item.size == event.size
      );

      if (existingItemIndex >= 0) {
        // If item exists, update quantity
        final existingItem = currentItems[existingItemIndex];
        final updatedItem = existingItem.copyWith(
            quantity: existingItem.quantity + event.quantity
        );

        await updateCartItemQuantityUseCase(updatedItem.id,updatedItem.quantity);
      } else {
        // If item doesn't exist, create a new one
        final newItem = CartItem.fromProduct(
          id: const Uuid().v4(),
          productId: event.product.id,
          name: event.product.name,
          imageUrl: event.product.imageUrl.isNotEmpty ? event.product.imageUrl[0] : '',
          price: event.product.salePrice ?? event.product.price,
          collection: event.product.collection,
          size: event.size,
          quantity: event.quantity,
        );

        await addToCartItemUseCase(newItem);
      }

      final updatedItems = await getCartItemsUsecase();
      emit(CartLoaded(updatedItems));
    } catch (e) {
      emit(CartError('Failed to add product to cart: ${e.toString()}'));
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
      // emit(CartLoading());
      try {
        // Find the item to update
        final items = await getCartItemsUsecase();
        final itemIndex = items.indexWhere((item) => item.id == event.cartItemId);

        if (itemIndex >= 0) {
          final item = items[itemIndex];
          final updatedItem = item.copyWith(quantity: event.quantity);

          await updateCartItemQuantityUseCase(updatedItem.id,updatedItem.quantity);

          final updatedItems = await getCartItemsUsecase();
          emit(CartLoaded(updatedItems));
        } else {
          emit(CartError('Item not found'));
        }
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