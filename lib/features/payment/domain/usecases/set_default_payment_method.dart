import '../entities/payment_method.dart';
import '../repositories/payment_repository.dart';

class SetDefaultPaymentMethod {
  final PaymentRepository repository;

  SetDefaultPaymentMethod(this.repository);

  Future<void> call(PaymentMethod paymentMethod,PaymentMethod paymentMethod2,bool defaultValue) async {
    await repository.setDefaultPaymentMethod(paymentMethod,paymentMethod2,defaultValue);
  }
}