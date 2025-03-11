part of 'favorite_bloc.dart';

abstract class FavoriteEvents{}

class LoadInitialEvent extends FavoriteEvents{}
class AddToFavoriteEvent extends FavoriteEvents{
  Product product;
  AddToFavoriteEvent(this.product);
}
class RemoveFromFavoriteEvent extends FavoriteEvents{
  Product product;
  RemoveFromFavoriteEvent(this.product);
}