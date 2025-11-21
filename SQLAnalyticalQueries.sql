-- Analytical Query 1: Compares each country's average CO2 concentration against the global average. Helps identify which regions are above or below the overall mean CO2 level. 

-- I. Calculates the average CO2 concentration from all buoy readings per country
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

-- II. Calculate the global average CO2 concentration
global_avg_co2 AS (
    SELECT AVG(co2_ppm) AS global_mean FROM all_co2_readings
)

-- III. Calculates the country average CO2, deviation, and retrieve the country name
SELECT
    cl.country_name, -- Fetch the human-readable name using the lookup table
    CAST(AVG(acr.co2_ppm) AS DECIMAL(6, 2)) AS country_average_co2_ppm,
    CAST(gac.global_mean AS DECIMAL(6, 2)) AS global_average_co2_ppm,
    -- Calculate deviation (Country Avg - Global Avg)
    CAST(AVG(acr.co2_ppm) - gac.global_mean AS DECIMAL(6, 2)) AS deviation_from_global
FROM
    all_co2_readings acr
-- IV. Use CROSS JOIN for the single-row global average CTE
CROSS JOIN
    global_avg_co2 gac
JOIN
    country_info cl ON acr.country_id = cl.country_id
GROUP BY
    cl.country_name, gac.global_mean
ORDER BY
    deviation_from_global DESC


    
-- Analytical Query 2: Compares average sea temperature against average land CO2 concentration to evaluate potential correlations.
-- I. Calculates the average sea temperature per country
WITH regional_sea_data AS (
    SELECT 
        ci.country_id,
        ci.country_name,
        AVG(br.sea_temp_c) AS average_sea_temp
    FROM 
        buoy_readings br
    JOIN
        buoy_info bi ON br.buoy_id = bi.buoy_id
    JOIN 
        country_info ci ON bi.country_id = ci.country_id
    WHERE
        br.sea_temp_c IS NOT NULL
    GROUP BY 
        ci.country_id, ci.country_name
),

-- II. Calculates the average land CO2 concentration per country
avg_land_co2 AS (
    SELECT 
        ci.country_id,
        AVG(sr.co2_ppm) AS average_land_co2
    FROM 
        surface_readings sr
    JOIN
        surface_info smi ON sr.surface_id = smi.surface_id
    JOIN
        country_info ci ON smi.country_id = ci.country_id
    WHERE 
        sr.co2_ppm IS NOT NULL
    GROUP BY
        ci.country_id 
)
-- III. Combine results, put in descending order by sea temperature
SELECT
    ast.country_name AS region,
    CAST(ast.average_sea_temp AS DECIMAL(5, 2)) AS average_sea_temp_c,
    CAST(alc.average_land_co2 AS DECIMAL(6, 2)) AS average_land_co2_ppm
FROM 
    regional_sea_data ast
JOIN
    avg_land_co2 alc ON ast.country_id = alc.country_id
ORDER BY
    average_sea_temp_c DESC;



-- Analytical Query 3: Determines the most crucial region for monitor deployment based on combined CO2 readings and wind speeds in all countries.
-- Cruciality = High Combined Average CO2 * High Average Wind Speed.

-- I. Gathers CO2 readings from all sensor types
WITH all_co2_readings AS (
    SELECT
        br.co2_ppm, bi.country_id
    FROM buoy_readings br JOIN buoy_info bi ON br.buoy_id = bi.buoy_id
    UNION ALL
    -- CO2 from Balloon Readings
    SELECT
        blr.co2_ppm, bli.country_id
    FROM balloon_readings blr JOIN balloon_info bli ON blr.balloon_id = bli.balloon_id
    UNION ALL
    -- CO2 from Surface Readings
    SELECT
        sr.co2_ppm, smi.country_id
    FROM surface_readings sr JOIN surface_info smi ON sr.surface_id = smi.surface_id
),

-- II. Gathers wind speed readings from buoys and balloons
all_wind_readings AS (
    SELECT
        br.wind_speed_ms, bi.country_id
    FROM buoy_readings br JOIN buoy_info bi ON br.buoy_id = bi.buoy_id
    WHERE br.wind_speed_ms IS NOT NULL
    UNION ALL
    SELECT
        blr.wind_speed_ms, bli.country_id
    FROM balloon_readings blr JOIN balloon_info bli ON blr.balloon_id = bli.balloon_id
    WHERE blr.wind_speed_ms IS NOT NULL
),

-- III. Calculates the average CO2 concentration for each country
avg_co2_per_country AS (
    SELECT
        country_id,
        AVG(co2_ppm) AS avg_co2
    FROM
        all_co2_readings
    GROUP BY
        country_id
),

-- IV. Calculates the average wind speed for each country
avg_wind_per_country AS (
    SELECT
        country_id,
        AVG(wind_speed_ms) AS avg_wind
    FROM
        all_wind_readings
    GROUP BY
        country_id
)

-- V. Calculates critical score and organizes results in descending order
SELECT
    ci.country_name AS region,
    ROUND(c.avg_co2, 2) AS average_co2_ppm,
    ROUND(w.avg_wind, 2) AS average_wind_speed_ms,
    -- Critical Score = (Avg CO2 * Avg Wind) / 100
    ROUND((c.avg_co2 * w.avg_wind) / 100, 4) AS critical_score
FROM
    country_info ci
JOIN
    avg_co2_per_country c ON ci.country_id = c.country_id
JOIN
    avg_wind_per_country w ON ci.country_id = w.country_id
ORDER BY
    critical_score DESC;

