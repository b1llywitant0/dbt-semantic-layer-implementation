CREATE DATABASE IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.product_categories (
    `product_category_id` UInt32,
    `product_category_name_spanish` String,
    `product_category_name_english` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY product_category_id;

CREATE TABLE IF NOT EXISTS raw.cdc_products (
    `before.product_id` Nullable(String),
    `before.product_category_id` Nullable(UInt32),
    `before.product_name_lenght` Nullable(UInt32),
    `before.product_description_lenght` Nullable(UInt32),
    `before.product_photo_qty` Nullable(UInt8),
    `before.product_weight_g` Nullable(UInt32),
    `before.product_length_cm` Nullable(UInt32),
    `before.product_height_cm` Nullable(UInt32),
    `before.product_width_cm` Nullable(UInt32),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.product_id` Nullable(String),
    `after.product_category_id` Nullable(UInt32),
    `after.product_name_lenght` Nullable(UInt32),
    `after.product_description_lenght` Nullable(UInt32),
    `after.product_photo_qty` Nullable(UInt8),
    `after.product_weight_g` Nullable(UInt32),
    `after.product_length_cm` Nullable(UInt32),
    `after.product_height_cm` Nullable(UInt32),
    `after.product_width_cm` Nullable(UInt32),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_products (
    `product_id` String,
    `product_category_id` Nullable(UInt32),
    `product_name_length` Nullable(UInt32),
    `product_description_length` Nullable(UInt32),
    `product_photo_qty` Nullable(UInt8),
    `product_weight_g` Nullable(UInt32),
    `product_length_cm` Nullable(UInt32),
    `product_height_cm` Nullable(UInt32),
    `product_width_cm` Nullable(UInt32),
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
PRIMARY KEY (created_at, product_id)
ORDER BY (created_at, product_id)
AS
SELECT 
    if(op = 'd', `before.product_id`, `after.product_id`) AS product_id,
    if(op = 'd', `before.product_category_id`, `after.product_category_id`) AS product_category_id,
    if(op = 'd', `before.product_name_lenght`, `after.product_name_lenght`) AS product_name_length,
    if(op = 'd', `before.product_description_lenght`, `after.product_description_lenght`) AS product_description_length,
    if(op = 'd', `before.product_photo_qty`, `after.product_photo_qty`) AS product_photo_qty,
    if(op = 'd', `before.product_weight_g`, `after.product_weight_g`) AS product_weight_g,
    if(op = 'd', `before.product_length_cm`, `after.product_length_cm`) AS product_length_cm,
    if(op = 'd', `before.product_height_cm`, `after.product_height_cm`) AS product_height_cm,
    if(op = 'd', `before.product_width_cm`, `after.product_width_cm`) AS product_width_cm,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    if(op = 'd', source.lsn, source.lsn) AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_products
WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS raw.geolocations (
    `geolocation_zip_code_prefix` UInt64,
    `geolocation_lat` Float64,
    `geolocation_lng` Float64,
    `geolocation_city` String,
    `geolocation_state` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = ReplacingMergeTree(updated_at)
PRIMARY KEY (geolocation_zip_code_prefix, geolocation_state, geolocation_city,  geolocation_lat, geolocation_lng)
ORDER BY (geolocation_zip_code_prefix, geolocation_state, geolocation_city,  geolocation_lat, geolocation_lng);

CREATE TABLE IF NOT EXISTS raw.cdc_customers (
    `before.customer_id` Nullable(String),
    `before.customer_unique_id` Nullable(String),
    `before.customer_zip_code_prefix` Nullable(UInt64),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.customer_id` Nullable(String),
    `after.customer_unique_id` Nullable(String),
    `after.customer_zip_code_prefix` Nullable(UInt64),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_customers (
    `customer_id` String,
    `customer_unique_id` Nullable(String),
    `customer_zip_code_prefix` Nullable(UInt64),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (customer_zip_code_prefix, created_at, customer_unique_id, customer_id)
AS
SELECT 
    if(op = 'd', `before.customer_id`, `after.customer_id`) AS customer_id,
    if(op = 'd', `before.customer_unique_id`, `after.customer_unique_id`) AS customer_unique_id,
    if(op = 'd', `before.customer_zip_code_prefix`, `after.customer_zip_code_prefix`) AS customer_zip_code_prefix,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    source.lsn AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_customers
WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS raw.cdc_sellers (
    `before.seller_id` Nullable(String),
    `before.seller_zip_code_prefix` Nullable(UInt64),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.seller_id` Nullable(String),
    `after.seller_zip_code_prefix` Nullable(UInt64),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_sellers (
    `seller_id` String,
    `seller_zip_code_prefix` Nullable(UInt64),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (seller_zip_code_prefix, created_at, seller_id)
AS
SELECT 
    if(op = 'd', `before.seller_id`, `after.seller_id`) AS seller_id,
    if(op = 'd', `before.seller_zip_code_prefix`, `after.seller_zip_code_prefix`) AS seller_zip_code_prefix,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    source.lsn AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_sellers
WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS raw.order_status (
    `order_status_id` UInt16,
    `order_status_name` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY order_status_id;

CREATE TABLE IF NOT EXISTS raw.cdc_orders (
    `before.order_id` Nullable(String),
    `before.customer_id` Nullable(String),
    `before.order_status_id` Nullable(UInt16),
    `before.order_purchase_timestamp` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.order_approved_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.order_delivered_carrier_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.order_delivered_customer_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.order_estimated_delivery_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.customer_id` Nullable(String),
    `after.order_status_id` Nullable(UInt16),
    `after.order_purchase_timestamp` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.order_approved_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.order_delivered_carrier_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.order_delivered_customer_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.order_estimated_delivery_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_orders (
    `order_id` String,
    `customer_id` Nullable(String),
    `order_status_id` Nullable(UInt16),
    `order_purchase_timestamp` Nullable(DateTime64(6,'Asia/Jakarta')),
    `order_approved_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `order_delivered_carrier_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `order_delivered_customer_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `order_estimated_delivery_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (order_status_id, order_purchase_timestamp, customer_id, order_id)
AS
SELECT 
    if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
    if(op = 'd', `before.customer_id`, `after.customer_id`) AS customer_id,
    if(op = 'd', `before.order_status_id`, `after.order_status_id`) AS order_status_id,
    if(op = 'd', `before.order_purchase_timestamp`, `after.order_purchase_timestamp`) AS order_purchase_timestamp,
    if(op = 'd', `before.order_approved_at`, `after.order_approved_at`) AS order_approved_at,
    if(op = 'd', `before.order_delivered_carrier_date`, `after.order_delivered_carrier_date`) AS order_delivered_carrier_date,
    if(op = 'd', `before.order_delivered_customer_date`, `after.order_delivered_customer_date`) AS order_delivered_customer_date,
    if(op = 'd', `before.order_estimated_delivery_date`, `after.order_estimated_delivery_date`) AS order_estimated_delivery_date,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    source.lsn AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_orders
WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS raw.order_payment_methods (
    `payment_method_id` UInt16,
    `payment_method_name` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY payment_method_id;

CREATE TABLE IF NOT EXISTS raw.cdc_order_payments (
    `before.order_id` Nullable(String),
    `before.payment_sequential` Nullable(UInt8),
    `before.payment_type_id` Nullable(UInt16),
    `before.payment_installments` Nullable(Float64),
    `before.payment_value` Nullable(Float64),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.payment_sequential` Nullable(UInt8),
    `after.payment_type_id` Nullable(UInt16),
    `after.payment_installments` Nullable(Float64),
    `after.payment_value` Nullable(Float64),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_order_payments (
    `order_id` String,
    `payment_sequential` Nullable(UInt8),
    `payment_type_id` Nullable(UInt16),
    `payment_installments` Nullable(Float64),
    `payment_value` Nullable(Float64),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (payment_type_id, payment_sequential, payment_installments, payment_value, created_at, order_id)
AS
SELECT 
    if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
    if(op = 'd', `before.payment_sequential`, `after.payment_sequential`) AS payment_sequential,
    if(op = 'd', `before.payment_type_id`, `after.payment_type_id`) AS payment_type_id,
    if(op = 'd', `before.payment_installments`, `after.payment_installments`) AS payment_installments,
    if(op = 'd', `before.payment_value`, `after.payment_value`) AS payment_value,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    source.lsn AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_order_payments
WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS raw.cdc_order_items (
    `before.order_id` Nullable(String),
    `before.order_item_id` Nullable(UInt32),
    `before.product_id` Nullable(String),
    `before.seller_id` Nullable(String),
    `before.shipping_limit_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.price` Nullable(Float64),
    `before.freight_value` Nullable(Float64),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.order_item_id` Nullable(UInt32),
    `after.product_id` Nullable(String),
    `after.seller_id` Nullable(String),
    `after.shipping_limit_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.price` Nullable(Float64),
    `after.freight_value` Nullable(Float64),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_order_items (
    `order_id` String,
    `order_item_id` UInt32,
    `product_id` Nullable(String),
    `seller_id` Nullable(String),
    `shipping_limit_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `price` Nullable(Float64),
    `freight_value` Nullable(Float64),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (order_item_id, seller_id, created_at, price, freight_value, product_id, order_id)
AS
SELECT 
    if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
    if(op = 'd', `before.order_item_id`, `after.order_item_id`) AS order_item_id,
    if(op = 'd', `before.product_id`, `after.product_id`) AS product_id,
    if(op = 'd', `before.seller_id`, `after.seller_id`) AS seller_id,
    if(op = 'd', `before.shipping_limit_date`, `after.shipping_limit_date`) AS shipping_limit_date,
    if(op = 'd', `before.price`, `after.price`) AS price,
    if(op = 'd', `before.freight_value`, `after.freight_value`) AS freight_value,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    source.lsn AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_order_items
WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS raw.cdc_order_reviews (
    `before.review_id` Nullable(String),
    `before.order_id` Nullable(String),
    `before.review_score` Nullable(UInt8),
    `before.review_comment_title` Nullable(String),
    `before.review_comment_message` Nullable(String),
    `before.review_creation_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.review_answer_timestamp` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.review_id` Nullable(String),
    `after.order_id` Nullable(String),
    `after.review_score` Nullable(UInt8),
    `after.review_comment_title` Nullable(String),
    `after.review_comment_message` Nullable(String),
    `after.review_creation_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.review_answer_timestamp` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_order_reviews (
    `review_id` String,
    `order_id` Nullable(String),
    `review_score` Nullable(UInt8),
    `review_comment_title` Nullable(String),
    `review_comment_message` Nullable(String),
    `review_creation_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `review_answer_timestamp` Nullable(DateTime64(6,'Asia/Jakarta')),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (order_id, review_id)
AS
SELECT 
    if(op = 'd', `before.review_id`, `after.review_id`) AS review_id,
    if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
    if(op = 'd', `before.review_score`, `after.review_score`) AS review_score,
    if(op = 'd', `before.review_comment_title`, `after.review_comment_title`) AS review_comment_title,
    if(op = 'd', `before.review_comment_message`, `after.review_comment_message`) AS review_comment_message,
    if(op = 'd', `before.review_creation_date`, `after.review_creation_date`) AS review_creation_date,
    if(op = 'd', `before.review_answer_timestamp`, `after.review_answer_timestamp`) AS review_answer_timestamp,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    if(op = 'd', source.lsn, source.lsn) AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_order_reviews
WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS raw.qualified_lead_origins (
    `origin_id` UInt16,
    `origin_name` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY origin_id;

CREATE TABLE IF NOT EXISTS raw.cdc_qualified_leads (
    `before.mql_id` Nullable(String),
    `before.first_contact_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.landing_page_id` Nullable(String),
    `before.origin_id` Nullable(UInt16),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.mql_id` Nullable(String),
    `after.first_contact_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.landing_page_id` Nullable(String),
    `after.origin_id` Nullable(UInt16),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_qualified_leads (
    `mql_id` String,
    `first_contact_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `landing_page_id` Nullable(String),
    `origin_id` Nullable(UInt16),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (origin_id, first_contact_date, landing_page_id, mql_id)
AS
SELECT 
    if(op = 'd', `before.mql_id`, `after.mql_id`) AS mql_id,
    if(op = 'd', `before.first_contact_date`, `after.first_contact_date`) AS first_contact_date,
    if(op = 'd', `before.landing_page_id`, `after.landing_page_id`) AS landing_page_id,
    if(op = 'd', `before.origin_id`, `after.origin_id`) AS origin_id,
    if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
    if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
    if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
    if(op = 'd', source.lsn, source.lsn) AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_qualified_leads
WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS raw.lead_business_segments (
    `business_segment_id` UInt16,
    `business_segment_name` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY business_segment_id;

CREATE TABLE IF NOT EXISTS raw.lead_types (
    `lead_type_id` UInt16,
    `lead_type_name` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY lead_type_id;

CREATE TABLE IF NOT EXISTS raw.lead_business_types (
    `business_type_id` UInt16,
    `business_type_name` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY business_type_id;

CREATE TABLE IF NOT EXISTS raw.cdc_lead_behaviour_profile (
    `lead_behaviour_id` UInt16,
    `lead_behaviour_name` String,
    `created_at` DateTime64(6,'Asia/Jakarta'),
    `updated_at` DateTime64(6,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY lead_behaviour_id;

CREATE TABLE IF NOT EXISTS raw.cdc_closed_deals (
    `before.mql_id` Nullable(String),
    `before.seller_id` Nullable(String),
    `before.sdr_id` Nullable(String),
    `before.sr_id` Nullable(String),
    `before.won_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.business_segment_id` Nullable(UInt16),
    `before.lead_type_id` Nullable(UInt16),
    `before.has_company` Nullable(Bool),
    `before.has_gtin` Nullable(Bool),
    `before.average_stock` Nullable(String),
    `before.business_type_id` Nullable(UInt16),
    `before.declared_product_catalog_size` Nullable(UInt64),
    `before.declared_monthly_revenue` Nullable(UInt64),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.mql_id` Nullable(String),
    `after.seller_id` Nullable(String),
    `after.sdr_id` Nullable(String),
    `after.sr_id` Nullable(String),
    `after.won_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.business_segment_id` Nullable(UInt16),
    `after.lead_type_id` Nullable(UInt16),
    `after.has_company` Nullable(Bool),
    `after.has_gtin` Nullable(Bool),
    `after.average_stock` Nullable(String),
    `after.business_type_id` Nullable(UInt16),
    `after.declared_product_catalog_size` Nullable(UInt64),
    `after.declared_monthly_revenue` Nullable(UInt64),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE MATERIALIZED VIEW raw.mv_closed_deals (
    `mql_id` String,
    `seller_id` Nullable(String),
    `sdr_id` Nullable(String),
    `sr_id` Nullable(String),
    `won_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `business_segment_id` Nullable(UInt16),
    `lead_type_id` Nullable(UInt16),
    `has_company` Nullable(Bool),
    `has_gtin` Nullable(Bool),
    `average_stock` Nullable(String),
    `business_type_id` Nullable(UInt16),
    `declared_product_catalog_size` Nullable(Float64),
    `declared_monthly_revenue` Nullable(Float64),
    `created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `version` UInt64,
    `deleted` UInt8
) ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY (lead_type_id, business_type_id, business_segment_id, won_date, sr_id, mql_id)
AS
SELECT 
    if(op = 'd', 'before.mql_id', 'after.mql_id') AS mql_id,
    if(op = 'd', 'before.seller_id', 'after.seller_id') AS seller_id,
    if(op = 'd', 'before.sdr_id', 'after.sdr_id') AS sdr_id,
    if(op = 'd', 'before.sr_id', 'after.sr_id') AS sr_id,
    if(op = 'd', 'before.won_date', 'after.won_date') AS won_date,
    if(op = 'd', 'before.business_segment_id', 'after.business_segment_id') AS business_segment_id,
    if(op = 'd', 'before.lead_type_id', 'after.lead_type_id') AS lead_type_id,
    if(op = 'd', before.has_company, after.has_company) AS has_company,
    if(op = 'd', before.has_gtin, after.has_gtin) AS has_gtin,
    if(op = 'd', 'before.average_stock', 'after.average_stock') AS average_stock,
    if(op = 'd', 'before.business_type_id', 'after.business_type_id') AS business_type_id,
    if(op = 'd', 'before.declared_product_catalog_size', 'after.declared_product_catalog_size') AS declared_product_catalog_size,
    if(op = 'd', 'before.declared_monthly_revenue', 'after.declared_monthly_revenue') AS declared_monthly_revenue,
    if(op = 'd', 'before.created_at', 'after.created_at') AS created_at,
    if(op = 'd', 'before.updated_at', 'after.updated_at') AS updated_at,
    if(op = 'd', 'before.deleted_at', 'after.deleted_at') AS deleted_at,
    if(op = 'd', source.lsn, source.lsn) AS version,
    if(op = 'd', 1, 0) AS deleted
FROM raw.cdc_closed_deals
WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS raw.cdc_bridge_lead_behaviour_profiles (
    `before.mql_id` Nullable(String),
    `before.lead_behaviour_id` Nullable(UInt32),
    `before.won_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `after.mql_id` Nullable(String),
    `after.lead_behaviour_id` Nullable(UInt32),
    `after.won_date` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.created_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(6,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(6,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE DATABASE IF NOT EXISTS mart_ecommerce;
CREATE DATABASE IF NOT EXISTS mart_marketing;