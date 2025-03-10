SELECT
	oi.order_id,
	oi.product_id,
	oi.seller_id,
	COUNT(DISTINCT oi.order_item_id) AS item_count,
	SUM(oi.price) AS price,
	SUM(oi.freight_value) AS freight_value
FROM order_items oi
GROUP BY oi.order_id, oi.product_id, oi.seller_id
ORDER BY item_count DESC