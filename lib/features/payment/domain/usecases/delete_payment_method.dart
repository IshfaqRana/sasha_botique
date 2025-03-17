import '../repositories/payment_repository.dart';

class DeletePaymentMethod {
  final PaymentRepository repository;

  DeletePaymentMethod(this.repository);

  Future<void> call(String id) async {
    await repository.deletePaymentMethod(id);
  }
}