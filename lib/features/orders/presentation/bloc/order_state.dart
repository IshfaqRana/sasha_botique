part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderCreateSuccess extends OrderState {
  final String orderId;
  final String paymentUrl;

  const OrderCreateSuccess({required this.orderId, required this.paymentUrl});

  @override
  List<Object> get props => [orderId, paymentUrl];
}

class OrderDetailsLoaded extends OrderState {
  final Order order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object> get props => [order];
}

class OrdersLoaded extends OrderState {
  final List<Order> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class PromoCodesLoading extends OrderState {}

class PromoCodesLoaded extends OrderState {
  final List<PromoCode> promoCodes;

  const PromoCodesLoaded(this.promoCodes);

  @override
  List<Object> get props => [promoCodes];
}

class PromoCodesError extends OrderState {
  final String message;

  const PromoCodesError(this.message);

  @override
  List<Object> get props => [message];
}