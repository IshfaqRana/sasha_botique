
import 'package:sasha_botique/features/orders/domain/repositories/order_repository.dart';

import '../entities/promo_code_entity.dart';

class GetPromoCodesUseCase {
  final OrderRepository repository;

  GetPromoCodesUseCase(this.repository);

  @override
  Future<List<PromoCode>> call() async {
    return await repository.getPromoCodes();
  }
}