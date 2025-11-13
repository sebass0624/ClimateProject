--Analytical Query 1, answers question regarding which country
--has the largest average difference in CO2 concentration according to 
--all three monitor types
WITH all_co2_readings AS (
    SELECT T1.co2_ppm, T2.country FROM buoy_readings T1 JOIN buoy_info T2 ON T1.buoy_id = T2.buoy_id
    UNION ALL
    SELECT T1.co2_ppm, T2.country FROM balloon_readings T1 JOIN balloon_info T2 ON T1.balloon_id = T2.balloon_id
    UNION ALL
    SELECT T1.co2_ppm, T2.country FROM surface_readings T1 JOIN surface_info T2 ON T1.surface_id = T2.surface_id
)
SELECT
    country,
    CAST(MAX(co2_ppm) AS DECIMAL(6, 2)) AS max_co2_ppm,
    CAST(MIN(co2_ppm) AS DECIMAL(6, 2)) AS min_co2_ppm,
    CAST(MAX(co2_ppm) - MIN(co2_ppm) AS DECIMAL(6, 2)) AS co2_range_difference
FROM
    all_co2_readings
GROUP BY
    country
ORDER BY
    co2_range_difference DESC

--Analytical Query 2, answers question regarding the correlation 
--between CO2 and land temperature amongst the different regions

(
-- Top 3 Hottest Readings
SELECT
    'Hottest' AS category,
    T2.location,
    T1.sea_temp_c,
    T1.co2_ppm,
    T1.buoy_reading_date
FROM
    buoy_readings T1
JOIN
    buoy_info T2 ON T1.buoy_id = T2.buoy_id
ORDER BY
    T1.sea_temp_c DESC
LIMIT 3
)
UNION ALL
(
-- Top 3 Coldest Readings
SELECT
    'Coldest' AS category,
    T2.location,
    T1.sea_temp_c,
    T1.co2_ppm,
    T1.buoy_reading_date
FROM
    buoy_readings T1
JOIN
    buoy_info T2 ON T1.buoy_id = T2.buoy_id
ORDER BY
    T1.sea_temp_c ASC
LIMIT 3
);

--Analytical Query 3, regarding the most crucial region for 
--monitor deployment

WITH all_co2_readings AS (
    SELECT T1.co2_ppm, T2.country FROM buoy_readings T1 JOIN buoy_info T2 ON T1.buoy_id = T2.buoy_id
    UNION ALL
    SELECT T1.co2_ppm, T2.country FROM balloon_readings T1 JOIN balloon_info T2 ON T1.balloon_id = T2.balloon_id
    UNION ALL
    SELECT T1.co2_ppm, T2.country FROM surface_readings T1 JOIN surface_info T2 ON T1.surface_id = T2.surface_id
)
SELECT
    country,
    CAST(AVG(co2_ppm) AS DECIMAL(6, 2)) AS average_co2_ppm_for_deployment
FROM
    all_co2_readings
GROUP BY
    country
ORDER BY
    average_co2_ppm_for_deployment DESC