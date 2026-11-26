import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rihl/core/app_colors.dart';
import 'package:rihl/core/constants.dart';

/// The app theme. Arabic uses IBM Plex Sans Arabic, English uses Inter.
class AppTheme {
  AppTheme._();

  /// Set to false in tests so no font is downloaded.
  static bool useGoogleFonts = true;

  static ThemeData light(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    TextTheme textTheme = base.textTheme;
    if (useGoogleFonts) {
      // Apply the font style by style. (Using GoogleFonts.xxxTextTheme directly
      // can clash with Flutter's own TextTheme type in newer versions.)
      textTheme = _withFont(
        textTheme,
        isArabic
            ? (style) => GoogleFonts.ibmPlexSansArabic(textStyle: style)
            : (style) => GoogleFonts.inter(textStyle: style),
      );
    }
    textTheme = textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.primary,
          fontSize: AppSizes.headingSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: _inputTheme(),
    );
  }

  static TextTheme _withFont(
    TextTheme theme,
    TextStyle Function(TextStyle style) font,
  ) {
    TextStyle? map(TextStyle? style) => style == null ? null : font(style);
    return theme.copyWith(
      displayLarge: map(theme.displayLarge),
      displayMedium: map(theme.displayMedium),
      displaySmall: map(theme.displaySmall),
      headlineLarge: map(theme.headlineLarge),
      headlineMedium: map(theme.headlineMedium),
      headlineSmall: map(theme.headlineSmall),
      titleLarge: map(theme.titleLarge),
      titleMedium: map(theme.titleMedium),
      titleSmall: map(theme.titleSmall),
      bodyLarge: map(theme.bodyLarge),
      bodyMedium: map(theme.bodyMedium),
      bodySmall: map(theme.bodySmall),
      labelLarge: map(theme.labelLarge),
      labelMedium: map(theme.labelMedium),
      labelSmall: map(theme.labelSmall),
    );
  }

  static InputDecorationTheme _inputTheme() {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      border: border(AppColors.accent),
      enabledBorder: border(AppColors.accent),
      focusedBorder: border(AppColors.primary, 2),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error, 2),
    );
  }

  /// A ready-made decoration for fields that are not [CustomTextField]
  /// (for example the dropdowns and the date picker).
  static InputDecoration inputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
    String? suffixText,
    String? errorText,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      contentPadding: contentPadding,
      suffixText: suffixText,
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: AppColors.secondary),
    );
  }
}