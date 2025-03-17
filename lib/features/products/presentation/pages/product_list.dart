import 'package:flutter/material.dart';
import 'package:sasha_botique/shared/widgets/loading_widget.dart';

import '../../../../core/utils/app_utils.dart';
import '../../domain/entities/products.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_product_screen.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;
  final bool isGridView;
  final bool hasMoreData;
  final bool isLoading;
  final Function() onLoadMore;
  final Function() onInitial;
  final Function(Product) onProductTap;

  const ProductList({
    Key? key,
    required this.products,
    required this.isGridView,
    required this.hasMoreData,
    required this.isLoading,
    required this.onLoadMore,
    required this.onProductTap,
    required this.onInitial,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    widget.onInitial();
    _scrollController.addListener(_onScroll);
    debugPrinter('_ProductListState.initState: ProductList: ${widget.products.length}');
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isGridView
        ? CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => GestureDetector(
                onTap: () => widget.onProductTap(widget.products[index]),
                child: SizedBox(
                  height: 400,
                  width: 170,
                  child: ProductCard(
                    product: widget.products[index],
                    index: index + 1,
                  ),
                ),
              ),
              childCount: widget.products.length,
            ),
          ),
        ),
        // Footer
        if (widget.products.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0,right: 12, top: 20,bottom: 50),
              child: !widget.hasMoreData
                  ? EmptyProductList(emptyList: false)
                  : widget.isLoading
                  ? AppLoading()
                  : SizedBox(),
            ),
          ),
      ],
    )
        : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: widget.products.length + 1,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => widget.onProductTap(widget.products[index]),
              child: index < widget.products.length
                  ? ProductCard(
                      product: widget.products[index],
                      isListView: true,
                      index: index + 1,
                    )
                  : Padding(
                padding: const EdgeInsets.only(left: 12.0,right: 12, top: 30,bottom: 30),
                      child: !widget.hasMoreData
                          ? EmptyProductList(
                              emptyList: false,
                            )
                          : widget.isLoading
                              ? AppLoading()
                              : SizedBox(),
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
