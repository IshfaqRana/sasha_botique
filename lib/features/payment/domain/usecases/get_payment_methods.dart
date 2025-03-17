import '../entities/payment_method.dart';
import '../repositories/payment_repository.dart';

class GetPaymentMethods {
  final PaymentRepository repository;

  GetPaymentMethods(this.repository);

  Future<List<PaymentMethod>> call() async {
    return await repository.getPaymentMethods();
  }
}