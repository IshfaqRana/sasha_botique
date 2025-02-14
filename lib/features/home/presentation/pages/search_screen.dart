import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Find Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              onChanged: (query) {
                // Implement search logic
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFilterSection('All Brands'),
                  _buildFilterSection('Winter Categories'),
                  _buildFilterSection('Summer Categories'),
                  _buildFilterSection('Stitched'),
                  _buildFilterSection('Unstitched'),
                  _buildFilterSection('Shirts'),
                  _buildFilterSection('Bottoms'),
                  _buildFilterSection('Dupattas'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFilterSection(String title) {
    return ExpansionTile(
      title: Text(title),
      children: [
        // Add filter options specific to each section
      ],
    );
  }
}