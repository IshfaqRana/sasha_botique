import '../../../payment/data/data_model/payment_method_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../profile/data/models/user_address_reponse_model.dart';
import '../../domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required String id,
    required List<ProductModel> items,
    required double totalAmount,
    PaymentMethodModel? paymentMethod,
    required UserAddressModel deliveryAddress,
    required String promoCode,
    required double discountAmount,
    required String currency,
    required String email,
    required String phone,
    required String name,
    required String status,
    required String revolutOrderId,
    required String paymentStatus,
    String? trackingId,
    String? trackingUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    String paymentUrl = '',
  }) : super(
          id: id,
          items: items,
          totalAmount: totalAmount,
          paymentMethod: paymentMethod,
          deliveryAddress: deliveryAddress,
          promoCode: promoCode,
          discountAmount: discountAmount,
          currency: currency,
          email: email,
          phone: phone,
          name: name,
          status: status,
          revolutOrderId: revolutOrderId,
          paymentStatus: paymentStatus,
          trackingId: trackingId,
          trackingUrl: trackingUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
          paymentUrl: paymentUrl,
        );

  // Helper method to parse order items which have a different structure
  static ProductModel _parseOrderItem(Map<String, dynamic> itemJson) {
    // If the item has full product data (from product listing)
    if (itemJson.containsKey('name') && itemJson.containsKey('price')) {
      return ProductModel.fromJson(itemJson);
    }

    // New structure: itemId contains full product object
    if (itemJson.containsKey('itemId') &&
        itemJson['itemId'] is Map<String, dynamic>) {
      final itemIdData = itemJson['itemId'] as Map<String, dynamic>;
      final quantity = (itemJson['quantity'] as num?)?.toInt() ?? 1;
      final itemPrice = (itemJson['price'] as num?)?.toDouble() ?? 0.0;

      // Create ProductModel from the itemId data
      final product = ProductModel.fromJson(itemIdData);

      // Override quantity and price with the order-specific values
      return ProductModel(
        isBasics: product.isBasics,
        id: product.id,
        name: product.name,
        price: itemPrice, // Use the order-specific price
        imageUrl: product.imageUrl,
        category: product.category,
        quantity: quantity, // Use the order-specific quantity
        gender: product.gender,
        isPopular: product.isPopular,
        isOnSale: product.isOnSale,
        colors: product.colors,
        sizes: product.sizes,
        productType: product.productType,
        season: product.season,
        fitType: product.fitType,
        brandName: product.brandName,
        collection: product.collection,
        description: product.description,
      );
    }

    // Fallback: If the item only has itemId as string and quantity (from old order response)
    return ProductModel(
      isBasics: false,
      id: itemJson['itemId']?.toString() ?? itemJson['_id']?.toString() ?? '',
      name: 'Item ${itemJson['itemId'] ?? itemJson['_id'] ?? ''}',
      price: (itemJson['price'] as num?)?.toDouble() ??
          0.0, // Use item price if available
      imageUrl: [],
      category: '',
      quantity: (itemJson['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final totalAmount = (json['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final itemsList = (json['items'] as List?) ?? [];

    return OrderModel(
      id: json['_id'] ?? '',
      items: itemsList.map((item) => _parseOrderItem(item)).toList(),
      totalAmount: totalAmount,
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethodModel.fromJson(json['paymentMethod'])
          : null,
      deliveryAddress: UserAddressModel.fromJson(json['deliveryAddress'] ?? {}),
      promoCode: json['promoCode']?.toString() ?? '',
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['deliveryAddress']?["full_name"]?.toString() ?? "",
      phone: json['deliveryAddress']?["phone_number"]?.toString() ?? "",
      status: json['status']?.toString() ?? '',
      revolutOrderId: json['revolutOrderId']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      trackingId: json['tracking_id']?.toString(),
      trackingUrl: json['tracking_url']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    // Debug: Print what's being sent to backend
    print('=== ORDER JSON DEBUG ===');
    print('Total Amount being sent: \$${totalAmount.toStringAsFixed(2)}');
    for (var item in items) {
      print(
          'Item: ${item.name}, Price: \$${item.price}, Quantity: ${item.quantity}');
    }

    final itemsList = items
        .map((item) => {
              'itemId': item.id,
              'price': item.price,
              'quantity': item.quantity,
            })
        .toList();

    print('Items list: $itemsList');
    print('Items list type: ${itemsList.runtimeType}');
    print('========================');

    return {
      'items': itemsList,
      'totalAmount': totalAmount,
      'currency': currency,
      'paymentMethod': paymentMethod != null
          ? {
              'type': paymentMethod!.type,
              'last4_digits': paymentMethod!.last4Digits,
              'card_holder_name': paymentMethod!.cardHolderName,
              'expiry_date': paymentMethod!.expiryDate,
              'country': paymentMethod!.country,
              'is_default': paymentMethod!.isDefault,
            }
          : null,
      'deliveryAddress': {
        'full_name': name,
        'address_line_1': deliveryAddress.street,
        'city': deliveryAddress.city,
        'postal_code': deliveryAddress.postalCode,
        'country': deliveryAddress.country,
        'phone_number': phone,
        'is_default': deliveryAddress.isDefault,
      },
      'promoCode': promoCode,
      'email': email,
    };
  }
}
