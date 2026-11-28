"""Repository Pattern: the only place that reads and writes shipments and trips.

Backend code (Mayar's and Yara's) calls these methods instead of using the
database directly, so all database access stays in one place.

Usage inside a FastAPI endpoint:
    repo = ShipmentRepository(db)
    shipment = repo.add(data.model_dump())
"""
from typing import Optional

from sqlalchemy import select
from sqlalchemy.orm import Session

from models import Shipment, Trip


class ShipmentRepository:
    """Saves and reads shipments."""

    def __init__(self, db: Session):
        self.db = db

    def add(self, data: dict) -> Shipment:
        """Saves a new shipment. `data` uses the same keys as ShipmentDetails.toJson()."""
        shipment = Shipment(**data)
        self.db.add(shipment)
        self.db.commit()
        self.db.refresh(shipment)
        return shipment

    def get(self, shipment_id: int) -> Optional[Shipment]:
        """Returns one shipment, or None if it does not exist."""
        return self.db.get(Shipment, shipment_id)

    def list_all(self) -> list[Shipment]:
        """Returns all shipments, newest first."""
        query = select(Shipment).order_by(Shipment.created_at.desc())
        return list(self.db.scalars(query))

    def update_status(self, shipment_id: int, status: str) -> Optional[Shipment]:
        """Changes a shipment's status (for example to 'assigned')."""
        shipment = self.get(shipment_id)
        if shipment is None:
            return None
        shipment.status = status
        self.db.commit()
        self.db.refresh(shipment)
        return shipment


class TripRepository:
    """Saves and reads published trips."""

    def __init__(self, db: Session):
        self.db = db

    def add(self, data: dict) -> Trip:
        """Publishes a new trip. `data` uses the same keys as TripDetails.toJson()."""
        trip = Trip(**data)
        self.db.add(trip)
        self.db.commit()
        self.db.refresh(trip)
        return trip

    def get(self, trip_id: int) -> Optional[Trip]:
        """Returns one trip, or None if it does not exist."""
        return self.db.get(Trip, trip_id)

    def list_published(self, origin: Optional[str] = None,
                       destination: Optional[str] = None) -> list[Trip]:
        """Returns published trips, optionally between two cities, by departure date."""
        query = select(Trip).where(Trip.status == "published")
        if origin:
            query = query.where(Trip.origin == origin)
        if destination:
            query = query.where(Trip.destination == destination)
        query = query.order_by(Trip.departure_date, Trip.departure_time)
        return list(self.db.scalars(query))
