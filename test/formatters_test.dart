import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/core/app_formatters.dart';

void main() {
  test('date is YYYY-MM-DD', () {
    expect(AppFormatters.date(DateTime(2026, 3, 5)), '2026-03-05');
    expect(AppFormatters.date(DateTime(2026, 12, 31)), '2026-12-31');
  });

  test('normalizeDigits converts Arabic digits and decimal mark', () {
    expect(AppFormatters.normalizeDigits('٠١٢٣٤٥٦٧٨٩'), '0123456789');
    expect(AppFormatters.normalizeDigits('٢٥٠٫٥'), '250.5');
    expect(AppFormatters.normalizeDigits('۱۲۳'), '123');
    expect(AppFormatters.normalizeDigits('12.5'), '12.5');
  });

  test('parseNumber', () {
    expect(AppFormatters.parseNumber('٢٥٠٫٥'), 250.5);
    expect(AppFormatters.parseNumber(' 42 '), 42);
    expect(AppFormatters.parseNumber(''), isNull);
    expect(AppFormatters.parseNumber(null), isNull);
    expect(AppFormatters.parseNumber('abc'), isNull);
  });
}
