import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/core/extensions/toast_extension.dart';
import 'package:sasha_botique/features/orders/presentation/pages/payment_webpage.dart';
import 'package:sasha_botique/shared/extensions/string_extensions.dart';
import 'dart:ui';

// Import your existing components and models
import '../../../../core/di/injections.dart';
import '../../../../shared/widgets/cache_image.dart';
import '../../domain/entities/order.dart';
import '../bloc/order_bloc.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late final OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = getIt<OrderBloc>();
    _orderBloc.add(GetOrderByIdEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Order Details',
          style: context.headlineSmall?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        bloc: _orderBloc,
        listener: (context, state) {
          if (state is OrderCreateSuccess) {
            // cartBloc.add(ClearCart());
            // Navigate to payment web view
            // final paymentState = paymentBloc.state;
            // final selectedPayment = paymentState.paymentMethods[0];

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentWebView(
                  paymentUrl: state.paymentUrl,
                  orderId: state.orderId,
                  // paymentMethodModel: selectedPayment,
                ),
              ),
            );
          } else if (state is OrderError) {
            context.showToast(state.message);
            // If it's a payment error, show a more detailed error dialog
            if (state.message.contains('Payment setup error') ||
                state.message.contains('Payment processing error')) {
              _showPaymentErrorDialog(context, state.message);
            }
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrderDetailsLoaded) {
            final order = state.order;
            return _buildOrderDetails(context, order);
          } else if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _orderBloc.add(GetOrderByIdEvent(widget.orderId));
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          // Initial state or any other state
          return const Center(child: Text("Loading order details..."));
        },
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, Order order) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    // Determine status color
    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'paid':
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'delivered':
        statusColor = Colors.blue;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Order #${order.id.substring(0, order.id.length > 8 ? 8 : order.id.length)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status.capitalizeFirstLetter(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Dates
          _buildInfoRow('Placed on:', dateFormat.format(order.createdAt)),
          _buildInfoRow('Last Updated:', dateFormat.format(order.updatedAt)),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Payment Information
          const Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payment Status:'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              order.paymentStatus.toLowerCase() == 'completed'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.paymentStatus.capitalizeFirstLetter(),
                          style: TextStyle(
                            color:
                                order.paymentStatus.toLowerCase() == 'completed'
                                    ? Colors.green
                                    : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Payment Method:',
                      order.paymentMethod?.cardHolderName ?? 'Stripe Payment'),
                  if (order.revolutOrderId.isNotEmpty)
                    _buildInfoRow('Transaction ID:', order.revolutOrderId),
                ],
              ),
            ),
          ),

          // Show tracking button if tracking URL is available
          if (order.trackingUrl != null && order.trackingUrl!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openTrackingUrl(order.trackingUrl!),
                    icon: const Icon(Icons.local_shipping, size: 18),
                    label: const Text('Track Package'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Delivery Information
          const Text(
            'Delivery Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery Status:'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _getDeliveryStatusColor(order).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getDeliveryStatus(order),
                          style: TextStyle(
                            color: _getDeliveryStatusColor(order),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDeliveryStatusDetails(order),
                  if (order.trackingId != null && order.trackingId!.isNotEmpty)
                    _buildInfoRow('Tracking ID:', order.trackingId!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Payment Actions
          if (order.paymentStatus.toLowerCase() == 'pending') ...[
            const SizedBox(height: 16),
            const Text(
              'Payment Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _orderBloc.add(UpdatePaymentURLEvent(orderID: order.id));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Complete Payment'),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Customer Information
          const Text(
            'Customer Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Name:', order.name),
                  _buildInfoRow('Email:', order.email),
                  _buildInfoRow('Phone:', order.phone),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Delivery Address
          const Text(
            'Delivery Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.deliveryAddress.street ?? ""),
                  Text(
                      '${order.deliveryAddress.city ?? ""}, ${order.deliveryAddress.postalCode ?? ""}'),
                  Text(order.deliveryAddress.country ?? ""),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Order Items
          const Text(
            'Order Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // List of items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: item.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedImage(
                                  imageUrl: item.imageUrl.first,
                                ),
                              )
                            : const Icon(
                                Icons.image_not_supported_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                      ),
                      const SizedBox(width: 16),
                      // Product details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (item.colors.isNotEmpty)
                              Text('Color: ${item.colors}'),
                            // if (item.size.isNotEmpty)
                            //   Text('Size: ${item.size}'),
                            // const SizedBox(height: 4),
                            Text(
                              'Quantity: ${item.quantity}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${order.currency} ${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (item.quantity > 1)
                            Text(
                              '${order.currency} ${item.price.toStringAsFixed(2)} × ${item.quantity}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Order summary (totals)
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPriceRow(
                      'Subtotal:', order.totalAmount + order.discountAmount),
                  if (order.discountAmount > 0)
                    _buildPriceRow(
                      'Discount (${order.promoCode}):',
                      -order.discountAmount,
                      isDiscount: true,
                    ),
                  const Divider(),
                  _buildPriceRow(
                    'Total:',
                    order.totalAmount,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons based on order status
          _buildActionButtons(context, order),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openTrackingUrl(String url) async {
    try {
      // Clean the URL by removing invalid characters like @ at the beginning
      String cleanedUrl = url.trim();
      if (cleanedUrl.startsWith('@')) {
        cleanedUrl = cleanedUrl.substring(1);
      }

      // Ensure the URL has a proper protocol
      if (!cleanedUrl.startsWith('http://') &&
          !cleanedUrl.startsWith('https://')) {
        cleanedUrl = 'https://$cleanedUrl';
      }

      final Uri uri = Uri.parse(cleanedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show error message if URL cannot be launched
        context.showToast('Cannot open tracking URL');
      }
    } catch (e) {
      // Show error message if there's an exception
      context.showToast('Error opening tracking URL: $e');
    }
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            '${isDiscount ? "-" : ""}${_orderBloc.state is OrderDetailsLoaded ? (_orderBloc.state as OrderDetailsLoaded).order.currency : ""} ${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Order order) {
    final List<Widget> buttons = [];

    // Add different buttons based on status
    if (order.status.toLowerCase() == 'delivered') {
      buttons.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to review order page
            },
            icon: const Icon(Icons.rate_review),
            // label: const Text('Write a Review'),
            label: const Text('Delivered'),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );
    } else if ((order.status.toLowerCase() == 'completed' ||
            order.status.toLowerCase() == 'paid') &&
        order.paymentStatus.toLowerCase() == 'completed') {
      buttons.add(SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement track order functionality
            },
            icon: const Icon(Icons.location_on),
            // label: const Text('Track Order'),
            label: const Text('In Progress'),

            style: ElevatedButton.styleFrom(),
          )));
    } else {
      buttons.add(SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _orderBloc.add(UpdatePaymentURLEvent(orderID: order.id));
            },
            icon: const Icon(Icons.shopping_basket),
            label: Text(order.status),
            style: ElevatedButton.styleFrom(),
          )));
    }
    return buttons.first;
  }

  void _showPaymentErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Error'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(errorMessage),
              const SizedBox(height: 16),
              const Text(
                'This error usually occurs when there\'s an issue with the payment setup. You can:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Contact customer support'),
              const Text('• Try creating a new order'),
              const Text('• Check if your payment method is valid'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally refresh the order details
                if (_orderBloc.state is OrderDetailsLoaded) {
                  final orderId =
                      (_orderBloc.state as OrderDetailsLoaded).order.id;
                  _orderBloc.add(GetOrderByIdEvent(orderId));
                }
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  String _getDeliveryStatus(Order order) {
    // If payment is not completed, show payment pending
    if (order.paymentStatus.toLowerCase() != 'completed') {
      return 'Payment Pending';
    }

    // If payment is completed but no tracking ID, show "In Shipment"
    if (order.trackingId == null || order.trackingId!.isEmpty) {
      return 'In Shipment';
    }

    // If payment is completed and tracking ID exists, show "Delivered"
    return 'Delivered';
  }

  Color _getDeliveryStatusColor(Order order) {
    // If payment is not completed, show orange
    if (order.paymentStatus.toLowerCase() != 'completed') {
      return Colors.orange;
    }

    // If payment is completed but no tracking ID, show blue (in shipment)
    if (order.trackingId == null || order.trackingId!.isEmpty) {
      return Colors.blue;
    }

    // If payment is completed and tracking ID exists, show green (delivered)
    return Colors.green;
  }

  Widget _buildDeliveryStatusDetails(Order order) {
    if (order.paymentStatus.toLowerCase() != 'completed') {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Your order will be processed once payment is completed.',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    if (order.trackingId == null || order.trackingId!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Your order has been shipped and is on its way to you.',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text(
        'Your order has been delivered successfully.',
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
