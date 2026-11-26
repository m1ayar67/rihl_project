import 'package:rihl/models/localized_option.dart';

/// Sizes agreed in the design system.
class AppSizes {
  AppSizes._();

  static const double buttonHeight = 52;
  static const double inputHeight = 52;
  static const double borderRadius = 12;
  static const double screenPadding = 20;
  static const double headingSize = 24;
  static const double bodyLarge = 16;
  static const double bodySmall = 14;

  /// Space between two fields in a form.
  static const double fieldSpacing = 16;

  /// Space between two sections of a screen.
  static const double sectionSpacing = 24;
}

/// Shared business constants and the lists used by the dropdowns.
///
/// Shipments (shipment screens) and trips (trip screens) both read these lists,
/// so a shipment's cargo type always matches a trip's allowed cargo type.
class AppConstants {
  AppConstants._();

  /// Heaviest shipment (or trip capacity) accepted, in kilograms.
  static const double maxWeightKg = 30000;

  /// How far ahead a date can be chosen.
  static const int maxBookingDaysAhead = 365;

  /// Firebase Authentication requires at least 6 characters.
  static const int minPasswordLength = 6;

  static const String ambientTemperatureCode = 'ambient';
  static const String chilledTemperatureCode = 'chilled';
  static const String frozenTemperatureCode = 'frozen';

  static const List<LocalizedOption> cities = [
    LocalizedOption(code: 'jeddah', en: 'Jeddah', ar: 'جدة'),
    LocalizedOption(code: 'riyadh', en: 'Riyadh', ar: 'الرياض'),
    LocalizedOption(code: 'dammam', en: 'Dammam', ar: 'الدمام'),
    LocalizedOption(code: 'makkah', en: 'Makkah', ar: 'مكة المكرمة'),
    LocalizedOption(code: 'madinah', en: 'Madinah', ar: 'المدينة المنورة'),
    LocalizedOption(code: 'taif', en: 'Taif', ar: 'الطائف'),
    LocalizedOption(code: 'abha', en: 'Abha', ar: 'أبها'),
    LocalizedOption(code: 'tabuk', en: 'Tabuk', ar: 'تبوك'),
    LocalizedOption(code: 'khobar', en: 'Khobar', ar: 'الخبر'),
    LocalizedOption(code: 'jubail', en: 'Jubail', ar: 'الجبيل'),
    LocalizedOption(code: 'buraidah', en: 'Buraidah', ar: 'بريدة'),
    LocalizedOption(code: 'hail', en: 'Hail', ar: 'حائل'),
    LocalizedOption(code: 'jazan', en: 'Jazan', ar: 'جازان'),
    LocalizedOption(code: 'najran', en: 'Najran', ar: 'نجران'),
  ];

  static const List<LocalizedOption> cargoTypes = [
    LocalizedOption(code: 'general', en: 'General cargo', ar: 'بضائع عامة'),
    LocalizedOption(code: 'food', en: 'Food & groceries', ar: 'مواد غذائية'),
    LocalizedOption(code: 'pharma', en: 'Pharmaceuticals', ar: 'أدوية'),
    LocalizedOption(code: 'electronics', en: 'Electronics', ar: 'إلكترونيات'),
    LocalizedOption(
      code: 'fragile',
      en: 'Fragile items',
      ar: 'مواد قابلة للكسر',
    ),
    LocalizedOption(code: 'furniture', en: 'Furniture', ar: 'أثاث'),
    LocalizedOption(
      code: 'auto_parts',
      en: 'Auto parts',
      ar: 'قطع غيار السيارات',
    ),
    LocalizedOption(code: 'clothing', en: 'Clothing', ar: 'ملابس'),
  ];

  // The Arabic labels wrap the temperature in Unicode isolate marks (u2066 and
  // u2069) so "2–8 °C" and "-18 °C" stay readable in right-to-left text.
  static const List<LocalizedOption> temperatureOptions = [
    LocalizedOption(
      code: ambientTemperatureCode,
      en: 'No cooling',
      ar: 'بدون تبريد',
    ),
    LocalizedOption(
      code: chilledTemperatureCode,
      en: 'Chilled (2–8 °C)',
      ar: 'مبرّد (\u20662–8 °C\u2069)',
    ),
    LocalizedOption(
      code: frozenTemperatureCode,
      en: 'Frozen (-18 °C)',
      ar: 'مجمّد (\u2066-18 °C\u2069)',
    ),
  ];
}