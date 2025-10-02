import 'package:flutter/material.dart';
import 'package:sasha_botique/shared/widgets/loading_widget.dart';

import 'empty_product_screen.dart';

class SliverGridFooter extends StatelessWidget {
  final bool hasMoreData;
  final bool isLoading;

  const SliverGridFooter({
    Key? key,
    required this.hasMoreData,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set width to match grid width
      width: double.infinity,
      // Set height to match grid item height
      height: 100,
      // Remove grid spacing on the last item
      margin: const EdgeInsets.only(top: -16),
      // Span both columns
      // gridSpan: 2,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: isLoading
              ? AppLoading()
              : hasMoreData
                  ? EmptyProductList(emptyList: false)
                  : const Text(
                      'Sorry, No more products.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
        ),
      ),
    );
  }
}
