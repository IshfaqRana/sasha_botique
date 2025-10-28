import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/app_utils.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.obscureText = false,
    this.onChange,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode customFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      focusNode: widget.focusNode ?? customFocusNode,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: (text){
        if (widget.onChange != null) {
          widget.onChange!(text); // Call the onChange callback
        }
        setState(() {

        });
        debugPrinter("Entering Text.... $text");
      },
      decoration: InputDecoration(
        labelText: widget.label,
        errorMaxLines: 3,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,

// prefix: SvgPicture.asset('assets/svgs/email.svg'),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: widget.validator,
    );
  }
}
