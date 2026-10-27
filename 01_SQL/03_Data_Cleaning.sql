
USE CustomerGrowthAnalytics;
GO
----------------------------------------------------------------------
-- Combine all five months
WITH all_events AS (
    SELECT * FROM events_oct2019
    UNION ALL
    SELECT * FROM events_nov2019
    UNION ALL
    SELECT * FROM events_dec2019
    UNION ALL
    SELECT * FROM events_jan2020
    UNION ALL
    SELECT * FROM events_feb2020
)
----------------------------------------------------------------------
-- Create the cleaned analytical table
SELECT
    CAST(LEFT(event_time, 19) AS DATETIME2) AS event_time,
    event_type,
    CAST(product_id AS BIGINT) AS product_id,
    CAST(category_id AS BIGINT) AS category_id,
    NULLIF(TRIM(category_code), '') AS category_code,
    NULLIF(TRIM(brand), '') AS brand,
    CAST(price AS DECIMAL(18,4)) AS price,
    CAST(user_id AS BIGINT) AS user_id,
    NULLIF(TRIM(user_session), '') AS user_session

INTO clean_events
FROM all_events;
----------------------------------------------------------------------
-- Check total records
SELECT COUNT_BIG(*) AS Total_Clean_Rows
FROM clean_events;

-- Inspect cleaned data
SELECT TOP 10 *
FROM clean_events;