CREATE DATABASE IF NOT EXISTS gcm_database;
USE gcm_database;

-- SECTION 1: DROP TABLES 
DROP TABLE IF EXISTS buoy_readings;
DROP TABLE IF EXISTS balloon_readings;
DROP TABLE IF EXISTS surface_readings;
DROP TABLE IF EXISTS monitor_maintenance; -- M:N Junction table
DROP TABLE IF EXISTS buoy_info;
DROP TABLE IF EXISTS balloon_info;
DROP TABLE IF EXISTS surface_info;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS country_info;
DROP TABLE IF EXISTS country_lookup;


-- SECTION 2: CREATE PARENT TABLES (Metadata & Staff)
-- 2.1 Staff Table (Parent for M:N relationship)
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- 2.2 Country Table (Parent for Monitors) 
CREATE TABLE country_info ( 
	country_id INT AUTO_INCREMENT PRIMARY KEY, 
    country_name VARCHAR(50) UNIQUE NOT NULL 
);

-- 2.3 Buoy Metadata Table (Parent for Buoy Readings and Monitor Maintenance)
CREATE TABLE buoy_info (
buoy_id INT AUTO_INCREMENT PRIMARY KEY,
location VARCHAR(50) NOT NULL,
country_id INT,
deploy_date DATE,
FOREIGN KEY(country_id) REFERENCES country_info(country_id) 
);

-- 2.4 Balloon Metadata Table
CREATE TABLE balloon_info (
balloon_id INT AUTO_INCREMENT PRIMARY KEY,
location VARCHAR(50) NOT NULL,
country_id INT,
deploy_date DATE, 
FOREIGN KEY(country_id) REFERENCES country_info(country_id) 
);

-- 2.5 Surface Monitor Metadata Table
CREATE TABLE surface_info (
surface_id INT AUTO_INCREMENT PRIMARY KEY,
location VARCHAR(50) NOT NULL,
country_id INT,
deploy_date DATE, 
FOREIGN KEY(country_id) REFERENCES country_info(country_id) 
);


-- SECTION 3: CREATE CHILD/JUNCTION TABLES
-- 3.1 Monitor Maintenance Table (Junction - M:N between staff and ALL monitor types)
CREATE TABLE monitor_maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    buoy_id INT,
    balloon_id INT,
    surface_id INT,
    maintenance_date DATE NOT NULL,
    description VARCHAR(255),
    -- Foreign Key Constraints
    FOREIGN KEY (buoy_id) REFERENCES buoy_info(buoy_id),
    FOREIGN KEY (balloon_id) REFERENCES balloon_info(balloon_id),
    FOREIGN KEY (surface_id) REFERENCES surface_info(surface_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- 3.2 Buoy Readings Table (1:N relationship with buoy_info)
CREATE TABLE buoy_readings (
    reading_id INT AUTO_INCREMENT PRIMARY KEY,
    buoy_id INT NOT NULL,
    buoy_reading_date DATE NOT NULL,
    co2_ppm DECIMAL(6,2) NOT NULL,
    sea_temp_c DECIMAL(5,2),
    wind_speed_ms DECIMAL(5,2),
    FOREIGN KEY (buoy_id) REFERENCES buoy_info(buoy_id)
);

-- 3.3 Balloon Readings Table (1:N relationship with balloon_info)
CREATE TABLE balloon_readings (
    balloon_reading_id INT AUTO_INCREMENT PRIMARY KEY,
    balloon_id INT NOT NULL,
    balloon_reading_date DATE NOT NULL,
    co2_ppm DECIMAL(6,2) NOT NULL,
    o3_ppb DECIMAL(6,2),
    wind_speed_ms DECIMAL (5,2),
    FOREIGN KEY (balloon_id) REFERENCES balloon_info(balloon_id)
);

-- 3.4 Surface Monitor Readings Table (1:N relationship with surface_info)
CREATE TABLE surface_readings (
    surface_readings_id INT AUTO_INCREMENT PRIMARY KEY,
    surface_id INT NOT NULL,
    surface_reading_date DATE NOT NULL,
    co2_ppm DECIMAL (6,2) NOT NULL,
    air_pressure_mb DECIMAL (6,2),
    humid_percent_m3 DECIMAL (5,2),
    FOREIGN KEY (surface_id) REFERENCES surface_info(surface_id)
);

-- 3.5 country_lookup table
CREATE TABLE country_lookup (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(255)
);


-- SECTION 4: CREATE INDEXES
-- Country FK indexes
CREATE INDEX idx_buoy_country on buoy_info (country_id);
CREATE INDEX idx_balloon_country on balloon_info (country_id);
CREATE INDEX idx_surface_country on surface_info (country_id);

-- Monitor ID indexes
CREATE INDEX idx_buoy_fk ON buoy_readings (buoy_id);
CREATE INDEX idx_balloon_fk ON balloon_readings (balloon_id);
CREATE INDEX idx_surface_fk ON surface_readings (surface_id);

-- Monitor Maintenance indexes
CREATE INDEX idx_maint_buoy_fk ON monitor_maintenance (buoy_id);
CREATE INDEX idx_maint_staff_fk ON monitor_maintenance (staff_id);
CREATE INDEX idx_maint_balloon_fk ON monitor_maintenance (balloon_id);
CREATE INDEX idx_maint_surface_fk ON monitor_maintenance (surface_id);

-- Date Indexes
CREATE INDEX idx_buoy_date ON buoy_readings (buoy_reading_date);
CREATE INDEX idx_balloon_date ON balloon_readings (balloon_reading_date);
CREATE INDEX idx_surface_date ON surface_readings (surface_reading_date);

-- Staff Name Indexes
CREATE INDEX idx_staff_name ON staff (staff_name);

