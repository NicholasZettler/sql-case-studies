-- Intel Device Repurposing: Sustainability Impact Analysis
-- Tables: intel.device_data, intel.impact_data (joined on device_id)
-- Synthetic Global Career Accelerator dataset


-- Task 1: Organize and prepare the data

-- 1a. Join device and impact data
SELECT d.*, i.*
FROM intel.device_data d
INNER JOIN intel.impact_data i
    ON d.device_id = i.device_id;

-- 1b. Add device_age (2024 - model_year)
SELECT d.*, i.*,
       2024 - d.model_year AS device_age
FROM intel.device_data d
INNER JOIN intel.impact_data i
    ON d.device_id = i.device_id;

-- 1c. Add device_age_bucket, ordered oldest to newest
SELECT d.*, i.*,
       2024 - d.model_year AS device_age,
       CASE
           WHEN 2024 - d.model_year <= 3 THEN 'newer'
           WHEN 2024 - d.model_year <= 6 THEN 'mid-age'
           ELSE 'older'
       END AS device_age_bucket
FROM intel.device_data d
INNER JOIN intel.impact_data i
    ON d.device_id = i.device_id
ORDER BY d.model_year ASC;



-- Task 2: Overall program impact

-- 2a. Total devices, avg age, avg energy savings, total CO2 saved (tons)
WITH repurposed AS (
    SELECT d.*, i.*,
           2024 - d.model_year AS device_age,
           CASE
               WHEN 2024 - d.model_year <= 3 THEN 'newer'
               WHEN 2024 - d.model_year <= 6 THEN 'mid-age'
               ELSE 'older'
           END AS device_age_bucket
    FROM intel.device_data d
    INNER JOIN intel.impact_data i ON d.device_id = i.device_id
)
SELECT COUNT(*)                    AS total_devices,
       AVG(device_age)             AS avg_device_age,
       AVG(energy_savings_yr)      AS avg_energy_savings_kwh,
       SUM(co2_saved_kg_yr) / 1000 AS total_co2_saved_tons
FROM repurposed;



-- Task 3: Trends by type, age, and region

-- 3a. Grouped by device_type
WITH repurposed AS (
    SELECT d.*, i.*,
           2024 - d.model_year AS device_age,
           CASE
               WHEN 2024 - d.model_year <= 3 THEN 'newer'
               WHEN 2024 - d.model_year <= 6 THEN 'mid-age'
               ELSE 'older'
           END AS device_age_bucket
    FROM intel.device_data d
    INNER JOIN intel.impact_data i ON d.device_id = i.device_id
)
SELECT device_type,
       COUNT(*)                    AS total_devices,
       AVG(energy_savings_yr)      AS avg_energy_savings_kwh,
       AVG(co2_saved_kg_yr) / 1000 AS avg_co2_saved_tons
FROM repurposed
GROUP BY device_type;

-- 3b. Grouped by device_age_bucket
WITH repurposed AS (
    SELECT d.*, i.*,
           2024 - d.model_year AS device_age,
           CASE
               WHEN 2024 - d.model_year <= 3 THEN 'newer'
               WHEN 2024 - d.model_year <= 6 THEN 'mid-age'
               ELSE 'older'
           END AS device_age_bucket
    FROM intel.device_data d
    INNER JOIN intel.impact_data i ON d.device_id = i.device_id
)
SELECT device_age_bucket,
       COUNT(*)                    AS total_devices,
       AVG(energy_savings_yr)      AS avg_energy_savings_kwh,
       AVG(co2_saved_kg_yr) / 1000 AS avg_co2_saved_tons
FROM repurposed
GROUP BY device_age_bucket;

-- 3c. Grouped by region
WITH repurposed AS (
    SELECT d.*, i.*,
           2024 - d.model_year AS device_age,
           CASE
               WHEN 2024 - d.model_year <= 3 THEN 'newer'
               WHEN 2024 - d.model_year <= 6 THEN 'mid-age'
               ELSE 'older'
           END AS device_age_bucket
    FROM intel.device_data d
    INNER JOIN intel.impact_data i ON d.device_id = i.device_id
)
SELECT region,
       COUNT(*)                    AS total_devices,
       AVG(energy_savings_yr)      AS avg_energy_savings_kwh,
       AVG(co2_saved_kg_yr) / 1000 AS avg_co2_saved_tons
FROM repurposed
GROUP BY region;
