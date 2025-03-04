COPY product_categories (
    product_category_id,
    product_category_name_spanish,
    product_category_name_english
)
FROM '/seeding/data/normalized/df_product_categories.csv' DELIMITER AS ',' CSV HEADER;

COPY products (
    product_id,
    -- product_category_name,
    product_category_id,
    product_name_lenght,
    product_description_lenght,
    product_photo_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
-- FROM '/seeding/data/olist_products_dataset.csv' DELIMITER AS ',' CSV HEADER;
FROM '/seeding/data/normalized/df_products.csv' DELIMITER AS ',' CSV HEADER;

COPY geolocations (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
)
FROM '/seeding/data/olist_geolocation_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix
    -- customer_city,
    -- customer_state
) 
-- FROM '/seeding/data/olist_customers_dataset.csv' DELIMITER AS ',' CSV HEADER;
FROM '/seeding/data/normalized/df_customers.csv' DELIMITER AS ',' CSV HEADER;

COPY sellers (
    seller_id,
    seller_zip_code_prefix
    -- seller_city,
    -- seller_state
)
-- FROM '/seeding/data/olist_sellers_dataset.csv' DELIMITER AS ',' CSV HEADER;
FROM '/seeding/data/normalized/df_sellers.csv' DELIMITER AS ',' CSV HEADER;

COPY order_status (
    order_status_id,
    order_status_name
)
FROM '/seeding/data/normalized/df_order_status.csv' DELIMITER AS ',' CSV HEADER;

COPY orders (
    order_id,
    customer_id,
    -- order_status,
    order_status_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
) 
-- FROM '/seeding/data/olist_orders_dataset.csv' DELIMITER AS ',' CSV HEADER;
FROM '/seeding/data/normalized/df_orders.csv' DELIMITER AS ',' CSV HEADER;

COPY order_payment_methods (
    payment_method_id,
    payment_method_name
)
FROM '/seeding/data/normalized/df_payment_methods.csv' DELIMITER AS ',' CSV HEADER;

COPY order_payments (
    order_id,
    payment_sequential,
    -- payment_type,
    payment_type_id,
    payment_installments,
    payment_value
) 
-- FROM '/seeding/data/olist_order_payments_dataset.csv' DELIMITER AS ',' CSV HEADER;
FROM '/seeding/data/normalized/df_order_payments.csv' DELIMITER AS ',' CSV HEADER;

COPY order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
) 
FROM '/seeding/data/olist_order_items_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
) 
FROM '/seeding/data/olist_order_reviews_dataset.csv' DELIMITER AS ',' CSV HEADER;

COPY qualified_lead_origins (
    origin_id,
    origin_name
)
FROM '/seeding/data/normalized/df_qualified_lead_origins.csv' DELIMITER AS ',' CSV HEADER;

COPY qualified_leads (
    mql_id,
    first_contact_date,
    landing_page_id,
    -- origin
    origin_id
)
-- FROM '/seeding/data/olist_marketing_qualified_leads_dataset.csv' DELIMITER AS ',' CSV HEADER;
FROM '/seeding/data/normalized/df_qualified_leads.csv' DELIMITER AS ',' CSV HEADER;

COPY lead_business_segments (
    business_segment_id,
    business_segment_name
)
FROM '/seeding/data/normalized/df_business_segments.csv' DELIMITER AS ',' CSV HEADER;

COPY lead_types (
    lead_type_id,
    lead_type_name
)
FROM '/seeding/data/normalized/df_lead_types.csv' DELIMITER AS ',' CSV HEADER;

COPY lead_business_types (
    business_type_id,
    business_type_name
)
FROM '/seeding/data/normalized/df_business_types.csv' DELIMITER AS ',' CSV HEADER;

COPY lead_behaviour_profiles (
    lead_behaviour_id,
    lead_behaviour_name
)
FROM '/seeding/data/normalized/df_lead_behaviour_profiles.csv' DELIMITER AS ',' CSV HEADER;

COPY bridge_lead_behaviour_profiles (
    mql_id,
    lead_behaviour_id,
    won_date
)
FROM '/seeding/data/normalized/df_lead_behaviour_bridge.csv' DELIMITER AS ',' CSV HEADER;

-- Inconsistency between seller id in closed deals and seller
COPY temp_closed_deals (
    mql_id, 
    seller_id, 
    sdr_id, 
    sr_id, 
    won_date, 
    -- business_segment, 
    -- lead_type, 
    business_segment_id,
    lead_type_id,
    -- lead_behaviour_profile, 
    has_company, 
    has_gtin, 
    average_stock,
    -- business_type, 
    business_type_id,
    declared_product_catalog_size, 
    declared_monthly_revenue
)
-- FROM '/seeding/data/olist_closed_deals_dataset.csv' DELIMITER AS ',' CSV HEADER;
FROM '/seeding/data/normalized/df_closed_deals.csv' DELIMITER AS ',' CSV HEADER;

INSERT INTO closed_deals (
    mql_id, seller_id, sdr_id, sr_id, won_date, 
    -- business_segment, 
    -- lead_type, 
    business_segment_id,
    lead_type_id,
    -- lead_behaviour_profile, 
    has_company, has_gtin, average_stock,
    -- business_type, 
    business_type_id,
    declared_product_catalog_size, declared_monthly_revenue,
    created_at, updated_at, deleted_at
)
SELECT c.* FROM temp_closed_deals c
INNER JOIN sellers s ON c.seller_id = s.seller_id;
DROP TABLE temp_closed_deals;

UPDATE sellers -- Executed last because it needed data from closed_deals
SET 
  created_at = closed_deals.created_at,
  updated_at = closed_deals.updated_at
FROM closed_deals
WHERE sellers.seller_id = closed_deals.seller_id;
