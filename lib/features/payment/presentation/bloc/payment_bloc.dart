import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/add_payment_method.dart';
import '../../domain/usecases/delete_payment_method.dart';
import '../../domain/usecases/get_payment_methods.dart';
import '../../domain/usecases/set_default_payment_method.dart';
import '../../domain/usecases/update_payment_method.dart';

part 'payment_event.dart';
part 'payment_state.dart';


class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetPaymentMethods getPaymentMethods;
  final AddPaymentMethod addPaymentMethod;
  final UpdatePaymentMethod updatePaymentMethod;
  final DeletePaymentMethod deletePaymentMethod;
  final SetDefaultPaymentMethod setDefaultPaymentMethod;
   List<PaymentMethod> loadedPaymentMethods = [];

  PaymentBloc({
    required this.getPaymentMethods,
    required this.addPaymentMethod,
    required this.updatePaymentMethod,
    required this.deletePaymentMethod,
    required this.setDefaultPaymentMethod,
  }) : super(PaymentInitial([])) {
    on<GetPaymentMethodsEvent>(_onGetPaymentMethods);
    on<AddPaymentMethodEvent>(_onAddPaymentMethod);
    on<UpdatePaymentMethodEvent>(_onUpdatePaymentMethod);
    on<DeletePaymentMethodEvent>(_onDeletePaymentMethod);
    on<SetDefaultPaymentMethodEvent>(_onSetDefaultPaymentMethod);
  }

  void _onGetPaymentMethods(
      GetPaymentMethodsEvent event,
      Emitter<PaymentState> emit,
      ) async {
    emit(PaymentLoading(loadedPaymentMethods));
    // await Future.delayed(Duration(seconds: 5));
    try {
      final paymentMethods = await getPaymentMethods();
      loadedPaymentMethods = paymentMethods;
      emit(PaymentMethodsLoaded(paymentMethods,loadedPaymentMethods));
    } catch (e) {
      emit(PaymentError('Failed to load payment methods: ${e.toString()}',loadedPaymentMethods));
    }
  }

  void _onAddPaymentMethod(
      AddPaymentMethodEvent event,
      Emitter<PaymentState> emit,
      ) async {
    emit(PaymentLoading(loadedPaymentMethods));
    try {
      // Generate a unique ID if not provided
      PaymentMethod paymentMethod = event.paymentMethod;
      if (paymentMethod.id.isEmpty) {
        paymentMethod = PaymentMethod(
          id: loadedPaymentMethods.length.toString(),
          type: paymentMethod.type,
          last4Digits: paymentMethod.last4Digits,
          cardHolderName: paymentMethod.cardHolderName,
          expiryDate: paymentMethod.expiryDate,
          country: paymentMethod.country,
          isDefault: paymentMethod.isDefault,
        );
      }

      await addPaymentMethod(paymentMethod);
      emit( PaymentOperationSuccess('Payment method added successfully',loadedPaymentMethods));

      // Reload payment methods
      final paymentMethods = await getPaymentMethods();
      loadedPaymentMethods = paymentMethods;
      emit(PaymentMethodsLoaded(paymentMethods,loadedPaymentMethods));
    } catch (e) {
      emit(PaymentError('Failed to add payment method: ${e.toString()}',loadedPaymentMethods));
    }
  }

  void _onUpdatePaymentMethod(
      UpdatePaymentMethodEvent event,
      Emitter<PaymentState> emit,
      ) async {
    emit(PaymentLoading(loadedPaymentMethods));
    try {
      await updatePaymentMethod(event.paymentMethod);
      emit( PaymentOperationSuccess('Payment method updated successfully',loadedPaymentMethods));

      // Reload payment methods
      final paymentMethods = await getPaymentMethods();
      loadedPaymentMethods = paymentMethods;
      emit(PaymentMethodsLoaded(paymentMethods,loadedPaymentMethods));
    } catch (e) {
      emit(PaymentError('Failed to update payment method: ${e.toString()}',loadedPaymentMethods));
    }
  }

  void _onDeletePaymentMethod(
      DeletePaymentMethodEvent event,
      Emitter<PaymentState> emit,
      ) async {
    emit(PaymentLoading(loadedPaymentMethods));
    try {
      await deletePaymentMethod(event.id);
      emit( PaymentOperationSuccess('Payment method deleted successfully',loadedPaymentMethods));

      // Reload payment methods
      final paymentMethods = await getPaymentMethods();
      loadedPaymentMethods = paymentMethods;
      emit(PaymentMethodsLoaded(paymentMethods,loadedPaymentMethods));
    } catch (e) {
      emit(PaymentError('Failed to delete payment method: ${e.toString()}',loadedPaymentMethods));
    }
  }

  void _onSetDefaultPaymentMethod(
      SetDefaultPaymentMethodEvent event,
      Emitter<PaymentState> emit,
      ) async {
    emit(PaymentLoading(loadedPaymentMethods));
    try {
      await setDefaultPaymentMethod(event.paymentMethod,event.paymentMethod2,event.defaultValue);
      emit( PaymentOperationSuccess('Default payment method set successfully',loadedPaymentMethods));

      // Reload payment methods
      final paymentMethods = await getPaymentMethods();
      loadedPaymentMethods = paymentMethods;
      emit(PaymentMethodsLoaded(paymentMethods,loadedPaymentMethods));
    } catch (e) {
      emit(PaymentError('Failed to set default payment method: ${e.toString()}',loadedPaymentMethods));
    }
  }
}