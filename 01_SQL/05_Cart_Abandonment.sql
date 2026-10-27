USE CustomerGrowthAnalytics;
GO
-----------------------------------------------------------------
-- ANALYZE CART ACTIVITY BY CUSTOMER SESSION:

WITH session_activity AS (
    SELECT
        user_id,
        user_session,
        MAX(CASE WHEN event_type = 'cart'
            THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_type = 'purchase'
            THEN 1 ELSE 0 END) AS purchased
    FROM clean_events
    WHERE user_session IS NOT NULL
    GROUP BY user_id, user_session
)

SELECT
    COUNT(*) AS Total_Sessions,

    SUM(added_to_cart) AS Sessions_With_Cart,

    SUM(CASE WHEN added_to_cart = 1 AND purchased = 1
        THEN 1 ELSE 0 END) AS Cart_And_Purchase,

    SUM(CASE WHEN added_to_cart = 1 AND purchased = 0
        THEN 1 ELSE 0 END) AS Cart_Without_Purchase

FROM session_activity;
-----------------------------------------------------------------
-- INVESTIGATING CART REMOVALS:

WITH session_activity AS (
    SELECT
        user_id,
        user_session,
        MAX(CASE WHEN event_type = 'cart'
            THEN 1 ELSE 0 END) AS carted,
        MAX(CASE WHEN event_type = 'purchase'
            THEN 1 ELSE 0 END) AS purchased,
        MAX(CASE WHEN event_type = 'remove_from_cart'
            THEN 1 ELSE 0 END) AS removed
    FROM clean_events
    WHERE user_session IS NOT NULL
    GROUP BY user_id, user_session
)

SELECT
    SUM(CASE WHEN carted = 1 AND purchased = 0
             AND removed = 1 THEN 1 ELSE 0 END)
        AS No_Purchase_With_Removal,

    SUM(CASE WHEN carted = 1 AND purchased = 0
             AND removed = 0 THEN 1 ELSE 0 END)
        AS No_Purchase_Without_Removal

FROM session_activity;
-----------------------------------------------------------------
