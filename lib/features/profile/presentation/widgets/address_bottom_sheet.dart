// lib/features/address/presentation/widgets/address_form_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/user_address_reponse_model.dart';
import '../../domain/entities/user_address.dart';

class AddressFormBottomSheet extends StatefulWidget {
  final UserAddress? existingAddress;
  final Function(UserAddress) onSubmit;

  const AddressFormBottomSheet({
    Key? key,
    this.existingAddress,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddressFormBottomSheet> createState() => _AddressFormBottomSheetState();
}

class _AddressFormBottomSheetState extends State<AddressFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _streetController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _instructionsController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _streetController =
        TextEditingController(text: widget.existingAddress?.street ?? '');
    _nameController =
        TextEditingController(text: widget.existingAddress?.name ?? '');
    final existingPhone = widget.existingAddress?.phone ?? '';
    // Expect stored format to be +44XXXXXXXXXX; strip +44 if present for editing
    final phoneWithoutCode =
        existingPhone.startsWith('+44') && existingPhone.length > 3
            ? existingPhone.substring(3)
            : existingPhone;
    _phoneController = TextEditingController(text: phoneWithoutCode);
    _instructionsController =
        TextEditingController(text: widget.existingAddress?.instruction ?? '');
    _cityController =
        TextEditingController(text: widget.existingAddress?.city ?? '');
    _stateController =
        TextEditingController(text: widget.existingAddress?.state ?? '');
    _postalCodeController =
        TextEditingController(text: widget.existingAddress?.postalCode ?? '');
    _countryController =
        TextEditingController(text: widget.existingAddress?.country ?? '');
    _isDefault = widget.existingAddress?.isDefault ?? false;
  }

  @override
  void dispose() {
    _streetController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                _buildFormField(
                  label: 'Name',
                  hint: 'Please enter your name',
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? '* Please enter your name' : null,
                ),
                _buildFormField(
                  label: 'Street',
                  hint: 'Please enter street number',
                  controller: _streetController,
                  validator: (value) =>
                      value!.isEmpty ? '* Please enter street number' : null,
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'City',
                  hint: 'Please enter your city',
                  controller: _cityController,
                  validator: (value) =>
                      value!.isEmpty ? '*  Please enter your city' : null,
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'State/Province',
                  hint: 'Please enter your state/province',
                  controller: _stateController,
                  validator: (value) => value!.isEmpty
                      ? '* Please enter your state/province'
                      : null,
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Postal Code',
                  hint: 'Please enter postal code',
                  controller: _postalCodeController,
                  validator: (value) =>
                      value!.isEmpty ? '* Please enter postal code' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Country',
                  hint: 'Please enter country',
                  controller: _countryController,
                  validator: (value) =>
                      value!.isEmpty ? '*  Please enter country' : null,
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Number',
                  hint: 'Please enter phone number',
                  controller: _phoneController,
                  validator: (value) {
                    final input = (value ?? '').trim();
                    if (input.isEmpty) return '* Please enter phone number';
                    // UK mobile local format: 7XXXXXXXXX (10 digits, starts with 7)
                    final isUkMobile = RegExp(r'^7\d{9}').hasMatch(input);
                    if (!isUkMobile)
                      return 'Enter valid UK mobile (starts with 7, 10 digits)';
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  isPhone: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Delivery Instructions',
                  hint: 'Please enter delivery instructions',
                  controller: _instructionsController,
                  validator: (value) => value!.isEmpty
                      ? '* Please enter delivery instructions'
                      : null,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Checkbox(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value ?? false;
                        });
                      },
                      // fillColor: WidgetStateProperty.resolveWith<Color>(
                      //       (Set<WidgetState> states) {
                      //     return Colors.white;
                      //   },
                      // ),
                    ),
                    const Text(
                      'Set as default address',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      widget.existingAddress == null
                          ? 'ADD ADDRESS'
                          : 'UPDATE ADDRESS',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
    bool isPhone = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            errorMaxLines: 3,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            prefixText: isPhone ? "+44" : "",
            // SizedBox(
            //   width: 40,
            //   child: Text(
            //     "+44",
            //     style: const TextStyle(
            //       color: Colors.grey,
            //       fontSize: 14.0,
            //     ),
            //   ),
            // ):SizedBox(),
            // suffixIcon: Padding(
            //   padding: EdgeInsets.only(right: 12.0),
            //   child: Text(
            //     '*',
            //     style: TextStyle(color: Colors.red, fontSize: 20.0),
            //   ),
            // ),
            suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        UserAddressModel(
          name: _nameController.text,
          instruction: _instructionsController.text,
          phone: "+44${_phoneController.text}",
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          postalCode: _postalCodeController.text,
          country: _countryController.text,
          isDefault: _isDefault,
        ),
      );
    }
  }
}
