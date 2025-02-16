import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/cart/presentation/pages/cart_screen.dart';
import 'package:sasha_botique/features/products/presentation/pages/search_screen.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

import '../../../../core/di/injections.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/utils/product_category_enum.dart';
import '../../../../core/utils/product_category_mapper.dart';
import '../../domain/entities/products.dart';
import '../bloc/home/home_bloc.dart';
import '../widgets/custom_drawar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/empty_product_screen.dart';
import 'product_list.dart';
import 'product_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final homeBloc = getIt<HomeBloc>();
  List<Product> popularProducts = <Product>[];
  List<Product> newArrivalProducts = <Product>[];
  List<Product> saleProducts = <Product>[];
  List<Product> womenProducts = <Product>[];
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    homeBloc.add(LoadInitialProducts(ProductCategory.popular));
    homeBloc.add(LoadInitialProducts(ProductCategory.sale));
    homeBloc.add(LoadInitialProducts(ProductCategory.all));
    homeBloc.add(LoadInitialProducts(ProductCategory.newArrival));
    homeBloc.add(LoadInitialProducts(ProductCategory.gender, gender: "women"));
    homeBloc.add(ChangeCategory(ProductCategory.popular));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "SASHA'S",
          style: context.headlineMedium,
        ),
        backgroundColor: context.colors.whiteColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => CartScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchScreen()));
            },
          ),
          // ThemeToggleButton(),
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: context.titleSmall?.copyWith(color: context.colors.blackWhite),
          unselectedLabelStyle: context.titleSmall?.copyWith(color: context.colors.grey),
          tabs: const [
            Tab(
              text: 'Popular',
            ),
            Tab(text: 'Brands'),
            Tab(text: 'Womens'),
            Tab(text: 'Sale'),
          ],
        ),
      ),
      endDrawer: const CustomDrawer(),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is HomeError) {
            debugPrinter('_HomePageState.build: STATE ============== HOME ERROR STATE');
            _showDeleteDialog(context, state);
          }
          if (state is HomeLoaded) {
            // debugPrint('Active Filters in Listener: ${state.activeFilters}');

            // print('_HomePageState.build: Current Category: ${state.currentCategory.toString()}');

            popularProducts = [...popularProducts, ...state.categoryProducts[CategoryMapper.getCategory(ProductCategory.popular)] ?? []];
            womenProducts = [...womenProducts, ...state.categoryProducts[CategoryMapper.getCategory(ProductCategory.gender)] ?? []];
            saleProducts = [...saleProducts, ...state.categoryProducts[CategoryMapper.getCategory(ProductCategory.sale)] ?? []];
            newArrivalProducts = [...newArrivalProducts, ...state.categoryProducts[CategoryMapper.getCategory(ProductCategory.newArrival)] ?? []];
            // debugPrinter('_HomePageState.build: popularProducts Products: ${popularProducts.length}');
            setState(() {
              hasMoreData = state.hasMoreProducts[CategoryMapper.getCategory(state.currentCategory)] ?? true;
            });
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return state.previousState != null ? _productListView(context, state.previousState as HomeLoaded) : Center(child: Text(state.message));
          }

          if (state is HomeLoaded) {
            return _productListView(context, state);
          }

          return EmptyProductList();
        },
      ),
    );
  }

  Widget _productListView(BuildContext context, HomeLoaded state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.filter_list,
                ),
                label: Text(
                  'FILTER & SORT',
                  style: context.headlineSmall,
                ),
                onPressed: () {
                  // debugPrint('Active Filters: ${state.activeFilters}');

                  // state.activeFilters.forEach((key, value) {
                  //   debugPrint('Filters into the Home Screen - $key: $value');
                  // });
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => FilterBottomSheet(
                      initialFilters: state.activeFilters,
                      currentSortOption: state.currentSortOption,

                      onApplyFilters: (filters, sortOption) {
                        clearCurrentList(state.currentCategory);
                        homeBloc.add(
                          ApplyFilters(filters: filters, sortOption: sortOption),
                        );
                      },
                      onCancelFilter: (filters, sortOption){
                        clearCurrentList(state.currentCategory);
                        homeBloc.add(
                          ApplyFilters(filters: filters, sortOption: sortOption),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  );

                  // Show filter bottom sheet
                },
              ),
              const Spacer(),
              IconButton(
                icon: Icon(state.isGridView ? Icons.grid_view : Icons.view_list),
                onPressed: () {
                  homeBloc.add(ToggleViewMode(!state.isGridView));
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              popularProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: popularProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreData,
                      isLoading: state.isLoadingMore,
                      onLoadMore: () {
                        if (!state.isLoadingMore && hasMoreData) {
                          homeBloc.add(
                            LoadMoreProducts(ProductCategory.popular),
                          );
                        }
                      },
                      onProductTap: (product) {},
                      onInitial: () {
                        homeBloc.add(ChangeCategory(ProductCategory.popular));
                      },
                    ),
              newArrivalProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: newArrivalProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreData,
                isLoading: state.isLoadingMore,

                onLoadMore: () {
                        if (!state.isLoadingMore && hasMoreData) {
                          homeBloc.add(
                            LoadMoreProducts(ProductCategory.newArrival),
                          );
                        }
                      },
                      onProductTap: (product) {},
                      onInitial: () {
                        homeBloc.add(ChangeCategory(ProductCategory.newArrival));
                      },
                    ),
              womenProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: womenProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreData,
                isLoading: state.isLoadingMore,

                onLoadMore: () {
                        if (!state.isLoadingMore && hasMoreData) {
                          homeBloc.add(
                            LoadMoreProducts(ProductCategory.gender, gender: "women"),
                          );
                        }
                      },
                      onProductTap: (product) {},
                      onInitial: () {
                        homeBloc.add(ChangeCategory(ProductCategory.gender));
                      },
                    ),
              saleProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: saleProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreData,
                isLoading: state.isLoadingMore,

                onLoadMore: () {
                        if (!state.isLoadingMore && hasMoreData) {
                          homeBloc.add(
                            LoadMoreProducts(ProductCategory.sale),
                          );
                        }
                      },
                      onProductTap: (product) {},
                      onInitial: () {
                        homeBloc.add(ChangeCategory(ProductCategory.sale));
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }

  void clearCurrentList(ProductCategory category) {
    switch (category) {
      case ProductCategory.popular:
        popularProducts = [];
      case ProductCategory.newArrival:
        newArrivalProducts = [];
      case ProductCategory.all:
      case ProductCategory.gender:
        womenProducts = [];
      case ProductCategory.sale:
        saleProducts = [];
    }
  }

  void _showDeleteDialog(BuildContext context, HomeError state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(state.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (state.previousState != null) {
                  homeBloc.add(ReloadStateEvent(state.previousState!));
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
