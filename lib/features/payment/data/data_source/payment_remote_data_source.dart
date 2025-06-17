// lib/features/payment/data/datasources/payment_remote_data_source.dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sasha_botique/core/utils/app_utils.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../../../core/network/network_manager.dart';
import '../data_model/payment_method_model.dart';
import '../data_model/payment_response_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<List<PaymentMethodModel>> addPaymentMethod(PaymentMethodModel paymentMethod);
  Future<PaymentMethodModel> updatePaymentMethod(PaymentMethodModel paymentMethod);
  Future<List<PaymentMethodModel>> deletePaymentMethod(String id);
  Future<PaymentMethodModel> setDefaultPaymentMethod(PaymentMethodModel paymentMethod);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final NetworkManager _networkManager;

  PaymentRemoteDataSourceImpl(
     this._networkManager,
  );

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await _networkManager.get(
        '/account/payment-method',
      );

      if (response.statusCode == 200) {
        PaymentResponseModel paymentResponseModel = PaymentResponseModel.fromJson(response.data);

        return paymentResponseModel.payload ?? [];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PaymentMethodModel>> addPaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      final response = await _networkManager.post(
        '/account/payment-method',

        data: json.encode(paymentMethod.toJson()),
      );
      PaymentResponseModel paymentResponseModel = PaymentResponseModel.fromJson(response.data);

      return paymentResponseModel.payload ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentMethodModel> updatePaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      final response = await _networkManager.patch(
        '/account/payment-method/${paymentMethod.id}',
        data: json.encode(paymentMethod.toJson()),
      );
      UpdatePaymentResponseModel paymentResponseModel = UpdatePaymentResponseModel.fromJson(response.data);

      return paymentResponseModel.payload ?? PaymentMethodModel(id: "", type: "", last4Digits: "", cardHolderName: "", expiryDate: "", country: "", isDefault: false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PaymentMethodModel>> deletePaymentMethod(String id) async {
    try {
      final response = await _networkManager.delete(
        '/account/payment-method/$id',
      );
      PaymentResponseModel paymentResponseModel = PaymentResponseModel.fromJson(response.data);

      return paymentResponseModel.payload ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentMethodModel> setDefaultPaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      final response = await _networkManager.patch(
        '/account/payment-method/${paymentMethod.id}',
        data: json.encode(paymentMethod.toJson()),
      );
      debugPrinter('/account/payment-method/${paymentMethod.id}');
      UpdatePaymentResponseModel paymentResponseModel = UpdatePaymentResponseModel.fromJson(response.data);

      return paymentResponseModel.payload ?? PaymentMethodModel(id: "", type: "", last4Digits: "", cardHolderName: "", expiryDate: "", country: "", isDefault: false);

    } catch (e) {
      rethrow;
    }
  }
}
