{{ 
    config(
        order_by='(valid_to, valid_from, user_id, account_id)' 
        )
}}

SELECT
    account_id,
    user_id,
    city,
    state,
    deleted,
    valid_from,
    valid_to
FROM {{ ref('stg_olist__customers') }}