-- Handling duplicate records created by handling late data by using unique_key
{{ 
    config(
        engine='MergeTree()', 
        materialized='incremental', 
        unique_key='order_id'
        )
}}

SELECT    
    order_id,
    customer_id,
    order_status_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    created_at,
    updated_at,
    deleted
FROM {{ source('olist','mv_orders') }}
FINAL

-- Also handling late data, if exists
{% if is_incremental() %}
    WHERE updated_at >= ( 
        SELECT addDays(MAX(updated_at), -3) from {{ this }}
    )
{% endif %} 

-- Once a week, run full refresh
