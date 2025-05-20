import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
        title:  Text('Order Details',style: context.headlineSmall?.copyWith(fontSize: 18),),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        bloc: _orderBloc,
        listener: (context, state){
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
                  'Order #${order.id.substring(0, 8)}',
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
                          color: order.paymentStatus.toLowerCase() == 'completed'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.paymentStatus.capitalizeFirstLetter(),
                          style: TextStyle(
                            color: order.paymentStatus.toLowerCase() == 'completed'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Payment Method:', order.paymentMethod.cardHolderName),
                  if (order.revolutOrderId.isNotEmpty)
                    _buildInfoRow('Transaction ID:', order.revolutOrderId),

                  // Show payment button if payment is pending
                  if (order.paymentStatus.toLowerCase() == 'pending')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _orderBloc.add(UpdatePaymentURLEvent(orderID: order.id));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Complete Payment'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

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

                  Text('${order.deliveryAddress.city}, ${order.deliveryAddress.postalCode}'),
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
                              'Quantity: ${item.collection}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      // Price
                      Text(
                        '${order.currency} ${(item.price).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
                  _buildPriceRow('Subtotal:', order.totalAmount + order.discountAmount),
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

  Widget _buildPriceRow(String label, double amount, {bool isBold = false, bool isDiscount = false}) {
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
            '${isDiscount ? "-" : ""}${_orderBloc
                .state is OrderDetailsLoaded ? (_orderBloc
                .state as OrderDetailsLoaded).order.currency : ""} ${amount.abs().toStringAsFixed(2)}',
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
    } else if (order.status.toLowerCase() == 'completed' && order.paymentStatus.toLowerCase() == 'completed') {
      buttons.add(
          SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement track order functionality
                },
                icon: const Icon(Icons.location_on),
                // label: const Text('Track Order'),
                label: const Text('In Progress'),

                style: ElevatedButton.styleFrom(),)));
    }else{
      buttons.add(SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _orderBloc.add(UpdatePaymentURLEvent(orderID: order.id));

            },
            icon: const Icon(Icons.shopping_basket),
            label:  Text(order.status),
            style: ElevatedButton.styleFrom(),)));
    }
    return buttons.first;

  }
}