import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/l10n/strings_ar.dart';
import 'package:rihl/l10n/strings_en.dart';

void main() {
  test('English and Arabic have exactly the same keys', () {
    expect(stringsAr.keys.toSet(), equals(stringsEn.keys.toSet()));
  });

  test('no empty texts', () {
    for (final entry in [...stringsEn.entries, ...stringsAr.entries]) {
      expect(entry.value.trim(), isNotEmpty, reason: entry.key);
    }
  });

  test('placeholders match between languages', () {
    final placeholder = RegExp(r'\{(\w+)\}');
    for (final key in stringsEn.keys) {
      final en = placeholder
          .allMatches(stringsEn[key]!)
          .map((m) => m[1])
          .toSet();
      final ar = placeholder
          .allMatches(stringsAr[key]!)
          .map((m) => m[1])
          .toSet();
      expect(ar, equals(en), reason: key);
    }
  });

  test('placeholders are filled', () {
    const en = AppStrings(Locale('en'));
    const ar = AppStrings(Locale('ar'));
    expect(en.stepOf(2, 3), 'Step 2 of 3');
    expect(ar.stepOf(2, 3), contains('2'));
    expect(en.exceedsMax(30000), contains('30000'));
    expect(en.passwordTooShort(6), contains('6'));
    expect(en.exceedsMax(30000), isNot(contains('{')));
  });

  test('option codes are unique in every list', () {
    for (final list in [
      AppConstants.cities,
      AppConstants.cargoTypes,
      AppConstants.temperatureOptions,
    ]) {
      final codes = list.map((o) => o.code).toList();
      expect(codes.toSet().length, codes.length);
      for (final option in list) {
        expect(option.en, isNotEmpty);
        expect(option.ar, isNotEmpty);
      }
    }
  });
}
