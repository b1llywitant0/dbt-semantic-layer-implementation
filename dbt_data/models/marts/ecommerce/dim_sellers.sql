{{ 
    config(
        order_by='(valid_to, valid_from, seller_id)' 
        )
}}

SELECT
    seller_id,
    city,
    state,
    deleted,
    valid_from,
    valid_to
FROM {{ ref('stg_olist__sellers') }}