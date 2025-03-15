WITH
order_status AS (
    SELECT *
    FROM {{ source('olist','order_status') }}
),

orders AS (
    SELECT *
    FROM {{ ref('base_olist__orders') }}
)

SELECT
    orders.order_id,
    orders.customer_id,
    order_status.order_status_name AS order_status,
    orders.order_purchase_timestamp,
    orders.order_approved_at,
    orders.order_delivered_carrier_date,
    orders.order_delivered_customer_date,
    orders.order_estimated_delivery_date,
    orders.created_at,
    orders.updated_at,
    orders.deleted
FROM orders
LEFT JOIN order_status 
ON orders.order_status_id = order_status.order_status_id
