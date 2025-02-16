import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/shared/extensions/widget_extensions.dart';

import '../../../../shared/widgets/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchProductsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text('Find Products',style: context.headlineSmall?.copyWith(fontSize: 18),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              controller: searchProductsController, label: 'Search here...',
              // suffixIcon: SvgPicture.asset('assets/svgs/email.svg',color: Colors.black,width: 25,height: 25),
              prefixIcon:Icon(Icons.search),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFilterSection('All Brands',['Zara', 'H&M', 'Uniqlo'],),
                  _buildFilterSection('Winter Categories',['Jackets', 'Sweaters', 'Boots'],),
                  _buildFilterSection('Summer Categories',[]),
                  _buildFilterSection('Stitched',[]),
                  _buildFilterSection('Unstitched',[]),
                  _buildFilterSection('Shirts',[]),
                  _buildFilterSection('Bottoms',[]),
                  _buildFilterSection('Dupattas',[]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title,List<String> children) {
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