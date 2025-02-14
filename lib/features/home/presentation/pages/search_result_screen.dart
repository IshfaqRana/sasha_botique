import 'package:flutter/material.dart';

import '../widgets/product_card.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SearchBar(),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) => SizedBox(

              ),
              itemCount: 4, // Replace with actual product count
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text('139 Items found for "Hoodies"'),
          const Spacer(),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              'Featured',
              'Best Selling',
              'A-Z',
              'Z-A',
              'Price High-Low',
              'Price Low-High',
              'Date Old-New',
              'Date New-Old',
            ].map((option) => PopupMenuItem(
              value: option,
              child: Text(option),
            )).toList(),
            onSelected: (value) {
              // Implement sorting logic
            },
          ),
        ],
      ),
    );
  }
}