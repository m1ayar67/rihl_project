import 'package:flutter/material.dart';
import 'package:rihl/dev/components_preview_screen.dart';
import 'package:rihl/features/shipments/screens/shipment_cargo_screen.dart';
import 'package:rihl/features/shipments/screens/shipment_details_screen.dart';
import 'package:rihl/features/shipments/screens/shipment_review_screen.dart';
import 'package:rihl/features/shipments/screens/shipment_success_screen.dart';
import 'package:rihl/features/trips/screens/trip_details_screen.dart';
import 'package:rihl/features/trips/screens/cargo_details_screen.dart';
import 'package:rihl/features/trips/screens/trip_review_screen.dart';
import 'package:rihl/features/trips/screens/trip_success_screen.dart';
import 'package:rihl/dev/role_selection_screen.dart';

/// Route names. Add the new screens here as they are built.
///
/// Keep the names; each person registers their own screens in [routes].
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String roleSelection = '/select-role';

  // Shipment flow (Elaf: UI. Mayar/Tala: saving it)
  static const String shipmentDetails = '/shipment/details';
  static const String shipmentCargo = '/shipment/cargo';
  static const String shipmentReview = '/shipment/review';
  static const String shipmentSuccess = '/shipment/success';

  // Trip flow (Layan: UI. Yara/Tala: saving it)
  static const String tripDetails = '/trip/details';
  static const String cargoDetails = '/trip/cargo';
  static const String tripReview = '/trip/review';
  static const String tripSuccess = '/trip/success';

  /// Until the real screens exist, the home route shows the components preview.
  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const ComponentsPreviewScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
    shipmentDetails: (context) => const ShipmentDetailsScreen(),
    tripDetails: (context) => const TripDetailsScreen(),
    cargoDetails: (context) => const CargoDetailsScreen(),
    tripReview: (context) => const TripReviewScreen(),
    tripSuccess: (context) => const TripSuccessScreen(),
    shipmentCargo: (context) => const ShipmentCargoScreen(),
    shipmentReview: (context) => const ShipmentReviewScreen(),
    shipmentSuccess: (context) => const ShipmentSuccessScreen(),
  };
}
