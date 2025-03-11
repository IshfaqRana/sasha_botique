part of 'search_bloc.dart';

abstract class SearchState {
  bool showResults;
  SearchState(this.showResults);
}

class InitialState extends SearchState{
  InitialState(super.showResults);
}
class SearchingProductState extends SearchState{
  SearchingProductState(super.showResults);
}
class FoundProductsState extends SearchState{
  final List<Product> foundedProductList;
  FoundProductsState(this.foundedProductList,super.showResults);

}
class ErrorSearchState extends SearchState{
  String error;
  ErrorSearchState(this.error,super.showResults);
}