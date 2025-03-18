WITH 
closed_deals_order_items AS (
    SELECT *
    FROM {{ ref("int_crm__closed_deals_join_order_items") }}
),

orders AS (
    SELECT 
        order_id,
        order_delivered_carrier_date
    FROM {{ ref('stg_olist__orders') }}
    WHERE 
        order_status = 'delivered' AND
        valid_to = '{{var("future_proof_date")}}'
)

SELECT
    closed_deals_order_items.mql_id,
    closed_deals_order_items.won_date,
    closed_deals_order_items.seller_id,
    closed_deals_order_items.order_id AS order_id,
    orders.order_delivered_carrier_date,
    closed_deals_order_items.order_value
FROM closed_deals_order_items
LEFT JOIN orders ON closed_deals_order_items.order_id = orders.order_id
WHERE orders.order_id != ''
