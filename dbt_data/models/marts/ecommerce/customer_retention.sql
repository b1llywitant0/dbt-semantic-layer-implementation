WITH
    start_date AS (
      SELECT toStartOfMonth(min(order_purchase_timestamp)) 
      FROM {{ ref("int_ecomm__order_customer_map") }}
    ),
    end_date AS (
      SELECT toStartOfMonth(max(order_purchase_timestamp)) 
      FROM {{ ref("int_ecomm__order_customer_map") }}
    ),
    period AS (
        SELECT DISTINCT date_month 
        FROM {{ ref("dim_dates") }}
        WHERE date_day BETWEEN (SELECT * FROM start_date) AND (SELECT * FROM end_date)
    ),
    
    crossed AS (
        SELECT 
            DISTINCT int_ecomm__order_customer_map.user_id,
            period.date_month
        FROM {{ ref("int_ecomm__order_customer_map") }}
        CROSS JOIN period
    ),
    
    customer_activity AS (
        SELECT
            DISTINCT user_id,
            order_month
        FROM {{ ref("int_ecomm__order_customer_map") }}
    ),
    
    joined AS (
        SELECT
            crossed.user_id AS user_id,
            crossed.date_month AS date_month,
            customer_activity.order_month AS order_month
        FROM crossed
        LEFT JOIN customer_activity ON 
            crossed.user_id = customer_activity.user_id AND
            crossed.date_month = customer_activity.order_month
    ),
    
    windowed AS (
        SELECT *,
        leadInFrame(order_month, 1) OVER (PARTITION BY user_id ORDER BY date_month ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS month_plus_1,
        leadInFrame(order_month, 2) OVER (PARTITION BY user_id ORDER BY date_month ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS month_plus_2,
        leadInFrame(order_month, 3) OVER (PARTITION BY user_id ORDER BY date_month ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS month_plus_3,
        leadInFrame(order_month, 4) OVER (PARTITION BY user_id ORDER BY date_month ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS month_plus_4,
        leadInFrame(order_month, 5) OVER (PARTITION BY user_id ORDER BY date_month ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS month_plus_5,
        leadInFrame(order_month, 6) OVER (PARTITION BY user_id ORDER BY date_month ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS month_plus_6
        FROM joined
        WHERE order_month IS NOT NULL
    ),

    counted AS (
        SELECT
            date_month AS cohort,
            COUNT(DISTINCT user_id) AS active_users,
            COUNT(DISTINCT CASE WHEN month_plus_1 IS NOT NULL THEN user_id END) AS retention_month_1,
            COUNT(DISTINCT CASE WHEN month_plus_2 IS NOT NULL THEN user_id END) AS retention_month_2,
            COUNT(DISTINCT CASE WHEN month_plus_3 IS NOT NULL THEN user_id END) AS retention_month_3,
            COUNT(DISTINCT CASE WHEN month_plus_4 IS NOT NULL THEN user_id END) AS retention_month_4,
            COUNT(DISTINCT CASE WHEN month_plus_5 IS NOT NULL THEN user_id END) AS retention_month_5,
            COUNT(DISTINCT CASE WHEN month_plus_6 IS NOT NULL THEN user_id END) AS retention_month_6
        FROM windowed
        GROUP BY date_month
        ORDER BY date_month
    )
    
SELECT
    cohort,
    active_users / NULLIF(active_users, 0) AS month_0,
    retention_month_1 / NULLIF(active_users, 0) AS month_1,
    retention_month_2 / NULLIF(active_users, 0) AS month_2,
    retention_month_3 / NULLIF(active_users, 0) AS month_3,
    retention_month_4 / NULLIF(active_users, 0) AS month_4,
    retention_month_5 / NULLIF(active_users, 0) AS month_5,
    retention_month_6 / NULLIF(active_users, 0) AS month_6
FROM counted
