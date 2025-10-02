import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:sasha_botique/features/products/domain/entities/products.dart';
import 'package:sasha_botique/features/products/domain/usecases/add_to_favourite.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_favorite_products.dart';
import 'package:sasha_botique/features/products/domain/usecases/remove_from_favourite.dart';

part 'favorite_events.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvents, FavoriteState> {
  GetFavoriteProductsUseCase getFavoriteProductsUseCase;
  AddToFavouriteUseCase addToFavouriteUseCase;
  RemoveFromFavoriteUseCase removeFromFavoriteUseCase;
  FavoriteBloc({required this.removeFromFavoriteUseCase, required this.addToFavouriteUseCase, required this.getFavoriteProductsUseCase}) : super(InitialState()) {
    on<RemoveFromFavoriteEvent>(_removeFromFavorite);
    on<LoadInitialEvent>(_onLoadInitialFavorite);
    on<AddToFavoriteEvent>(_addToFavorite);
  }

  Future<void> _onLoadInitialFavorite(LoadInitialEvent event, Emitter<FavoriteState> emit) async {
    emit(LoadingFavProductState());
    try{
      final List<Product> favProducts = await getFavoriteProductsUseCase();
      emit(LoadedFavProducts(favoriteProductList:  favProducts,isLoading: false));
    }catch(e){
      emit(ErrorState(e.toString()));
    }
  }
  Future<void> _removeFromFavorite(RemoveFromFavoriteEvent event, Emitter<FavoriteState> emit) async {
    if (state is! LoadedFavProducts) {
      emit(LoadingFavProductState());
    } else {
      var currentState = state as LoadedFavProducts;
      emit(currentState.copyWith(isLoading: true));
    }

    try{
       await removeFromFavoriteUseCase(event.product.id);

       final List<Product> favProducts = await getFavoriteProductsUseCase();

       emit(LoadedFavProducts(favoriteProductList:  favProducts,isLoading:  false));
    }catch(e){
      emit(ErrorState(e.toString()));
    }
  }
  Future<void> _addToFavorite(AddToFavoriteEvent event, Emitter<FavoriteState> emit) async {
    if (state is! LoadedFavProducts) {
      emit(LoadingFavProductState());
    } else {
      var currentState = state as LoadedFavProducts;
      emit(currentState.copyWith(isLoading: true));
    }

    try{
      await addToFavouriteUseCase(event.product.id);

      final List<Product> favProducts = await getFavoriteProductsUseCase();

      emit(LoadedFavProducts(  favoriteProductList:  favProducts,isLoading:  false));
    }catch(e){
      emit(ErrorState(e.toString()));
    }
  }
}
