// lib/features/payment/data/datasources/payment_local_data_source.dart
import '../data_model/payment_method_model.dart';
import '../../../../core/services/hive_service.dart';

abstract class PaymentLocalDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethodModel paymentMethod);
  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod);
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(PaymentMethodModel paymentMethod);
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  final HiveService hiveService;

  PaymentLocalDataSourceImpl(this.hiveService);

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final paymentMethodsHive = hiveService.getAllPaymentMethods();
    return paymentMethodsHive
        .map((hiveModel) => PaymentMethodModel.fromHiveModel(hiveModel))
        .toList();
  }

  @override
  Future<void> addPaymentMethod(PaymentMethodModel paymentMethod) async {
    // If this is set as default, unset all others
    if (paymentMethod.isDefault) {
      await _unsetAllDefaultPaymentMethods();
    }

    await hiveService.addPaymentMethod(paymentMethod.toHiveModel());
  }

  @override
  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod) async {
    // If this is set as default, unset all others
    if (paymentMethod.isDefault) {
      await _unsetAllDefaultPaymentMethods();
    }

    await hiveService.addPaymentMethod(paymentMethod.toHiveModel());
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    await hiveService.removePaymentMethod(id);
  }

  @override
  Future<void> setDefaultPaymentMethod(PaymentMethodModel paymentMethods) async {
    await _unsetAllDefaultPaymentMethods();

    final paymentMethod = hiveService.getPaymentMethod(paymentMethods.id);
    if (paymentMethod != null) {
      paymentMethod.isDefault = true;
      await hiveService.addPaymentMethod(paymentMethod);
    }
  }

  Future<void> _unsetAllDefaultPaymentMethods() async {
    final paymentMethods = hiveService.getAllPaymentMethods();
    for (var method in paymentMethods) {
      if (method.isDefault) {
        method.isDefault = false;
        await hiveService.addPaymentMethod(method);
      }
    }
  }
}