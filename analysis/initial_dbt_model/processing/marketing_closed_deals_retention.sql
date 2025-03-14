WITH 
seller_mql AS (
	SELECT 
		os.order_id,
		ois.seller_id,
		os.order_purchase_timestamp,
		os.order_status
	FROM {{ref("order_items_stg")}} ois 
	LEFT JOIN {{ref("orders_stg")}} os ON ois.order_id = os.order_id
	WHERE os.order_status = 'delivered'
),
day_diff AS (
	SELECT
		sm.order_id,
		sm.seller_id,
		cds.won_date,
		EXTRACT(DAY FROM sm.order_purchase_timestamp-cds.won_date) AS day_diff
	FROM seller_mql sm
	RIGHT JOIN {{ref("closed_deals_stg")}} cds ON sm.seller_id = cds.seller_id
),
retention AS (
	SELECT
		dd.seller_id,
		dd.won_date,
		MIN(dd.day_diff) AS first_sale
	FROM day_diff dd
	GROUP BY dd.seller_id, dd.won_date
	HAVING MIN(dd.day_diff) < 90
)
SELECT
	DATE_PART('year', r.won_date) AS year_won, 
    DATE_PART('month', r.won_date) AS month_won,
	COUNT(DISTINCT r.seller_id) AS mql_retention_count
FROM retention r
GROUP BY year_won, month_won