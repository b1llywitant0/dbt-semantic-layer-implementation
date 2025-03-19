WITH
orders AS (
    SELECT
        order_id,
        customer_id
    FROM {{ ref('stg_olist__orders') }}
    WHERE valid_to = '{{var("future_proof_date")}}'
),

order_items AS (
    SELECT
        DISTINCT(order_id),
    FROM {{ ref("stg_olist__order_items") }}
),

filter_id AS (
    SELECT
        orders.order_id,
        orders.customer_id
    FROM orders
    INNER JOIN order_items ON orders.order_id = order_items.order_id
)

SELECT * FROM filter_id