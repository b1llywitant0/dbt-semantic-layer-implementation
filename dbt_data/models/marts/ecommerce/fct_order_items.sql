{{ 
    config(
        order_by='(order_creation_date, seller_id, product_id, order_id)' 
        )
}}

SELECT
    order_id,
    product_id,
    seller_id,
    SUM(price) AS total_price,
    SUM(freight_value) AS total_freight_value,
    COUNT(product_id) AS quantity,
    MIN(created_at) AS order_creation_date,
    MAX(shipping_limit_date) AS shipping_limit_date
FROM {{ ref('stg_olist__order_items') }}
GROUP BY order_id, product_id, seller_id
