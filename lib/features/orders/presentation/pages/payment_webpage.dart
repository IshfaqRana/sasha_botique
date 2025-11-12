import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // Temporarily commented out
import 'package:webview_flutter/webview_flutter.dart';

import '../../../payment/domain/entities/payment_method.dart';
import 'order_detail_page.dart';
import '../../data/source/order_remote_source.dart';
import '../../../../core/di/injections.dart';
import '../../../../core/network/network_manager.dart';

class PaymentWebView extends StatefulWidget {
  final PaymentMethod? paymentMethodModel;
  final String paymentUrl;
  final String orderId;

  const PaymentWebView({
    Key? key,
    required this.paymentUrl,
    required this.orderId,
    this.paymentMethodModel,
  }) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late WebViewController controller;
  bool isLoading = true;
  String cardNumber = "";
  String cvc = "";
  String cardHolderName = "";
  String expiryDate = "";
  Timer? _statusCheckTimer;
  Timer? _orderStatusTimer;
  late OrderRemoteDataSource _orderDataSource;

  @override
  void initState() {
    super.initState();
    _orderDataSource =
        OrderRemoteDataSourceImpl(networkManager: getIt<NetworkManager>());
    setState(() {
      // Payment method data temporarily commented out - will be handled by Stripe
      cardHolderName = ""; // widget.paymentMethodModel?.cardHolderName ?? "";
      cvc = ""; // widget.paymentMethodModel?.id ?? "";
      cardNumber = ""; // widget.paymentMethodModel?.last4Digits ?? "";
      expiryDate = ""; // widget.paymentMethodModel?.expiryDate ?? "";
    });
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });

            // Check for redirect URLs that indicate payment completion
            if (_isPaymentRedirectUrl(url)) {
              // Close webview immediately to prevent showing error page
              Future.delayed(const Duration(milliseconds: 100), () {
                _handlePaymentRedirect(url);
              });
            }
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });

            // Wait a moment for the form to be fully rendered
            Future.delayed(const Duration(milliseconds: 500), () {
              // Check if we're on the card details page
              controller.runJavaScriptReturningResult('''
                (function() {
                  if (document.querySelector('input[placeholder="Card number"]') ||
                      document.querySelector('input[aria-label="Card number"]')) {
                    return 'card_page';
                  }
                  return 'other_page';
                })()
              ''').then((result) {
                String pageType = result.toString().replaceAll('"', '');

                if (pageType == 'card_page') {
                  // Fill in card details
                  _fillCardDetails();
                }
              });
            });

            // Start monitoring for payment status
            _startPageContentMonitoring();
            _startOrderStatusMonitoring();

            // Also check current URL for redirect patterns
            if (_isPaymentRedirectUrl(url)) {
              _handlePaymentRedirect(url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _isPaymentRedirectUrl(String url) {
    // Check for common payment redirect patterns that indicate completion
    return url.contains('/success') ||
        url.contains('/complete') ||
        url.contains('/thank-you') ||
        url.contains('/return') ||
        url.contains('/callback') ||
        url.contains('payment_status=success') ||
        url.contains('status=success') ||
        url.contains('payment_status=complete') ||
        url.contains('status=complete') ||
        // Check for API redirect URLs that might show errors
        (url.contains('/api/') &&
            (url.contains('success') || url.contains('complete'))) ||
        // Check for error patterns that should close the webview
        url.contains('error') &&
            (url.contains('payment') || url.contains('order'));
  }

  void _handlePaymentRedirect(String url) {
    // Cancel any ongoing monitoring
    _statusCheckTimer?.cancel();
    _orderStatusTimer?.cancel();

    // Determine if this is a success or error based on URL
    bool isSuccess = url.contains('success') ||
        url.contains('complete') ||
        url.contains('thank-you') ||
        (!url.contains('error') && url.contains('/api/'));

    if (isSuccess) {
      _handlePaymentSuccess();
    } else {
      _handlePaymentError();
    }
  }

  void _fillCardDetails() {
    // Format card data as needed
    final formattedCardNumber = cardNumber.isEmpty ? "" : cardNumber;
    final formattedExpiry = expiryDate.isEmpty ? "" : expiryDate;
    final formattedName = cardHolderName.isEmpty ? "" : cardHolderName;
    final formattedCvc = cvc.isEmpty ? "" : cvc;

    controller.runJavaScript('''
      (function() {
        // Try different selector patterns that might match Revolut's form
        const cardNumberInput = document.querySelector('input[placeholder="Card number"]') || 
                               document.querySelector('input[aria-label="Card number"]') ||
                               document.querySelector('input[type="text"][name*="card"]');
        
        const cardholderInput = document.querySelector('input[placeholder="Cardholder name"]') || 
                               document.querySelector('input[aria-label="Cardholder name"]') ||
                               document.querySelector('input[name*="cardholder"]');
        
        const expiryInput = document.querySelector('input[placeholder="MM/YY"]') || 
                           document.querySelector('input[placeholder="Expiry date"]') ||
                           document.querySelector('input[aria-label="Expiry date"]');
        
        const cvcInput = document.querySelector('input[placeholder="CVV"]') ||
                        document.querySelector('input[aria-label="CVV"]') ||
                        document.querySelector('input[placeholder="CVC"]');
        
        // Fill in the fields if they exist
        if (cardNumberInput) {
          cardNumberInput.value = "$formattedCardNumber";
          cardNumberInput.dispatchEvent(new Event('input', { bubbles: true }));
        }
        
        if (cardholderInput) {
          cardholderInput.value = "$formattedName";
          cardholderInput.dispatchEvent(new Event('input', { bubbles: true }));
        }
        
        if (expiryInput) {
          expiryInput.value = "$formattedExpiry";
          expiryInput.dispatchEvent(new Event('input', { bubbles: true }));
        }
        
        if (cvcInput) {
          cvcInput.value = "$formattedCvc";
          cvcInput.dispatchEvent(new Event('input', { bubbles: true }));
        }
      })();
    ''');
  }

  void _startPageContentMonitoring() {
    // Cancel any existing timer
    _statusCheckTimer?.cancel();

    // Check every 2 seconds for payment status changes
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      controller.runJavaScriptReturningResult('''
        (function() {
          const pageText = document.body.innerText || '';
          const h1Text = document.querySelector('h1')?.innerText || '';
          const currentUrl = window.location.href;
          
          // Check URL for success/failure patterns
          if (currentUrl.includes('success') || 
              currentUrl.includes('complete') ||
              currentUrl.includes('thank-you') ||
              currentUrl.includes('/return') ||
              currentUrl.includes('/callback') ||
              (currentUrl.includes('/api/') && !currentUrl.includes('error'))) {
            return 'success';
          }
          
          if (currentUrl.includes('cancel') || 
              currentUrl.includes('error') ||
              currentUrl.includes('failed') ||
              currentUrl.includes('declined')) {
            return 'error';
          }
          
          // Check for success indicators in page content
          if (pageText.includes('Payment successful') || 
              pageText.includes('Payment completed') ||
              pageText.includes('Thank you') ||
              pageText.includes('Order confirmed') ||
              pageText.includes('Payment processed') ||
              pageText.includes('Transaction successful') ||
              pageText.includes('Order placed') ||
              h1Text.includes('Payment successful') ||
              h1Text.includes('Thank you') ||
              h1Text.includes('Order confirmed') ||
              h1Text.includes('Payment completed')) {
            return 'success';
          }
          
          // Check for failure indicators
          if (pageText.includes('Something went wrong') || 
              pageText.includes('3DS Verification failed') ||
              pageText.includes('Uh oh!') ||
              pageText.includes('Payment failed') ||
              pageText.includes('Declined') ||
              pageText.includes('Error processing payment')) {
            return 'error';
          }
          
          return 'pending';
        })()
      ''').then((result) {
        String status = result.toString().replaceAll('"', '');

        if (status == 'success') {
          timer.cancel();
          _orderStatusTimer?.cancel(); // Stop order status monitoring too
          _handlePaymentSuccess();
        } else if (status == 'error') {
          timer.cancel();
          _orderStatusTimer?.cancel(); // Stop order status monitoring too
          _handlePaymentError();
        }
      }).catchError((error) {
        // If JavaScript execution fails, continue monitoring
      });
    });
  }

  void _handlePaymentSuccess() {
    // Close WebView immediately to prevent 404 errors
    Navigator.pop(context); // Close the WebView page

    // Show success message and navigate to order details
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful!'),
        content: const Text('Your payment has been processed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Clear navigation stack back to HomeScreen and push order detail page
              // This ensures back button goes to HomeScreen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailPage(orderId: widget.orderId),
                ),
                (Route<dynamic> route) {
                  // Keep only the first route (HomeScreen) - remove all intermediate routes
                  // This ensures when user taps back, they go to HomeScreen
                  return route.isFirst;
                },
              );
            },
            child: const Text('View Order'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentError() {
    // Close WebView immediately to prevent 404 errors
    Navigator.pop(context); // Close the WebView page

    // Handle payment error
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text(
            'Your payment could not be processed. Please try again or use another card.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                  context); // Close dialog and return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startOrderStatusMonitoring() {
    // Cancel any existing timer
    _orderStatusTimer?.cancel();

    // Check order status every 10 seconds as a fallback
    _orderStatusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _checkOrderStatus();
    });
  }

  Future<void> _checkOrderStatus() async {
    try {
      final order = await _orderDataSource.getOrderById(widget.orderId);

      if (order.paymentStatus.toLowerCase() == 'paid' ||
          order.paymentStatus.toLowerCase() == 'completed') {
        _orderStatusTimer?.cancel();
        _statusCheckTimer?.cancel();
        _handlePaymentSuccess();
      } else if (order.paymentStatus.toLowerCase() == 'failed' ||
          order.paymentStatus.toLowerCase() == 'cancelled') {
        _orderStatusTimer?.cancel();
        _statusCheckTimer?.cancel();
        _handlePaymentError();
      }
    } catch (e) {
      // If we can't check the order status, continue monitoring
    }
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    _orderStatusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show confirmation dialog before closing
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cancel Payment?'),
                content: const Text(
                    'Are you sure you want to cancel this payment? Your order will not be completed.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No, continue'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close payment page
                    },
                    child: const Text('Yes, cancel'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
