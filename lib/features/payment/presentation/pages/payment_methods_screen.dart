// lib/features/payment/presentation/pages/payment_methods_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';

import '../../domain/entities/payment_method.dart';
import '../bloc/payment_bloc.dart';
import '../widgets/payment_method_card.dart';
import 'add_payment_method_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  late final PaymentBloc paymentBloc;
  @override
  void initState() {
    super.initState();
    paymentBloc = getIt<PaymentBloc>()..add(GetPaymentMethodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      bloc: paymentBloc,
      listener: (context, state) {
        if (state is PaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is PaymentOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final paymentMethods = state.paymentMethods;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Payment Methods',
              style: context.titleMedium,
            ),
            centerTitle: true,
          ),
          body: state is PaymentLoading
              ? const Center(child: CircularProgressIndicator())
              : state is PaymentMethodsLoaded
                  ? paymentMethods.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No payment methods added yet',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),

                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            final paymentMethod = paymentMethods[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: PaymentMethodCard(
                                paymentMethod: paymentMethod,
                                onDelete: () {
                                  _confirmDeletePaymentMethod(context, paymentMethod);
                                },
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddPaymentMethodScreen(
                                        paymentMethod: paymentMethod,
                                      ),
                                    ),
                                  );
                                },
                                onSetDefault: () {
                                  if (!paymentMethod.isDefault) {
                                    paymentBloc.add(
                                      SetDefaultPaymentMethodEvent(paymentMethod.id),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        )
                  : const Center(child: Text('Something went wrong')),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => const AddPaymentMethodScreen(),
          //       ),
          //     );
          //   },
          //   child: const Icon(Icons.add),
          // ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddPaymentMethodScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20.0),
                // ),
              ),
              child: const Text(
                'Add Payment Method',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDeletePaymentMethod(BuildContext context, PaymentMethod paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text('Are you sure you want to delete this payment method ending in ${paymentMethod.last4Digits}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              paymentBloc.add(DeletePaymentMethodEvent(paymentMethod.id));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
