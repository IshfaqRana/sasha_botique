import '../entities/payment_method.dart';
import '../repositories/payment_repository.dart';

class AddPaymentMethod {
  final PaymentRepository repository;

  AddPaymentMethod(this.repository);

  Future<void> call(PaymentMethod paymentMethod) async {
    await repository.addPaymentMethod(paymentMethod);
  }
}