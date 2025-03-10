WITH
product_categories AS (
    SELECT 
        product_category_id,
        product_category_name_english
    FROM {{ source('olist','product_categories') }}
    WHERE deleted_at IS NULL
)

SELECT * FROM product_categories