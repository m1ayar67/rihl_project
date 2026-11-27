import 'package:flutter/foundation.dart';
import 'package:rihl/core/app_formatters.dart';

/// What the sender entered in the Shipment Details screen (step 1 of 3).
///
/// Passed to the next screen with
/// `Navigator.pushNamed(context, AppRoutes.shipmentReview, arguments: details)`,
/// and sent to the backend with [toJson].
///
/// [origin], [destination], [cargoType] and [temperature] are option codes
/// (for example `jeddah`, `food`, `chilled`), never display labels.
@immutable
class ShipmentDetails {
  const ShipmentDetails({
    required this.origin,
    required this.destination,
    required this.cargoType,
    required this.weightKg,
    required this.temperature,
    required this.deliveryDate,
  });

  final String origin;
  final String destination;
  final String cargoType;
  final double weightKg;
  final String temperature;
  final DateTime deliveryDate;

  /// Weight for display: `250` instead of `250.0`.
  String get weightText => weightKg == weightKg.truncateToDouble()
      ? weightKg.toInt().toString()
      : weightKg.toString();

  /// Keys follow the backend naming (snake_case). Date is `YYYY-MM-DD`.
  Map<String, dynamic> toJson() => {
    'origin': origin,
    'destination': destination,
    'cargo_type': cargoType,
    'weight_kg': weightKg,
    'temperature': temperature,
    'delivery_date': AppFormatters.date(deliveryDate),
  };

  @override
  bool operator ==(Object other) {
    return other is ShipmentDetails &&
        other.origin == origin &&
        other.destination == destination &&
        other.cargoType == cargoType &&
        other.weightKg == weightKg &&
        other.temperature == temperature &&
        other.deliveryDate == deliveryDate;
  }

  @override
  int get hashCode => Object.hash(
    origin,
    destination,
    cargoType,
    weightKg,
    temperature,
    deliveryDate,
  );

  @override
  String toString() => 'ShipmentDetails(${toJson()})';
}
