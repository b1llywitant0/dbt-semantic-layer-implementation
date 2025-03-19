{{config(
    materialized='table',
	post_hook=[
      "CREATE INDEX IF NOT EXISTS idx_unique_customers ON {{ this }} (customer_unique_id, order_purchase_timestamp)"
	]
  )
}}

SELECT
    os.order_id,
    cs.customer_unique_id,
    os.order_purchase_timestamp 
FROM {{ref("customers_stg")}} cs 
RIGHT JOIN {{ref("orders_stg")}} os ON cs.customer_id = os.customer_id