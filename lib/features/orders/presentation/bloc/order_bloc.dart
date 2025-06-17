import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sasha_botique/features/orders/domain/usecases/get_promo_codes.dart';
import 'package:sasha_botique/features/orders/domain/usecases/update_payment_url.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../../payment/data/data_model/payment_method_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../profile/data/models/user_address_reponse_model.dart';
import '../../domain/entities/create_order_params.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/promo_code_entity.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/get_all_orders.dart';
import '../../domain/usecases/get_user_by_id.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final GetAllOrdersUseCase getAllOrdersUseCase;
  final GetPromoCodesUseCase getPromoCodes;
  final UpdatePaymentUrlUseCase updatePaymentUrlUseCase;


  OrderBloc({
    required this.createOrderUseCase,
    required this.getOrderByIdUseCase,
    required this.getAllOrdersUseCase,
    required this.getPromoCodes,
    required this.updatePaymentUrlUseCase,
  }) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdatePaymentURLEvent>(_updatePaymentUrl);
    on<GetOrderByIdEvent>(_onGetOrderById);
    on<GetAllOrdersEvent>(_onGetAllOrders);
    on<GetPromoCodesEvent>(_onGetPromoCodesEvent);

  }
  Future<void> _onGetPromoCodesEvent(
      GetPromoCodesEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(PromoCodesLoading());
    try {
      final result = await getPromoCodes();

            emit(PromoCodesLoaded(result));

    }catch(e){
      emit(PromoCodesError('Failed to load promo codes'));
    }
  }
  void _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      print(event.params);
      final result = await createOrderUseCase(event.params);
      if (result.success) {
        emit(OrderCreateSuccess(orderId: result.orderId, paymentUrl: result.paymentUrl));
      } else {
        emit(OrderError("Something went wrong, Try Again!"));
      }
    } catch (e) {
      emit(OrderError(_mapFailureToMessage(e)));
    }
  }
  void _updatePaymentUrl(UpdatePaymentURLEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final result = await updatePaymentUrlUseCase(event.orderID);
      if (result.success) {
        emit(OrderCreateSuccess(orderId: result.orderId, paymentUrl: result.paymentUrl));
      } else {
        emit(OrderError("Something went wrong, Try Again!"));
      }
    } catch (e) {
      emit(OrderError(_mapFailureToMessage(e)));
    }
  }

  void _onGetOrderById(GetOrderByIdEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final result = await getOrderByIdUseCase(event.orderId);

      emit(OrderDetailsLoaded(result));
    } catch (e) {
      emit(OrderError(_mapFailureToMessage(e)));
    }
  }

  void _onGetAllOrders(GetAllOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final result = await getAllOrdersUseCase();

      emit(OrdersLoaded(result));
    } catch (e) {
      emit(OrderError(_mapFailureToMessage(e)));
    }
  }
  String _mapFailureToMessage( exception) {
    switch (exception) {
      case NotFoundException _:
        return exception.message;
      case ServerException _:
        return 'Server Error: Please try again later';
      case NetworkException _:
        return 'Network Error: Please check your internet connection';
      case UnauthorizedException _:
        return exception.message;
      default:
        return exception?.toString() ?? 'Something went wrong. Please try again';
    }
  }
}
