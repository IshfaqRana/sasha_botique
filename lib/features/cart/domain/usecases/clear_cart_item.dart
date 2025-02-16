import 'package:sasha_botique/features/cart/domain/repository/cart_repository.dart';

class ClearCartUseCase{
  final CartRepository cartRepository;
  ClearCartUseCase(this.cartRepository);
  Future<void> call(){
    return cartRepository.clearCart();
  }
}