import 'package:flutter_test/flutter_test.dart';
import 'package:rihl/features/shipments/models/shipment_details.dart';

void main() {
  final details = ShipmentDetails(
    origin: 'jeddah',
    destination: 'riyadh',
    cargoType: 'food',
    weightKg: 250.5,
    temperature: 'chilled',
    deliveryDate: DateTime(2026, 12, 3),
  );

  test('toJson uses backend keys, codes and YYYY-MM-DD', () {
    expect(details.toJson(), {
      'origin': 'jeddah',
      'destination': 'riyadh',
      'cargo_type': 'food',
      'weight_kg': 250.5,
      'temperature': 'chilled',
      'delivery_date': '2026-12-03',
    });
  });

  test('equal values are equal', () {
    final same = ShipmentDetails(
      origin: 'jeddah',
      destination: 'riyadh',
      cargoType: 'food',
      weightKg: 250.5,
      temperature: 'chilled',
      deliveryDate: DateTime(2026, 12, 3),
    );
    expect(same, details);
    expect(same.hashCode, details.hashCode);
  });
}
