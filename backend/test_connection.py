"""Quick check that the backend can reach the database through the repositories.
Run from the backend folder:  python test_connection.py
"""
from datetime import date, time

from database import SessionLocal
from repositories import ShipmentRepository, TripRepository

db = SessionLocal()
try:
    shipments = ShipmentRepository(db)
    trips = TripRepository(db)

    print("Shipments in the database:", len(shipments.list_all()))
    print("Published trips Jeddah -> Riyadh:", len(trips.list_published("jeddah", "riyadh")))

    # Save a shipment and a trip exactly like the app sends them, then read them back
    s = shipments.add({"origin": "jeddah", "destination": "riyadh", "cargo_type": "general",
                       "weight_kg": 250, "temperature": "ambient",
                       "delivery_date": date(2026, 12, 10)})
    t = trips.add({"origin": "jeddah", "destination": "riyadh",
                   "departure_date": date(2026, 12, 9), "departure_time": time(14, 30),
                   "capacity_kg": 1500, "cargo_type": "general", "temperature": "ambient"})
    print("Saved shipment", s.shipment_id, "status:", shipments.get(s.shipment_id).status)
    print("Saved trip", t.trip_id, "status:", trips.get(t.trip_id).status)

    # Remove the test rows again
    db.delete(s)
    db.delete(t)
    db.commit()
    print("Connection works.")
finally:
    db.close()
