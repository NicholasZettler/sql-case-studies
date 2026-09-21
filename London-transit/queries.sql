-- London Underground Ridership Analysis
-- Table: tfl.rods (TfL RODS, typical November weekday)
-- Columns: entry_zone, time_period, origin_purpose,
--          destination_purpose, distance, daily_journeys


-- Task 1: General usage statistics

-- 1a. Total daily journeys (result: 4,878,330)
SELECT SUM(daily_journeys) AS total_journeys
FROM tfl.rods;

-- 1b. Journeys by entry zone
--     Zone 1 share calculated outside SQL (result: 51.7%)
SELECT entry_zone,
       SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY entry_zone;

-- 1c. Journeys by time period (highest: PM Peak)
SELECT time_period,
       SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY time_period
ORDER BY total_journeys DESC;


-- Task 2: Why people use the Underground

-- 2a. Journeys by origin purpose
SELECT origin_purpose,
       SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY origin_purpose
ORDER BY total_journeys DESC;

-- 2b. Journeys by origin/destination purpose pair
SELECT origin_purpose,
       destination_purpose,
       SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY origin_purpose, destination_purpose
ORDER BY total_journeys DESC;

-- 2c. Journeys by origin purpose and time period
SELECT origin_purpose,
       time_period,
       SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY origin_purpose, time_period
ORDER BY origin_purpose, total_journeys DESC;

-- 2d. Journeys by entry zone and origin purpose
SELECT entry_zone,
       origin_purpose,
       SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY entry_zone, origin_purpose
ORDER BY entry_zone, total_journeys DESC;

-- Extension: Tourist-related travel

-- 3. Tourist trips by purpose pair and time period
SELECT origin_purpose,
       destination_purpose,
       time_period,
       SUM(daily_journeys) AS total_journeys
FROM tfl.rods
WHERE origin_purpose = 'Tourist'
   OR destination_purpose = 'Tourist'
GROUP BY origin_purpose, destination_purpose, time_period
ORDER BY total_journeys DESC;
