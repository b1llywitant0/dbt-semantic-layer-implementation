WITH
source AS (
    SELECT *
    FROM {{ source('olist','product_categories') }}
),

active_product_categories AS (
    SELECT 
        product_category_id,
        product_category_name_english
    FROM source
    WHERE deleted_at IS NULL
)

SELECT * FROM active_product_categories