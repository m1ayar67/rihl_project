import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/cargo_dropdown.dart';
import 'package:rihl/widgets/city_dropdown.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/custom_date_picker.dart';
import 'package:rihl/widgets/custom_text_field.dart';
import 'package:rihl/widgets/step_indicator.dart';
import 'package:rihl/widgets/temperature_dropdown.dart';

Widget host(Widget child, {String language = 'en'}) {
  AppTheme.useGoogleFonts = false;
  return MaterialApp(
    locale: Locale(language),
    supportedLocales: AppStrings.supportedLocales,
    localizationsDelegates: const [
      AppStrings.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: AppTheme.light(Locale(language)),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );
}

void main() {
  group('CustomButton', () {
    testWidgets('calls onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(CustomButton(label: 'Go', onPressed: () => taps++)),
      );
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });

    testWidgets('loading shows spinner and ignores taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          CustomButton(label: 'Go', isLoading: true, onPressed: () => taps++),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(taps, 0);
    });
  });

  group('Dropdowns', () {
    testWidgets('city dropdown reports the code', (tester) async {
      String? picked;
      await tester.pumpWidget(
        host(CityDropdown(label: 'City', onChanged: (v) => picked = v)),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Riyadh').last);
      await tester.pumpAndSettle();
      expect(picked, 'riyadh');
    });

    testWidgets('city labels are Arabic in Arabic', (tester) async {
      await tester.pumpWidget(
        host(
          CityDropdown(label: 'المدينة', value: 'jeddah', onChanged: (_) {}),
          language: 'ar',
        ),
      );
      expect(find.text('جدة'), findsOneWidget);
    });

    testWidgets('temperature dropdown reports the code', (tester) async {
      String? picked;
      await tester.pumpWidget(
        host(TemperatureDropdown(label: 'Temp', onChanged: (v) => picked = v)),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No cooling').last);
      await tester.pumpAndSettle();
      expect(picked, 'ambient');
    });

    testWidgets('cargo dropdown shows its options', (tester) async {
      await tester.pumpWidget(
        host(CargoDropdown(label: 'Cargo', onChanged: (_) {})),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('Pharmaceuticals'), findsOneWidget);
    });

    testWidgets('validator error is displayed', (tester) async {
      final key = GlobalKey<FormState>();
      await tester.pumpWidget(
        host(
          Form(
            key: key,
            child: CityDropdown(
              label: 'City',
              onChanged: (_) {},
              validator: (v) => v == null ? 'required!' : null,
            ),
          ),
        ),
      );
      key.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('required!'), findsOneWidget);
    });
  });

  group('CustomTextField', () {
    testWidgets('password toggle reveals the text', (tester) async {
      await tester.pumpWidget(
        host(const CustomTextField(label: 'Password', isPassword: true)),
      );
      EditableText field() =>
          tester.widget<EditableText>(find.byType(EditableText));
      expect(field().obscureText, isTrue);
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(field().obscureText, isFalse);
    });
  });

  group('StepIndicator', () {
    testWidgets('shows the step text and filled segments', (tester) async {
      await tester.pumpWidget(
        host(
          const StepIndicator(currentStep: 2, totalSteps: 3, label: 'Review'),
        ),
      );
      expect(find.text('Step 2 of 3 · Review'), findsOneWidget);
      expect(find.byKey(const ValueKey('step-3')), findsOneWidget);
    });
  });

  group('CustomDatePicker', () {
    testWidgets('shows YYYY-MM-DD after choosing today', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        host(CustomDatePicker(label: 'Date', onChanged: (d) => picked = d)),
      );
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(picked, isNotNull);
      final now = DateTime.now();
      final expected =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      expect(find.text(expected), findsOneWidget);
    });
  });
}
