WITH
order_items AS (
    SELECT *
    FROM {{ ref('snp_olist__order_items') }}
)

SELECT
    order_items.order_item_sk,
    order_items.order_id,
    order_items.order_item_id,
    order_items.product_id,
    order_items.seller_id,
    order_items.shipping_limit_date,
    order_items.price,
    order_items.freight_value,
    order_items.deleted,
    order_items.dbt_valid_from AS valid_from,
    COALESCE(order_items.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM order_items
