import 'package:flutter/services.dart';

/// Formatting and parsing helpers shared by the whole app.
class AppFormatters {
  AppFormatters._();

  /// Dates are written as `YYYY-MM-DD` everywhere (screens and backend).
  static String date(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Turns Arabic-Indic digits (٠-٩), Persian digits (۰-۹) and the Arabic
  /// decimal separator (٫) into their ASCII form, so `٢٥٠٫٥` becomes `250.5`.
  static String normalizeDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x0660 && rune <= 0x0669) {
        buffer.writeCharCode(rune - 0x0660 + 0x30);
      } else if (rune >= 0x06F0 && rune <= 0x06F9) {
        buffer.writeCharCode(rune - 0x06F0 + 0x30);
      } else if (rune == 0x066B) {
        buffer.write('.');
      } else if (rune == 0x066C) {
        // Arabic thousands separator: ignore it.
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  /// Parses a number typed with Western or Arabic digits. Returns null when the
  /// text is empty or is not a number.
  static double? parseNumber(String? input) {
    if (input == null) return null;
    final text = normalizeDigits(input.trim());
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  /// Lets the user type only digits (Western or Arabic) and a decimal point.
  static final List<TextInputFormatter> decimalInput = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩۰-۹.٫]')),
  ];
}
