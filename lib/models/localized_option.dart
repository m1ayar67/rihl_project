import 'package:flutter/foundation.dart';

/// A choice shown in a dropdown.
///
/// [code] is the stable value that is stored and sent to the backend.
/// The labels are only for display, one per supported language.
@immutable
class LocalizedOption {
  const LocalizedOption({
    required this.code,
    required this.en,
    required this.ar,
  });

  /// Stable identifier, for example `jeddah`. Never translate or rename it.
  final String code;

  /// English label.
  final String en;

  /// Arabic label.
  final String ar;

  /// Label for the given language code (`en` or `ar`).
  String label(String languageCode) => languageCode == 'ar' ? ar : en;

  /// Returns the option with the given [code], or null if there is none.
  static LocalizedOption? find(List<LocalizedOption> options, String? code) {
    for (final option in options) {
      if (option.code == code) return option;
    }
    return null;
  }
}
