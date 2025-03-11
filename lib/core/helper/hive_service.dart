import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/cart/data/models/cart_item_hive_model.dart';

class HiveService {
  static const String cartBoxName = 'cartBox';

  /// Initialize Hive
  Future<void> init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(CartItemHiveModelAdapter());
    await Hive.openBox<CartItemHiveModel>(cartBoxName);
  }

  /// Get the cart box
  Box<CartItemHiveModel> getCartBox() {
    return Hive.box<CartItemHiveModel>(cartBoxName);
  }

  /// Add or update a cart item in the box
  Future<void> addCartItem(CartItemHiveModel item) async {
    final box = getCartBox();
    await box.put(item.id, item);
  }

  /// Get a cart item by ID
  CartItemHiveModel? getCartItem(String id) {
    final box = getCartBox();
    return box.get(id);
  }

  /// Get all cart items
  List<CartItemHiveModel> getAllCartItems() {
    final box = getCartBox();
    return box.values.toList();
  }

  /// Remove a cart item by ID
  Future<void> removeCartItem(String id) async {
    final box = getCartBox();
    await box.delete(id);
  }

  /// Clear all cart items
  Future<void> clearCart() async {
    final box = getCartBox();
    await box.clear();
  }
}