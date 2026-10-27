USE CustomerGrowthAnalytics;
GO

-----------------------------------------------------------------------------------------------------------
-- NULL VALUE ANALYSIS:

WITH all_events AS (
    SELECT '2019-10' AS Month, * FROM events_oct2019
    UNION ALL
    SELECT '2019-11', * FROM events_nov2019
    UNION ALL
    SELECT '2019-12', * FROM events_dec2019
    UNION ALL
    SELECT '2020-01', * FROM events_jan2020
    UNION ALL
    SELECT '2020-02', * FROM events_feb2020
)

SELECT
    Month,
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN event_time IS NULL OR event_time = '' THEN 1 ELSE 0 END) AS Null_Time,
    SUM(CASE WHEN event_type IS NULL OR event_type = '' THEN 1 ELSE 0 END) AS Null_Event_Type,
    SUM(CASE WHEN product_id IS NULL OR product_id = '' THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN category_id IS NULL OR category_id = '' THEN 1 ELSE 0 END) AS Null_Category_ID,
    SUM(CASE WHEN category_code IS NULL OR category_code = '' THEN 1 ELSE 0 END) AS Null_Category_Code,
    SUM(CASE WHEN brand IS NULL OR brand = '' THEN 1 ELSE 0 END) AS Null_Brand,
    SUM(CASE WHEN price IS NULL OR price = '' THEN 1 ELSE 0 END) AS Null_Price,
    SUM(CASE WHEN user_id IS NULL OR user_id = '' THEN 1 ELSE 0 END) AS Null_User_ID,
    SUM(CASE WHEN user_session IS NULL OR user_session = '' THEN 1 ELSE 0 END) AS Null_Session
FROM all_events
GROUP BY Month
ORDER BY Month;

-----------------------------------------------------------------------------------------------------------
-- DUPLICATE DETECTION:

WITH all_events AS (
    SELECT '2019-10' AS Month, * FROM events_oct2019
    UNION ALL
    SELECT '2019-11', * FROM events_nov2019
    UNION ALL
    SELECT '2019-12', * FROM events_dec2019
    UNION ALL
    SELECT '2020-01', * FROM events_jan2020
    UNION ALL
    SELECT '2020-02', * FROM events_feb2020
),

duplicate_check AS (
    SELECT
        Month,
        event_time,
        event_type,
        product_id,
        category_id,
        category_code,
        brand,
        price,
        user_id,
        user_session,
        COUNT_BIG(*) AS Row_Count
    FROM all_events
    GROUP BY
        Month, event_time, event_type,
        product_id, category_id, category_code,
        brand, price, user_id, user_session
)

SELECT
    Month,
    SUM(CASE WHEN Row_Count > 1 THEN 1 ELSE 0 END)
        AS Duplicate_Groups,
    SUM(Row_Count - 1) AS Extra_Duplicate_Rows
FROM duplicate_check
GROUP BY Month
ORDER BY Month;

--------------------------------------------------------------------------------
-- VALIDATING DATA VALUES AND TYPES:

WITH all_events AS (
    SELECT '2019-10' AS Month,
           event_time, event_type, category_id, price, user_id
    FROM events_oct2019

    UNION ALL
    SELECT '2019-11', event_time, event_type, category_id, price, user_id
    FROM events_nov2019

    UNION ALL
    SELECT '2019-12', event_time, event_type, category_id, price, user_id
    FROM events_dec2019

    UNION ALL
    SELECT '2020-01', event_time, event_type, category_id, price, user_id
    FROM events_jan2020

    UNION ALL
    SELECT '2020-02', event_time, event_type, category_id, price, user_id
    FROM events_feb2020
)

SELECT
    Month,

    SUM(CASE WHEN TRY_CONVERT(DATETIME2, LEFT(event_time, 19))
             IS NULL THEN 1 ELSE 0 END) AS Invalid_Dates,

    SUM(CASE WHEN TRY_CONVERT(DECIMAL(18,4), price)
             IS NULL THEN 1 ELSE 0 END) AS Invalid_Prices,

    SUM(CASE WHEN TRY_CONVERT(BIGINT, category_id)
             IS NULL THEN 1 ELSE 0 END) AS Invalid_Category_IDs,

    SUM(CASE WHEN TRY_CONVERT(BIGINT, user_id)
             IS NULL THEN 1 ELSE 0 END) AS Invalid_User_IDs,

    SUM(CASE WHEN event_type NOT IN
             ('view', 'cart', 'purchase', 'remove_from_cart')
             THEN 1 ELSE 0 END) AS Invalid_Event_Types

FROM all_events
GROUP BY Month
ORDER BY Month;