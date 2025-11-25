CREATE DATABASE IF NOT EXISTS gcm_database;
USE gcm_database;

-- SECTION 1: DROP TABLES 
-- Per advice, all drop table statements have been moved to their respective create table statements.
-- After updating each monitor's maintenance table to be separate, we ran into an issue where the code would not successfully run due to foreign key issues. 
-- To remediate this, we set the foreign key check value to 0 until the end of the program, after which it is reset to 1.

SET FOREIGN_KEY_CHECKS = 0;

-- SECTION 2: CREATE PARENT TABLES (Metadata & Staff)
-- 2.1 Staff Table (Parent for M:N relationship)
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- 2.2 Country Table (Parent for Monitors)
DROP TABLE IF EXISTS country_info;
CREATE TABLE country_info ( 
	country_id INT AUTO_INCREMENT PRIMARY KEY, 
    country_name VARCHAR(50) UNIQUE NOT NULL 
);

-- 2.3 Buoy Metadata Table (Parent for Buoy Readings and Monitor Maintenance)
DROP TABLE IF EXISTS buoy_info;
CREATE TABLE buoy_info (
buoy_id INT AUTO_INCREMENT PRIMARY KEY,
location VARCHAR(50) NOT NULL,
country_id INT,
deploy_date DATE,
FOREIGN KEY(country_id) REFERENCES country_info(country_id) 
);

-- 2.4 Balloon Metadata Table
DROP TABLE IF EXISTS balloon_info;
CREATE TABLE balloon_info (
balloon_id INT AUTO_INCREMENT PRIMARY KEY,
location VARCHAR(50) NOT NULL,
country_id INT,
deploy_date DATE, 
FOREIGN KEY(country_id) REFERENCES country_info(country_id) 
);

-- 2.5 Surface Monitor Metadata Table
DROP TABLE IF EXISTS surface_info;
CREATE TABLE surface_info (
surface_id INT AUTO_INCREMENT PRIMARY KEY,
location VARCHAR(50) NOT NULL,
country_id INT,
deploy_date DATE, 
FOREIGN KEY(country_id) REFERENCES country_info(country_id) 
);


-- SECTION 3: CREATE CHILD/JUNCTION TABLES
-- 3.1 Buoy Maintenance (M:N Staff to Buoy)
DROP TABLE IF EXISTS maintenance_buoy;
CREATE TABLE maintenance_buoy (
    maint_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    buoy_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (buoy_id) REFERENCES buoy_info(buoy_id)
);

-- 3.2 Balloon Maintenance (M:N Staff to Balloon)
DROP TABLE IF EXISTS maintenance_balloon;
CREATE TABLE maintenance_balloon (
    maint_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    balloon_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (balloon_id) REFERENCES balloon_info(balloon_id)
);

-- 3.3 Surface Monitor Maintenance (M:N Staff to Surface Monitor)
DROP TABLE IF EXISTS maintenance_surface;
CREATE TABLE maintenance_surface (
    maint_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    surface_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (surface_id) REFERENCES surface_info(surface_id)
);

-- 4.1 Buoy Readings Table (1:N relationship with buoy_info)
DROP TABLE IF EXISTS buoy_readings;
CREATE TABLE buoy_readings (
    reading_id INT AUTO_INCREMENT PRIMARY KEY,
    buoy_id INT NOT NULL,
    buoy_reading_date DATE NOT NULL,
    co2_ppm DECIMAL(6,2) NOT NULL,
    sea_temp_c DECIMAL(5,2),
    wind_speed_ms DECIMAL(5,2),
    FOREIGN KEY (buoy_id) REFERENCES buoy_info(buoy_id)
);

-- 4.2 Balloon Readings Table (1:N relationship with balloon_info)
DROP TABLE IF EXISTS balloon_readings;
CREATE TABLE balloon_readings (
    balloon_reading_id INT AUTO_INCREMENT PRIMARY KEY,
    balloon_id INT NOT NULL,
    balloon_reading_date DATE NOT NULL,
    co2_ppm DECIMAL(6,2) NOT NULL,
    o3_ppb DECIMAL(6,2),
    wind_speed_ms DECIMAL (5,2),
    FOREIGN KEY (balloon_id) REFERENCES balloon_info(balloon_id)
);

-- 4.3 Surface Monitor Readings Table (1:N relationship with surface_info)
DROP TABLE IF EXISTS surface_readings;
CREATE TABLE surface_readings (
    surface_readings_id INT AUTO_INCREMENT PRIMARY KEY,
    surface_id INT NOT NULL,
    surface_reading_date DATE NOT NULL,
    co2_ppm DECIMAL (6,2) NOT NULL,
    air_pressure_mb DECIMAL (6,2),
    humid_percent_m3 DECIMAL (5,2),
    FOREIGN KEY (surface_id) REFERENCES surface_info(surface_id)
);

SET FOREIGN_KEY_CHECKS = 1;


-- SECTION 5: CREATE INDEXES
-- Country FK indexes
CREATE INDEX idx_buoy_country on buoy_info (country_id);
CREATE INDEX idx_balloon_country on balloon_info (country_id);
CREATE INDEX idx_surface_country on surface_info (country_id);

-- Monitor ID indexes
CREATE INDEX idx_buoy_fk ON buoy_readings (buoy_id);
CREATE INDEX idx_balloon_fk ON balloon_readings (balloon_id);
CREATE INDEX idx_surface_fk ON surface_readings (surface_id);

-- Monitor Maintenance indexes
CREATE INDEX idx_maint_buoy_fk ON maintenance_buoy (buoy_id);
CREATE INDEX idx_maint_balloon_fk ON maintenance_balloon (balloon_id);
CREATE INDEX idx_maint_surface_fk ON maintenance_surface (surface_id);
CREATE INDEX idx_maint_staff ON maintenance_buoy (staff_id);

-- Date Indexes
CREATE INDEX idx_buoy_date ON buoy_readings (buoy_reading_date);
CREATE INDEX idx_balloon_date ON balloon_readings (balloon_reading_date);
CREATE INDEX idx_surface_date ON surface_readings (surface_reading_date);

-- Staff Name Indexes
CREATE INDEX idx_staff_name ON staff (staff_name);

