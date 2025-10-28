/// Helper class to map UI filter/sort options to API format
class FilterHelper {
  /// Maps UI sort option to API sortBy field and sortOrder
  /// Returns a map with 'sortBy' and 'sortOrder' keys
  static Map<String, String> mapSortOption(String uiSortOption) {
    switch (uiSortOption) {
      case 'Featured':
        return {'sortBy': 'id', 'sortOrder': 'DESC'};
      case 'Best Selling':
        return {'sortBy': 'popularity', 'sortOrder': 'DESC'};
      case 'Alphabetically, A-Z':
        return {'sortBy': 'name', 'sortOrder': 'ASC'};
      case 'Alphabetically, Z-A':
        return {'sortBy': 'name', 'sortOrder': 'DESC'};
      case 'Price, Low to High':
        return {'sortBy': 'price', 'sortOrder': 'ASC'};
      case 'Price, High to Low':
        return {'sortBy': 'price', 'sortOrder': 'DESC'};
      case 'Date, Old to New':
        return {'sortBy': 'createdAt', 'sortOrder': 'ASC'};
      case 'Date, New to Old':
        return {'sortBy': 'createdAt', 'sortOrder': 'DESC'};
      default:
        return {'sortBy': 'id', 'sortOrder': 'DESC'};
    }
  }

  /// Converts old filter format (Map<String, dynamic>) to new API filter array
  /// Old format: {'brand_name': ['Maria B'], 'season': ['Winter']}
  /// New format needs to extract category-type filters for the filters array
  ///
  /// Note: The new API uses filters array for categories like "Popular", "Clearance", etc.
  /// Other filters (brand, season, etc.) might need different handling based on backend
  static List<String> extractCategoryFilters(Map<String, dynamic> oldFilters) {
    List<String> categoryFilters = [];

    // For now, we'll return empty since the old filter format doesn't include
    // category-type filters. This will be combined with tab-specific category
    // in the HomeBloc
    return categoryFilters;
  }

  /// Get category filter value for each tab
  /// This maps ProductCategory to the API filter value
  static String? getCategoryFilterForTab(String categoryKey) {
    switch (categoryKey) {
      case 'popular':
        return 'Popular';
      case 'clearance':
        return 'Clearance';
      case 'accessories':
        return 'Accessories';
      case 'sasha-b':
        return 'Sasha Basics';
      case 'all':
        return null; // No filter for "all" - shows everything
      default:
        return null;
    }
  }

  /// Combines category filter with search query
  /// Used when applying filters to ensure the current tab's category is maintained
  static List<String> buildFilterArray({
    String? categoryFilter,
    List<String>? additionalFilters,
  }) {
    List<String> filters = [];

    if (categoryFilter != null && categoryFilter.isNotEmpty) {
      filters.add(categoryFilter);
    }

    if (additionalFilters != null) {
      filters.addAll(additionalFilters);
    }

    return filters;
  }

  /// Builds the new API filter request structure
  /// Returns a map with filterList, sortBy, sortOrder, page, limit, search, and filters
  static Map<String, dynamic> buildNewFilterRequest({
    List<String>? filterList,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 10,
    String? search,
    Map<String, String>? filters,
  }) {
    return {
      'filterList': filterList ?? [],
      'sortBy': sortBy ?? 'id',
      'sortOrder': sortOrder ?? 'DESC',
      'page': page,
      'limit': limit,
      'search': search ?? '',
      'filters': filters ?? {},
    };
  }

  /// Extracts filterList from UI filters
  /// Maps UI filter categories to API filterList values
  static List<String> extractFilterList(Map<String, dynamic> uiFilters) {
    List<String> filterList = [];
    
    if (uiFilters.containsKey('filterList') && uiFilters['filterList'] is List) {
      filterList.addAll((uiFilters['filterList'] as List).cast<String>());
    }
    
    return filterList;
  }

  /// Extracts additional filters object from UI filters
  /// Maps UI filter fields to API filters object
  static Map<String, String> extractFiltersObject(Map<String, dynamic> uiFilters) {
    Map<String, String> filters = {};
    
    // Map UI filter keys to API filter keys
    final filterMappings = {
      'brand_name': 'brand_name',
      'product_type': 'product_type', 
      'season': 'season',
      'fit_type': 'fit_type',
      'collection': 'collection',
      'category': 'category',
    };
    
    filterMappings.forEach((uiKey, apiKey) {
      if (uiFilters.containsKey(uiKey) && uiFilters[uiKey] != null) {
        final value = uiFilters[uiKey];
        if (value is String && value.isNotEmpty) {
          filters[apiKey] = value;
        } else if (value is List && value.isNotEmpty) {
          filters[apiKey] = value.first.toString();
        }
      }
    });
    
    return filters;
  }

  /// Valid filterList values for the API
  static const List<String> validFilterListValues = [
    'Sasha Basics',
    'Popular', 
    'Clearance',
    'Accessories',
  ];

  /// Valid sortBy values for the API
  static const List<String> validSortByValues = [
    'price',
    'name', 
    'createdAt',
    'popularity',
    'id',
  ];

  /// Valid sortOrder values for the API
  static const List<String> validSortOrderValues = [
    'ASC',
    'DESC',
  ];
}
