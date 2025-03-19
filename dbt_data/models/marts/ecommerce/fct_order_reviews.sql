{{ 
    config(
        order_by='(deleted, review_score, review_creation_date, review_answer_timestamp, order_id, customer_id, review_id)' 
        )
}}

WITH
valid_orders AS (
    SELECT *
    FROM {{ ref("int_ecomm__valid_orders_based_on_order_items") }}
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
)

SELECT
    order_reviews.review_id,
    order_reviews.order_id AS order_id,
    valid_orders.customer_id,
    order_reviews.review_score,
    order_reviews.review_comment_title,
    order_reviews.review_comment_message,
    order_reviews.review_creation_date,
    order_reviews.review_answer_timestamp,
    order_reviews.deleted AS deleted
FROM order_reviews
INNER JOIN valid_orders ON order_reviews.order_id = valid_orders.order_id
