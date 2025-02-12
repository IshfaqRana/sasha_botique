
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/home/domain/usecases/get_products_by_gender.dart';
import 'package:sasha_botique/features/home/domain/usecases/get_products_on_sale.dart';

import '../../../../core/utils/app_utils.dart';
import '../../../../core/utils/product_category_enum.dart';
import '../../../../core/utils/product_category_mapper.dart';
import '../../domain/entities/products.dart';
import '../../domain/usecases/get_new_arrival_products.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_popular_products.dart';
import '../../domain/usecases/search_products.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllProductsUseCase getAllProducts;
  final GetPopularProductsUseCase getPopularProducts;
  final GetNewArrivalProductsUseCase getNewArrivalProductsUseCase;
  final GetGenderProductsUseCase getGenderProductsUseCase;
  final GetProductsOnSaleUseCase getProductsOnSaleUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  static const int _pageSize = 20;

  HomeBloc({
    required this.getAllProducts,
    required this.getPopularProducts,
    required this.searchProductsUseCase,
    required this.getProductsOnSaleUseCase,
    required this.getGenderProductsUseCase,
    required this.getNewArrivalProductsUseCase,
  }) : super(HomeInitial()) {
    on<LoadInitialProducts>(_onLoadInitialProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<ApplyFilters>(_onApplyFilters);
    on<ChangeCategory>(_onChangeCategory);
    on<ToggleViewMode>(_onToggleViewMode);
  }

  Future<void> _onLoadInitialProducts(
      LoadInitialProducts event,
      Emitter<HomeState> emit,
      ) async {
    if (state is! HomeLoaded) {
      emit(HomeLoading());
    }

    try {
      final List<Product> products = await _loadProductsByCategory(
        event.category,
        0,
        _pageSize,
      );

      debugPrint('HomeBloc._onLoadInitialProducts: ${CategoryMapper.getCategory(event.category)}: ${products.length}');

      emit(HomeLoaded(
        categoryProducts: {CategoryMapper.getCategory(event.category): products},
        categoryOffsets: {CategoryMapper.getCategory(event.category): _pageSize},
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event,
      Emitter<HomeState> emit,
      ) async {
    final currentState = state as HomeLoaded;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final currentOffset = currentState.categoryOffsets[CategoryMapper.getCategory(event.category)] ?? 0;
      final List<Product> newProducts = await _loadProductsByCategory(
        event.category,
        currentOffset,
        _pageSize,
        currentState.activeFilters,
        currentState.currentSortOption,
        event.gender,
      );

      final List<Product> updatedProducts = [
        ...currentState.categoryProducts[CategoryMapper.getCategory(event.category)] ?? [],
        ...newProducts,
      ];

      emit(currentState.copyWith(
        categoryProducts: {
          ...currentState.categoryProducts,
          CategoryMapper.getCategory(event.category): updatedProducts,
        },
        categoryOffsets: {
          ...currentState.categoryOffsets,
          CategoryMapper.getCategory(event.category): currentOffset + _pageSize,
        },
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<List<Product>> _loadProductsByCategory(
      ProductCategory category,
      int offset,
      int limit, [
        Map<String, dynamic>? filters,
        String? sortOption,
        String? gender,
      ]) async {
    switch (category) {
      case ProductCategory.popular:
        return await getPopularProducts(
          offset: offset,
          limit: limit,
          filters: filters,
          sortOption: sortOption,
        );
      case ProductCategory.newArrival:
        return await getNewArrivalProductsUseCase(
          offset: offset,
          limit: limit,
          filters: filters,
          sortOption: sortOption,
        );
      case ProductCategory.all:
        return await getAllProducts(
          category: "all",
          offset: offset,
          limit: limit,
          filters: filters,
          sortOption: sortOption,
        );
      case ProductCategory.gender:
        return await getGenderProductsUseCase(
          offset: offset,
          limit: limit,
          gender: gender ?? "women",
          filters: filters,
          sortOption: sortOption,
        );
      case ProductCategory.sale:
        return await getProductsOnSaleUseCase(
          offset: offset,
          limit: limit,
          filters: filters,
          sortOption: sortOption,
        );

    }
  }

  Future<void> _onApplyFilters(
      ApplyFilters event,
      Emitter<HomeState> emit,
      ) async {
    final currentState = state as HomeLoaded;

    emit(currentState.copyWith(
      activeFilters: event.filters,
      currentSortOption: event.sortOption,
    ));

    // Reload products with new filters
    add(LoadInitialProducts(currentState.currentCategory));
  }

  void _onChangeCategory(
      ChangeCategory event,
      Emitter<HomeState> emit,
      ) {
    add(LoadInitialProducts(event.category));
  }

  void _onToggleViewMode(
      ToggleViewMode event,
      Emitter<HomeState> emit,
      ) {
    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(isGridView: event.isGrid));
  }
}
