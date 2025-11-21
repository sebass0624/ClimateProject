-- SECTION 5: INSERT MOCK/TESTING DATA (DML) - CORRECTED

-- 5.1 Insert Staff Data
-- Note: IDs will be 1, 2, 3
INSERT INTO staff (staff_name, role) VALUES
('Dr. Lena Jones', 'Senior Data Scientist'),
('Enrique Vasquez', 'Field Technician'),
('Sarah Chen', 'Field Technician');

-- 5.2 Insert Country Data
-- We must insert data into country_info (the FK parent) 
INSERT INTO country_info (country_id, country_name) VALUES 
(1, 'USA'), 
(2, 'Australia'), 
(3, 'India'), 
(4, 'Norway'), 
(5, 'Antarctica');

-- 5.3 Insert Monitor Metadata (Now includes the critical country_id foreign key)
-- Country ID assignments: 1=USA, 2=Australia, 3=India, 4=Norway, 5=Antarctica

INSERT INTO buoy_info (country_id, location, deploy_date) VALUES
(1, 'Atlantic Buoy A1','2025-01-10'),  -- Linked to USA
(2, 'Pacific Buoy B1', '2025-02-15'),  -- Linked to Australia
(3, 'Indian Buoy C1', '2025-03-06'),   -- Linked to India
(4, 'Arctic Buoy D1', '2025-04-17'),   -- Linked to Norway
(5, 'Southern Buoy A1', '2025-05-18'); -- Linked to Antarctica

INSERT INTO balloon_info (country_id, location, deploy_date) VALUES
(1, 'Atlantic Balloon A1', '2025-01-12'), -- Linked to USA
(2, 'Pacific Balloon B1', '2025-03-14'), -- Linked to Australia
(3, 'Indian Balloon C1', '2025-03-26'),  -- Linked to India
(4, 'Arctic Balloon D1', '2025-04-14'),  -- Linked to Norway
(5, 'Southern Balloon A1', '2025-05-15');-- Linked to Antarctica

INSERT INTO surface_info(country_id, location, deploy_date) VALUES
(1, 'Atlantic Surface Monitor A1', '2025-01-24'), -- Linked to USA
(2, 'Pacific Surface Monitor B1', '2025-02-06'), -- Linked to Australia
(3, 'Indian Surface Monitor C1', '2025-04-12'),  -- Linked to India
(4, 'Arctic Surface Monitor D1', '2025-05-01'),  -- Linked to Norway
(5, 'Southern Surface Monitor A1', '2025-01-23');-- Linked to Antarctica

-- 5.4 Insert Maintenance Data (M:N Link)
-- Correcting staff IDs based on the inserts (1=Dr. Jones, 2=Enrique, 3=Sarah)
INSERT INTO monitor_maintenance (staff_id, buoy_id, balloon_id, surface_id, maintenance_date, description) VALUES
(2, 1, NULL, NULL, '2025-06-01', 'Replaced light and cleaned sensors on Buoy 1.'),
(3, 1, NULL, NULL, '2025-09-15', 'Annual calibration check on Buoy 1.'),
(2, 2, NULL, NULL, '2025-07-20', 'Repaired wind speed sensor on Buoy 2.'),
(2, NULL, 3, NULL, '2025-08-10', 'Replaced GPS unit on Balloon 3.'),
(3, NULL, 5, NULL, '2025-09-01', 'Retrieved and re-launched Balloon 5.'),
(3, NULL, NULL, 2, '2025-08-25', 'Fixed power supply on Surface Monitor 2.'),
(2, NULL, NULL, 4, '2025-09-05', 'Replaced humidity sensor on Surface Monitor 4.');

