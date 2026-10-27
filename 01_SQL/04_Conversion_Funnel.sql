USE CustomerGrowthAnalytics;
GO
------------------------------------------------------------------
-- ANALYZE CUSTOMER ACTIVITIES:

SELECT
    event_type,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS unique_users
FROM clean_events
GROUP BY event_type
ORDER BY
    CASE event_type
        WHEN 'view' THEN 1
        WHEN 'cart' THEN 2
        WHEN 'purchase' THEN 3
        WHEN 'remove_from_cart' THEN 4
    END;

------------------------------------------------------------------
-- EXAMINE CUSTOMER PROGRESSION:

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
)

SELECT
    SUM(viewed) AS Total_Viewers,
    SUM(CASE WHEN viewed = 1 AND carted = 1
        THEN 1 ELSE 0 END) AS Viewed_And_Carted,
    SUM(CASE WHEN viewed = 1 AND purchased = 1
        THEN 1 ELSE 0 END) AS Viewed_And_Purchased,
    SUM(CASE WHEN viewed = 1 AND carted = 1 AND purchased = 1
        THEN 1 ELSE 0 END) AS All_Three_Activities
FROM user_activity;
------------------------------------------------------------------
-- CHECKING CUSTOMER ACTIVITY ORDER:

WITH first_activity AS (
    SELECT
        user_id,
        MIN(CASE WHEN event_type = 'view'
            THEN event_time END) AS first_view,
        MIN(CASE WHEN event_type = 'cart'
            THEN event_time END) AS first_cart,
        MIN(CASE WHEN event_type = 'purchase'
            THEN event_time END) AS first_purchase
    FROM clean_events
    GROUP BY user_id
)

SELECT
    COUNT(first_view) AS Total_Viewers,

    SUM(CASE WHEN first_cart > first_view
        THEN 1 ELSE 0 END) AS View_Then_Cart,

    SUM(CASE WHEN first_cart > first_view
             AND first_purchase > first_cart
        THEN 1 ELSE 0 END) AS View_Cart_Purchase

FROM first_activity;
------------------------------------------------------------------