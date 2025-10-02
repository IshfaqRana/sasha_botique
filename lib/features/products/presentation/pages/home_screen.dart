import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sasha_botique/features/cart/presentation/pages/cart_screen.dart';
import 'package:sasha_botique/features/products/presentation/pages/favourite_products_screen.dart';
import 'package:sasha_botique/features/products/presentation/pages/search_screen.dart';
import 'package:sasha_botique/features/profile/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';
import 'package:sasha_botique/shared/widgets/loading_overlay.dart';
import 'package:sasha_botique/shared/widgets/cart_icon_with_badge.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/di/injections.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/utils/product_category_enum.dart';
import '../../../../core/utils/product_category_mapper.dart';
import '../../../payment/presentation/bloc/payment_bloc.dart';
import '../../../profile/presentation/bloc/user_address/user_address_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';
import 'products_detail_screen.dart';
import '../../domain/entities/products.dart';
import '../bloc/home/home_bloc.dart';
import '../widgets/custom_drawar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/empty_product_screen.dart';
import 'product_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final homeBloc = getIt<HomeBloc>();
  late final FavoriteBloc _wishlistBloc;
  late final ProfileBloc _profileBloc;
  late final AddressBloc addressBloc;
  late final PaymentBloc paymentBloc;

  List<Product> popularProducts = <Product>[];
  List<Product> newArrivalProducts = <Product>[];
  List<Product> saleProducts = <Product>[];
  List<Product> womenProducts = <Product>[];
  List<Product> allProducts = <Product>[];
  List<Product> accessoriesProducts = <Product>[];
  List<Product> sashaBProducts = <Product>[];
  Map<String, bool> hasMoreDataPerCategory = {
    'all': true,
    'popular': true,
    'clearance': true,
    'accessories': true,
    'sasha-b': true,
  };

  @override
  void initState() {
    super.initState();

    // Initialize blocs but don't load user-specific data yet
    _profileBloc = getIt<ProfileBloc>();
    _wishlistBloc = getIt<FavoriteBloc>();
    addressBloc = getIt<AddressBloc>();
    paymentBloc = getIt<PaymentBloc>();

    // Check authentication status and load appropriate data
    _loadInitialData();

    _tabController = TabController(length: 5, vsync: this);
    homeBloc.add(LoadInitialProducts(ProductCategory.popular));
    homeBloc.add(LoadInitialProducts(ProductCategory.sale));
    homeBloc.add(LoadInitialProducts(ProductCategory.all));
    homeBloc.add(LoadInitialProducts(ProductCategory.accessories));
    homeBloc.add(LoadInitialProducts(ProductCategory.sashaB));
    // homeBloc.add(LoadInitialProducts(ProductCategory.newArrival));
    // homeBloc.add(LoadInitialProducts(ProductCategory.gender, gender: "women"));
    homeBloc.add(ChangeCategory(ProductCategory.all));
  }

  Future<void> _loadInitialData() async {
    // Check if user is authenticated
    final authBloc = context.read<AuthBloc>();
    final currentState = authBloc.state;

    if (currentState is Authenticated) {
      print('🔍 Home: User is authenticated, loading user-specific data');
      // Load user-specific data
      _profileBloc.add(GetUserProfileEvent());
      _wishlistBloc.add(LoadInitialEvent());
      addressBloc.add(GetAddressesEvent());
      paymentBloc.add(GetPaymentMethodsEvent());
    } else {
      print('🔍 Home: User not authenticated, skipping user-specific data');
      // Only load non-user-specific data or initialize with empty states
    }
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is Authenticated) {
          print('🔍 Home: AuthBloc became Authenticated, loading user data');
          // Load user-specific data when auth state becomes Authenticated
          _profileBloc.add(GetUserProfileEvent());
          _wishlistBloc.add(LoadInitialEvent());
          addressBloc.add(GetAddressesEvent());
          paymentBloc.add(GetPaymentMethodsEvent());
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          bloc: _wishlistBloc,
          builder: (context, state2) {
            bool isLoading = false;
            if (state2 is LoadedFavProducts) {
              isLoading = state2.isLoading;
            }
            return LoadingOverlay(
              isLoading: isLoading,
              child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "SASHA",
                style: context.headlineMedium,
              ),
              backgroundColor: context.colors.whiteColor,
              actions: [
                // IconButton(
                //   icon: Icon(
                //     Icons.notifications_outlined,
                //   ),
                //   onPressed: () {},
                // ),
                CartIconWithBadge(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => CartScreen()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => FavouriteProductsScreen()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SearchScreen(
                                  popularProducts: popularProducts,
                                )));
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
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.only(left: 35, right: 10, bottom: 0),
                isScrollable: true,
                controller: _tabController,
                labelStyle: context.titleSmall
                    ?.copyWith(color: context.colors.blackWhite),
                unselectedLabelStyle:
                    context.titleSmall?.copyWith(color: context.colors.grey),
                tabs: const [
                  Tab(
                    text: 'Brands',
                  ),
                  Tab(text: 'New in'),
                  Tab(text: 'SASHA BASICS'),
                  Tab(text: 'Accessories'),
                  Tab(text: 'Clearance'),
                ],
              ),
            ),
            endDrawer: CustomDrawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: _openWhatsApp,
              backgroundColor: Colors.green,
              child: const FaIcon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'Contact via WhatsApp',
            ),
            body: BlocConsumer<HomeBloc, HomeState>(
              bloc: homeBloc,
              listener: (context, state) {
                if (state is HomeError) {
                  debugPrinter(
                      '_HomePageState.build: STATE ============== HOME ERROR STATE: ${state.message}');
                  // _showDeleteDialog(context, state);
                }
                if (state is HomeLoaded) {
                  // debugPrint('Active Filters in Listener: ${state.activeFilters}');

                  // print('_HomePageState.build: Current Category: ${state.currentCategory.toString()}');

                  popularProducts = [
                    ...popularProducts,
                    ...state.categoryProducts[CategoryMapper.getCategory(
                            ProductCategory.popular)] ??
                        []
                  ];
                  allProducts = [
                    ...allProducts,
                    ...state.categoryProducts[
                            CategoryMapper.getCategory(ProductCategory.all)] ??
                        []
                  ];
                  womenProducts = [
                    ...womenProducts,
                    ...state.categoryProducts[CategoryMapper.getCategory(
                            ProductCategory.gender)] ??
                        []
                  ];
                  saleProducts = [
                    ...saleProducts,
                    ...state.categoryProducts[
                            CategoryMapper.getCategory(ProductCategory.sale)] ??
                        []
                  ];
                  newArrivalProducts = [
                    ...newArrivalProducts,
                    ...state.categoryProducts[CategoryMapper.getCategory(
                            ProductCategory.newArrival)] ??
                        []
                  ];
                  accessoriesProducts = [
                    ...accessoriesProducts,
                    ...state.categoryProducts[CategoryMapper.getCategory(
                            ProductCategory.accessories)] ??
                        []
                  ];
                  sashaBProducts = [
                    ...sashaBProducts,
                    ...state.categoryProducts[CategoryMapper.getCategory(
                            ProductCategory.sashaB)] ??
                        []
                  ];
                  // debugPrinter('_HomePageState.build: popularProducts Products: ${popularProducts.length}');
                  setState(() {
                    // Update hasMoreData for the current category
                    String categoryKey =
                        CategoryMapper.getCategory(state.currentCategory);
                    hasMoreDataPerCategory[categoryKey] =
                        state.hasMoreProducts[categoryKey] ?? true;

                    // For categories that don't support pagination, set hasMoreData to false after initial load
                    if (categoryKey == 'popular' ||
                        categoryKey == 'clearance' ||
                        categoryKey == 'accessories') {
                      hasMoreDataPerCategory[categoryKey] = false;
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HomeError) {
                  return state.previousState != null
                      ? _productListView(
                          context, state.previousState as HomeLoaded)
                      : Center(child: Text(state.message));
                }

                if (state is HomeLoaded) {
                  return _productListView(context, state);
                }

                return EmptyProductList();
              },
            ),
          ),
        );
      },
        ),
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
                          ApplyFilters(
                              filters: filters, sortOption: sortOption),
                        );
                      },
                      onCancelFilter: (filters, sortOption) {
                        clearCurrentList(state.currentCategory);
                        homeBloc.add(
                          ApplyFilters(
                              filters: filters, sortOption: sortOption),
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
                icon:
                    Icon(state.isGridView ? Icons.grid_view : Icons.view_list),
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
              // Brands tab (formerly All)
              allProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: allProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreDataPerCategory['all'] ?? true,
                      isLoading: state.isLoadingMore,
                      onLoadMore: () {
                        if (!state.isLoadingMore &&
                            (hasMoreDataPerCategory['all'] ?? true)) {
                          homeBloc.add(
                            LoadMoreProducts(ProductCategory.all),
                          );
                        }
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
                        homeBloc.add(ChangeCategory(ProductCategory.all));
                      },
                    ),
              // New in tab (formerly Popular)
              popularProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: popularProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreDataPerCategory['popular'] ?? false,
                      isLoading: state.isLoadingMore,
                      onLoadMore: () {
                        // Popular doesn't support pagination - disabled
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
                        homeBloc.add(ChangeCategory(ProductCategory.popular));
                      },
                    ),
              // Sasha B tab
              sashaBProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: sashaBProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreDataPerCategory['sasha-b'] ?? true,
                      isLoading: state.isLoadingMore,
                      onLoadMore: () {
                        if (!state.isLoadingMore &&
                            (hasMoreDataPerCategory['sasha-b'] ?? true)) {
                          homeBloc.add(
                            LoadMoreProducts(ProductCategory.sashaB),
                          );
                        }
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
                        homeBloc.add(ChangeCategory(ProductCategory.sashaB));
                      },
                    ),
              // Accessories tab
              accessoriesProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: accessoriesProducts,
                      isGridView: state.isGridView,
                      hasMoreData:
                          hasMoreDataPerCategory['accessories'] ?? false,
                      isLoading: state.isLoadingMore,
                      onLoadMore: () {
                        // Accessories doesn't support pagination - disabled
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
                        homeBloc
                            .add(ChangeCategory(ProductCategory.accessories));
                      },
                    ),
              // Clearance tab (formerly Sale)
              saleProducts.isEmpty
                  ? EmptyProductList()
                  : ProductList(
                      products: saleProducts,
                      isGridView: state.isGridView,
                      hasMoreData: hasMoreDataPerCategory['clearance'] ?? false,
                      isLoading: state.isLoadingMore,
                      onLoadMore: () {
                        // Clearance doesn't support pagination - disabled
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
        hasMoreDataPerCategory['popular'] = true;
      case ProductCategory.newArrival:
        newArrivalProducts = [];
      case ProductCategory.all:
      case ProductCategory.gender:
        womenProducts = [];
        hasMoreDataPerCategory['all'] = true;
      case ProductCategory.sale:
        saleProducts = [];
        hasMoreDataPerCategory['clearance'] = true;
      case ProductCategory.accessories:
        accessoriesProducts = [];
        hasMoreDataPerCategory['accessories'] = true;
      case ProductCategory.sashaB:
        sashaBProducts = [];
        hasMoreDataPerCategory['sasha-b'] = true;
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

  // WhatsApp contact function
  Future<void> _openWhatsApp() async {
    const String phoneNumber = "+447824519154";
    final String message = "Hello! I'm interested in your products.";
    final String whatsappUrl =
        "https://wa.me/${phoneNumber.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}";

    try {
      final Uri url = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to regular SMS if WhatsApp is not available
        final String smsUrl =
            "sms:$phoneNumber?body=${Uri.encodeComponent(message)}";
        final Uri smsUri = Uri.parse(smsUrl);
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        }
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }
}
