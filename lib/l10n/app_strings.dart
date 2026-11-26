import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'strings_ar.dart';
import 'strings_en.dart';

/// All the texts of the app, in English and Arabic.
///
/// Use it in a widget with `AppStrings.of(context).next`.
///
/// To add a text:
/// 1. add the key to `strings_en.dart` and `strings_ar.dart`,
/// 2. add a getter below.
/// (A unit test fails if a key exists in only one language.)
class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        AppStrings(Localizations.maybeLocaleOf(context) ?? const Locale('en'));
  }

  bool get isArabic => locale.languageCode == 'ar';

  String _t(String key, [Map<String, Object> args = const {}]) {
    final table = isArabic ? stringsAr : stringsEn;
    var value = table[key] ?? stringsEn[key] ?? key;
    args.forEach((name, replacement) {
      value = value.replaceAll('{$name}', '$replacement');
    });
    return value;
  }

  // General
  String get appName => _t('appName');
  String get next => _t('next');
  String get back => _t('back');
  String get submit => _t('submit');
  String get continueLabel => _t('continueLabel');
  String get cancel => _t('cancel');
  String get reset => _t('reset');

  // Field labels
  String get originCity => _t('originCity');
  String get destinationCity => _t('destinationCity');
  String get city => _t('city');
  String get cargoType => _t('cargoType');
  String get temperature => _t('temperature');
  String get weightKg => _t('weightKg');
  String get capacityKg => _t('capacityKg');
  String get deliveryDate => _t('deliveryDate');
  String get departureDate => _t('departureDate');
  String get fullName => _t('fullName');
  String get email => _t('email');
  String get password => _t('password');

  // Validation messages
  String get requiredField => _t('requiredField');
  String get selectOption => _t('selectOption');
  String get sameCity => _t('sameCity');
  String get invalidNumber => _t('invalidNumber');
  String get mustBePositive => _t('mustBePositive');
  String exceedsMax(double max) =>
      _t('exceedsMax', {'max': max.toStringAsFixed(0)});
  String get invalidEmail => _t('invalidEmail');
  String passwordTooShort(int min) => _t('passwordTooShort', {'min': min});
  String get nameTooShort => _t('nameTooShort');
  String get chooseDate => _t('chooseDate');
  String get datePast => _t('datePast');

  // Steps and misc
  String stepOf(int current, int total) =>
      _t('stepOf', {'current': current, 'total': total});
  String get formValid => _t('formValid');
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppStrings> load(Locale locale) {
    return SynchronousFuture<AppStrings>(AppStrings(locale));
  }

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
