// core/utils/capitalize_formatter.dart
import 'package:flutter/services.dart';

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final capitalized = text[0].toUpperCase() + text.substring(1);
    if (capitalized == text) return newValue;

    return newValue.copyWith(
      text: capitalized,
      selection: newValue.selection,
    );
  }
}