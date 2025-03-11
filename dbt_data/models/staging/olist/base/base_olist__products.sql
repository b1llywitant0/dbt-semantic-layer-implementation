-- Handling duplicate records created by handling late data by using unique_key
{{ 
    config(
        engine='MergeTree()', 
        materialized='incremental', 
        unique_key='product_id'
        )
}}

SELECT 
    product_id,
    product_category_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    created_at,
    updated_at,
    deleted
FROM {{ source('olist','mv_products') }}
FINAL

-- Also handling late data, if exists
{% if is_incremental() %}
    WHERE updated_at >= ( 
        SELECT addDays(MAX(updated_at), -3) from {{ this }}
    )
{% endif %}

-- Once a week, run full refresh
