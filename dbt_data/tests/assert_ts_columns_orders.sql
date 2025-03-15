-- The timestamps should be in order

SELECT
    order_id
FROM {{ ref('stg_olist__orders') }}
WHERE
    order_purchase_timestamp > order_approved_at OR
    order_approved_at > order_delivered_carrier_date OR
    order_delivered_carrier_date > order_delivered_customer_date OR
    order_estimated_delivery_date < order_purchase_timestamp