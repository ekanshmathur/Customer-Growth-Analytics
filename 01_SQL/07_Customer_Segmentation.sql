USE CustomerGrowthAnalytics;
GO
-----------------------------------------------------------------------
-- Segment customers based on their activities

WITH user_activity AS (
    SELECT
        user_id,
        MAX(CASE WHEN event_type = 'view'
            THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_type = 'cart'
            THEN 1 ELSE 0 END) AS carted,
        MAX(CASE WHEN event_type = 'purchase'
            THEN 1 ELSE 0 END) AS purchased
    FROM clean_events
    GROUP BY user_id
),

customer_segments AS (
    SELECT
        CASE
            WHEN purchased = 1 THEN 'Purchasing Customers'
            WHEN carted = 1 THEN 'Carted But Never Purchased'
            WHEN viewed = 1 THEN 'Browsed Only'
            ELSE 'Other Activity'
        END AS customer_segment
    FROM user_activity
)

SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM customer_segments
GROUP BY customer_segment
ORDER BY total_customers DESC;