part of 'product_details_bloc.dart';

abstract class ProductDetailState {}
class ProductDetailInitial extends ProductDetailState {}
class ProductDetailLoading extends ProductDetailState {}
class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  ProductDetailLoaded({required this.product});
}
class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError({required this.message});
}