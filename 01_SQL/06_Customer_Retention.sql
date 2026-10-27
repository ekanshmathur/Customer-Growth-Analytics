USE CustomerGrowthAnalytics;
GO
-----------------------------------------------------------------
-- IDENTIFY REPEAT PURCHASING CUSTOMERS:

WITH customer_purchases AS (
    SELECT
        user_id,
        COUNT(DISTINCT YEAR(event_time) * 100
              + MONTH(event_time)) AS purchase_months
    FROM clean_events
    WHERE event_type = 'purchase'
    GROUP BY user_id
)

SELECT
    COUNT(*) AS Total_Purchasers,

    SUM(CASE WHEN purchase_months = 1
        THEN 1 ELSE 0 END) AS One_Month_Purchasers,

    SUM(CASE WHEN purchase_months >= 2
        THEN 1 ELSE 0 END) AS Repeat_Month_Purchasers

FROM customer_purchases;

-----------------------------------------------------------------
-- Monthly Customer Cohort Analysis

WITH monthly_buyers AS (
    SELECT DISTINCT
        user_id,
        DATEFROMPARTS(
            YEAR(event_time),
            MONTH(event_time), 1
        ) AS purchase_month
    FROM clean_events
    WHERE event_type = 'purchase'
),

first_purchase AS (
    SELECT
        user_id,
        MIN(purchase_month) AS cohort_month
    FROM monthly_buyers
    GROUP BY user_id
)

SELECT
    first_purchase.cohort_month,
    DATEDIFF(MONTH, cohort_month, purchase_month)
        AS months_after_first_purchase,
    COUNT(*) AS purchasing_customers

FROM monthly_buyers
JOIN first_purchase
    ON monthly_buyers.user_id = first_purchase.user_id

GROUP BY
    first_purchase.cohort_month,
    DATEDIFF(MONTH, cohort_month, purchase_month)

ORDER BY
    cohort_month,
    months_after_first_purchase;

-----------------------------------------------------------------
-- First-observed vs returning monthly buyers

WITH monthly_buyers AS (
    SELECT DISTINCT
        user_id,
        DATEFROMPARTS(
            YEAR(event_time),
            MONTH(event_time), 1
        ) AS purchase_month
    FROM clean_events
    WHERE event_type = 'purchase'
),

first_purchase AS (
    SELECT
        user_id,
        MIN(purchase_month) AS first_month
    FROM monthly_buyers
    GROUP BY user_id
)

SELECT
    m.purchase_month,

    COUNT(*) AS total_buyers,

    SUM(CASE
        WHEN m.purchase_month = f.first_month
        THEN 1 ELSE 0
    END) AS first_observed_buyers,

    SUM(CASE
        WHEN m.purchase_month > f.first_month
        THEN 1 ELSE 0
    END) AS returning_buyers

FROM monthly_buyers m
JOIN first_purchase f
    ON m.user_id = f.user_id

GROUP BY m.purchase_month
ORDER BY m.purchase_month;