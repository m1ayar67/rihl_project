-- Sample data for testing (not real users)
INSERT INTO shipments (origin, destination, cargo_type, weight_kg, temperature, delivery_date) VALUES
 ('jeddah', 'riyadh', 'general', 500,  'ambient', '2026-12-07'),
 ('jeddah', 'makkah', 'food',    300,  'chilled', '2026-12-05'),
 ('riyadh', 'dammam', 'pharma',  120,  'frozen',  '2026-12-08');

INSERT INTO trips (origin, destination, departure_date, departure_time, capacity_kg, cargo_type, temperature) VALUES
 ('jeddah', 'riyadh', '2026-12-05', '08:00', 3000, 'general', 'ambient'),
 ('jeddah', 'makkah', '2026-12-05', '09:30', 2000, 'food',    'chilled'),
 ('riyadh', 'dammam', '2026-12-06', '07:00',  800, 'pharma',  'frozen');
