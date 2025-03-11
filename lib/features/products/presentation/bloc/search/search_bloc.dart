import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_utils.dart';
import '../../../domain/entities/products.dart';
import '../../../domain/usecases/search_products.dart';

part 'search_events.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvents, SearchState> {
  SearchProductsUseCase searchProductsUseCase;
  bool showResults = false;

  SearchBloc({required this.searchProductsUseCase,}) : super(InitialState(false)) {
    on<SearchProductsEvent>(_searchProductsEvent);
    on<ShowResultsEvent>((event,emit){
      showResults = !showResults;
      if (state is InitialState) {
        emit(InitialState(showResults));
      } else if (state is SearchingProductState) {
        emit(SearchingProductState(showResults));
      } else if (state is FoundProductsState) {
        final currentState = state as FoundProductsState;
        emit(FoundProductsState( currentState.foundedProductList,  showResults));
      } else if (state is ErrorSearchState) {
        final currentState = state as ErrorSearchState;
        emit(ErrorSearchState(currentState.error, showResults));
      }
    });

  }

  Future<void> _searchProductsEvent(SearchProductsEvent event, Emitter<SearchState> emit) async {
    emit(SearchingProductState(showResults));
    try{
      final List<Product> foundedProducts = await searchProductsUseCase(event.query, event.filters);
      debugPrinter("foundedProducts in bloc");
      debugPrinter(foundedProducts.length);
      emit(FoundProductsState(foundedProducts,showResults));
    }catch(e){
      emit(ErrorSearchState(e.toString(),showResults));
    }
  }
 }
