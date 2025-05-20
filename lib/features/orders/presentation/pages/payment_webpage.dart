import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../payment/domain/entities/payment_method.dart';
import 'order_detail_page.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      cardHolderName = widget.paymentMethodModel?.cardHolderName ?? "";
      cvc = widget.paymentMethodModel?.id ?? "";
      cardNumber = widget.paymentMethodModel?.last4Digits ?? "";
      expiryDate = widget.paymentMethodModel?.expiryDate ?? "";
    });
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
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
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
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

    // Check every second for payment status changes
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      controller.runJavaScriptReturningResult('''
        (function() {
          const pageText = document.body.innerText || '';
          const h1Text = document.querySelector('h1')?.innerText || '';
          
          // Check for success indicators
          if (pageText.includes('Payment successful') || 
              h1Text.includes('Payment successful')) {
            return 'success';
          }
          
          // Check for failure indicators
          if (pageText.includes('Something went wrong') || 
              pageText.includes('3DS Verification failed') ||
              pageText.includes('Uh oh!')) {
            return 'error';
          }
          
          return 'pending';
        })()
      ''').then((result) {
        String status = result.toString().replaceAll('"', '');

        if (status == 'success') {
          timer.cancel();
          // Handle success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailPage(orderId: widget.orderId),
            ),
          );
        } else if (status == 'error') {
          timer.cancel();
          // Handle error
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Payment Failed'),
              content: const Text('Your payment could not be processed. Please try again or use another card.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to previous screen
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
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
                    'Are you sure you want to cancel this payment? Your order will not be completed.'
                ),
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