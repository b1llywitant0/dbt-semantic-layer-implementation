-- Defining churn rate of sellers if they didn't generate sales in the next three months after won

SELECT 
	mtcd.year_won,
	mtcd.month_won,
	TO_CHAR(ROUND((1 - ROUND(mcdr.mql_retention_count,2 )/ROUND(mtcd.total_won,2))*100.00,2), 'fm990.00%') AS churn_rate 
FROM {{ref("marketing_total_closed_deals")}} mtcd 
LEFT JOIN {{ref("marketing_closed_deals_retention")}} mcdr 
ON mtcd.year_won = mcdr.year_won AND mtcd.month_won = mcdr.month_won