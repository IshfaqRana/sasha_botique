import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_products_by_gender.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_products_on_sale.dart';

import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/utils/product_category_enum.dart';
import '../../../../../core/utils/product_category_mapper.dart';
import '../../../domain/entities/products.dart';
import '../../../domain/usecases/get_new_arrival_products.dart';
import '../../../domain/usecases/get_all_products.dart';
import '../../../domain/usecases/get_popular_products.dart';
import '../../../domain/usecases/search_products.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllProductsUseCase getAllProducts;
  final GetPopularProductsUseCase getPopularProducts;
  final GetNewArrivalProductsUseCase getNewArrivalProductsUseCase;
  final GetGenderProductsUseCase getGenderProductsUseCase;
  final GetProductsOnSaleUseCase getProductsOnSaleUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  static const int _pageSize = 5;

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
    on<ReloadStateEvent>(_onReloadHomeState);
  }

  Future<void> _onLoadInitialProducts(
    LoadInitialProducts event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) {
      emit(HomeLoading());
    }

    try {
//check if user clear all filters then we are clearing the list
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(
          categoryProducts: {CategoryMapper.getCategory(currentState.currentCategory): []},
          hasMoreProducts: {...currentState.hasMoreProducts, CategoryMapper.getCategory(event.category): true},

        ));
      }

      final List<Product> products = await _loadProductsByCategory(
        event.category,
        0,
        _pageSize,
      );

      if (state is! HomeLoaded) {
        emit(HomeLoaded(
          categoryProducts: {CategoryMapper.getCategory(event.category): products},
          categoryOffsets: {CategoryMapper.getCategory(event.category): _pageSize},
          hasMoreProducts: {CategoryMapper.getCategory(event.category): products.length >= 5 ? true : false},
        ));
      } else {
        final currentState = state as HomeLoaded;

        emit(currentState.copyWith(
          categoryProducts: {CategoryMapper.getCategory(event.category): products},
          categoryOffsets: {...currentState.categoryOffsets, CategoryMapper.getCategory(event.category): _pageSize},
          hasMoreProducts: {...currentState.hasMoreProducts, CategoryMapper.getCategory(event.category): products.length >= 5 ? true : false},
        ));
      }
      // debugPrint('HomeBloc._onLoadInitialProducts: categoryOffsets; ${state.categoryOffsets[CategoryMapper.getCategory(event.category)]}: ${products.length}');
    } catch (e) {
      final currentState = state as HomeLoaded;

      emit(HomeError(e.toString().substring(11), previousState: currentState)); // Emit error with previous state
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state as HomeLoaded;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(
      isLoadingMore: true,
      categoryProducts: {
        CategoryMapper.getCategory(event.category): [],
      },
    ));

    try {
      final currentOffset = currentState.categoryOffsets[CategoryMapper.getCategory(event.category)] ?? 0;
      await Future.delayed(Duration(seconds: 3));
      final List<Product> newProducts = await _loadProductsByCategory(
        event.category,
        currentOffset,
        _pageSize,
        currentState.activeFilters,
        currentState.currentSortOption,
        event.gender,
      );

      // if(newProducts.length <= 5){
      //   throw Exception("No More Products");
      // }

      emit(currentState.copyWith(
        categoryProducts: {
          CategoryMapper.getCategory(event.category): newProducts,
        },
        categoryOffsets: {
          ...currentState.categoryOffsets,
          CategoryMapper.getCategory(event.category): currentOffset + _pageSize,
        },
        isLoadingMore: false,
        hasMoreProducts: {CategoryMapper.getCategory(event.category): newProducts.length >= 5 ? true : false},
      ));
    } catch (e) {
      emit(HomeError(e.toString().substring(11), previousState: currentState));
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
      categoryProducts: {CategoryMapper.getCategory(currentState.currentCategory): []},

    ));

    // Reload products with new filters
    final List<Product> products = await _loadProductsByCategory(
      currentState.currentCategory,
      0,
      _pageSize,
      event.filters,
      event.sortOption,
    );
    final currentState2 = state as HomeLoaded;

    // debugPrinter('HomeBloc.Sort Options${event.sortOption}: ${CategoryMapper.getCategory(currentState.currentCategory)}: ${products.length}');
    // debugPrinter('HomeBloc.hasMoreProducts${currentState2.hasMoreProducts}: ${CategoryMapper.getCategory(currentState.currentCategory)}: ${products.length}');

    emit(currentState.copyWith(
      categoryProducts: {CategoryMapper.getCategory(currentState.currentCategory): products},
      categoryOffsets: {CategoryMapper.getCategory(currentState.currentCategory): _pageSize},
      activeFilters: event.filters,
      currentSortOption: event.sortOption,
      hasMoreProducts: {...currentState.hasMoreProducts, CategoryMapper.getCategory(currentState.currentCategory): true},

    ));
  }

  void _onChangeCategory(
    ChangeCategory event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state as HomeLoaded;
    ProductCategory prevCategory = currentState.currentCategory;

    emit(currentState.copyWith(categoryProducts: {CategoryMapper.getCategory(prevCategory): []}, currentCategory: event.category));
  }

  void _onToggleViewMode(
    ToggleViewMode event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(isGridView: event.isGrid));
  }

  void _onReloadHomeState(
    ReloadStateEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(event.state);
  }
}
