-- Handling duplicate records created by handling late data by using unique_key
{{ 
    config(
        engine='MergeTree()', 
        materialized='incremental', 
        unique_key='review_id'
        )
}}

SELECT 
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    created_at,
    updated_at,
    deleted
FROM {{ source('olist','mv_order_reviews') }}
FINAL

-- Also handling late data, if exists
{% if is_incremental() %}
    WHERE updated_at >= ( 
        SELECT addDays(MAX(updated_at), -3) from {{ this }}
    )
{% endif %} 

-- Once a week, run full refresh
