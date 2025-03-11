import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/products.dart';
import '../../../domain/usecases/fetch_product_detail.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  FetchProductDetailUseCase  fetchProductDetailUseCase;
  ProductDetailBloc({required this.fetchProductDetailUseCase}) : super(ProductDetailInitial()) {
    on<FetchProductDetail>((event, emit) async {
      emit(ProductDetailLoading());
      try{
        Product? product =await fetchProductDetailUseCase(event.productId);
        if(product!=null){
          emit(ProductDetailLoaded(product: product));
        }else{
          emit(ProductDetailError(message: "Something went wrong!"));
        }
      }catch(e){
        emit(ProductDetailError(message: e.toString()));
      }
    });
  }
}
