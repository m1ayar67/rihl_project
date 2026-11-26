import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rihl/core/app_locale.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/l10n/app_strings.dart';

void main() {
  runApp(const RihlApp());
}

class RihlApp extends StatelessWidget {
  const RihlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocale.notifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'RIHL',
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: AppStrings.supportedLocales,
          localizationsDelegates: const [
            AppStrings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light(locale),
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
