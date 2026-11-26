import 'package:flutter/widgets.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/l10n/app_strings.dart';

/// Form validators shared by all screens. Messages follow the current language.
///
/// Usage inside a widget:
/// ```dart
/// final validators = Validators.of(context);
/// CustomTextField(label: strings.email, validator: validators.email);
/// ```
/// Every validator returns an error message, or null when the value is valid.
class Validators {
  const Validators(this.strings);

  factory Validators.of(BuildContext context) {
    return Validators(AppStrings.of(context));
  }

  final AppStrings strings;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Any text field that must not be empty.
  String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) return strings.requiredField;
    return null;
  }

  /// A dropdown that must have a selection.
  String? requiredSelection(String? value) {
    if (value == null || value.isEmpty) return strings.selectOption;
    return null;
  }

  /// Destination city: required, and different from the origin city.
  String? destination(String? value, String? originCode) {
    final missing = requiredSelection(value);
    if (missing != null) return missing;
    if (value == originCode) return strings.sameCity;
    return null;
  }

  String? fullName(String? value) {
    final missing = requiredText(value);
    if (missing != null) return missing;
    if (value!.trim().length < 2) return strings.nameTooShort;
    return null;
  }

  String? email(String? value) {
    final missing = requiredText(value);
    if (missing != null) return missing;
    if (!_emailPattern.hasMatch(value!.trim())) return strings.invalidEmail;
    return null;
  }

  String? password(String? value) {
    if (value == null || value.isEmpty) return strings.requiredField;
    if (value.length < AppConstants.minPasswordLength) {
      return strings.passwordTooShort(AppConstants.minPasswordLength);
    }
    return null;
  }

  /// Shipment weight or trip capacity, in kilograms.
  /// Accepts Western and Arabic digits.
  String? weightKg(String? value) {
    final missing = requiredText(value);
    if (missing != null) return missing;
    final number = AppFormatters.parseNumber(value);
    if (number == null || !number.isFinite) return strings.invalidNumber;
    if (number <= 0) return strings.mustBePositive;
    if (number > AppConstants.maxWeightKg) {
      return strings.exceedsMax(AppConstants.maxWeightKg);
    }
    return null;
  }

  /// A date that is required and not in the past.
  /// [today] is only for tests.
  String? date(DateTime? value, {DateTime? today}) {
    if (value == null) return strings.chooseDate;
    final now = today ?? DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final chosen = DateTime(value.year, value.month, value.day);
    if (chosen.isBefore(startOfToday)) return strings.datePast;
    return null;
  }
}
