// lib/features/order/presentation/pages/orders_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/core/extensions/toast_extension.dart';
import 'package:sasha_botique/features/orders/presentation/pages/payment_webpage.dart';
import 'package:sasha_botique/features/products/presentation/pages/home_screen.dart';
import 'package:sasha_botique/shared/extensions/string_extensions.dart';
import 'package:sasha_botique/shared/widgets/cache_image.dart';

import '../../../payment/presentation/bloc/payment_bloc.dart';
import '../../domain/entities/order.dart';
import '../bloc/order_bloc.dart';
import 'order_detail_page.dart';

//OrderDetailsPage
class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final OrderBloc orderBloc;
  late final PaymentBloc paymentBloc;

  @override
  void initState() {
    super.initState();
    // Load orders when the page is initialized
    orderBloc = getIt<OrderBloc>();
    paymentBloc = getIt<PaymentBloc>();
    orderBloc.add(GetAllOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Orders',
          style: context.headlineSmall?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        bloc: orderBloc,
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start shopping to place your first order',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to products/home page
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('Shop Now'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                orderBloc.add(GetAllOrdersEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return _buildOrderCard(context, order);
                },
              ),
            );
          } else if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      orderBloc.add(GetAllOrdersEvent());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No orders available'));
          }
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final dateFormat = DateFormat('MMM dd, yyyy');

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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailPage(orderId: order.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id.substring(0, 8)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
              Text(
                'Placed on: ${dateFormat.format(order.createdAt)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display first item image or placeholder
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: order.items.isNotEmpty &&
                            order.items[0].imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedImage(
                              imageUrl: order.items[0].imageUrl.first,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            size: 30,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.items.isNotEmpty
                              ? '${order.items[0].name}${order.items.length > 1 ? ' + ${order.items.length - 1} more' : ''}'
                              : 'No items',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${order.currency} ${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.paymentStatus.capitalizeFirstLetter(),
                        style: TextStyle(
                          color:
                              order.paymentStatus.toLowerCase() == 'completed'
                                  ? Colors.green
                                  : Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (order.paymentStatus.toLowerCase() == 'pending')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      orderBloc.add(UpdatePaymentURLEvent(orderID: order.id));

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => PaymentWebView(
                      //       paymentUrl: order.paymentUrl,
                      //       orderId: order.id,
                      //       paymentMethodModel: paymentBloc.state.paymentMethods.isNotEmpty ? paymentBloc.state.paymentMethods.firstWhere((test)=> test.isDefault):null,
                      //     ),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Complete Payment'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
                // Optionally refresh the orders list
                orderBloc.add(GetAllOrdersEvent());
              },
              child: const Text('Refresh'),
            ),
          ],
        );
      },
    );
  }
}
