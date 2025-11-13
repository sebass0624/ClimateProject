-- SECTION 2: CREATE PARENT TABLES (Metadata & Staff) -- Added NOT NULL constraints for required fields like location and country. 
-- 2.1 Staff Table (Parent for M:N relationship) 
CREATE TABLE staff ( 
    staff_id INT AUTO_INCREMENT PRIMARY KEY, 
    staff_name VARCHAR(100) NOT NULL, 
    role VARCHAR(50) NOT NULL 
);


-- 2.2 Buoy Metadata Table (Parent for Buoy Readings and Monitor Maintenance) 
CREATE TABLE buoy_info (
    buoy_id INT AUTO_INCREMENT PRIMARY KEY, 
    location VARCHAR(50) NOT NULL, 
    country VARCHAR(50) NOT NULL, 
    deploy_date DATE
);


-- 2.3 Balloon Metadata Table 
CREATE TABLE balloon_info (
    balloon_id INT AUTO_INCREMENT PRIMARY KEY, 
    location VARCHAR(50) NOT NULL, 
    country VARCHAR(50) NOT NULL, 
    deploy_date DATE 
);


-- 2.4 Surface Monitor Metadata Table 
CREATE TABLE surface_info (
    surface_id INT AUTO_INCREMENT PRIMARY KEY, 
    location VARCHAR(50) NOT NULL, 
    country VARCHAR(50) NOT NULL, 
    deploy_date DATE 
);


-- SECTION 3: CREATE CHILD/JUNCTION TABLES -- Establish the Foreign Key (FK) constraints here. 
-- 3.1 Monitor Maintenance Table (Junction - M:N between staff and ALL monitor types) 
CREATE TABLE monitor_maintenance ( 
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY, 
    staff_id INT NOT NULL, 
    buoy_id INT, 
    balloon_id INT, 
    surface_id INT, 
    maintenance_date DATE NOT NULL, 
    description VARCHAR(255), 
    -- Define Foreign Key Constraints 
    FOREIGN KEY  (buoy_id) REFERENCES buoy_info(buoy_id), 
    FOREIGN KEY  (balloon_id) REFERENCES balloon_info(balloon_id), 
    FOREIGN KEY  (surface_id) REFERENCES surface_info(surface_id), 
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





-- SECTION 4: CREATE INDEXES 
-- Foreign Key Indexes 
CREATE INDEX idx_buoy_fk ON buoy_readings (buoy_id); 
CREATE INDEX idx_balloon_fk ON balloon_readings (balloon_id); 
CREATE INDEX idx_surface_fk ON surface_readings (surface_id); 
CREATE INDEX idx_maint_buoy_fk ON monitor_maintenance (buoy_id); 
CREATE INDEX idx_maint_staff_fk ON monitor_maintenance (staff_id); 
CREATE INDEX idx_maint_balloon_fk ON monitor_maintenance (balloon_id);   CREATE INDEX idx_maint_surface_fk ON monitor_maintenance (surface_id);
-- Analytical Indexes 
CREATE INDEX idx_buoy_country ON buoy_info (country); 
CREATE INDEX idx_buoy_date ON buoy_readings (buoy_reading_date);