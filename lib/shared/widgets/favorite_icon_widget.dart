import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injections.dart';
import '../../core/utils/app_utils.dart';
import '../../features/products/domain/entities/products.dart';
import '../../features/products/presentation/bloc/favorite/favorite_bloc.dart';

class FavouriteIconWidget extends StatefulWidget {
  Product product;
   FavouriteIconWidget({super.key,required this.product});

  @override
  State<FavouriteIconWidget> createState() => _FavouriteIconWidgetState();
}

class _FavouriteIconWidgetState extends State<FavouriteIconWidget> {
  late final FavoriteBloc _wishlistBloc;
  @override
  void initState() {
    _wishlistBloc = getIt<FavoriteBloc>();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      bloc: _wishlistBloc,
      builder: (context, state) {
        bool isWishlisted = widget.product.isWishlisted;

        if (state is LoadedFavProducts) {
          isWishlisted = isFavorite(widget.product.id, state.favoriteProductList);
        }

        return IconButton(
          onPressed: () {
            if (isWishlisted) {
              _wishlistBloc.add(RemoveFromFavoriteEvent(widget.product));
            } else {
              _wishlistBloc.add(AddToFavoriteEvent(widget.product));
            }
          },
          icon: Icon(
             isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: isWishlisted ? Colors.red : Colors.black,
          ),
        );
      },
    );
  }
}
