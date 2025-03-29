{{ 
    config(
        order_by='(customer_id, order_purchase_timestamp, order_id)' 
        )
}}

WITH
order_customer AS (
    SELECT
        customer_id,
        order_id,
        order_purchase_timestamp,
        toStartOfYear(order_purchase_timestamp) AS order_year,
        toStartOfMonth(order_purchase_timestamp) AS order_month
    FROM {{ ref("stg_olist__orders") }}
    WHERE valid_to = '{{var("future_proof_date")}}'
)

SELECT * FROM order_customer



