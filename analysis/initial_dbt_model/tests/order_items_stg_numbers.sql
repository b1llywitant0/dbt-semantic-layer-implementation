SELECT 
    *
FROM {{ref("order_items_stg")}}
WHERE 
    item_count < 0 OR 
    price < 0 OR 
    freight_value < 0