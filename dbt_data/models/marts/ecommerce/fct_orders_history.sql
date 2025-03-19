{{ 
    config(
        order_by='(order_status, order_purchase_timestamp, valid_from, valid_to, order_id)' 
        )
}}

SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    valid_from,
    valid_to
FROM {{ ref('stg_olist__orders') }}