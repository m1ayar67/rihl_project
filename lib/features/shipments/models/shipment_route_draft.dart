import 'package:flutter/foundation.dart';

/// The first half of a shipment: what step 1 (route and date) collects.
///
/// Passed from the Shipment Details screen to the Cargo Details screen,
/// which adds the cargo information and builds the final `ShipmentDetails`.
@immutable
class ShipmentRouteDraft {
  const ShipmentRouteDraft({
    required this.origin,
    required this.destination,
    required this.deliveryDate,
  });

  /// City codes, for example `jeddah`.
  final String origin;
  final String destination;
  final DateTime deliveryDate;

  @override
  bool operator ==(Object other) {
    return other is ShipmentRouteDraft &&
        other.origin == origin &&
        other.destination == destination &&
        other.deliveryDate == deliveryDate;
  }

  @override
  int get hashCode => Object.hash(origin, destination, deliveryDate);
}
