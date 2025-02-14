import 'package:flutter/material.dart';

class EmptyProductList extends StatelessWidget {
  final bool emptyList;
  const EmptyProductList({
    super.key,
    this.emptyList = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(emptyList? "Sorry, there are no products here.": "Sorry, No more products."));
  }
}