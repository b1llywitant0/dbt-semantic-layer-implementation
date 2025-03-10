SELECT 
	cd.mql_id,
	cd.seller_id,
	ql.first_contact_date,
	cd.won_date,
	ql.origin,
	cd.business_segment
FROM closed_deals cd
LEFT JOIN qualified_leads ql ON cd.mql_id = ql.mql_id