COPY products FROM '/seeding/data/olist_products_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY geolocations FROM '/seeding/data/olist_geolocation_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY customers FROM '/seeding/data/olist_customers_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY sellers FROM '/seeding/data/olist_sellers_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY orders FROM '/seeding/data/olist_orders_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY order_payments FROM '/seeding/data/olist_order_payments_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY order_reviews FROM '/seeding/data/olist_order_reviews_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY order_items FROM '/seeding/data/olist_order_items_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY qualified_leads FROM '/seeding/data/olist_marketing_qualified_leads_dataset.csv' DELIMITER AS ',' CSV HEADER;

-- Inconsistency between seller id in closed deals and seller
COPY temp_closed_deals FROM '/seeding/data/olist_closed_deals_dataset.csv' DELIMITER AS ',' CSV HEADER;
INSERT INTO closed_deals(
    mql_id, seller_id, sdr_id, sr_id, won_date, business_segment, lead_type, 
    lead_behaviour_profile, has_company, has_gtin, average_stock, business_type, 
    declared_product_catalog_size, declared_monthly_revenue)
SELECT c.* FROM temp_closed_deals c
INNER JOIN sellers s ON c.seller_id = s.seller_id;
DROP TABLE temp_closed_deals;