"""SQLAlchemy models for the RIHL tables. They match schema.sql exactly.
Column names match the keys the Flutter app sends (ShipmentDetails / TripDetails .toJson()).
"""
from datetime import date, datetime, time
from decimal import Decimal
from typing import Optional

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, Numeric, String, Time, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base

# Same codes as lib/core/constants.dart in the Flutter app
CARGO_TYPES = ("general", "food", "pharma", "electronics",
               "fragile", "furniture", "auto_parts", "clothing")
TEMPERATURES = ("ambient", "chilled", "frozen")
MAX_WEIGHT_KG = 30000


class City(Base):
    __tablename__ = "cities"

    code: Mapped[str] = mapped_column(String(30), primary_key=True)
    name_en: Mapped[str] = mapped_column(String(60))
    name_ar: Mapped[str] = mapped_column(String(60))
    # cities.location (PostGIS) is not mapped yet; it is added when the engines need it.


class User(Base):
    __tablename__ = "users"

    user_id: Mapped[int] = mapped_column(primary_key=True)
    firebase_uid: Mapped[str] = mapped_column(String(128), unique=True)
    name: Mapped[str] = mapped_column(String(100))
    email: Mapped[str] = mapped_column(String(255), unique=True)
    phone: Mapped[Optional[str]] = mapped_column(String(20))
    role: Mapped[str] = mapped_column(String(20))  # shipper | shipping_company | driver
    company_name: Mapped[Optional[str]] = mapped_column(String(150))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class Vehicle(Base):
    __tablename__ = "vehicles"

    vehicle_id: Mapped[int] = mapped_column(primary_key=True)
    owner_id: Mapped[int] = mapped_column(ForeignKey("users.user_id"))
    vehicle_type: Mapped[str] = mapped_column(String(50))
    total_capacity_kg: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    is_refrigerated: Mapped[bool] = mapped_column(Boolean, default=False)
    status: Mapped[str] = mapped_column(String(20), default="available")


class Shipment(Base):
    __tablename__ = "shipments"

    shipment_id: Mapped[int] = mapped_column(primary_key=True)
    shipper_id: Mapped[Optional[int]] = mapped_column(ForeignKey("users.user_id"))
    origin: Mapped[str] = mapped_column(ForeignKey("cities.code"))
    destination: Mapped[str] = mapped_column(ForeignKey("cities.code"))
    cargo_type: Mapped[str] = mapped_column(String(20))
    weight_kg: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    temperature: Mapped[str] = mapped_column(String(10))
    delivery_date: Mapped[date] = mapped_column(Date)
    status: Mapped[str] = mapped_column(String(30), default="pending_assignment")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class Trip(Base):
    __tablename__ = "trips"

    trip_id: Mapped[int] = mapped_column(primary_key=True)
    publisher_id: Mapped[Optional[int]] = mapped_column(ForeignKey("users.user_id"))
    vehicle_id: Mapped[Optional[int]] = mapped_column(ForeignKey("vehicles.vehicle_id"))
    origin: Mapped[str] = mapped_column(ForeignKey("cities.code"))
    destination: Mapped[str] = mapped_column(ForeignKey("cities.code"))
    departure_date: Mapped[date] = mapped_column(Date)
    departure_time: Mapped[time] = mapped_column(Time)
    capacity_kg: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    cargo_type: Mapped[str] = mapped_column(String(20))
    temperature: Mapped[str] = mapped_column(String(10))
    status: Mapped[str] = mapped_column(String(20), default="published")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
