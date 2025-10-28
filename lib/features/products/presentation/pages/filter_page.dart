import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final String currentSortOption;
  final Function(Map<String, dynamic>, String) onApplyFilters;

  const FilterPage({
    Key? key,
    required this.initialFilters,
    required this.currentSortOption,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late Map<String, dynamic> _filters;
  late String _sortOption;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.initialFilters);
    _sortOption = widget.currentSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filters indicator
          if (hasActiveFilters())
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Active filters: ${_getActiveFilterCount()}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Category Filters Section
                _buildSectionHeader(
                  icon: Icons.category,
                  title: 'Category Filters',
                  subtitle: 'Filter by product categories',
                ),
                const SizedBox(height: 12),
                _buildFilterListSection(),
                const SizedBox(height: 24),
                
                // Brand Name
                _buildSectionHeader(
                  icon: Icons.branding_watermark,
                  title: 'Brand',
                ),
                const SizedBox(height: 12),
                _buildExpandableFilter(
                  'Brand Name', 
                  ['Bilal A', 'Maria B', 'SASHA BASICS'],
                ),
                const SizedBox(height: 24),
                
                // Product Type
                _buildSectionHeader(
                  icon: Icons.inventory_2,
                  title: 'Product Type',
                ),
                const SizedBox(height: 12),
                _buildExpandableFilter(
                  'Product Type',
                  ['Stitched', 'Unstitched', 'Semi-Stitched'],
                ),
                const SizedBox(height: 24),
                
                // Season
                _buildSectionHeader(
                  icon: Icons.sunny,
                  title: 'Season',
                ),
                const SizedBox(height: 12),
                _buildExpandableFilter(
                  'Season',
                  ['Summer', 'Winter', 'Spring', 'Fall'],
                ),
                const SizedBox(height: 24),
                
                // Fit Type
                _buildSectionHeader(
                  icon: Icons.straighten,
                  title: 'Fit Type',
                ),
                const SizedBox(height: 12),
                _buildExpandableFilter(
                  'Fit Type',
                  ['Regular', 'Slim', 'Loose'],
                ),
                const SizedBox(height: 24),
                
                // Collection
                _buildSectionHeader(
                  icon: Icons.collections,
                  title: 'Collection',
                ),
                const SizedBox(height: 12),
                _buildExpandableFilter(
                  'Collection',
                  [
                    'Eid Collection 2025',
                    'Summer Collection',
                    'Winter Collection',
                  ],
                ),
                const SizedBox(height: 24),
                
                // Category
                _buildSectionHeader(
                  icon: Icons.label,
                  title: 'Category',
                ),
                const SizedBox(height: 12),
                _buildExpandableFilter(
                  'Category',
                  ['Dresses', 'Tops', 'Bottoms', 'Accessories', 'Shoes'],
                ),
                const SizedBox(height: 24),
                
                // Sort By Section
                _buildSectionHeader(
                  icon: Icons.sort,
                  title: 'Sort By',
                  subtitle: 'Choose how to sort products',
                ),
                const SizedBox(height: 12),
                _buildSortSection(),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    // Call the callback to handle navigation
                    widget.onApplyFilters(_filters, _sortOption);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterListSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
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
    );
  }

  Widget _buildExpandableFilter(String title, List<String> options) {
    String filterKey = _getFilterKey(title);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options
                  .map((option) => ChoiceChip(
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
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Featured'),
            subtitle: const Text('Default sorting'),
            value: 'Featured',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Best Selling'),
            subtitle: const Text('Sort by popularity'),
            value: 'Best Selling',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Alphabetically, A-Z'),
            subtitle: const Text('Name A to Z'),
            value: 'Alphabetically, A-Z',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Alphabetically, Z-A'),
            subtitle: const Text('Name Z to A'),
            value: 'Alphabetically, Z-A',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Price, Low to High'),
            subtitle: const Text('Price ascending'),
            value: 'Price, Low to High',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Price, High to Low'),
            subtitle: const Text('Price descending'),
            value: 'Price, High to Low',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Date, New to Old'),
            subtitle: const Text('Newest first'),
            value: 'Date, New to Old',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Date, Old to New'),
            subtitle: const Text('Oldest first'),
            value: 'Date, Old to New',
            groupValue: _sortOption,
            onChanged: (value) => setState(() => _sortOption = value!),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
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

  bool hasActiveFilters() {
    return _filters.isNotEmpty && _filters.values.any((value) {
      if (value is List) return value.isNotEmpty;
      return value != null && value != '';
    });
  }

  int _getActiveFilterCount() {
    int count = 0;
    _filters.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        count += value.length;
      } else if (value != null && value != '') {
        count++;
      }
    });
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _sortOption = 'Featured';
    });
  }
}

