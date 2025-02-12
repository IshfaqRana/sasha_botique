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