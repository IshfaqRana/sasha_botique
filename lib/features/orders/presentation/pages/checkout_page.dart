// lib/features/order/presentation/pages/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/toast_extension.dart';
import 'package:sasha_botique/features/orders/domain/entities/create_order_params.dart';
import 'package:sasha_botique/features/orders/presentation/pages/payment_webpage.dart';
import 'package:sasha_botique/features/payment/data/data_model/payment_method_model.dart';
import 'package:sasha_botique/features/payment/presentation/pages/payment_methods_screen.dart';
import 'package:sasha_botique/features/products/data/models/product_model.dart';
import 'package:sasha_botique/features/profile/data/models/user_address_reponse_model.dart';
import 'package:sasha_botique/features/profile/presentation/bloc/user_profile/user_profile_bloc.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../payment/presentation/bloc/payment_bloc.dart';
import '../../../profile/presentation/bloc/user_address/user_address_bloc.dart';
import '../../../profile/presentation/pages/user_address_screen.dart';
import '../../domain/entities/promo_code_entity.dart';
import '../bloc/order_bloc.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int? selectedAddressIndex;
  int? selectedPaymentIndex;
  int discountedAmount = 0;
  String? promoCodeError;
  PromoCode? appliedPromoCode;
  double discountAmount = 0.0;
  final TextEditingController promoCodeController = TextEditingController();
  late final OrderBloc orderBloc;
  late final AddressBloc addressBloc;
  late final ProfileBloc profileBloc;
  late final PaymentBloc paymentBloc;
  late final CartBloc cartBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderBloc = getIt<OrderBloc>();
    profileBloc = getIt<ProfileBloc>();
    addressBloc = getIt<AddressBloc>();
    paymentBloc = getIt<PaymentBloc>();
    cartBloc = getIt<CartBloc>();
    orderBloc.add(GetPromoCodesEvent());
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<OrderBloc, OrderState>(
            bloc: orderBloc,
            listener: (context, state) {
              if (state is OrderCreateSuccess) {
                // Navigate to payment web view
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentWebView(
                      paymentUrl: state.paymentUrl,
                      orderId: state.orderId,
                    ),
                  ),
                );
              } else if (state is OrderError) {
                context.showToast(state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<CartBloc, CartState>(
          bloc: cartBloc,
          builder: (context, cartState) {
            if (cartState is CartLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Delivery Address Section
                          _buildAddressSection(),
                          const SizedBox(height: 20),

                          // Payment Method Section
                          _buildPaymentMethodSection(),
                          const SizedBox(height: 20),

                          // Promo Code Section
                          _buildPromoCodeSection(orderBloc.state),
                          const SizedBox(height: 20),

                          // Order Summary
                          _buildOrderSummary(cartState),
                        ],
                      ),
                    ),
                  ),
                  // Place Order Button
                  _buildPlaceOrderButton(cartState),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
             TextButton(
               child: Text(
                 'View All',
                 style: TextStyle(fontSize: 16),
               ),
               onPressed: () {
                 Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(
                       builder: (_) => AddressScreen(),
                     ));
               },
             )
           ],
         ),

        const SizedBox(height: 10),
        BlocBuilder<AddressBloc, AddressState>(
          bloc: addressBloc,
          builder: (context, state) {
            if (state is AddressesLoaded) {
              if (state.addresses.isEmpty) {
                return const Text('No saved addresses. Please add an address.');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.addresses.length,
                itemBuilder: (context, index) {
                  final address = state.addresses[index];
                  return RadioListTile(
                    value: index,
                    groupValue: selectedAddressIndex,
                    title: Text('${address.street}'),
                    subtitle: Text(
                      '${address.city}, ${address.postalCode}, ${address.country}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedAddressIndex = value as int;
                      });
                    },
                  );
                },
              );
            } else if (state is AddressLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Text('Failed to load addresses');
            }
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              child: Text(
                'View All',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentMethodsScreen(),
                    ));
              },
            )
          ],
        ),
        const SizedBox(height: 10),
        BlocBuilder<PaymentBloc, PaymentState>(
          bloc: paymentBloc,
          builder: (context, state) {
            if (state is PaymentMethodsLoaded) {
              if (state.paymentMethods.isEmpty) {
                return const Text('No saved payment methods. Please add a payment method.');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = state.paymentMethods[index];
                  return RadioListTile(
                    value: index,
                    groupValue: selectedPaymentIndex,
                    title: Text(
                      '${paymentMethod.type} (**** ${paymentMethod.last4Digits})',
                    ),
                    subtitle: Text('Expires: ${paymentMethod.expiryDate}'),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentIndex = value as int;
                      });
                    },
                  );
                },
              );
            } else if (state is PaymentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Text('Failed to load payment methods');
            }
          },
        ),
      ],
    );
  }

  Widget _buildPromoCodeSection(OrderState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Promo Code',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: promoCodeController,
          enabled: appliedPromoCode == null,
          decoration: InputDecoration(
            hintText: 'Enter promo code',
            errorText: promoCodeError,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: appliedPromoCode != null
                ? IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: clearPromoCode,
            )
                : state is PromoCodesLoading
                ? Container(
              width: 80,
              alignment: Alignment.center,
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : TextButton(
              onPressed: state is PromoCodesLoaded
                  ? () => validatePromoCode(state.promoCodes)
                  : null,
              child: const Text('Apply'),
            ),
          ),
        ),
        if (appliedPromoCode != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Discount applied: ${appliedPromoCode!.discount}% off',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        if (state is PromoCodesError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Could not load promo codes: ${state.message}',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }


  Widget _buildOrderSummary(CartLoaded cartState) {
    final totalAmount = cartState.total;
    // Example discount calculation (this should come from your business logic)
    final discountAmount = promoCodeController.text.isNotEmpty ? totalAmount * 0.1 : 0.0;
    final finalAmount = totalAmount - discountAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSummaryItem('Subtotal', '\$${totalAmount.toStringAsFixed(2)}'),
                _buildSummaryItem('Discount', '-\$${discountAmount.toStringAsFixed(2)}'),
                const Divider(),
                _buildSummaryItem(
                  'Total',
                  '\$${finalAmount.toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(CartLoaded cartState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      // height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(8),
          // ),
        ),
        onPressed: () {
          if (selectedAddressIndex == null) {
            context.showToast('Please select a delivery address');
            return;
          }

          if (selectedPaymentIndex == null) {
            context.showToast('Please select a payment method');
            return;
          }

          final addressState = addressBloc.state;
          final paymentState = paymentBloc.state;
          final profileState = profileBloc.state;

          if (addressState is AddressesLoaded && paymentState is PaymentMethodsLoaded && profileState is ProfileLoaded) {
            final selectedAddress = addressState.addresses[selectedAddressIndex!];
            final selectedPayment = paymentState.paymentMethods[selectedPaymentIndex!];

            // Calculate final amount
            final totalAmount = cartState.total;
            final discountAmount = promoCodeController.text.isNotEmpty ? totalAmount * 0.1 : 0.0;

            // Create order params
            final orderParams = {
              'items': cartState.items
                  .map((item) => {
                        '_id': item.id,
                        'price': item.price,
                        // 'quantity': item.quantity,
                      })
                  .toList(),
              'totalAmount': totalAmount - discountAmount,
              'currency': 'USD', // Or fetch from settings
              'paymentMethod': {
                'type': selectedPayment.type,
                'last4_digits': selectedPayment.last4Digits,
                'card_holder_name': selectedPayment.cardHolderName,
                'expiry_date': selectedPayment.expiryDate,
                'country': selectedPayment.country,
                'is_default': selectedPayment.isDefault,
              },
              'deliveryAddress': {
                'full_name': "${profileState.user.firstName} ${profileState.user.lastName}",
                'address_line_1': selectedAddress.street,
                'city': selectedAddress.city,
                'postal_code': selectedAddress.postalCode,
                'country': selectedAddress.country,
                'phone_number': profileState.user.mobileNo,
                'is_default': selectedAddress.isDefault,
              },
              'promoCode': promoCodeController.text,
              'email': profileState.user.email, // Get from user profile
            };
            CreateOrderParams orderParam = CreateOrderParams(items: cartState.items.map((item) => ProductModel(id: item.id, isBasics: false, name: item.name, price: item.price, category: item.collection,)).toList(), totalAmount: totalAmount, currency: "USD",
                paymentMethod: PaymentMethodModel(id: "id", type: selectedPayment.type, last4Digits: selectedPayment.last4Digits, cardHolderName: selectedPayment.cardHolderName, expiryDate: selectedPayment.expiryDate, country: selectedPayment.country, isDefault: selectedPayment.isDefault),
                deliveryAddress: UserAddressModel(street: selectedAddress.street, city: selectedAddress.city, state: selectedAddress.state, postalCode: selectedAddress.postalCode, country: selectedAddress.country, isDefault: selectedAddress.isDefault),
                promoCode:promoCodeController.text,
                email: profileState.user.email,
                name: "${profileState.user.firstName} ${profileState.user.lastName}",
                phone: profileState.user.mobileNo,
            );

            // Dispatch create order event
            orderBloc.add(CreateOrderEvent(params: orderParam));
          }
        },
        child: const Text(
          'Place Order',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
  void validatePromoCode(List<PromoCode> availableCodes) {
    final enteredCode = promoCodeController.text.trim().toUpperCase();

    if (enteredCode.isEmpty) {
      setState(() {
        promoCodeError = 'Please enter a promo code';
        appliedPromoCode = null;
        discountAmount = 0.0;
      });
      return;
    }

    // Find matching promo code
    final matchingCode = availableCodes.where((code) =>
    code.code == enteredCode &&
        code.isActive &&
        code.expiresAt.isAfter(DateTime.now())
    ).toList();

    if (matchingCode.isEmpty) {
      setState(() {
        promoCodeError = 'Invalid or expired promo code';
        appliedPromoCode = null;
        discountAmount = 0.0;
      });
    } else {
      final promoCode = matchingCode.first;
      // final newDiscountAmount = (orderTotal * promoCode.discount) / 100;

      setState(() {
        promoCodeError = null;
        appliedPromoCode = promoCode;
        discountAmount = promoCode.discount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code applied! You save Amount ${discountAmount.toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void clearPromoCode() {
    setState(() {
      promoCodeController.clear();
      promoCodeError = null;
      appliedPromoCode = null;
      discountAmount = 0.0;
    });
  }
}
