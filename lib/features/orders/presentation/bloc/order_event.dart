part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class CreateOrderEvent extends OrderEvent {
  final CreateOrderParams params;

  const CreateOrderEvent({
    required this.params,
  });

  @override
  List<Object> get props => [params];
}
class UpdatePaymentURLEvent extends OrderEvent {
  final String orderID;

  const UpdatePaymentURLEvent({
    required this.orderID,
  });

  @override
  List<Object> get props => [orderID];
}

class GetOrderByIdEvent extends OrderEvent {
  final String orderId;

  const GetOrderByIdEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class GetAllOrdersEvent extends OrderEvent {}
class GetPromoCodesEvent extends OrderEvent {}


