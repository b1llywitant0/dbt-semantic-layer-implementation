WITH
product_categories AS (
    SELECT *
    FROM {{ ref('base_olist__product_categories') }}
),

products AS (
    SELECT *
    FROM {{ source('olist','mv_products') }}
    FINAL
)

SELECT
    products.*,
    product_categories.product_category_name_english AS product_category
FROM products
LEFT JOIN product_categories 
USING product_category_id