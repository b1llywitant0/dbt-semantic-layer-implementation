WITH 
marketing_revenue AS (
    SELECT 
        DATE_PART('year',os.order_delivered_customer_date) AS year, 
        DATE_PART('month',os.order_delivered_customer_date) AS month,
        COUNT(DISTINCT ois.order_id) AS orders_count,
        SUM(ois.item_count) AS products_count,
        TO_CHAR(SUM(ois.price+ois.freight_value), 'fm999999999.0') AS total_revenue,
        TO_CHAR(SUM(ois.price)/SUM(ois.item_count), 'fm999999.0') AS average_price_per_product,
        TO_CHAR(SUM(ois.price+ois.freight_value)/COUNT(DISTINCT ois.order_id), 'fm999999.0') AS average_revenue_per_order
    FROM {{ref("order_items_stg")}} ois
    LEFT JOIN {{ref("orders_stg")}} os ON ois.order_id = os.order_id
    RIGHT JOIN {{ref("closed_deals_stg")}} cds ON ois.seller_id = cds.seller_id
    WHERE 
        os.order_status = 'delivered' AND 
        os.order_delivered_customer_date IS NOT NULL
    GROUP BY year, month
)
SELECT 
    mr.year,
    mr.month,
    mr.orders_count,
    mr.products_count,
    mr.total_revenue,
    mr.average_price_per_product,
    mr.average_revenue_per_order
FROM marketing_revenue mr