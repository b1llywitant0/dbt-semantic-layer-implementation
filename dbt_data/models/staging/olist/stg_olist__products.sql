WITH
product_categories AS (
    SELECT *
    FROM {{ ref('base_olist__product_categories') }}
),

products AS (
    SELECT *
    FROM {{ ref('snp_olist__products') }}
)

SELECT
    products.product_id,
    product_categories.product_category_name_english AS product_category,
    products.product_weight_g,
    products.product_length_cm,
    products.product_height_cm,
    products.product_width_cm,
    products.deleted,
    products.dbt_valid_from AS valid_from,
    COALESCE(products.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM products
LEFT JOIN product_categories 
ON products.product_category_id = product_categories.product_category_id
