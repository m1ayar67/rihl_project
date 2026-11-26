import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/core/validators.dart';
import 'package:rihl/l10n/app_strings.dart';

void main() {
  final en = Validators(const AppStrings(Locale('en')));
  final ar = Validators(const AppStrings(Locale('ar')));

  group('requiredText / requiredSelection', () {
    test('rejects null, empty and spaces', () {
      expect(en.requiredText(null), isNotNull);
      expect(en.requiredText(''), isNotNull);
      expect(en.requiredText('   '), isNotNull);
      expect(en.requiredText('abc'), isNull);
    });

    test('selection must not be empty', () {
      expect(en.requiredSelection(null), isNotNull);
      expect(en.requiredSelection(''), isNotNull);
      expect(en.requiredSelection('jeddah'), isNull);
    });
  });

  group('destination', () {
    test('required', () {
      expect(en.destination(null, 'jeddah'), isNotNull);
    });
    test('must differ from origin', () {
      expect(en.destination('jeddah', 'jeddah'), en.strings.sameCity);
    });
    test('valid when different', () {
      expect(en.destination('riyadh', 'jeddah'), isNull);
      expect(en.destination('riyadh', null), isNull);
    });
  });

  group('weightKg', () {
    test('rejects empty, text, zero, negative and too heavy', () {
      expect(en.weightKg(''), isNotNull);
      expect(en.weightKg('abc'), isNotNull);
      expect(en.weightKg('0'), isNotNull);
      expect(en.weightKg('-5'), isNotNull);
      expect(en.weightKg('30001'), isNotNull);
    });
    test('accepts valid numbers, including Arabic digits', () {
      expect(en.weightKg('1'), isNull);
      expect(en.weightKg('250.5'), isNull);
      expect(en.weightKg('30000'), isNull);
      expect(en.weightKg('٢٥٠٫٥'), isNull);
    });
    test('message follows the language', () {
      expect(en.weightKg(''), isNot(equals(ar.weightKg(''))));
    });
  });

  group('email / password / name', () {
    test('email', () {
      expect(en.email('a@b.co'), isNull);
      expect(en.email('a@b'), isNotNull);
      expect(en.email('plain'), isNotNull);
      expect(en.email(''), isNotNull);
    });
    test('password needs 6 characters', () {
      expect(en.password('12345'), isNotNull);
      expect(en.password('123456'), isNull);
    });
    test('full name', () {
      expect(en.fullName('A'), isNotNull);
      expect(en.fullName('Elaf'), isNull);
    });
  });

  group('date', () {
    final today = DateTime(2026, 11, 26, 15, 30);
    test('required', () {
      expect(en.date(null, today: today), isNotNull);
    });
    test('past is rejected, today and future accepted', () {
      expect(en.date(DateTime(2026, 11, 25), today: today), isNotNull);
      expect(en.date(DateTime(2026, 11, 26), today: today), isNull);
      expect(en.date(DateTime(2027, 1, 1), today: today), isNull);
    });
  });
}
