-- Handling duplicate records created by handling late data by using unique_key
{{ 
    config(
        engine='MergeTree()', 
        materialized='incremental', 
        unique_key=['order_id','order_item_id'],
        )
}}

SELECT    
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    created_at,
    updated_at,
    deleted
FROM {{ source('olist','mv_order_items') }}
FINAL

-- Also handling late data, if exists
{% if is_incremental() %}
    WHERE updated_at >= ( 
        SELECT addDays(MAX(updated_at), -3) from {{ this }}
    )
{% endif %} 

-- Once a week, run full refresh
