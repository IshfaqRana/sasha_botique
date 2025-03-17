// lib/features/payment/presentation/widgets/card_input_formatter.dart
import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Initialize variables
    StringBuffer buffer = StringBuffer();
    int offset = 0;

    // Format in groups of 4 digits
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
        offset++;
      }
    }

    // Calculate cursor position
    var cursorPosition = newValue.selection.end + (buffer.length - newValue.text.length);

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Initialize variables
    StringBuffer buffer = StringBuffer();
    int offset = 0;

    // Add first part (month)
    if (text.length >= 1) {
      buffer.write(text.substring(0, text.length > 2 ? 2 : text.length));
    }

    // Add separator
    if (text.length > 2) {
      buffer.write('/');
      offset++;
    }

    // Add second part (year)
    if (text.length > 2) {
      buffer.write(text.substring(2, text.length));
    }

    // Calculate cursor position
    var cursorPosition = newValue.selection.end + (buffer.length - newValue.text.length);

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}