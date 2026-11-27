import 'package:flutter/foundation.dart';
import 'package:rihl/core/app_formatters.dart';

@immutable
class TripDetails {
  const TripDetails({
    required this.origin,
    required this.destination,
    required this.departureDate,
    required this.departureTime,
    required this.capacityKg,
    required this.cargoType,
    required this.temperature,
  });

  final String origin;
  final String destination;
  final DateTime departureDate;
  final String departureTime;
  final double capacityKg;
  final String cargoType;
  final String temperature;

  Map<String, dynamic> toJson() => {
    'origin': origin,
    'destination': destination,
    'departure_date': AppFormatters.date(departureDate),
    'departure_time': departureTime,
    'capacity_kg': capacityKg,
    'cargo_type': cargoType,
    'temperature': temperature,
  };

  @override
  bool operator ==(Object other) {
    return other is TripDetails &&
        other.origin == origin &&
        other.destination == destination &&
        other.departureDate == departureDate &&
        other.departureTime == departureTime &&
        other.capacityKg == capacityKg &&
        other.cargoType == cargoType &&
        other.temperature == temperature;
  }

  @override
  int get hashCode => Object.hash(
    origin,
    destination,
    departureDate,
    departureTime,
    capacityKg,
    cargoType,
    temperature,
  );

  @override
  String toString() => 'TripDetails(${toJson()})';
}