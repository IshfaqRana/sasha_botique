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
                // Only show filters that backend supports
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
      default:
        return title.toLowerCase().replaceAll(' ', '_');
    }
  }

  Widget _buildSortDropdown() {
    return ListTile(
      title: const Text('Sort'),
      trailing: DropdownButton<String>(
        value: _sortOption,
        items: [
          'Featured',
          'Best Selling',
          'Alphabetically, A-Z',
          'Alphabetically, Z-A',
          'Price, High to Low',
          'Price, Low to High',
          'Date, Old to New',
          'Date, New to Old',
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _sortOption = newValue;
            });
          }
        },
      ),
    );
  }
}
