// lib/features/payment/presentation/pages/add_payment_method_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/shared/widgets/loading_overlay.dart';

import '../../../../core/di/injections.dart';
import '../../domain/entities/payment_method.dart';
import '../bloc/payment_bloc.dart';
import '../widgets/card_input_formatter.dart';


class AddPaymentMethodScreen extends StatefulWidget {
  final PaymentMethod? paymentMethod;
  final int? index;

  const AddPaymentMethodScreen({Key? key, this.paymentMethod,required this.index}) : super(key: key);

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  late final PaymentBloc paymentBloc;


  late final TextEditingController _nameController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _cvcController;

  String _cardType = 'Credit';
  String _country = 'UK';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    paymentBloc = getIt<PaymentBloc>();


    // Initialize controllers with existing data if editing
    if (widget.paymentMethod != null) {
      _nameController = TextEditingController(text: widget.paymentMethod!.cardHolderName);
      _cardNumberController = TextEditingController(text: '**** **** **** ${widget.paymentMethod!.last4Digits}');
      _expiryDateController = TextEditingController(text: widget.paymentMethod!.expiryDate);
      _cvcController = TextEditingController();
      _cardType = widget.paymentMethod!.type;
      _country = widget.paymentMethod!.country;
      _isDefault = widget.paymentMethod!.isDefault;
    } else {
      _nameController = TextEditingController();
      _cardNumberController = TextEditingController();
      _expiryDateController = TextEditingController();
      _cvcController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paymentMethod != null ? 'Edit Payment Method' : 'Add Payment Method',style: context.titleMedium,),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        bloc: paymentBloc,
        listener: (context, state) {
          if (state is PaymentOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder:(context,state) {
          return LoadingOverlay(
            isLoading: state is PaymentLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card preview
                    _buildCardPreview(),

                    const SizedBox(height: 24),

                    // Card form
                    Text(
                      'Name on card',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card holder name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Card number',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(
                        hintText: '4747 4747 4747 4747',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/mastercard.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberInputFormatter(),
                        LengthLimitingTextInputFormatter(19),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        if (value
                            .replaceAll(' ', '')
                            .length < 16) {
                          return 'Please enter a valid card number';
                        }
                        return null;
                      },
                      enabled: widget.paymentMethod == null, // Only enable for new cards
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry date',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _expiryDateController,
                                decoration: InputDecoration(
                                  hintText: 'MM/YY',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ExpiryDateInputFormatter(),
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter expiry date';
                                  }
                                  if (value.length < 5) {
                                    return 'Invalid format';
                                  }
                                  if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                                    return 'Invalid format (MM/YY)';
                                  }

                                  // Extract month and year
                                  List<String> parts = value.split('/');
                                  int month = int.tryParse(parts[0]) ?? 0;
                                  int year = int.tryParse(parts[1]) ?? 0;

                                  // Get current month and year
                                  DateTime now = DateTime.now();
                                  int currentYear = now.year % 100; // Extract last 2 digits of the year
                                  int currentMonth = now.month;

                                  // Check if expiry date is in the past
                                  if (year < currentYear || (year == currentYear && month < currentMonth)) {
                                    return 'Card has expired';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CVC',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _cvcController,
                                decoration: InputDecoration(
                                  hintText: '474',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                validator: (value) {
                                  if (widget.paymentMethod == null && (value == null || value.isEmpty)) {
                                    return 'Please enter CVC';
                                  }
                                  if (value != null && value.isNotEmpty && value.length < 3) {
                                    return 'Invalid CVC';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Card type
                    Text(
                      'Card type',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _cardType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Credit', child: Text('Credit')),
                        DropdownMenuItem(value: 'Debit', child: Text('Debit')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _cardType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Country
                    Text(
                      'Country',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _country,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'UK', child: Text('United Kingdom')),
                        DropdownMenuItem(value: 'US', child: Text('United States')),
                        DropdownMenuItem(value: 'CA', child: Text('Canada')),
                        DropdownMenuItem(value: 'AU', child: Text('Australia')),
                        DropdownMenuItem(value: 'PK', child: Text('Pakistan')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _country = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // Set as default
                    CheckboxListTile(
                      title: const Text('Set as default payment method'),
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _submitForm(state),
                        child: Text(widget.paymentMethod != null ? 'UPDATE CARD' : 'USE THIS CARD'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit / Debit card',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              Image.asset(
                'assets/images/mastercard.png',
                width: 40,
                height: 40,
              ),
            ],
          ),
          Text(
            _cardNumberController.text.isEmpty
                ? '5757 4747 5757 4747'
                : _cardNumberController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER NAME',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _nameController.text.isEmpty
                        ? 'VARAT SINGH SHARMA'
                        : _nameController.text.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _expiryDateController.text.isEmpty
                        ? '07/21'
                        : _expiryDateController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitForm(PaymentState state) {
    if (_formKey.currentState!.validate()) {
      final String last4Digits;

      // Get last 4 digits from card number
      if (widget.paymentMethod != null) {
        // If editing existing card, use the stored last 4 digits
        last4Digits = widget.paymentMethod!.last4Digits;
      } else {
        // For new card, extract from the input field
        final cardNumber = _cardNumberController.text.replaceAll(' ', '');
        last4Digits = cardNumber.substring(cardNumber.length - 4);
      }

      final paymentMethod = PaymentMethod(
        id: widget.paymentMethod != null ? widget.index.toString() : state.paymentMethods.length.toString(),
        type: _cardType,
        last4Digits: last4Digits,
        cardHolderName: _nameController.text,
        expiryDate: _expiryDateController.text,
        country: _country,
        isDefault: _isDefault,
      );

      if (widget.paymentMethod != null) {
        paymentBloc.add(UpdatePaymentMethodEvent(paymentMethod));
      } else {
        paymentBloc.add(AddPaymentMethodEvent(paymentMethod));
      }
    }
  }
}