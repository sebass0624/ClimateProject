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
