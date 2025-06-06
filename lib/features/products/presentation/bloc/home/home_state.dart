
part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Map<String, List<Product>> categoryProducts;
  final Map<String, int> categoryOffsets;
  final Map<String, bool> hasMoreProducts;
  final bool isGridView;
  final Map<String, dynamic> activeFilters;
  final String currentSortOption;
  final bool isLoadingMore;
  final ProductCategory currentCategory;
  final Map<String, String?> categoryErrors;
  final Map<String, CartOperationStatus> productCartStatuses; // Track cart operation status for each product
  final Set<String> productsInCart; // Track which products are in cart
  final Map<String, String?> cartErrors; // Track cart operation errors


  HomeLoaded({
    required this.categoryProducts,
    required this.categoryOffsets,
    required this.hasMoreProducts,
    this.isGridView = true,
    this.categoryErrors = const {},
    this.activeFilters = const {},
    this.currentSortOption = 'Featured',
    this.isLoadingMore = false,
    this.currentCategory = ProductCategory.popular,
    this.productCartStatuses = const {},
    this.productsInCart = const {},
    this.cartErrors = const {},
  });

  HomeLoaded copyWith({
    Map<String, List<Product>>? categoryProducts,
    Map<String, int>? categoryOffsets,
    Map<String, bool>? hasMoreProducts,
    Map<String, String?>? categoryErrors,
    bool? isGridView,
    Map<String, dynamic>? activeFilters,
    String? currentSortOption,
    bool? isLoadingMore,
    ProductCategory? currentCategory,
    Map<String, CartOperationStatus>? productCartStatuses,
    Set<String>? productsInCart,
    Map<String, String?>? cartErrors,
  }) {
    return HomeLoaded(
      categoryProducts: categoryProducts ?? this.categoryProducts,
      categoryOffsets: categoryOffsets ?? this.categoryOffsets,
      isGridView: isGridView ?? this.isGridView,
      categoryErrors: categoryErrors ?? this.categoryErrors,
      activeFilters: activeFilters ?? this.activeFilters,
      currentSortOption: currentSortOption ?? this.currentSortOption,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentCategory: currentCategory ?? this.currentCategory,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      productCartStatuses: productCartStatuses ?? this.productCartStatuses,
      productsInCart: productsInCart ?? this.productsInCart,
      cartErrors: cartErrors ?? this.cartErrors,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  final HomeLoaded? previousState; // Include the previous state

  HomeError(this.message,{this.previousState});
}
