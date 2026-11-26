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

  testWidgets('app starts on the components preview', (tester) async {
    await tester.pumpWidget(const RihlApp());
    await tester.pumpAndSettle();
    expect(find.text('RIHL'), findsWidgets);
    expect(find.text('Origin city'), findsOneWidget);
  });

  testWidgets('language toggle switches to Arabic and RTL', (tester) async {
    await tester.pumpWidget(const RihlApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('مدينة الانطلاق'), findsOneWidget);
    final direction = Directionality.of(tester.element(find.byType(Scaffold)));
    expect(direction, TextDirection.rtl);
  });

  testWidgets('submitting an empty form shows errors', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const RihlApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Please select an option'), findsWidgets);
    expect(find.text('This field is required'), findsOneWidget);
  });
}
