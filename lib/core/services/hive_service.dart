// lib/core/services/hive_service.dart
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/cart/data/models/cart_item_hive_model.dart';
import '../../features/payment/data/data_model/payment_method_hive_model.dart';

class HiveService {
  static const String cartBoxName = 'cartBox';
  static const String paymentMethodsBoxName = 'paymentMethodsBox';

  /// Initialize Hive
  Future<void> init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    // Register adapters
    Hive.registerAdapter(CartItemHiveModelAdapter());
    Hive.registerAdapter(PaymentMethodHiveModelAdapter());

    // Open boxes
    await Hive.openBox<CartItemHiveModel>(cartBoxName);
    await Hive.openBox<PaymentMethodHiveModel>(paymentMethodsBoxName);
  }

  // Cart methods
  Box<CartItemHiveModel> getCartBox() {
    return Hive.box<CartItemHiveModel>(cartBoxName);
  }

  Future<void> addCartItem(CartItemHiveModel item) async {
    final box = getCartBox();
    await box.put(item.id, item);
  }

  CartItemHiveModel? getCartItem(String id) {
    final box = getCartBox();
    return box.get(id);
  }

  List<CartItemHiveModel> getAllCartItems() {
    final box = getCartBox();
    return box.values.toList();
  }

  Future<void> removeCartItem(String id) async {
    final box = getCartBox();
    await box.delete(id);
  }

  Future<void> clearCart() async {
    final box = getCartBox();
    await box.clear();
  }

  // Payment methods methods
  Box<PaymentMethodHiveModel> getPaymentMethodsBox() {
    return Hive.box<PaymentMethodHiveModel>(paymentMethodsBoxName);
  }

  Future<void> addPaymentMethod(PaymentMethodHiveModel paymentMethod) async {
    final box = getPaymentMethodsBox();
    await box.put(paymentMethod.id, paymentMethod);
  }

  PaymentMethodHiveModel? getPaymentMethod(String id) {
    final box = getPaymentMethodsBox();
    return box.get(id);
  }

  List<PaymentMethodHiveModel> getAllPaymentMethods() {
    final box = getPaymentMethodsBox();
    return box.values.toList();
  }

  Future<void> removePaymentMethod(String id) async {
    final box = getPaymentMethodsBox();
    await box.delete(id);
  }

  Future<void> clearPaymentMethods() async {
    final box = getPaymentMethodsBox();
    await box.clear();
  }
}