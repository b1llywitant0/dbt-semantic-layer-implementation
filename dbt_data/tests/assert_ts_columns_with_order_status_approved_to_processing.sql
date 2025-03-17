-- It is mandatory to use test whether the status and the column is matching each other.
-- Created status should have order_purchase_timestamp, and null values in other timestamp columns

SELECT
    order_id
FROM {{ ref('stg_olist__orders') }}
WHERE
    (
        order_status = 'approved' OR
        order_status = 'invoiced' OR
        order_status = 'processing'
    ) 
    AND
    (
        order_purchase_timestamp IS NULL OR
        order_approved_at IS NULL OR
        order_delivered_carrier_date IS NOT NULL OR
        order_delivered_customer_date IS NOT NULL
    )
