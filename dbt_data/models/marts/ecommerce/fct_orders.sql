{{ 
    config(
        order_by='(order_status, order_creation_date, customer_id, order_id)' 
        )
}}

WITH
orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_estimated_delivery_date
    FROM {{ ref('stg_olist__orders') }}
    WHERE valid_to = '{{var("future_proof_date")}}'
),

order_values AS (
    SELECT
        order_id,
        SUM(price) + SUM(freight_value) AS order_value,
        MAX(shipping_limit_date) AS shipping_limit_date
    FROM {{ ref("stg_olist__order_items") }}
    GROUP BY order_id
)

SELECT
    orders.order_id AS order_id,
    orders.customer_id,
    orders.order_purchase_timestamp AS order_creation_date,
    order_values.shipping_limit_date,
    orders.order_estimated_delivery_date,
    orders.order_status,
    order_values.order_value
FROM orders
INNER JOIN order_values ON orders.order_id = order_values.order_id
