import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/products/domain/entities/products.dart';
import 'package:sasha_botique/features/products/presentation/bloc/home/home_bloc.dart';
import 'package:sasha_botique/features/products/presentation/pages/products_detail_screen.dart';
import 'package:sasha_botique/features/products/presentation/widgets/empty_product_screen.dart';
import 'package:sasha_botique/features/products/presentation/pages/filter_page.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';
import 'package:sasha_botique/shared/widgets/loading_overlay.dart';

import 'product_list.dart';

class FilteredProductsScreen extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final String initialSortOption;

  const FilteredProductsScreen({
    Key? key,
    required this.initialFilters,
    required this.initialSortOption,
  }) : super(key: key);

  @override
  State<FilteredProductsScreen> createState() => _FilteredProductsScreenState();
}

class _FilteredProductsScreenState extends State<FilteredProductsScreen> {
  late final HomeBloc _filterBloc;
  Map<String, dynamic> _currentFilters = {};
  String _currentSortOption = 'Featured';
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _filterBloc = getIt<HomeBloc>();
    _currentFilters = Map.from(widget.initialFilters);
    _currentSortOption = widget.initialSortOption;
    
    // Apply filters immediately
    _applyFilters();
  }

  void _applyFilters() {
    _filterBloc.add(ApplyFilters(
      filters: _currentFilters,
      sortOption: _currentSortOption,
    ));
  }

  @override
  void dispose() {
    _filterBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _filterBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            setState(() {
              _isLoading = state.isLoadingMore;
              // Get filtered products from the current category
              final categoryProducts = state.categoryProducts.values.firstOrNull ?? [];
              _filteredProducts = categoryProducts;
            });
          } else if (state is HomeLoading) {
            setState(() {
              _isLoading = true;
            });
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: _isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Filtered Products',
                  style: context.headlineMedium,
                ),
                backgroundColor: context.colors.whiteColor,
                actions: [
                  IconButton(
                    icon: Icon(_isGridView ? Icons.grid_view : Icons.view_list),
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  // Filter Summary Section
                  _buildFilterSummary(),
                  
                  // Products List
                  Expanded(
                    child: _filteredProducts.isEmpty && !_isLoading
                        ? EmptyProductList()
                        : ProductList(
                            products: _filteredProducts,
                            isGridView: _isGridView,
                            hasMoreData: false,
                            isLoading: _isLoading,
                            onLoadMore: () {},
                            onProductTap: (product) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            onInitial: () {},
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSummary() {
    int filterCount = _countActiveFilters();
    bool hasSortApplied = _currentSortOption != 'Featured';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                '$filterCount ${filterCount == 1 ? 'Filter' : 'Filters'} Applied',
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasSortApplied) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Sorted',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Change'),
                onPressed: () => _showFilterSheet(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Active filters chips
          if (filterCount > 0)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildActiveFilterChips(),
            ),
          
          const SizedBox(height: 8),
          
          // Results count and clear button
          Row(
            children: [
              Text(
                '${_filteredProducts.length} ${_filteredProducts.length == 1 ? 'result' : 'results'} found',
                style: context.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              if (filterCount > 0 || hasSortApplied)
                TextButton(
                  onPressed: () {
                    // Navigate back to home screen when clearing all filters
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];
    
    _currentFilters.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        for (var item in value) {
          chips.add(
            Chip(
              avatar: Container(
                decoration: BoxDecoration(
                  gradient: appGradientColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              label: Text(
                item.toString(),
                style: const TextStyle(fontSize: 13),
              ),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                setState(() {
                  List<dynamic> currentValues = List.from(value);
                  currentValues.remove(item);
                  if (currentValues.isEmpty) {
                    _currentFilters.remove(key);
                  } else {
                    _currentFilters[key] = currentValues;
                  }
                });
                _applyFilters();
              },
              backgroundColor: Colors.amber.withOpacity(0.1),
              side: BorderSide(color: Colors.amber.withOpacity(0.3)),
            ),
          );
        }
      }
    });
    
    return chips;
  }

  int _countActiveFilters() {
    int count = 0;
    _currentFilters.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        count += value.length;
      }
    });
    return count;
  }

  void _showFilterSheet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(
          initialFilters: _currentFilters,
          currentSortOption: _currentSortOption,
          onApplyFilters: (filters, sortOption) {
            // First pop the filter page
            Navigator.pop(context);
            // Then update filters and apply
            setState(() {
              _currentFilters = filters;
              _currentSortOption = sortOption;
            });
            _applyFilters();
          },
        ),
      ),
    );
  }
}

