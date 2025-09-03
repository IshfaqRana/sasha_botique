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
    debugPrinter(
        '_ProductListState.initState: ProductList: ${widget.products.length}');
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth < 900;

    // Responsive grid configuration
    int crossAxisCount;
    double childAspectRatio;
    double crossAxisSpacing;
    double mainAxisSpacing;

    if (isSmallScreen) {
      crossAxisCount = 2;
      childAspectRatio =
          0.8; // Adjusted to accommodate increased content height
      crossAxisSpacing = 12;
      mainAxisSpacing = 12;
    } else if (isMediumScreen) {
      crossAxisCount = 3;
      childAspectRatio =
          0.85; // Adjusted to accommodate increased content height
      crossAxisSpacing = 16;
      mainAxisSpacing = 16;
    } else {
      crossAxisCount = 4;
      childAspectRatio =
          0.9; // Adjusted to accommodate increased content height
      crossAxisSpacing = 20;
      mainAxisSpacing = 20;
    }

    return widget.isGridView
        ? CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => GestureDetector(
                      onTap: () => widget.onProductTap(widget.products[index]),
                      child: ProductCard(
                        product: widget.products[index],
                        index: index + 1,
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
                    padding: EdgeInsets.only(
                      left: isSmallScreen ? 8.0 : 12.0,
                      right: isSmallScreen ? 8.0 : 12.0,
                      top: 20,
                      bottom: 50,
                    ),
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
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            itemCount: widget.products.length + 1,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => widget.onProductTap(widget.products[index]),
              child: index < widget.products.length
                  ? Padding(
                      padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                      child: ProductCard(
                        product: widget.products[index],
                        isListView: true,
                        index: index + 1,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        left: isSmallScreen ? 8.0 : 12.0,
                        right: isSmallScreen ? 8.0 : 12.0,
                        top: 30,
                        bottom: 30,
                      ),
                      child: !widget.hasMoreData
                          ? EmptyProductList(emptyList: false)
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
