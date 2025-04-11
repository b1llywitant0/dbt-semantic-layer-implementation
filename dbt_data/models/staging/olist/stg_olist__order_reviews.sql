WITH
order_reviews AS (
    SELECT *
    FROM {{ ref('snp_olist__order_reviews') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['order_reviews.review_id', 'order_reviews.order_id', 'order_reviews.dbt_valid_from']) }} AS order_review_sk,
    order_reviews.review_id,
    order_reviews.order_id,
    order_reviews.review_score,
    order_reviews.review_comment_title,
    order_reviews.review_comment_message,
    order_reviews.review_creation_date,
    order_reviews.review_answer_timestamp,
    order_reviews.deleted,
    order_reviews.dbt_valid_from AS valid_from,
    COALESCE(order_reviews.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM order_reviews
