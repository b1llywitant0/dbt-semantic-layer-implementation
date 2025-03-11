-- Handling duplicate records created by handling late data by using unique_key
{{ 
    config(engine='MergeTree()', 
    materialized='incremental', 
    unique_key='product_id')
}}

SELECT *
FROM {{ source('olist','mv_products') }}

-- Also handling late data, if exists
{% if is_incremental %}
    WHERE updated_at >= ( 
        SELECT addDays(MAX(updated_at), -3) from {{ this }}
    )
{% endif %}

-- Once a week, run full refresh
