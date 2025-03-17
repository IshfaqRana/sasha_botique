part of 'payment_bloc.dart';


abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class GetPaymentMethodsEvent extends PaymentEvent {}

class AddPaymentMethodEvent extends PaymentEvent {
  final PaymentMethod paymentMethod;

  const AddPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

class UpdatePaymentMethodEvent extends PaymentEvent {
  final PaymentMethod paymentMethod;

  const UpdatePaymentMethodEvent(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

class DeletePaymentMethodEvent extends PaymentEvent {
  final String id;

  const DeletePaymentMethodEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SetDefaultPaymentMethodEvent extends PaymentEvent {
  final String id;

  const SetDefaultPaymentMethodEvent(this.id);

  @override
  List<Object> get props => [id];
}