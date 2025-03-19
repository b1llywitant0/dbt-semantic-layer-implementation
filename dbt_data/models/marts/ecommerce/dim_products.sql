{{ 
    config(
        order_by='(product_category, valid_to, valid_from, product_id)' 
        )
}}

SELECT
    product_id,
    product_category,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_length_cm * product_height_cm * product_width_cm AS product_volume_cm3,
    deleted,
    valid_from,
    valid_to
FROM {{ ref('stg_olist__products') }}