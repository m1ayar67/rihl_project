# RIHL Database (Sprint 1)

Put these files in a new folder called `backend/` inside the rihl_project repo.

## Files
- schema.sql          creates the tables and adds the 14 cities
- sample_data.sql     3 test shipments and 3 test trips
- database.py         FastAPI connection (engine, session, get_db)
- models.py           SQLAlchemy models that match schema.sql
- repositories.py     Repository Pattern: ShipmentRepository and TripRepository (all saving/reading goes here)
- test_connection.py  checks the backend can save and read data
- requirements.txt    Python packages
- .env.example        where the database link goes

## The tables match what the app sends
| App (toJson)                 | Table column              |
|------------------------------|---------------------------|
| ShipmentDetails.origin       | shipments.origin          |
| ShipmentDetails.destination  | shipments.destination     |
| cargo_type                   | shipments.cargo_type      |
| weight_kg                    | shipments.weight_kg       |
| temperature                  | shipments.temperature     |
| delivery_date (YYYY-MM-DD)   | shipments.delivery_date   |
| TripDetails.origin           | trips.origin              |
| TripDetails.destination      | trips.destination         |
| departure_date (YYYY-MM-DD)  | trips.departure_date      |
| departure_time (HH:mm)       | trips.departure_time      |
| capacity_kg                  | trips.capacity_kg         |
| cargo_type                   | trips.cargo_type          |
| temperature                  | trips.temperature         |

## Allowed values (same as lib/core/constants.dart)
- cities: jeddah, riyadh, dammam, makkah, madinah, taif, abha, tabuk, khobar, jubail, buraidah, hail, jazan, najran
- cargo_type: general, food, pharma, electronics, fragile, furniture, auto_parts, clothing
- temperature: ambient, chilled, frozen
- weight_kg / capacity_kg: more than 0, up to 30000
If the app adds a new city or cargo type, the database must be updated too.

## Setup (one shared database for the whole team)
1. Create a free account at neon.tech and make a project called "rihl".
2. In Neon, open the SQL Editor, paste schema.sql and run it. Then run sample_data.sql.
3. Copy the connection string (Dashboard > Connect). It starts with postgresql://
4. In backend/, copy .env.example to .env and paste it as DATABASE_URL.
   Share it with the team privately. Make sure .env is in .gitignore.
5. pip install -r requirements.txt
6. python test_connection.py   ->  should end with "Connection works."

## Using it in FastAPI (for Mayar and Yara)
Use the repositories instead of touching the database directly (Repository Pattern):

    from fastapi import Depends
    from sqlalchemy.orm import Session
    from database import get_db
    from repositories import ShipmentRepository

    @app.post("/shipments")
    def create_shipment(data: ShipmentIn, db: Session = Depends(get_db)):
        return ShipmentRepository(db).add(data.model_dump())

Tip: declare delivery_date as `date` and departure_time as `time` in the Pydantic
models (ShipmentIn / TripIn). Pydantic then turns '2026-12-10' and '14:30' from
the app into real dates and times automatically.
