part of 'product_details_bloc.dart';

abstract class ProductDetailEvent {}
class FetchProductDetail extends ProductDetailEvent {
  final String productId;
  FetchProductDetail({required this.productId});
}