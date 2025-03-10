WITH
product_categories AS (
    SELECT *
    FROM {{ ref('base_olist__product_categories') }}
),

cdc_products AS (
    SELECT *,
    after.product_category_id AS product_category_id
    FROM {{ source('olist','cdc_products') }}
)

SELECT
    cdc_products.*,
    product_categories.product_category_name_english AS product_category
FROM cdc_products
LEFT JOIN product_categories ON cdc_products.product_category_id = product_categories.product_category_id