import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/products/presentation/bloc/search/search_bloc.dart';
import 'package:sasha_botique/features/products/presentation/pages/product_list.dart';
import 'package:sasha_botique/features/products/presentation/pages/products_detail_screen.dart';
import 'package:sasha_botique/features/products/presentation/pages/search_result_screen.dart';

import '../../../../core/di/injections.dart';
import '../../../../core/helper/debouncer.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/entities/products.dart';
import '../widgets/empty_product_screen.dart';
import '../widgets/product_tile_card.dart';

class SearchScreen extends StatefulWidget {
  final List<Product> popularProducts;
  SearchScreen({Key? key, required this.popularProducts}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchProductsController = TextEditingController();
  List<Product> foundedProduct = [];
  List<Product> popularProducts = <Product>[];

  final searchBloc = getIt<SearchBloc>();
  final debouncer = Debouncer(milliseconds: 500);
  FocusNode focusNode = FocusNode();
  Map<String, dynamic> filters = Map.from({});

  void search(String query) {
    setState(() {
      foundedProduct = [];
    });
    debouncer.run(() {
      if (query.length > 0) {
        searchBloc.add(SearchProductsEvent(query, filters));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){

    popularProducts = [...widget.popularProducts];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Find Products',
          style: context.headlineSmall?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SearchBloc, SearchState>(
        bloc: searchBloc,
        listener: (context, state) {
          if (state is FoundProductsState) {
            foundedProduct = [...state.foundedProductList];
            print(foundedProduct.length);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomTextField(
                  controller: searchProductsController,
                  label: 'Search here...',
                  focusNode: focusNode,
                  prefixIcon: Icon(Icons.search),
                  onChange: (text) {
                    search(text);
                    print(text);
                  },
                ),
              ),
              state is SearchingProductState ? loadingState() : Expanded(child: buildBody(state)),
            ],
          );
        },
      ),
    );
  }

  Widget loadingState() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
  Widget buildBody(SearchState state) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: Column(
        children: [
          if (!(state.showResults && !focusNode.hasFocus) && foundedProduct.isEmpty && searchProductsController.text.isNotEmpty && searchProductsController.text.length > 1)
            SizedBox(
              height: 50,
            ),
          if (!(state.showResults && !focusNode.hasFocus) && foundedProduct.isEmpty && searchProductsController.text.isNotEmpty && searchProductsController.text.length > 1)
            Center(
                child: Text(
              "Sorry, No products found.",
              style: context.headlineSmall,
            )),
          if (!(state.showResults && !focusNode.hasFocus) && foundedProduct.isEmpty && searchProductsController.text.isNotEmpty && searchProductsController.text.length > 1)
            SizedBox(
              height: 50,
            ),
          if (foundedProduct.isNotEmpty) _buildFilterBar(foundedProduct.length, searchProductsController.text),
      
          // if (!(state.showResults && !focusNode.hasFocus) && foundedProduct.isEmpty)
          if (foundedProduct.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Popular Products",
                    style: context.headlineSmall,
                  )
                ],
              ),
            ),
          // state.showResults && !focusNode.hasFocus
          //     ?
          foundedProduct.isEmpty
              ? AnimatedContainer(
              duration: Duration(milliseconds: 500),child: showPopularProducts())
              : SearchResultsScreen(
                  productList: foundedProduct,
                  onProductTap: (product) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: product,
                            )));
                  },
                )
          // : initialScreen(),
        ],
      ),
    );
  }

  // Widget initialScreen() => foundedProduct.isNotEmpty ? suggestedProducts() : categoriesWidget();
  Widget initialScreen() => foundedProduct.isNotEmpty ? suggestedProducts() : showPopularProducts();

  Widget suggestedProducts() {
    return Expanded(
      child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: foundedProduct.length, // Replace with actual data length
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ProductTileCard(
              product: foundedProduct[index],
              onTap: () {},
            );
          }),
    );
  }

  Widget categoriesWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilterSection(
              'All Brands',
              ['Zara', 'H&M', 'Uniqlo'],
            ),
            _buildFilterSection(
              'Winter Categories',
              ['Jackets', 'Sweaters', 'Boots'],
            ),
            _buildFilterSection('Summer Categories', []),
            _buildFilterSection('Stitched', []),
            _buildFilterSection('Unstitched', []),
            _buildFilterSection('Shirts', []),
            _buildFilterSection('Bottoms', []),
            _buildFilterSection('Dupattas', []),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> children) {
    return ExpansionTile(
      title: Text(title),
      children: children
          .map((child) => ListTile(
                title: Text(child),
                onTap: () {
                  // Handle category selection
                },
              ))
          .toList(),
    );
  }

  Widget _buildFilterBar(int length, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text('$length Items found for "$text"'),
          // const Spacer(),
          // PopupMenuButton<String>(
          //   itemBuilder: (context) => [
          //     'Featured',
          //     'Best Selling',
          //     'A-Z',
          //     'Z-A',
          //     'Price High-Low',
          //     'Price Low-High',
          //     'Date Old-New',
          //     'Date New-Old',
          //   ]
          //       .map((option) => PopupMenuItem(
          //             value: option,
          //             child: Text(option),
          //           ))
          //       .toList(),
          //   onSelected: (value) {
          //     // Implement sorting logic
          //   },
          // ),
        ],
      ),
    );
  }

  Widget showPopularProducts() {
    return _productListView(context);
  }

  Widget _productListView(
    BuildContext context,
  ) {
    return popularProducts.isEmpty
        ? EmptyProductList()
        : Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: ProductList(
                products: popularProducts,
                isGridView: true,
                hasMoreData: true,
                isLoading: false,
                onLoadMore: () {
                  // if (!state.isLoadingMore && hasMoreData) {
                  //   homeBloc.add(
                  //     LoadMoreProducts(ProductCategory.popular),
                  //   );
                  // }
                },
                onProductTap: (product) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ProductDetailScreen(
                                product: product,
                              )));
                },
                onInitial: () {
                  // homeBloc.add(ChangeCategory(ProductCategory.popular));
                },
              ),
            ),
          );
  }
}
