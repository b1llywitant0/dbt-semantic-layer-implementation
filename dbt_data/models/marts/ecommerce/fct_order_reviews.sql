{{ 
    config(
        order_by='(deleted, review_score, review_creation_date, review_answer_timestamp, order_id, customer_id, review_id)' 
        )
}}

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
),

order_reviews AS (
    SELECT 
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp,
        deleted
    FROM {{ ref("stg_olist__order_reviews") }}
    WHERE valid_to = '{{var("future_proof_date")}}'
),

final AS (
    SELECT
        order_reviews.review_id,
        order_reviews.order_id AS order_id,
        filter_id.customer_id,
        order_reviews.review_score,
        order_reviews.review_comment_title,
        order_reviews.review_comment_message,
        order_reviews.review_creation_date,
        order_reviews.review_answer_timestamp,
        order_reviews.deleted AS deleted
    FROM order_reviews
    INNER JOIN filter_id ON order_reviews.order_id = filter_id.order_id
)

SELECT * FROM final