part of 'search_bloc.dart';

abstract class SearchEvents{}

class SearchProductsEvent extends SearchEvents{
  String query;
  Map<String, dynamic>? filters;
  SearchProductsEvent(this.query, this.filters);
}
class ShowResultsEvent extends SearchEvents{

  ShowResultsEvent();
}