-- 5.5 Insert Readings (Mock Data) - These remain correct, just the IDs matter.
INSERT INTO buoy_readings (buoy_id, buoy_reading_date, co2_ppm, sea_temp_c, wind_speed_ms) VALUES
(1, '2025-10-05', 415.23, 22.5, 5.2), (1, '2025-10-01', 414.90, 22.7, 4.9), (1, '2025-10-04', 416.10, 22.4, 5.5), (1, '2025-10-05', 415.75, 22.6, 5.1),
(2, '2025-10-02', 401.20, 24.3, 6.8), (2, '2025-10-03', 400.75, 24.1, 6.6), (2, '2025-10-04', 402.10, 24.5, 6.9), (2, '2025-10-06', 401.85, 24.2, 7.0),
(3, '2025-10-08', 410.45, 26.4, 4.9), (3, '2025-10-09', 409.90, 26.1, 5.0), (3, '2025-10-06', 411.20, 26.3, 4.8), (3, '2025-10-05', 410.95, 26.5, 5.1),
(4, '2025-10-03', 392.12, 2.1, 3.1), (4, '2025-10-02', 391.75, 2.3, 3.0), (4, '2025-10-03', 392.40, 2.2, 3.2), (4, '2025-10-05', 392.00, 2.0, 3.3),
(5, '2025-10-04', 405.10, 19.4, 5.7), (5, '2025-10-03', 404.85, 19.5, 5.5), (5, '2025-10-09', 405.45, 19.6, 5.8), (5, '2025-10-07', 405.00, 19.5, 5.6);

INSERT INTO balloon_readings (balloon_id, balloon_reading_date, co2_ppm, o3_ppb, wind_speed_ms) VALUES
(1, '2025-10-03', 415.23, 22.5, 5.2), (1, '2025-10-09', 414.90, 22.7, 4.9), (1, '2025-10-05', 416.10, 22.4, 5.5), (1, '2025-10-07', 415.75, 22.6, 5.1),
(2, '2025-10-08', 401.20, 24.3, 6.8), (2, '2025-10-02', 400.75, 24.1, 6.6), (2, '2025-10-04', 402.10, 24.5, 6.9), (2, '2025-10-05', 401.85, 24.2, 7.0),
(3, '2025-10-07', 410.45, 26.4, 4.9), (3, '2025-10-08', 409.90, 26.1, 5.0), (3, '2025-10-05', 411.20, 26.3, 4.8), (3, '2025-10-02', 410.95, 26.5, 5.1),
(4, '2025-10-06', 392.12, 2.1, 3.1), (4, '2025-10-08', 391.75, 2.3, 3.0), (4, '2025-10-01', 392.40, 2.2, 3.2), (4, '2025-10-09', 392.00, 2.0, 3.3),
(5, '2025-10-01', 405.10, 19.4, 5.7), (5, '2025-10-02', 404.85, 19.5, 5.5), (5, '2025-10-05', 405.45, 19.6, 5.8), (5, '2025-10-04', 405.00, 19.5, 5.6);

INSERT INTO surface_readings (surface_id, surface_reading_date, co2_ppm, air_pressure_mb, humid_percent_m3) VALUES
(1, '2025-10-06', 415.23, 1012.50, 50.2), (1, '2025-10-02', 414.90, 1012.70, 49.9), (1, '2025-10-03', 416.10, 1012.40, 50.5), (1, '2025-10-04', 415.75, 1012.60, 50.1),
(2, '2025-10-05', 401.20, 1008.30, 60.8), (2, '2025-10-08', 400.75, 1008.10, 60.6), (2, '2025-10-09', 402.10, 1008.50, 60.9), (2, '2025-10-01', 401.85, 1008.20, 61.0),
(3, '2025-10-02', 410.45, 1010.40, 55.9), (3, '2025-10-05', 409.90, 1010.10, 56.0), (3, '2025-10-03', 411.20, 1010.30, 55.8), (3, '2025-10-02', 410.95, 1010.50, 56.1),
(4, '2025-10-09', 392.12, 1005.10, 40.1), (4, '2025-10-08', 391.75, 1005.30, 40.0), (4, '2025-10-03', 392.40, 1005.20, 40.2), (4, '2025-10-04', 392.00, 1005.00, 40.3),
(5, '2025-10-02', 405.10, 1011.40, 58.7), (5, '2025-10-08', 404.85, 1011.50, 58.5), (5, '2025-10-05', 405.45, 1011.60, 58.8), (5, '2025-10-03', 405.00, 1011.50, 58.6);


