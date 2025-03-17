// lib/features/payment/domain/repositories/payment_repository.dart
import '../entities/payment_method.dart';

abstract class PaymentRepository {
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethod paymentMethod);
  Future<void> updatePaymentMethod(PaymentMethod paymentMethod);
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(String id);
}