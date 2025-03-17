import '../repositories/payment_repository.dart';

class SetDefaultPaymentMethod {
  final PaymentRepository repository;

  SetDefaultPaymentMethod(this.repository);

  Future<void> call(String id) async {
    await repository.setDefaultPaymentMethod(id);
  }
}