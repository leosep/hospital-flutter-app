// Import necessary packages
import 'package:flutter/services.dart';

// Custom TextInputFormatter for formatting phone numbers
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters from the input
    final filteredValue = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Create a new selection for the formatted value
    final newSelection = newValue.selection.copyWith(
      baseOffset: newValue.text.length,
      extentOffset: newValue.text.length,
    );

    // Return the formatted value with updated selection and no composition
    return TextEditingValue(
      text: formatPhoneNumber(filteredValue), // Apply phone number formatting
      selection: newSelection,
      composing: TextRange.empty,
    );
  }

  // Function to format the phone number
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 3) {
      return phoneNumber; // Return as-is if it's less than or equal to 3 digits
    } else if (phoneNumber.length <= 6) {
      // Format as (XXX) XXXXXXX for phone numbers between 4 and 6 digits
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3)}';
    } else {
      // Format as (XXX) XXX-XXXX for phone numbers longer than 6 digits
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
  }
}
