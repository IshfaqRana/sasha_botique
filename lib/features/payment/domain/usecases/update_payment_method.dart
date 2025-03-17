import '../entities/payment_method.dart';
import '../repositories/payment_repository.dart';

class UpdatePaymentMethod {
  final PaymentRepository repository;

  UpdatePaymentMethod(this.repository);

  Future<void> call(PaymentMethod paymentMethod) async {
    await repository.updatePaymentMethod(paymentMethod);
  }
}