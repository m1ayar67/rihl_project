import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/core/app_locale.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/main.dart';

void main() {
  setUp(() {
    AppTheme.useGoogleFonts = false;
    AppLocale.change(const Locale('en'));
  });

  testWidgets('app starts on the role selection screen', (tester) async {
    await tester.pumpWidget(const RihlApp());
    await tester.pumpAndSettle();

    expect(find.text('Select your role'), findsWidgets);
    expect(find.text('Shipper'), findsOneWidget);
    expect(find.text('Carrier'), findsOneWidget);
  });

  testWidgets('language toggle switches to Arabic and RTL', (tester) async {
    await tester.pumpWidget(const RihlApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('اختر نوع المستخدم'), findsWidgets);
    final direction = Directionality.of(tester.element(find.byType(Scaffold)));
    expect(direction, TextDirection.rtl);
  });
}
