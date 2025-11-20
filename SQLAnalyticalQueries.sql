WITH all_co2_readings AS (
    -- Get buoy readings, create alias
    SELECT T1.co2_ppm, T2.country_id AS country_id
    FROM buoy_readings T1
    JOIN buoy_info T2 ON T1.buoy_id = T2.buoy_id

    UNION ALL

    -- Get balloon readings, create alias
    SELECT T1.co2_ppm, T2.country_id
    FROM balloon_readings T1
    JOIN balloon_info T2 ON T1.balloon_id = T2.balloon_id

    UNION ALL

    -- Get surface monitor readings, create alias
    SELECT T1.co2_ppm, T2.country_id
    FROM surface_readings T1
    JOIN surface_info T2 ON T1.surface_id = T2.surface_id
),

-- 2. Calculate the global average CO2 concentration
global_avg_co2 AS (
    SELECT AVG(co2_ppm) AS global_mean FROM all_co2_readings
)

-- 3. Calculate country average CO2, deviation, and retrieve the country name
SELECT
    cl.country_name, -- Fetch the human-readable name using the lookup table
    CAST(AVG(acr.co2_ppm) AS DECIMAL(6, 2)) AS country_average_co2_ppm,
    CAST(gac.global_mean AS DECIMAL(6, 2)) AS global_average_co2_ppm,
    -- Calculate deviation (Country Avg - Global Avg)
    CAST(AVG(acr.co2_ppm) - gac.global_mean AS DECIMAL(6, 2)) AS deviation_from_global
FROM
    all_co2_readings acr
-- Use CROSS JOIN for the single-row global average CTE
CROSS JOIN
    global_avg_co2 gac
JOIN
    country_lookup cl ON acr.country_id = cl.country_id
GROUP BY
    cl.country_name, gac.global_mean
ORDER BY
    deviation_from_global DESC

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
