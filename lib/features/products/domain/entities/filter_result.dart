import 'products.dart';

class FilterResult {
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final List<Product> items;
  final List<String> appliedFilters;
  final String? sortBy;
  final String? sortOrder;

  FilterResult({
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.items,
    required this.appliedFilters,
    this.sortBy,
    this.sortOrder,
  });

  factory FilterResult.empty() {
    return FilterResult(
      totalItems: 0,
      currentPage: 1,
      totalPages: 0,
      hasNextPage: false,
      hasPrevPage: false,
      items: [],
      appliedFilters: [],
      sortBy: null,
      sortOrder: null,
    );
  }
}
