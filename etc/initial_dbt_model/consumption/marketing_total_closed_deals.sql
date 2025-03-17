WITH 
total_closed_leads AS (
    SELECT 
        DATE_PART('year',won_date) AS year_won, 
        DATE_PART('month',won_date) AS month_won,
        COUNT(DISTINCT seller_id) AS total_won
    FROM {{ ref('closed_deals_stg')}}
    GROUP BY year_won, month_won
    ORDER BY year_won, month_won
)
SELECT * 
FROM total_closed_leads