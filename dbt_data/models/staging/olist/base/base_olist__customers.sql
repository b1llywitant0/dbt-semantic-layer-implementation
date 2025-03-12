-- Handling duplicate records created by handling late data by using unique_key
{{ 
    config(
        engine='MergeTree()', 
        materialized='incremental', 
        unique_key='customer_id'
        )
}}

SELECT 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    created_at,
    updated_at,
    deleted
FROM {{ source('olist','mv_customers') }}
FINAL

-- Also handling late data, if exists
{% if is_incremental() %}
    WHERE updated_at >= ( 
        SELECT addDays(MAX(updated_at), -3) from {{ this }}
    )
{% endif %} 

-- Once a week, run full refresh
