import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/cart/domain/entity/cart_item.dart';
import 'package:sasha_botique/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sasha_botique/shared/widgets/auth_required_dialog.dart';

import '../../../orders/presentation/pages/checkout_page.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartBloc = getIt<CartBloc>();
  List<CartItem> cartItems = [];

  @override
  void initState() {
    cartBloc.add(LoadCartItems());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'My Cart',
          style: context.headlineSmall?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        bloc: cartBloc,
        listener: (context, state) {
          print('_CartScreenState.build: ${state}');
          if (state is CartLoaded) {
            print('_CartScreenState.build: items ${state.items.length}');

            cartItems = [...state.items];
          }
        },
        builder: (context, state) {
          if (state is CartLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      key: PageStorageKey('cartProducts'),
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length,
                      // Replace with actual cart items length
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return CartItemCard(
                          name: cartItem.name,
                          collection: cartItem.collection,
                          price: cartItem.price,
                          imageUrl: cartItem.imageUrl,
                          quantity: cartItem.quantity,
                          onRemove: () {
                            cartBloc.add(RemoveCartItem(cartItem.id));
                          },
                          onQuantityChanged: (newQuantity) {
                            cartBloc.add(UpdateCartItemQuantity(
                                cartItemId: cartItem.id,
                                quantity: newQuantity));
                          },
                        );
                      }),
                ),
                SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final isAuthenticated = await AuthRequiredMixin.checkAuthAndPrompt(
                            context,
                            title: 'Login Required',
                            message: 'You need to login to proceed with checkout.',
                          );

                          if (isAuthenticated) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CheckoutPage()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'GO TO CHECKOUT',
                              style: TextStyle(color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '\$${state.total}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            );
          }
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
              child: Text(
            "Sorry, there are no products in cart.",
            style: context.headlineSmall,
          ));
        },
      ),
    );
  }
}
