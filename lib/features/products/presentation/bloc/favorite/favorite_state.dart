part of 'favorite_bloc.dart';
abstract class FavoriteState {}

class InitialState extends FavoriteState{}
class LoadingFavProductState extends FavoriteState{}
class LoadedFavProducts extends FavoriteState{
  final bool isLoading;
  final List<Product> favoriteProductList;
  LoadedFavProducts({required this.favoriteProductList,required this.isLoading});
  LoadedFavProducts copyWith ({
    List<Product>? favoriteProductList,
    bool? isLoading,
}){return LoadedFavProducts(favoriteProductList:favoriteProductList ?? this.favoriteProductList, isLoading: isLoading ?? this.isLoading);}
}
class ErrorState extends FavoriteState{
  String error;
  ErrorState(this.error);
}