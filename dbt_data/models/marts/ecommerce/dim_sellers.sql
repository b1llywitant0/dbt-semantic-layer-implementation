{{ 
    config(
        order_by='(valid_to, valid_from, seller_id)' 
        )
}}

SELECT
    seller_sk,
    seller_id,
    city,
    state,
    deleted,
    valid_from,
    valid_to,
    CASE
        WHEN valid_to = '{{var("future_proof_date")}}' THEN 1
        ELSE 0
    END AS is_current
FROM {{ ref('stg_olist__sellers') }}