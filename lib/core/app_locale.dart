import 'package:flutter/widgets.dart';

/// The language the app is currently showing (English or Arabic).
///
/// [RihlApp] listens to [notifier] and rebuilds when it changes.
class AppLocale {
  AppLocale._();

  static final ValueNotifier<Locale> notifier = ValueNotifier<Locale>(
    const Locale('en'),
  );

  static bool get isArabic => notifier.value.languageCode == 'ar';

  static void change(Locale locale) {
    notifier.value = locale;
  }

  static void toggle() {
    change(isArabic ? const Locale('en') : const Locale('ar'));
  }
}
