import 'package:flutter/material.dart';
import 'package:rihl/dev/components_preview_screen.dart';
import 'package:rihl/features/shipments/screens/shipment_details_screen.dart';

/// Route names. Add the new screens here as they are built.
///
/// Keep the names; each person registers their own screens in [routes].
class AppRoutes {
  AppRoutes._();

  static const String home = '/';

  // Shipment flow (Elaf, Mayar)
  static const String shipmentDetails = '/shipment/details';
  static const String shipmentReview = '/shipment/review';
  static const String shipmentSuccess = '/shipment/success';

  // Trip flow (Layan, Tala)
  static const String tripDetails = '/trip/details';
  static const String cargoDetails = '/trip/cargo';
  static const String tripReview = '/trip/review';
  static const String tripSuccess = '/trip/success';

  /// Until the real screens exist, the home route shows the components preview.
  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const ComponentsPreviewScreen(),
    shipmentDetails: (context) => const ShipmentDetailsScreen(),
    // shipmentReview: (context) => const ShipmentReviewScreen(),
  };
}
