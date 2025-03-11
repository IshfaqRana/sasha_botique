part of 'home_bloc.dart';
abstract class HomeEvent {}

class LoadInitialProducts extends HomeEvent {
  final ProductCategory category;
  final String gender;
  LoadInitialProducts(this.category, {this.gender= "women"});
}

class LoadMoreProducts extends HomeEvent {
  final ProductCategory category;
  final String gender;

  LoadMoreProducts(this.category,{this.gender= "women"});
}

class ApplyFilters extends HomeEvent {
  final Map<String, dynamic> filters;
  final String sortOption;
  ApplyFilters({required this.filters, required this.sortOption});
}

class ChangeCategory extends HomeEvent {
  final ProductCategory category;
  ChangeCategory(this.category);
}

class ToggleViewMode extends HomeEvent {
  final bool isGrid;
  ToggleViewMode(this.isGrid);
}
class ReloadStateEvent extends HomeEvent {
  final HomeLoaded state;
  ReloadStateEvent(this.state);
}

class AddToCartEvent extends HomeEvent{
  final String productId;final int quantity;final String name;final String imageURL;final double price;final String collection;
  AddToCartEvent({required this.productId, required this.imageURL,required this.price,required this.collection, required this.quantity, required this.name});
}

class RemoveFromCartEvent extends HomeEvent{
  final String productId;
  RemoveFromCartEvent(this.productId);
}