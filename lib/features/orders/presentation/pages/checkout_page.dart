// lib/features/order/presentation/pages/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Temporarily commented out
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/core/extensions/toast_extension.dart';
import 'package:sasha_botique/features/orders/domain/entities/create_order_params.dart';
import 'package:sasha_botique/features/orders/presentation/pages/payment_webpage.dart';
// import 'package:sasha_botique/features/payment/data/data_model/payment_method_model.dart'; // Temporarily commented out
// import 'package:sasha_botique/features/payment/presentation/pages/payment_methods_screen.dart'; // Temporarily commented out
import 'package:sasha_botique/features/products/data/models/product_model.dart';
import 'package:sasha_botique/features/profile/data/models/user_address_reponse_model.dart';
import 'package:sasha_botique/features/profile/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:sasha_botique/shared/widgets/auth_required_dialog.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../payment/presentation/bloc/payment_bloc.dart';
import '../../../profile/presentation/bloc/user_address/user_address_bloc.dart';
import '../../../profile/presentation/widgets/address_bottom_sheet.dart';
// import '../../../profile/presentation/pages/user_address_screen.dart'; // Temporarily commented out
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
    addressBloc = getIt<AddressBloc>()..add(GetAddressesEvent());
    paymentBloc = getIt<PaymentBloc>();
    cartBloc = getIt<CartBloc>();
    orderBloc.add(GetPromoCodesEvent());
    final addressState = addressBloc.state;
    if (addressState is AddressesLoaded) {
      if (addressState.addressList.isNotEmpty) {
        int index = addressState.addressList
            .indexWhere((element) => element.isDefault == true);
        print("index: $index");
        setState(() {
          selectedAddressIndex = index;
        });
      }
    }
    final paymentState = paymentBloc.state;
    if (paymentState is PaymentMethodsLoaded) {
      if (paymentState.paymentMethods.isNotEmpty) {
        int index = paymentState.paymentMethods
            .indexWhere((element) => element.isDefault == true);
        print("index: $index");
        setState(() {
          selectedPaymentIndex = index;
        });
      }
    }
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
        leading: const BackButton(),
        title: Text(
          'Check Out',
          style: context.headlineSmall?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<OrderBloc, OrderState>(
            bloc: orderBloc,
            listener: (context, state) {
              if (state is OrderCreateSuccess) {
                cartBloc.add(ClearCart());
                // Navigate to payment web view - payment method handled by Stripe
                // final paymentState = paymentBloc.state;
                // final selectedPayment =
                //     paymentState.paymentMethods[selectedPaymentIndex!];

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentWebView(
                      paymentUrl: state.paymentUrl,
                      orderId: state.orderId,
                      // paymentMethodModel: selectedPayment, // Temporarily commented out
                    ),
                  ),
                );
              } else if (state is OrderError) {
                context.showToast(state.message);
              }
            },
          ),
          BlocListener<AddressBloc, AddressState>(
            bloc: addressBloc,
            listener: (context, state) {
              if (state is AddressesLoaded && state.addressList.isNotEmpty) {
                // Auto-select the newly added address (last in the list)
                // Or select the default address if one exists
                int defaultIndex = state.addressList
                    .indexWhere((element) => element.isDefault == true);

                if (defaultIndex != -1) {
                  // If there's a default address, select it
                  setState(() {
                    selectedAddressIndex = defaultIndex;
                  });
                } else if (selectedAddressIndex == null) {
                  // If no address was selected before and no default, select the last one (newly added)
                  setState(() {
                    selectedAddressIndex = state.addressList.length - 1;
                  });
                }
              } else if (state is AddressError) {
                // Show error message (e.g., duplicate address)
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

                          // Payment Method Section - Temporarily commented out
                          // _buildPaymentMethodSection(),
                          // const SizedBox(height: 20),

                          // Promo Code Section
                          _buildPromoCodeSection(orderBloc.state),
                          const SizedBox(height: 20),

                          // Order Summary
                          _buildOrderSummary(cartState),
                        ],
                      ),
                    ),
                  ),
                  // Place Order Button wrapped in SafeArea to keep visible
                  SafeArea(
                      top: false, child: _buildPlaceOrderButton(cartState)),
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
            // TextButton(
            //   child: Text(
            //     'View All',
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   onPressed: () {
            //     Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => AddressScreen(),
            //         ));
            //   },
            // )
          ],
        ),
        const SizedBox(height: 10),
        BlocConsumer<AddressBloc, AddressState>(
          bloc: addressBloc,
          listener: (context, state) {
            // print("in listener");
            // if (state is AddressesLoaded) {
            //   if (state.addresses.isNotEmpty) {
            //     int index = state.addresses.indexWhere((element) => element.isDefault == true);
            //     print("index: $index");
            //     setState(() {
            //       selectedAddressIndex = index;
            //     });
            //   }
            // }
          },
          builder: (context, state) {
            if (state is AddressesLoaded) {
              if (state.addressList.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.location_off, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'No saved addresses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Please add a delivery address to continue',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showAddressBottomSheet(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Address'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.addressList.length,
                    itemBuilder: (context, index) {
                      final address = state.addressList[index];
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
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _showAddressBottomSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
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
            // TextButton(
            //   child: Text(
            //     'View All',
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   onPressed: () {
            //     Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => PaymentMethodsScreen(),
            //         ));
            //   },
            // )
          ],
        ),
        const SizedBox(height: 10),
        BlocBuilder<PaymentBloc, PaymentState>(
          bloc: paymentBloc,
          builder: (context, state) {
            if (state is PaymentMethodsLoaded) {
              if (state.paymentMethods.isEmpty) {
                return const Text(
                    'No saved payment methods. Please add a payment method.');
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Promo Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (appliedPromoCode != null)
              TextButton(
                child: Text(
                  'Remove Promo Code',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  promoCodeController.clear();
                  setState(() {
                    promoCodeError = null;
                    appliedPromoCode = null;
                    discountAmount = 0.0;
                  });
                },
              )
          ],
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
                ? SizedBox()
                // IconButton(
                //         icon: Icon(Icons.close, color: Colors.red),
                //         onPressed: () {
                //           print("on tap");
                //
                //         },
                //       )
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
                        child: const Text(
                          'Apply',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
          ),
        ),
        if (appliedPromoCode != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Discount applied: ${appliedPromoCode?.discount ?? 0}% off',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
    final discountAmount = promoCodeController.text.isNotEmpty
        ? totalAmount * ((appliedPromoCode?.discount ?? 0) / 100)
        : 0.0;
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
                _buildSummaryItem(
                    'Subtotal', '\$${totalAmount.toStringAsFixed(2)}'),
                _buildSummaryItem(
                    'Discount', '-\$${discountAmount.toStringAsFixed(2)}'),
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
          // Validate cart has items
          if (cartState.items.isEmpty) {
            context.showToast('Please select at least one item before proceeding.');
            return;
          }

          if (selectedAddressIndex == null) {
            context.showToast('Please select a delivery address');
            return;
          }

          // Payment method validation temporarily commented out
          // if (selectedPaymentIndex == null) {
          //   context.showToast('Please select a payment method');
          //   return;
          // }

          final addressState = addressBloc.state;
          // final paymentState = paymentBloc.state; // Temporarily commented out
          final profileState = profileBloc.state;

          if (addressState is AddressesLoaded &&
              profileState is ProfileLoaded) {
            final selectedAddress =
                addressState.addressList[selectedAddressIndex!];
            // Payment method temporarily commented out
            // final selectedPayment =
            //     paymentState.paymentMethods[selectedPaymentIndex!];

            // Calculate final amount
            final totalAmount = cartState.total;
            final discountAmount = promoCodeController.text.isNotEmpty
                ? totalAmount * ((appliedPromoCode?.discount ?? 0) / 100)
                : 0.0;

            // Debug: Print cart items and total
            print('=== CART DEBUG ===');
            for (var item in cartState.items) {
              print(
                  'Item: ${item.name}, Price: \$${item.price}, Quantity: ${item.quantity}, Subtotal: \$${(item.price * item.quantity).toStringAsFixed(2)}');
            }
            print('Cart Total: \$${totalAmount.toStringAsFixed(2)}');
            print(
                'Final Amount (after discount): \$${(totalAmount - discountAmount).toStringAsFixed(2)}');
            print('==================');

            // Note: orderParams is not used as we use CreateOrderParams instead
            CreateOrderParams orderParam = CreateOrderParams(
              items: cartState.items
                  .map((item) => ProductModel(
                        id: item.productId,
                        isBasics: false,
                        name: item.name,
                        price: item.price,
                        category: item.collection,
                        quantity: item.quantity,
                      ))
                  .toList(),
              totalAmount: totalAmount - discountAmount,
              currency: "GBP",
              // Payment method temporarily commented out - will be handled by Stripe
              // paymentMethod: PaymentMethodModel(
              //     id: "id",
              //     type: selectedPayment.type,
              //     last4Digits: selectedPayment.last4Digits,
              //     cardHolderName: selectedPayment.cardHolderName,
              //     expiryDate: selectedPayment.expiryDate,
              //     country: selectedPayment.country,
              //     isDefault: selectedPayment.isDefault),
              deliveryAddress: UserAddressModel(
                  name: selectedAddress.name,
                  instruction: selectedAddress.instruction,
                  phone: selectedAddress.phone,
                  street: selectedAddress.street,
                  city: selectedAddress.city,
                  state: selectedAddress.state,
                  postalCode: selectedAddress.postalCode,
                  country: selectedAddress.country,
                  isDefault: selectedAddress.isDefault),
              promoCode: promoCodeController.text.isEmpty
                  ? " "
                  : promoCodeController.text.toUpperCase(),
              discountAmount: discountAmount,
              email: profileState.user.email,
              name:
                  "${profileState.user.firstName} ${profileState.user.lastName}",
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

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressFormBottomSheet(
        onSubmit: (newAddress) {
          addressBloc.add(AddAddressEvent(address: newAddress));
          Navigator.pop(context);
          // Reload addresses to ensure the new one appears immediately
          Future.delayed(Duration(milliseconds: 500), () {
            addressBloc.add(GetAddressesEvent());
          });
        },
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
    final matchingCode = availableCodes
        .where((code) =>
            code.code == enteredCode &&
            code.isActive &&
            code.expiresAt.isAfter(DateTime.now()))
        .toList();

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
          content: Text(
              'Promo code applied! You save Amount ${discountAmount.toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void clearPromoCode() {
    print("on tap");
    promoCodeController.clear();
    setState(() {
      promoCodeError = null;
      appliedPromoCode = null;
      discountAmount = 0.0;
    });
  }
}
