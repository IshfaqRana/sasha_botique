import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/products/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:sasha_botique/shared/widgets/cache_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injections.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/widgets/favorite_icon_widget.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/entities/products.dart';
import '../bloc/product_detail/product_details_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailBloc _productDetailBloc;
  late final FavoriteBloc _wishlistBloc;
  late final CartBloc _cartBloc;

  int _selectedSizeIndex = 0;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _productDetailBloc = getIt<ProductDetailBloc>();
    _wishlistBloc = getIt<FavoriteBloc>();
    _cartBloc = getIt<CartBloc>();

    _productDetailBloc.add(FetchProductDetail(productId: widget.product.id));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      bloc: _wishlistBloc,
      builder: (context, state2) {
        bool isLoading  = false;
        if(state2 is LoadedFavProducts){
          isLoading = state2.isLoading;
        }
        return LoadingOverlay(
          isLoading: isLoading,
          child: Scaffold(
            body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              bloc: _productDetailBloc,
              builder: (context, state) {
                if (state is ProductDetailLoading) {
                  return SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAppBar(null),
                          SizedBox(
                            height: 300,
                          ),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ));
                } else if (state is ProductDetailLoaded) {
                  final product = state.product;
                  return _buildProductDetail(product);
                } else if (state is ProductDetailError) {
                  return SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAppBar(null),
                          SizedBox(
                            height: 300,
                          ),
                          Center(child: Text('Error: ${state.message}'))
                        ],
                      ));
                }
                return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildAppBar(null),
                        SizedBox(
                          height: 300,
                        ),
                        const Center(child: Text('Something went wrong')),
                      ],
                    ));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductDetail(Product product) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(product),
                  _buildImageSlider(product),
                  _buildProductInfo(product),
                  _buildSizeSelector(product),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Show more details
                          },
                          child: Text(
                            'detail',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAddToCartButton(product),
        ],
      ),
    );
  }

  Widget _buildAppBar(Product? product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          product == null
              ? SizedBox.shrink()
              : FavouriteIconWidget(product: product),
        ],
      ),
    );
  }

  Widget _buildImageSlider(Product product) {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: product.imageUrl.isEmpty ? Center(child: Text("Sorry, No images provided against this product",style: context.headlineSmall,),) : PageView.builder(
            controller: _pageController,
            itemCount: product.imageUrl.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedImage(
                imageUrl: product.imageUrl[index],
                placeholder: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 208,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ),
                errorWidget: Icon(Icons.error),
                width: 300,
                height: 200,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        if (product.imageUrl.length > 1)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                  onPressed: _currentImageIndex > 0
                      ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
                  onPressed: _currentImageIndex < product.imageUrl.length - 1
                      ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                      : null,
                ),
              ],
            ),
          ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              product.imageUrl.length,
                  (index) =>
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index ? Colors.black : Colors.grey[300],
                    ),
                  ),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   right: 10,
        //   child: IconButton(
        //     icon: const Icon(Icons.share_outlined),
        //     onPressed: () {
        //       // Share product
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildProductInfo(Product product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              product.brandName,
              style: context.bodyLarge
          ),
          const SizedBox(height: 4),
          Text(
              product.name,
              style: context.headlineMedium
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Star rating
              // Row(
              //   children: List.generate(
              //     5,
              //     (index) => Icon(
              //       index < 4 ? Icons.star : Icons.star_half,
              //       color: Colors.amber,
              //       size: 18,
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 4),
              // const Text(
              //   '(4.5)',
              //   style: TextStyle(color: Colors.grey, fontSize: 14),
              // ),
              Text(
                "Price",
                style: context.titleMedium,
              ),
              const Spacer(),
              Text(
                '\$${product.price.toStringAsFixed(2)} USD',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SELECT SIZE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              product.sizes.length,
                  (index) =>
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSizeIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _selectedSizeIndex == index ? Colors.black : Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          product.sizes[index],
                          style: TextStyle(
                            color: _selectedSizeIndex == index ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(Product product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          final selectedSize = product.sizes[_selectedSizeIndex];
          _cartBloc.add(AddProductToCart(
            product: product,
            quantity: 1,
            size: selectedSize,
          ));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added to cart'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_bag_outlined),
            SizedBox(width: 8),
            Text(
              'ADD TO CART',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
