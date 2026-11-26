import 'package:flutter/material.dart';

/// RIHL brand colors (from the team's design system).
///
/// Always use these instead of hard-coded colors in screens and widgets.
class AppColors {
  AppColors._();

  /// Main buttons and headings.
  static const Color primary = Color(0xFF064C50);

  /// Icons and secondary elements.
  static const Color secondary = Color(0xFF598672);

  /// Cards, borders and highlighted elements.
  static const Color accent = Color(0xFFC7D9CB);

  /// App background.
  static const Color background = Color(0xFFF5F8F6);

  /// Field and card background.
  static const Color surface = Color(0xFFFFFFFF);

  /// Main text.
  static const Color text = Color(0xFF172D2B);

  /// Error messages.
  static const Color error = Color(0xFFDC2626);

  // Derived tones. These two are not in the original palette.

  /// Hints and secondary text.
  static const Color textMuted = Color(0xFF5F7370);

  /// Disabled elements.
  static const Color disabled = Color(0xFFB7C6BE);
}
