class CreateOrderModel {
  final bool success;
  final String orderId;
  final String paymentUrl;

  CreateOrderModel({
    required this.success,
    required this.orderId,
    required this.paymentUrl,
  });
}