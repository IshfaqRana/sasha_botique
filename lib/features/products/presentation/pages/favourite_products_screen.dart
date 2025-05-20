import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/products/domain/entities/products.dart';
import 'package:sasha_botique/features/products/presentation/pages/products_detail_screen.dart';

import '../../../../core/di/injections.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../widgets/product_tile_card.dart';

class FavouriteProductsScreen extends StatefulWidget {
  FavouriteProductsScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteProductsScreen> createState() => _FavouriteProductsScreenState();
}

class _FavouriteProductsScreenState extends State<FavouriteProductsScreen> {
  final favoriteBloc = getIt<FavoriteBloc>();
  late final CartBloc _cartBloc;


  List<Product> favoriteProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartBloc = getIt<CartBloc>();

    favoriteBloc.add(LoadInitialEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrinter('_FavouriteProductsScreenState.didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Favorite',
          style: context.headlineSmall?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        bloc: favoriteBloc,
        listener: (context, state) {
          if (state is LoadedFavProducts) {
            // favoriteProducts = [...favoriteProducts, ...state.favoriteProductList];
            favoriteProducts = [ ...state.favoriteProductList];
          }
        },
        builder: (context, state) {
          if(state is LoadedFavProducts) {
            return favoriteProducts.isEmpty ? Center(child: Text( "Sorry, there are no products in your Wishlist.",style: context.headlineSmall,))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      key: PageStorageKey('favoriteProducts'),
                      padding: const EdgeInsets.all(16),
                      itemCount: favoriteProducts.length,
                      // Replace with actual data length
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return ProductTileCard(
                          product: favoriteProducts[index],
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      product: favoriteProducts[index],
                                    )));
                          },
                        );
                      }),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16),
                //   child: ElevatedButton(
                //     onPressed: () {
                //
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.black,
                //       minimumSize: const Size(double.infinity, 50),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //     child: const Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.shopping_cart, color: Colors.white),
                //         SizedBox(width: 8),
                //         Text(
                //           'ADD ALL TO CART',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            );
          }
          if(state is LoadingFavProductState){
            return const Center(child: CircularProgressIndicator());
          }
          return Center(child: Text( "Sorry, there are no products in your Wishlist.",style: context.headlineSmall,));

        },
      ),
    );
  }
}
