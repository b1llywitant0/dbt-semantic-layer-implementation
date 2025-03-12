SELECT 
    *
FROM {{ref("closed_deals_stg")}}
WHERE 
    DATE(first_contact_date) > CURRENT_DATE OR
	DATE(won_date) > CURRENT_DATE OR
    DATE(won_date) < DATE(first_contact_date)