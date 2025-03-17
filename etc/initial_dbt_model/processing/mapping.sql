{{config(
    materialized='table',
	post_hook=[
      "CREATE INDEX IF NOT EXISTS idx_mapping ON {{ this }} (customer_unique_id, order_year, order_month)"
	]
  )
}}

SELECT 
    DISTINCT customer_unique_id, 
    DATE_PART('year', order_purchase_timestamp) AS order_year,
    DATE_PART('month', order_purchase_timestamp) AS order_month 
FROM {{ref("unique_customers")}} 
ORDER BY customer_unique_id
