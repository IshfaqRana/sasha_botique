part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  final List<PaymentMethod> paymentMethods;
  const PaymentState(this.paymentMethods);

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {
  PaymentInitial(super.paymentMethods);
}

class PaymentLoading extends PaymentState {
  PaymentLoading(super.paymentMethods);
}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethod> loadedPaymentMethods;

  const PaymentMethodsLoaded(super.paymentMethods,this.loadedPaymentMethods);

  @override
  List<Object> get props => [paymentMethods];
}

class PaymentOperationSuccess extends PaymentState {
  final String message;

  const PaymentOperationSuccess(this.message,super.paymentMethods);

  @override
  List<Object> get props => [message];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message,super.paymentMethods);

  @override
  List<Object> get props => [message];
}