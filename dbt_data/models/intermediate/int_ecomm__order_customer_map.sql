{{ 
    config(
        order_by='(order_year, order_month, user_id, order_purchase_timestamp, order_id)' 
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
),

valid_orders AS (
    SELECT *
    FROM {{ ref("int_ecomm__valid_orders_based_on_order_items") }}
),

users AS (
    SELECT
        account_id,
        user_id
    FROM {{ ref("stg_olist__customers") }}
    WHERE valid_to = '{{var("future_proof_date")}}'
)

SELECT 
    users.user_id,
    valid_orders.order_id AS order_id,
    order_customer.order_purchase_timestamp,
    order_customer.order_year,
    order_customer.order_month
FROM valid_orders
LEFT JOIN order_customer ON order_customer.order_id = valid_orders.order_id
LEFT JOIN users ON order_customer.customer_id = users.account_id
