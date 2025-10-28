import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final String currentSortOption;
  final Function(Map<String, dynamic>, String) onApplyFilters;
  final Function(Map<String, dynamic>, String) onCancelFilter;

  const FilterBottomSheet({
    Key? key,
    required this.initialFilters,
    required this.currentSortOption,
    required this.onApplyFilters,
    required this.onCancelFilter,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;
  late String _sortOption;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.initialFilters);
    _sortOption = widget.currentSortOption;
  }

  @override
  void didUpdateWidget(FilterBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle updates if the initial filters change
    if (oldWidget.initialFilters != widget.initialFilters ||
        oldWidget.currentSortOption != widget.currentSortOption) {
      setState(() {
        _filters = Map.from(widget.initialFilters);
        _sortOption = widget.currentSortOption;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                // New filterList section for category filters
                _buildFilterListSection(),
                const Divider(),
                
                // Additional filters section
                _buildExpandableFilter(
                    'Brand Name', ['Bilal A', 'Maria B', 'SASHA BASICS']),
                _buildExpandableFilter('Product Type',
                    ['Stitched', 'Unstitched', 'Semi-Stitched']),
                _buildExpandableFilter(
                    'Season', ['Summer', 'Winter', 'Spring', 'Fall']),
                _buildExpandableFilter(
                    'Fit Type', ['Regular', 'Slim', 'Loose']),
                _buildExpandableFilter('Collection', [
                  'Eid Collection 2025',
                  'Summer Collection',
                  'Winter Collection'
                ]),
                _buildExpandableFilter('Category', [
                  'Dresses', 'Tops', 'Bottoms', 'Accessories', 'Shoes'
                ]),
                _buildSortDropdown(),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(_filters, _sortOption);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filter'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                      _sortOption = 'Featured';
                      widget.onCancelFilter(_filters, _sortOption);
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableFilter(String title, List<String> options) {
    // Map UI titles to backend filter keys
    String filterKey = _getFilterKey(title);

    return ExpansionTile(
      title: Text(title),
      children: [
        Wrap(
          spacing: 8,
          children: options
              .map((option) => FilterChip(
                    label: Text(option),
                    selected: (_filters[filterKey] ?? []).contains(option),
                    onSelected: (selected) {
                      setState(() {
                        final List<String> currentFilters =
                            List.from(_filters[filterKey] ?? []);
                        if (selected) {
                          currentFilters.add(option);
                        } else {
                          currentFilters.remove(option);
                        }
                        _filters[filterKey] = currentFilters;
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  String _getFilterKey(String title) {
    switch (title) {
      case 'Brand Name':
        return 'brand_name';
      case 'Product Type':
        return 'product_type';
      case 'Season':
        return 'season';
      case 'Fit Type':
        return 'fit_type';
      case 'Collection':
        return 'collection';
      case 'Category':
        return 'category';
      default:
        return title.toLowerCase().replaceAll(' ', '_');
    }
  }

  Widget _buildFilterListSection() {
    return ExpansionTile(
      title: const Text('Category Filters'),
      subtitle: const Text('Filter by product categories'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select categories to filter by:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  'Sasha Basics',
                  'Popular',
                  'Clearance', 
                  'Accessories',
                ].map((category) => FilterChip(
                  label: Text(category),
                  selected: (_filters['filterList'] ?? []).contains(category),
                  onSelected: (selected) {
                    setState(() {
                      final List<String> currentFilters = 
                          List.from(_filters['filterList'] ?? []);
                      if (selected) {
                        currentFilters.add(category);
                      } else {
                        currentFilters.remove(category);
                      }
                      _filters['filterList'] = currentFilters;
                    });
                  },
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return ExpansionTile(
      title: const Text('Sort By'),
      subtitle: Text(_sortOption),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildSortOption('Featured', 'Default sorting'),
              _buildSortOption('Best Selling', 'Sort by popularity'),
              _buildSortOption('Alphabetically, A-Z', 'Name A to Z'),
              _buildSortOption('Alphabetically, Z-A', 'Name Z to A'),
              _buildSortOption('Price, Low to High', 'Price ascending'),
              _buildSortOption('Price, High to Low', 'Price descending'),
              _buildSortOption('Date, New to Old', 'Newest first'),
              _buildSortOption('Date, Old to New', 'Oldest first'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOption(String value, String description) {
    return RadioListTile<String>(
      title: Text(value),
      subtitle: Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: value,
      groupValue: _sortOption,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _sortOption = newValue;
          });
        }
      },
    );
  }
}
