USE CustomerGrowthAnalytics;
GO
-------------------------------------------------------------------
-- MONTHLY PURCHASE PERFORMANCE:

SELECT
    YEAR(event_time) AS Purchase_Year,
    MONTH(event_time) AS Purchase_Month,

    COUNT(*) AS Total_Purchase_Events,

    COUNT(DISTINCT user_id) AS Unique_Buyers,

    SUM(price) AS Total_Purchase_Value

FROM clean_events
WHERE event_type = 'purchase'

GROUP BY
    YEAR(event_time),
    MONTH(event_time)

ORDER BY
    Purchase_Year,
    Purchase_Month;
-------------------------------------------------------------------
-- TOP 10 PRODUCTS BY PURCHASE VALUE:

SELECT TOP 10
    product_id,
    COUNT(*) AS Total_Purchases,
    COUNT(DISTINCT user_id) AS Unique_Buyers,
    SUM(price) AS Total_Purchase_Value

FROM clean_events
WHERE event_type = 'purchase'

GROUP BY product_id
ORDER BY Total_Purchase_Value DESC;
-------------------------------------------------------------------
-- Top 10 brands by purchase value

SELECT TOP 10
    COALESCE(brand, 'Unknown') AS Brand,
    COUNT(*) AS Total_Purchases,
    COUNT(DISTINCT product_id) AS Unique_Products,
    SUM(price) AS Total_Purchase_Value

FROM clean_events
WHERE event_type = 'purchase'

GROUP BY COALESCE(brand, 'Unknown')
ORDER BY Total_Purchase_Value DESC;