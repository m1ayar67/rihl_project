import 'package:flutter/material.dart';
import 'package:rihl/core/app_colors.dart';
import 'package:rihl/core/app_locale.dart';

/// Small button for the AppBar that switches between English and Arabic.
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return TextButton.icon(
      onPressed: AppLocale.toggle,
      icon: const Icon(Icons.language, color: AppColors.primary),
      label: Text(
        isArabic ? 'English' : 'العربية',
        style: const TextStyle(color: AppColors.primary),
      ),
    );
  }
}
