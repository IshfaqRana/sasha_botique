import 'package:flutter/material.dart';
import 'package:sasha_botique/core/utils/app_utils.dart';

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
    // widget.initialFilters.forEach((key,value){
    //   debugPrinter("$key >>>>>>>>>>>>>>==============>>>>>>>>>>>>>>> $value");
    //
    // });
    // _sortOption = widget.currentSortOption;
    debugPrint('FilterBottomSheet initState called');
    _initializeFilters();
  }

  void _initializeFilters() {
    // Create a deep copy of the initial filters
    _filters = Map<String, dynamic>.from(widget.initialFilters);
    _sortOption = widget.currentSortOption;

    // Debug prints to verify initialization
    debugPrint('Initial Filters: $_filters');
    debugPrint('Initial Sort Option: $_sortOption');

    // Print each filter separately
    widget.initialFilters.forEach((key, value) {
      debugPrint('Filter - $key: $value');
    });
  }

  @override
  void didUpdateWidget(FilterBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle updates if the initial filters change
    if (oldWidget.initialFilters != widget.initialFilters ||
        oldWidget.currentSortOption != widget.currentSortOption) {
      _initializeFilters();
    }
  }

  @override
  void dispose() {
    debugPrint('FilterBottomSheet dispose called');
    super.dispose();
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
                _buildExpandableFilter('Color', ['Red', 'Blue', 'Black', 'White']),
                _buildExpandableFilter('Product Type', ['Shirt', 'Pants', 'Dress']),
                _buildExpandableFilter('Size', ['S', 'M', 'L', 'XL']),
                _buildExpandableFilter('Season', ['Summer', 'Winter', 'Spring']),
                _buildExpandableFilter('Price', []),
                _buildExpandableFilter('Gender', ['Men', 'Women', 'Unisex']),
                _buildExpandableFilter('Fit Type', ['Regular', 'Slim', 'Loose']),
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
                      widget.onCancelFilter(_filters,_sortOption);
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

    return ExpansionTile(
      title: Text(title),
      children: [
        if (title == 'Price') _buildPriceRangeFilter()
        else Wrap(
          spacing: 8,
          children: options.map((option) => FilterChip(
            label: Text(option),
            selected: (_filters[title.toLowerCase()] ?? []).contains(option),
            onSelected: (selected) {
              setState(() {
                final List<String> currentFilters =
                List.from(_filters[title.toLowerCase()] ?? []);
                if (selected) {
                  currentFilters.add(option);
                } else {
                  currentFilters.remove(option);
                }
                _filters[title.toLowerCase()] = currentFilters;
              });
            },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RangeSlider(
        values: RangeValues(
          _filters['minPrice']?.toDouble() ?? 0.0,
          _filters['maxPrice']?.toDouble() ?? 1000.0,
        ),
        min: 0.0,
        max: 1000.0,
        divisions: 20,
        labels: RangeLabels(
          '\$${_filters['minPrice']?.toStringAsFixed(0) ?? '0'}',
          '\$${_filters['maxPrice']?.toStringAsFixed(0) ?? '1000'}',
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _filters['minPrice'] = values.start;
            _filters['maxPrice'] = values.end;
          });
        },
      ),
    );
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
