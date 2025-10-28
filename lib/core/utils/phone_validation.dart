import 'package:flutter/services.dart';

/// UK Mobile Number Validation Utility
class PhoneValidation {
  /// UK mobile number patterns
  static const String ukMobilePattern = r'^(\+447[0-9]{9}|07[0-9]{9}|7[0-9]{9})$';
  static const String ukMobileCleanPattern = r'^7[0-9]{9}$';
  
  /// Valid UK mobile prefixes
  static const List<String> validUkMobilePrefixes = [
    '70', '71', '72', '73', '74', '75', '76', '77', '78', '79'
  ];

  /// Validates UK mobile number format
  /// Accepts formats: +447XXXXXXXXX, 07XXXXXXXXX, 7XXXXXXXXX
  static bool isValidUkMobile(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;
    
    // Remove all spaces, dashes, and parentheses
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check if it matches UK mobile pattern
    final regex = RegExp(ukMobilePattern);
    if (!regex.hasMatch(cleanNumber)) return false;
    
    // Extract the 10-digit number (remove +44 or 0 prefix)
    String mobileNumber = cleanNumber;
    if (cleanNumber.startsWith('+447')) {
      // +447XXXXXXXXX format - should have exactly 13 characters total
      if (cleanNumber.length != 13) return false;
      mobileNumber = cleanNumber.substring(3); // Remove +44, keep 7XXXXXXXXX
    } else if (cleanNumber.startsWith('07')) {
      // 07XXXXXXXXX format - should have exactly 11 characters total
      if (cleanNumber.length != 11) return false;
      mobileNumber = cleanNumber.substring(1); // Remove 0, keep 7XXXXXXXXX
    } else if (cleanNumber.startsWith('7')) {
      // 7XXXXXXXXX format - should have exactly 10 characters total
      if (cleanNumber.length != 10) return false;
      mobileNumber = cleanNumber; // Keep as is
    } else {
      return false; // Doesn't match any expected format
    }
    
    // Check if it's exactly 10 digits starting with 7
    if (mobileNumber.length != 10 || !mobileNumber.startsWith('7')) {
      return false;
    }
    
    // Check if the prefix is valid (70-79)
    String prefix = mobileNumber.substring(0, 2);
    return validUkMobilePrefixes.contains(prefix);
  }

  /// Formats phone number for display
  /// Converts to format: +44 7XXX XXX XXX
  static String formatUkMobile(String phoneNumber) {
    if (phoneNumber.isEmpty) return '';
    
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Remove +44 or 0 prefix
    if (cleanNumber.startsWith('+44')) {
      cleanNumber = cleanNumber.substring(3);
    } else if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }
    
    // Format as +44 7XXX XXX XXX
    if (cleanNumber.length == 10 && cleanNumber.startsWith('7')) {
      return '+44 ${cleanNumber.substring(0, 4)} ${cleanNumber.substring(4, 7)} ${cleanNumber.substring(7)}';
    }
    
    return phoneNumber;
  }

  /// Gets validation error message
  static String? getValidationError(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return 'Phone number is required';
    }
    
    if (!isValidUkMobile(phoneNumber)) {
      return 'Please enter a valid UK mobile number\n(e.g., 07XXXXXXXXX or +447XXXXXXXXX)';
    }
    
    return null;
  }

  /// Input formatters for UK mobile numbers
  static List<TextInputFormatter> getUkMobileFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-\(\)]')),
      LengthLimitingTextInputFormatter(15), // +44 7XXX XXX XXX = 15 chars max
      _UkMobileInputFormatter(),
    ];
  }

  /// Cleans phone number to standard format (7XXXXXXXXX)
  static String cleanUkMobile(String phoneNumber) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (cleanNumber.startsWith('+44')) {
      return cleanNumber.substring(3);
    } else if (cleanNumber.startsWith('0')) {
      return cleanNumber.substring(1);
    }
    
    return cleanNumber;
  }
}

/// Custom input formatter for UK mobile numbers
class _UkMobileInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    int selectionIndex = newValue.selection.baseOffset;
    
    // Remove all non-digit characters except + at the beginning
    String digitsOnly = text.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Calculate how many characters were removed
    int removedChars = text.length - digitsOnly.length;
    
    // Adjust cursor position based on removed characters
    int adjustedCursorPosition = selectionIndex - removedChars;
    
    // If it starts with +44, keep it
    if (digitsOnly.startsWith('+44')) {
      // Limit to +44 followed by 10 digits
      if (digitsOnly.length > 13) {
        digitsOnly = digitsOnly.substring(0, 13);
        adjustedCursorPosition = adjustedCursorPosition > 13 ? 13 : adjustedCursorPosition;
      }
    } else if (digitsOnly.startsWith('0')) {
      // If it starts with 0, limit to 11 digits (0 + 10 digits)
      if (digitsOnly.length > 11) {
        digitsOnly = digitsOnly.substring(0, 11);
        adjustedCursorPosition = adjustedCursorPosition > 11 ? 11 : adjustedCursorPosition;
      }
    } else {
      // If it starts with 7, limit to 10 digits
      if (digitsOnly.length > 10) {
        digitsOnly = digitsOnly.substring(0, 10);
        adjustedCursorPosition = adjustedCursorPosition > 10 ? 10 : adjustedCursorPosition;
      }
    }
    
    // Ensure cursor position is within bounds
    if (adjustedCursorPosition < 0) adjustedCursorPosition = 0;
    if (adjustedCursorPosition > digitsOnly.length) adjustedCursorPosition = digitsOnly.length;
    
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: adjustedCursorPosition),
    );
  }
}



