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
  final PaymentMethod paymentMethod; final PaymentMethod paymentMethod2;
  final bool defaultValue;

  const SetDefaultPaymentMethodEvent(this.paymentMethod,this.paymentMethod2,this.defaultValue);

  @override
  List<Object> get props => [paymentMethod,paymentMethod2,defaultValue];
}