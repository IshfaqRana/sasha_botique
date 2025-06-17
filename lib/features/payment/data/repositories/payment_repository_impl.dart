import 'package:dartz/dartz.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_repository.dart';
import '../data_source/payment_local_data_source.dart';
import '../data_source/payment_remote_data_source.dart';
import '../data_model/payment_method_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final PaymentLocalDataSource localDataSource;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    // For fetching payment methods, we prioritize local data
    // since it contains the complete information
    try {
      return await remoteDataSource.getPaymentMethods();
    } catch (e) {
      // If local fetch fails, return empty list
      print('Failed to fetch payment methods locally: $e');
      return [];
    }
  }

  @override
  Future<void> addPaymentMethod(PaymentMethod paymentMethod) async {
    // Create local model with full card number
    final localPaymentMethodModel = PaymentMethodModel(
      id: paymentMethod.id,
      type: paymentMethod.type,
      last4Digits: paymentMethod.last4Digits, // This would be the full card number locally
      cardHolderName: paymentMethod.cardHolderName,
      expiryDate: paymentMethod.expiryDate,
      country: paymentMethod.country,
      isDefault: paymentMethod.isDefault,
    );

    // Create remote model with only last 4 digits
    final remotePaymentMethodModel = PaymentMethodModel(
      id: paymentMethod.id,
      type: paymentMethod.type,
      last4Digits: _extractLast4Digits(paymentMethod.last4Digits), // Only last 4 digits
      cardHolderName: paymentMethod.cardHolderName,
      expiryDate: paymentMethod.expiryDate,
      country: paymentMethod.country,
      isDefault: paymentMethod.isDefault,
    );

    // Save to local storage
    try {
      await localDataSource.addPaymentMethod(localPaymentMethodModel);
    } catch (e) {
      print('Failed to save payment method locally: $e');
      rethrow; // Critical error, rethrow to caller
    }

    // Try to save to the server (with reduced info)
    try {
      await remoteDataSource.addPaymentMethod(remotePaymentMethodModel);
    } catch (e) {
      // Log but continue since we saved locally
      print('Failed to save payment method remotely: $e');
    }
  }

  @override
  Future<void> updatePaymentMethod(PaymentMethod paymentMethod) async {
    // Create local model with full card number
    // final localPaymentMethodModel = PaymentMethodModel(
    //   id: paymentMethod.id,
    //   type: paymentMethod.type,
    //   last4Digits: paymentMethod.last4Digits, // Full card number
    //   cardHolderName: paymentMethod.cardHolderName,
    //   expiryDate: paymentMethod.expiryDate,
    //   country: paymentMethod.country,
    //   isDefault: paymentMethod.isDefault,
    // );

    // Create remote model with only last 4 digits
    final remotePaymentMethodModel = PaymentMethodModel(
      id: paymentMethod.id,
      type: paymentMethod.type,
      last4Digits: _extractLast4Digits(paymentMethod.last4Digits), // Only last 4 digits
      cardHolderName: paymentMethod.cardHolderName,
      expiryDate: paymentMethod.expiryDate,
      country: paymentMethod.country,
      isDefault: paymentMethod.isDefault,
    );

    // Update locally
    // try {
    //   await localDataSource.updatePaymentMethod(localPaymentMethodModel);
    // } catch (e) {
    //   print('Failed to update payment method locally: $e');
    //   rethrow; // Critical error, rethrow to caller
    // }

    // Try to update on the server
    try {
      await remoteDataSource.updatePaymentMethod(remotePaymentMethodModel);
    } catch (e) {
      // Log but continue since we updated locally
      print('Failed to update payment method remotely: $e');
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    // Always delete locally first
    // try {
    //   await localDataSource.deletePaymentMethod(id);
    // } catch (e) {
    //   print('Failed to delete payment method locally: $e');
    //   rethrow; // Critical error, rethrow to caller
    // }

    // Try to delete from the server
    try {
      await remoteDataSource.deletePaymentMethod(id);
    } catch (e) {
      // Log but continue since we deleted locally
      print('Failed to delete payment method remotely: $e');
    }
  }

  @override
  Future<void> setDefaultPaymentMethod(PaymentMethod paymentMethod, PaymentMethod paymentMethod2,bool defaultValue,) async {
    // Get the payment method from local data
    List<PaymentMethodModel> localMethods;
    PaymentMethodModel? defaultMethod;

      localMethods = await remoteDataSource.getPaymentMethods();
    // try {
    //   localMethods = await localDataSource.getPaymentMethods();
    //   defaultMethod = localMethods.firstWhere((method) => method.id == id);
    // } catch (e) {
    //   print('Failed to retrieve payment method locally: $e');
    //   rethrow; // Critical error, rethrow to caller
    // }
    //
    // // Set as default locally
    // try {
    //   await localDataSource.setDefaultPaymentMethod(defaultMethod);
    // } catch (e) {
    //   print('Failed to set default payment method locally: $e');
    //   rethrow; // Critical error, rethrow to caller
    // }
    // defaultMethod = localMethods.firstWhere((method) => method.isDefault,orElse: () => PaymentMethodModel(id: "null", type: "type", last4Digits: "last4Digits", cardHolderName: "cardHolderName", expiryDate: "expiryDate", country: "country", isDefault: false));

      final removeAsAnDefault = PaymentMethodModel(
        id: paymentMethod2.id,
        type: paymentMethod2.type,
        last4Digits: _extractLast4Digits(paymentMethod2.last4Digits),
        cardHolderName: paymentMethod2.cardHolderName,
        expiryDate: paymentMethod2.expiryDate,
        country: paymentMethod2.country,
        isDefault: false,
      );
      try {
        await remoteDataSource.updatePaymentMethod(removeAsAnDefault);

      } catch (e) {
        // Log but continue since default is set locally
        print('Failed to set default payment method remotely: $e');
      }



    // Create a remote version with only last 4 digits for setting default on server
    final remoteDefaultMethod = PaymentMethodModel(
      id: paymentMethod.id,
      type: paymentMethod.type,
      last4Digits: _extractLast4Digits(paymentMethod.last4Digits),
      cardHolderName: paymentMethod.cardHolderName,
      expiryDate: paymentMethod.expiryDate,
      country: paymentMethod.country,
      isDefault: defaultValue,
    );

    // Try to set default on the server
    try {
      await remoteDataSource.updatePaymentMethod(remoteDefaultMethod);

    } catch (e) {
      // Log but continue since default is set locally
      print('Failed to set default payment method remotely: $e');
    }
  }

  // Helper method to extract last 4 digits from a card number
  String _extractLast4Digits(String cardNumber) {
    // Clean the card number first (remove spaces, dashes, etc)
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Extract last 4 digits if the card number is long enough
    if (cleanCardNumber.length >= 4) {
      return cleanCardNumber.substring(cleanCardNumber.length - 4);
    }

    // Return the original if it's too short (shouldn't happen with valid cards)
    return cleanCardNumber;
  }
}