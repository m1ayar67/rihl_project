import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/core/app_locale.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/features/shipments/screens/shipment_details_screen.dart';
import 'package:rihl/main.dart';

/// Opens the app and navigates to the shipment details screen.
Future<void> openScreen(WidgetTester tester) async {
  AppTheme.useGoogleFonts = false;
  AppLocale.change(const Locale('en'));
  tester.view.physicalSize = const Size(800, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const RihlApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Shipment details'));
  await tester.pumpAndSettle();
  expect(find.byType(ShipmentDetailsScreen), findsOneWidget);
}

Future<void> pick(WidgetTester tester, int dropdownIndex, String label) async {
  await tester.tap(find.byType(DropdownButton<String>).at(dropdownIndex));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> fillValid(WidgetTester tester) async {
  await pick(tester, 0, 'Jeddah');
  await pick(tester, 1, 'Riyadh');
  await pick(tester, 2, 'Food & groceries');
  await pick(tester, 3, 'Chilled (2–8 °C)');
  await tester.enterText(find.byType(TextFormField), '250');
  await tester.tap(find.text('Expected delivery date'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('no errors are shown before pressing Next', (tester) async {
    await openScreen(tester);
    expect(find.text('Please select an option'), findsNothing);
    expect(find.text('This field is required'), findsNothing);
  });

  testWidgets('empty form shows errors and stays on the screen', (
    tester,
  ) async {
    await openScreen(tester);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Please select an option'), findsNWidgets(4));
    expect(find.text('This field is required'), findsOneWidget);
    expect(find.text('Please choose a date'), findsOneWidget);
    expect(find.byType(ShipmentDetailsScreen), findsOneWidget);
  });

  testWidgets('same origin and destination is rejected', (tester) async {
    await openScreen(tester);
    await fillValid(tester);
    await pick(tester, 1, 'Jeddah');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(
      find.text('Destination must be different from the origin'),
      findsOneWidget,
    );
    expect(find.byType(ShipmentDetailsScreen), findsOneWidget);
  });

  testWidgets('too heavy weight is rejected', (tester) async {
    await openScreen(tester);
    await fillValid(tester);
    await tester.enterText(find.byType(TextFormField), '30001');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Cannot exceed 30000 kg'), findsOneWidget);
  });

  testWidgets('valid form shows the confirmation message', (tester) async {
    await openScreen(tester);
    await fillValid(tester);
    await tester.tap(find.text('Next'));
    await tester.pump();

    expect(find.text('The form is valid'), findsOneWidget);
    expect(find.text('Please select an option'), findsNothing);
    expect(find.text('This field is required'), findsNothing);
  });

  testWidgets('Arabic digits are accepted for the weight', (tester) async {
    await openScreen(tester);
    await fillValid(tester);
    await tester.enterText(find.byType(TextFormField), '٢٥٠٫٥');
    await tester.tap(find.text('Next'));
    await tester.pump();

    expect(find.text('Enter a valid number'), findsNothing);
    expect(find.text('The form is valid'), findsOneWidget);
  });
}
