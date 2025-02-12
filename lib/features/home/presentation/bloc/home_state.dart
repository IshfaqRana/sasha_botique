
part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Map<String, List<Product>> categoryProducts;
  final Map<String, int> categoryOffsets;
  final bool isGridView;
  final Map<String, dynamic> activeFilters;
  final String currentSortOption;
  final bool isLoadingMore;
  final ProductCategory currentCategory;

  HomeLoaded({
    required this.categoryProducts,
    required this.categoryOffsets,
    this.isGridView = true,
    this.activeFilters = const {},
    this.currentSortOption = 'Featured',
    this.isLoadingMore = false,
    required this.currentCategory,
  });

  HomeLoaded copyWith({
    Map<String, List<Product>>? categoryProducts,
    Map<String, int>? categoryOffsets,
    bool? isGridView,
    Map<String, dynamic>? activeFilters,
    String? currentSortOption,
    bool? isLoadingMore,
    ProductCategory? currentCategory,
  }) {
    return HomeLoaded(
      categoryProducts: categoryProducts ?? this.categoryProducts,
      categoryOffsets: categoryOffsets ?? this.categoryOffsets,
      isGridView: isGridView ?? this.isGridView,
      activeFilters: activeFilters ?? this.activeFilters,
      currentSortOption: currentSortOption ?? this.currentSortOption,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentCategory: currentCategory ?? this.currentCategory,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
