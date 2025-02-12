import 'package:flutter/material.dart';

import '../../domain/entities/products.dart';
import '../widgets/product_card.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;
  final bool isGridView;
  final Function() onLoadMore;
  final Function(Product) onProductTap;

  const ProductList({
    Key? key,
    required this.products,
    required this.isGridView,
    required this.onLoadMore,
    required this.onProductTap,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    print('_ProductListState.initState: ProductList: ${widget.products.length}');
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isGridView
        ? GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => widget.onProductTap(widget.products[index]),
        child: SizedBox(
          height: 320,
          width: 170,
          child: ProductCard(
            product: widget.products[index],
          ),
        ),
      ),
    )
        : ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.products.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => widget.onProductTap(widget.products[index]),
        child: ProductCard(
          product: widget.products[index],
          isListView: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}