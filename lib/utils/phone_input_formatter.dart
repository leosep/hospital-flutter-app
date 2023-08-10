import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredValue = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    final newSelection = newValue.selection.copyWith(
      baseOffset: newValue.text.length,
      extentOffset: newValue.text.length,
    );

    return TextEditingValue(
      text: formatPhoneNumber(filteredValue),
      selection: newSelection,
      composing: TextRange.empty,
    );
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 3) {
      return phoneNumber;
    } else if (phoneNumber.length <= 6) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3)}';
    } else {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
  }
}
