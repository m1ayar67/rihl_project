-- RIHL database schema (Sprint 1)
-- Matches the data the Flutter app sends:
--   ShipmentDetails.toJson(): origin, destination, cargo_type, weight_kg, temperature, delivery_date
--   TripDetails.toJson():     origin, destination, departure_date, departure_time, capacity_kg, cargo_type, temperature
-- Allowed codes come from lib/core/constants.dart (AppConstants).

-- PostGIS adds location support (report: Table 1.1 and Section 1.6.4).
-- Neon supports it. Sprint 1 does not use locations yet; the Routing and
-- Recovery Engines will use them later.
CREATE EXTENSION IF NOT EXISTS postgis;

-- Cities: the same codes as AppConstants.cities
CREATE TABLE cities (
    code      VARCHAR(30)  PRIMARY KEY,         -- e.g. 'jeddah'
    name_en   VARCHAR(60)  NOT NULL,
    name_ar   VARCHAR(60)  NOT NULL,
    location  GEOGRAPHY(POINT, 4326)           -- city coordinates, added later
);

-- Users: shippers, shipping companies and drivers.
-- Login is handled by Firebase Authentication; this table keeps each user's
-- profile and role, linked by their Firebase UID. (Not used yet in Sprint 1.)
CREATE TABLE users (
    user_id        SERIAL PRIMARY KEY,
    firebase_uid   VARCHAR(128) NOT NULL UNIQUE,
    name           VARCHAR(100) NOT NULL,
    email          VARCHAR(255) NOT NULL UNIQUE,
    phone          VARCHAR(20),
    role           VARCHAR(20)  NOT NULL
                   CHECK (role IN ('shipper', 'shipping_company', 'driver')),
    company_name   VARCHAR(150),
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Vehicles: each trip will later be linked to a vehicle (UC-02). (Not used yet in Sprint 1.)
CREATE TABLE vehicles (
    vehicle_id         SERIAL PRIMARY KEY,
    owner_id           INTEGER       NOT NULL REFERENCES users(user_id),
    vehicle_type       VARCHAR(50)   NOT NULL,
    total_capacity_kg  NUMERIC(10,2) NOT NULL CHECK (total_capacity_kg > 0),
    is_refrigerated    BOOLEAN       NOT NULL DEFAULT FALSE,
    status             VARCHAR(20)   NOT NULL DEFAULT 'available'
                       CHECK (status IN ('available', 'in_use', 'broken_down', 'inactive'))
);

-- Shipments: from Elaf's form, saved by Mayar's backend code.
CREATE TABLE shipments (
    shipment_id    SERIAL PRIMARY KEY,
    shipper_id     INTEGER       REFERENCES users(user_id),      -- filled once login is added
    origin         VARCHAR(30)   NOT NULL REFERENCES cities(code),
    destination    VARCHAR(30)   NOT NULL REFERENCES cities(code),
    cargo_type     VARCHAR(20)   NOT NULL
                   CHECK (cargo_type IN ('general', 'food', 'pharma', 'electronics',
                                         'fragile', 'furniture', 'auto_parts', 'clothing')),
    weight_kg      NUMERIC(10,2) NOT NULL CHECK (weight_kg > 0 AND weight_kg <= 30000),
    temperature    VARCHAR(10)   NOT NULL CHECK (temperature IN ('ambient', 'chilled', 'frozen')),
    delivery_date  DATE          NOT NULL,
    status         VARCHAR(30)   NOT NULL DEFAULT 'pending_assignment'
                   CHECK (status IN ('pending_assignment', 'assigned', 'in_transit',
                                     'at_transfer_point', 'delivered', 'disrupted',
                                     'reassignment_pending', 'reassigned')),
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CHECK (origin <> destination)
);

-- Trips: from Layan's form, saved by Yara's backend code.
CREATE TABLE trips (
    trip_id         SERIAL PRIMARY KEY,
    publisher_id    INTEGER       REFERENCES users(user_id),     -- filled once login is added
    vehicle_id      INTEGER       REFERENCES vehicles(vehicle_id), -- filled once vehicle selection is added
    origin          VARCHAR(30)   NOT NULL REFERENCES cities(code),
    destination     VARCHAR(30)   NOT NULL REFERENCES cities(code),
    departure_date  DATE          NOT NULL,
    departure_time  TIME          NOT NULL,                       -- app sends 'HH:mm'
    capacity_kg     NUMERIC(10,2) NOT NULL CHECK (capacity_kg > 0 AND capacity_kg <= 30000),
    cargo_type      VARCHAR(20)   NOT NULL
                    CHECK (cargo_type IN ('general', 'food', 'pharma', 'electronics',
                                          'fragile', 'furniture', 'auto_parts', 'clothing')),
    temperature     VARCHAR(10)   NOT NULL CHECK (temperature IN ('ambient', 'chilled', 'frozen')),
    status          VARCHAR(20)   NOT NULL DEFAULT 'published'
                    CHECK (status IN ('published', 'in_progress', 'completed', 'cancelled')),
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CHECK (origin <> destination)
);

-- Speeds up searching for trips between two cities (used later by the Routing Engine)
CREATE INDEX idx_trips_route ON trips (origin, destination, departure_date);

-- The 14 cities from AppConstants.cities
INSERT INTO cities (code, name_en, name_ar) VALUES
 ('jeddah',   'Jeddah',   'جدة'),
 ('riyadh',   'Riyadh',   'الرياض'),
 ('dammam',   'Dammam',   'الدمام'),
 ('makkah',   'Makkah',   'مكة المكرمة'),
 ('madinah',  'Madinah',  'المدينة المنورة'),
 ('taif',     'Taif',     'الطائف'),
 ('abha',     'Abha',     'أبها'),
 ('tabuk',    'Tabuk',    'تبوك'),
 ('khobar',   'Khobar',   'الخبر'),
 ('jubail',   'Jubail',   'الجبيل'),
 ('buraidah', 'Buraidah', 'بريدة'),
 ('hail',     'Hail',     'حائل'),
 ('jazan',    'Jazan',    'جازان'),
 ('najran',   'Najran',   'نجران');
