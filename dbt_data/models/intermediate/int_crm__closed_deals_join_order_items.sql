{{ 
    config(
        order_by='(won_date, order_id, mql_id)' 
        )
}}

WITH
closed_deals AS (
    SELECT
        mql_id,
        seller_id,
        created_at
    FROM {{ ref("stg_crm__closed_deals") }}
),

order_items AS (
    SELECT
        order_id,
        seller_id,
        price,
        freight_value
    FROM {{ ref("stg_olist__order_items") }}
)

SELECT
    closed_deals.mql_id,
    closed_deals.created_at AS won_date,
    closed_deals.seller_id,
    order_items.order_id,
    SUM(order_items.price) + SUM(order_items.freight_value) AS order_value
FROM closed_deals
LEFT JOIN order_items ON closed_deals.seller_id = order_items.seller_id
GROUP BY closed_deals.mql_id, won_date, closed_deals.seller_id, order_items.order_id