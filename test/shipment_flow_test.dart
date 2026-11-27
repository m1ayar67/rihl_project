import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/core/app_locale.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/main.dart';

/// Opens the app and enters the shipment flow as a shipper.
Future<void> openShipmentFlow(WidgetTester tester) async {
  AppTheme.useGoogleFonts = false;
  AppLocale.change(const Locale('en'));
  tester.view.physicalSize = const Size(800, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const RihlApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Shipper'));
  await tester.pumpAndSettle();
}

Future<void> pick(WidgetTester tester, int dropdownIndex, String label) async {
  await tester.tap(find.byType(DropdownButton<String>).at(dropdownIndex));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> next(WidgetTester tester) async {
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
}

/// Fills step 1 (Jeddah -> Riyadh, today) and goes to step 2.
Future<void> completeStepOne(WidgetTester tester) async {
  await pick(tester, 0, 'Jeddah');
  await pick(tester, 1, 'Riyadh');
  await tester.tap(find.text('Expected delivery date'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  await next(tester);
}

/// Fills step 2 and goes to the review screen.
Future<void> completeStepTwo(
  WidgetTester tester, {
  String weight = '250',
}) async {
  await pick(tester, 0, 'Food & groceries');
  await pick(tester, 1, 'Chilled (2–8 °C)');
  await tester.enterText(find.byType(TextFormField), weight);
  await next(tester);
}

void main() {
  group('Step 1: shipment details', () {
    testWidgets('no errors are shown before pressing Next', (tester) async {
      await openShipmentFlow(tester);
      expect(find.text('Please select an option'), findsNothing);
      expect(find.text('Please choose a date'), findsNothing);
    });

    testWidgets('empty form shows errors and stays on the screen', (
      tester,
    ) async {
      await openShipmentFlow(tester);
      await next(tester);

      expect(find.text('Please select an option'), findsNWidgets(2));
      expect(find.text('Please choose a date'), findsOneWidget);
      expect(find.text('Cargo details'), findsNothing);
    });

    testWidgets('same origin and destination is rejected', (tester) async {
      await openShipmentFlow(tester);
      await pick(tester, 0, 'Jeddah');
      await pick(tester, 1, 'Jeddah');
      await next(tester);

      expect(
        find.text('Destination must be different from the origin'),
        findsOneWidget,
      );
    });

    testWidgets('valid step 1 goes to step 2', (tester) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);

      expect(find.text('Cargo details'), findsOneWidget);
      expect(find.text('Step 2 of 3 · Cargo details'), findsOneWidget);
    });
  });

  group('Step 2: cargo details', () {
    testWidgets('empty form shows errors and stays on the screen', (
      tester,
    ) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);
      await next(tester);

      expect(find.text('Please select an option'), findsNWidgets(2));
      expect(find.text('This field is required'), findsOneWidget);
      expect(find.text('Review shipment'), findsNothing);
    });

    testWidgets('too heavy weight is rejected', (tester) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);
      await completeStepTwo(tester, weight: '30001');

      expect(find.text('Cannot exceed 30000 kg'), findsOneWidget);
      expect(find.text('Review shipment'), findsNothing);
    });

    testWidgets('zero weight is rejected', (tester) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);
      await completeStepTwo(tester, weight: '0');

      expect(find.text('Must be greater than 0'), findsOneWidget);
    });
  });

  group('Review and success', () {
    testWidgets('review shows everything that was entered', (tester) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);
      await completeStepTwo(tester);

      expect(find.text('Review shipment'), findsWidgets);
      expect(find.text('Jeddah'), findsOneWidget);
      expect(find.text('Riyadh'), findsOneWidget);
      expect(find.text('Food & groceries'), findsOneWidget);
      expect(find.text('Chilled (2–8 °C)'), findsOneWidget);
      expect(find.text('250'), findsOneWidget);
    });

    testWidgets('Arabic digits are read as a number', (tester) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);
      await completeStepTwo(tester, weight: '٢٥٠٫٥');

      expect(find.text('250.5'), findsOneWidget);
    });

    testWidgets('submitting shows the success screen, then back to home', (
      tester,
    ) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);
      await completeStepTwo(tester);

      await tester.tap(find.text('Submit shipment'));
      await tester.pumpAndSettle();
      expect(find.text('Shipment submitted successfully'), findsOneWidget);

      await tester.tap(find.text('Back to home'));
      await tester.pumpAndSettle();
      expect(find.text('Select your role'), findsWidgets);
    });

    testWidgets('Back on the review screen returns to step 2', (tester) async {
      await openShipmentFlow(tester);
      await completeStepOne(tester);
      await completeStepTwo(tester);

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Step 2 of 3 · Cargo details'), findsOneWidget);
    });
  });
}
