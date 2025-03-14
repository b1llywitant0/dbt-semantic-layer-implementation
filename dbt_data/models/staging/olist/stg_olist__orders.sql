WITH
order_status AS (
    SELECT *
    FROM {{ source('olist','order_status') }}
),

orders AS (
    SELECT *
    FROM {{ ref('snp_olist__orders') }}
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
    orders.deleted,
    orders.dbt_valid_from AS valid_from,
    COALESCE(orders.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM orders
LEFT JOIN order_status 
ON orders.order_status_id = order_status.order_status_id
