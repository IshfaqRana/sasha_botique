import 'package:flutter/material.dart';

class SearchOverlay extends StatelessWidget {
  const SearchOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Find Products',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          CategoryExpansionTile(
            title: 'All Brands',
            children: ['Zara', 'H&M', 'Uniqlo'],
          ),
          CategoryExpansionTile(
            title: 'Winter Categories',
            children: ['Jackets', 'Sweaters', 'Boots'],
          ),
          // Add more categories...
        ],
      ),
    );
  }
}
class CategoryExpansionTile extends StatelessWidget {
  final String title;
  final List<String> children;

  const CategoryExpansionTile({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: children
          .map((child) => ListTile(
        title: Text(child),
        onTap: () {
          // Handle category selection
        },
      ))
          .toList(),
    );
  }
}