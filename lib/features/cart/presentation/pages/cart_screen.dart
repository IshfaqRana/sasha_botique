import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/cart/domain/entity/cart_item.dart';
import 'package:sasha_botique/features/cart/presentation/bloc/cart_bloc.dart';

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
        title:  Text('My Cart',style: context.headlineSmall?.copyWith(fontSize: 18),),
        centerTitle: true,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        bloc: cartBloc,
        listener: (context, state) {
          if(state is CartLoaded)
            {
              cartItems = [...cartItems,...state.items];
            }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length, // Replace with actual cart items length
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return CartItemCard(
                      name: cartItem.name,
                      collection: cartItem.collection,
                      price: cartItem.price,
                      imageUrl: cartItem.imageUrl,
                      quantity: cartItem.quantity,
                      onRemove: () {
                        // Handle remove item
                      },
                      onQuantityChanged: (newQuantity) {
                        // Handle quantity change
                      },
                    );
                  }
                ),
              ),
              Container(
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
                  onPressed: () {
                    // Handle checkout
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
                        child: const Text(
                          '\$135.96',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}