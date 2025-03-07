CREATE TABLE IF NOT EXISTS ecommerce_dw.product_categories (
    `product_category_id` UInt32,
    `product_category_name_spanish` String,
    `product_category_name_english` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY product_category_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_products (
    `before.product_id` Nullable(String),
    `before.product_category_id` Nullable(UInt32),
    `before.product_name_lenght` Nullable(UInt32),
    `before.product_description_lenght` Nullable(UInt32),
    `before.product_photo_qty` Nullable(UInt8),
    `before.product_weight_g` Nullable(UInt32),
    `before.product_length_cm` Nullable(UInt32),
    `before.product_height_cm` Nullable(UInt32),
    `before.product_width_cm` Nullable(UInt32),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.product_id` Nullable(String),
    `after.product_category_id` Nullable(UInt32),
    `after.product_name_lenght` Nullable(UInt32),
    `after.product_description_lenght` Nullable(UInt32),
    `after.product_photo_qty` Nullable(UInt8),
    `after.product_weight_g` Nullable(UInt32),
    `after.product_length_cm` Nullable(UInt32),
    `after.product_height_cm` Nullable(UInt32),
    `after.product_width_cm` Nullable(UInt32),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_products (
--     `product_id` String,
--     `product_category_name` Nullable(String),
--     `product_name_lenght` Nullable(UInt32),
--     `product_description_lenght` Nullable(UInt32),
--     `product_photo_qty` Nullable(UInt8),
--     `product_weight_g` Nullable(UInt32),
--     `product_length_cm` Nullable(UInt32),
--     `product_height_cm` Nullable(UInt32),
--     `product_width_cm` Nullable(UInt32),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY product_id
-- AS
-- SELECT 
--     if(op = 'd', `before.product_id`, `after.product_id`) AS product_id,
--     if(op = 'd', `before.product_category_name`, `after.product_category_name`) AS product_category_name,
--     if(op = 'd', `before.product_name_lenght`, `after.product_name_lenght`) AS product_name_lenght,
--     if(op = 'd', `before.product_description_lenght`, `after.product_description_lenght`) AS product_description_lenght,
--     if(op = 'd', `before.product_photo_qty`, `after.product_photo_qty`) AS product_photo_qty,
--     if(op = 'd', `before.product_weight_g`, `after.product_weight_g`) AS product_weight_g,
--     if(op = 'd', `before.product_length_cm`, `after.product_length_cm`) AS product_length_cm,
--     if(op = 'd', `before.product_height_cm`, `after.product_height_cm`) AS product_height_cm,
--     if(op = 'd', `before.product_width_cm`, `after.product_width_cm`) AS product_width_cm,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     if(op = 'd', source.lsn, source.lsn) AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_products
-- WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.geolocations (
    `geolocation_zip_code_prefix` UInt64,
    `geolocation_lat` Float64,
    `geolocation_lng` Float64,
    `geolocation_city` String,
    `geolocation_state` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY geolocation_zip_code_prefix;

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_geolocations (
--     `geolocation_zip_code_prefix` UInt64,
--     `geolocation_lat` Nullable(Float64),
--     `geolocation_lng` Nullable(Float64),
--     `geolocation_city` Nullable(String),
--     `geolocation_state` Nullable(String),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY geolocation_zip_code_prefix
-- AS
-- SELECT 
--     if(op = 'd', `before.geolocation_zip_code_prefix`, `after.geolocation_zip_code_prefix`) AS geolocation_zip_code_prefix,
--     if(op = 'd', `before.geolocation_lat`, `after.geolocation_lat`) AS geolocation_lat,
--     if(op = 'd', `before.geolocation_lng`, `after.geolocation_lng`) AS geolocation_lng,
--     if(op = 'd', `before.geolocation_city`, `after.geolocation_city`) AS geolocation_city,
--     if(op = 'd', `before.geolocation_state`, `after.geolocation_state`) AS geolocation_state,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     source.lsn AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_geolocations
-- WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_customers (
    `before.customer_id` Nullable(String),
    `before.customer_unique_id` Nullable(String),
    `before.customer_zip_code_prefix` Nullable(UInt64),
    -- `before.customer_city` Nullable(String),
    -- `before.customer_state` Nullable(String),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.customer_id` Nullable(String),
    `after.customer_unique_id` Nullable(String),
    `after.customer_zip_code_prefix` Nullable(UInt64),
    -- `after.customer_city` Nullable(String),
    -- `after.customer_state` Nullable(String),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_customers (
--     `customer_id` String,
--     `customer_unique_id` Nullable(String),
--     `customer_zip_code_prefix` Nullable(UInt64),
--     `customer_city` Nullable(String),
--     `customer_state` Nullable(String),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY customer_id
-- AS
-- SELECT 
--     if(op = 'd', `before.customer_id`, `after.customer_id`) AS customer_id,
--     if(op = 'd', `before.customer_unique_id`, `after.customer_unique_id`) AS customer_unique_id,
--     if(op = 'd', `before.customer_zip_code_prefix`, `after.customer_zip_code_prefix`) AS customer_zip_code_prefix,
--     if(op = 'd', `before.customer_city`, `after.customer_city`) AS customer_city,
--     if(op = 'd', `before.customer_state`, `after.customer_state`) AS customer_state,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     source.lsn AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_customers
-- WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_sellers (
    `before.seller_id` Nullable(String),
    `before.seller_zip_code_prefix` Nullable(UInt64),
    -- `before.seller_city` Nullable(String),
    -- `before.seller_state` Nullable(String),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.seller_id` Nullable(String),
    `after.seller_zip_code_prefix` Nullable(UInt64),
    -- `after.seller_city` Nullable(String),
    -- `after.seller_state` Nullable(String),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_sellers (
--     `seller_id` String,
--     `seller_zip_code_prefix` Nullable(UInt64),
--     `seller_city` Nullable(String),
--     `seller_state` Nullable(String),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY seller_id
-- AS
-- SELECT 
--     if(op = 'd', `before.seller_id`, `after.seller_id`) AS seller_id,
--     if(op = 'd', `before.seller_zip_code_prefix`, `after.seller_zip_code_prefix`) AS seller_zip_code_prefix,
--     if(op = 'd', `before.seller_city`, `after.seller_city`) AS seller_city,
--     if(op = 'd', `before.seller_state`, `after.seller_state`) AS seller_state,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     source.lsn AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_sellers
-- WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.order_status (
    `order_status_id` UInt16,
    `order_status_name` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY order_status_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_orders (
    `before.order_id` Nullable(String),
    `before.customer_id` Nullable(String),
    `before.order_status_id` Nullable(UInt16),
    `before.order_purchase_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.order_approved_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.order_delivered_carrier_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.order_delivered_customer_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.order_estimated_delivery_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.customer_id` Nullable(String),
    `after.order_status_id` Nullable(UInt16),
    `after.order_purchase_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.order_approved_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.order_delivered_carrier_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.order_delivered_customer_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.order_estimated_delivery_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_orders (
--     `order_id` String,
--     `customer_id` Nullable(String),
--     `order_status` Nullable(String),
--     `order_purchase_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `order_approved_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `order_delivered_carrier_date` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `order_delivered_customer_date` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `order_estimated_delivery_date` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY order_id
-- AS
-- SELECT 
--     if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
--     if(op = 'd', `before.customer_id`, `after.customer_id`) AS customer_id,
--     if(op = 'd', `before.order_status`, `after.order_status`) AS order_status,
--     if(op = 'd', `before.order_purchase_timestamp`, `after.order_purchase_timestamp`) AS order_purchase_timestamp,
--     if(op = 'd', `before.order_approved_at`, `after.order_approved_at`) AS order_approved_at,
--     if(op = 'd', `before.order_delivered_carrier_date`, `after.order_delivered_carrier_date`) AS order_delivered_carrier_date,
--     if(op = 'd', `before.order_delivered_customer_date`, `after.order_delivered_customer_date`) AS order_delivered_customer_date,
--     if(op = 'd', `before.order_estimated_delivery_date`, `after.order_estimated_delivery_date`) AS order_estimated_delivery_date,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     source.lsn AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_orders
-- WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.order_payment_methods (
    `payment_method_id` UInt16,
    `payment_method_name` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY payment_method_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_order_payments (
    `before.order_id` Nullable(String),
    `before.payment_sequential` Nullable(UInt8),
    `before.payment_type_id` Nullable(UInt16),
    `before.payment_installments` Nullable(Float64),
    `before.payment_value` Nullable(Float64),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.payment_sequential` Nullable(UInt8),
    `after.payment_type` Nullable(String),
    `after.payment_installments` Nullable(Float64),
    `after.payment_value` Nullable(Float64),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_order_payments (
--     `order_id` String,
--     `payment_sequential` Nullable(UInt8),
--     `payment_type` Nullable(String),
--     `payment_installments` Nullable(Float64),
--     `payment_value` Nullable(Float64),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY order_id
-- AS
-- SELECT 
--     if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
--     if(op = 'd', `before.payment_sequential`, `after.payment_sequential`) AS payment_sequential,
--     if(op = 'd', `before.payment_type`, `after.payment_type`) AS payment_type,
--     if(op = 'd', `before.payment_installments`, `after.payment_installments`) AS payment_installments,
--     if(op = 'd', `before.payment_value`, `after.payment_value`) AS payment_value,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     source.lsn AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_order_payments
-- WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_order_items (
    `before.order_id` Nullable(String),
    `before.order_item_id` Nullable(UInt32),
    `before.product_id` Nullable(String),
    `before.seller_id` Nullable(String),
    `before.shipping_limit_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.price` Nullable(Float64),
    `before.freight_value` Nullable(Float64),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.order_item_id` Nullable(UInt32),
    `after.product_id` Nullable(String),
    `after.seller_id` Nullable(String),
    `after.shipping_limit_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.price` Nullable(Float64),
    `after.freight_value` Nullable(Float64),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_order_items (
--     `order_id` String,
--     `order_item_id` UInt32,
--     `product_id` Nullable(String),
--     `seller_id` Nullable(String),
--     `shipping_limit_date` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `price` Nullable(Float64),
--     `freight_value` Nullable(Float64),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY (order_id, order_item_id)
-- AS
-- SELECT 
--     if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
--     if(op = 'd', `before.order_item_id`, `after.order_item_id`) AS order_item_id,
--     if(op = 'd', `before.product_id`, `after.product_id`) AS product_id,
--     if(op = 'd', `before.seller_id`, `after.seller_id`) AS seller_id,
--     if(op = 'd', `before.shipping_limit_date`, `after.shipping_limit_date`) AS shipping_limit_date,
--     if(op = 'd', `before.price`, `after.price`) AS price,
--     if(op = 'd', `before.freight_value`, `after.freight_value`) AS freight_value,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     source.lsn AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_order_items
-- WHERE op IN ('c', 'r', 'u', 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_order_reviews (
    `before.review_id` Nullable(String),
    `before.order_id` Nullable(String),
    `before.review_score` Nullable(UInt8),
    `before.review_comment_title` Nullable(String),
    `before.review_comment_message` Nullable(String),
    `before.review_creation_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.review_answer_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.review_id` Nullable(String),
    `after.order_id` Nullable(String),
    `after.review_score` Nullable(UInt8),
    `after.review_comment_title` Nullable(String),
    `after.review_comment_message` Nullable(String),
    `after.review_creation_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.review_answer_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_order_reviews (
--     `review_id` String,
--     `order_id` Nullable(String),
--     `review_score` Nullable(UInt8),
--     `review_comment_title` Nullable(String),
--     `review_comment_message` Nullable(String),
--     `review_creation_date` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `review_answer_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY review_id
-- AS
-- SELECT 
--     if(op = 'd', `before.review_id`, `after.review_id`) AS review_id,
--     if(op = 'd', `before.order_id`, `after.order_id`) AS order_id,
--     if(op = 'd', `before.review_score`, `after.review_score`) AS review_score,
--     if(op = 'd', `before.review_comment_title`, `after.review_comment_title`) AS review_comment_title,
--     if(op = 'd', `before.review_comment_message`, `after.review_comment_message`) AS review_comment_message,
--     if(op = 'd', `before.review_creation_date`, `after.review_creation_date`) AS review_creation_date,
--     if(op = 'd', `before.review_answer_timestamp`, `after.review_answer_timestamp`) AS review_answer_timestamp,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     if(op = 'd', source.lsn, source.lsn) AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_order_reviews
-- WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.qualified_lead_origins (
    `origin_id` UInt16,
    `origin_name` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY origin_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_qualified_leads (
    `before.mql_id` Nullable(String),
    `before.first_contact_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.landing_page_id` Nullable(String),
    `before.origin_id` Nullable(UInt16),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.mql_id` Nullable(String),
    `after.first_contact_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.landing_page_id` Nullable(String),
    `after.origin` Nullable(String),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_qualified_leads (
--     `mql_id` String,
--     `first_contact_date` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `landing_page_id` Nullable(String),
--     `origin` Nullable(String),
--     `created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),
--     `version` UInt64,
--     `deleted` UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY mql_id
-- AS
-- SELECT 
--     if(op = 'd', `before.mql_id`, `after.mql_id`) AS mql_id,
--     if(op = 'd', `before.first_contact_date`, `after.first_contact_date`) AS first_contact_date,
--     if(op = 'd', `before.landing_page_id`, `after.landing_page_id`) AS landing_page_id,
--     if(op = 'd', `before.origin`, `after.origin`) AS origin,
--     if(op = 'd', `before.created_at`, `after.created_at`) AS created_at,
--     if(op = 'd', `before.updated_at`, `after.updated_at`) AS updated_at,
--     if(op = 'd', `before.deleted_at`, `after.deleted_at`) AS deleted_at,
--     if(op = 'd', source.lsn, source.lsn) AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_qualified_leads
-- WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.lead_business_segments (
    `business_segment_id` UInt16,
    `business_segment_name` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY business_segment_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.lead_types (
    `lead_type_id` UInt16,
    `lead_type_name` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY lead_type_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.lead_business_types (
    `business_type_id` UInt16,
    `business_type_name` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY business_type_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_lead_behaviour_profile (
    `lead_behaviour_id` UInt16,
    `lead_behaviour_name` String,
    `created_at` DateTime64(0,'Asia/Jakarta'),
    `updated_at` DateTime64(0,'Asia/Jakarta'),
    `deleted_at` Nullable(DateTime64(0,'Asia/Jakarta'))
)
ENGINE = MergeTree()
ORDER BY lead_behaviour_id;

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_closed_deals (
    `before.mql_id` Nullable(String),
    `before.seller_id` Nullable(String),
    `before.sdr_id` Nullable(String),
    `before.sr_id` Nullable(String),
    `before.won_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.business_segment_id` Nullable(UInt16),
    `before.lead_type_id` Nullable(UInt16),
    `before.has_company` Nullable(Bool),
    `before.has_gtin` Nullable(Bool),
    `before.average_stock` Nullable(String),
    `before.business_type_id` Nullable(UInt16),
    `before.declared_product_catalog_size` Nullable(UInt64),
    `before.declared_monthly_revenue` Nullable(UInt64),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.mql_id` Nullable(String),
    `after.seller_id` Nullable(String),
    `after.sdr_id` Nullable(String),
    `after.sr_id` Nullable(String),
    `after.won_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.business_segment` Nullable(String),
    `after.lead_type` Nullable(String),
    `after.has_company` Nullable(Bool),
    `after.has_gtin` Nullable(Bool),
    `after.average_stock` Nullable(String),
    `after.business_type_id` Nullable(UInt16),
    `after.declared_product_catalog_size` Nullable(UInt64),
    `after.declared_monthly_revenue` Nullable(UInt64),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

-- CREATE MATERIALIZED VIEW ecommerce_dw.mv_closed_deals (
--     mql_id String,
--     seller_id Nullable(String),
--     sdr_id Nullable(String),
--     sr_id Nullable(String),
--     won_date Nullable(DateTime64(0,'Asia/Jakarta')),
--     business_segment Nullable(String),
--     lead_type Nullable(String),
--     lead_behaviour_profile Nullable(String),
--     has_company Nullable(Bool),
--     has_gtin Nullable(Bool),
--     average_stock Nullable(String),
--     business_type Nullable(String),
--     declared_product_catalog_size Nullable(Float64),
--     declared_monthly_revenue Nullable(Float64),
--     created_at Nullable(DateTime64(0,'Asia/Jakarta')),
--     updated_at Nullable(DateTime64(0,'Asia/Jakarta')),
--     deleted_at Nullable(DateTime64(0,'Asia/Jakarta')),
--     version UInt64,
--     deleted UInt8
-- ) ENGINE = ReplacingMergeTree(version, deleted)
-- ORDER BY mql_id
-- AS
-- SELECT 
--     if(op = 'd', before.mql_id, after.mql_id) AS mql_id,
--     if(op = 'd', before.seller_id, after.seller_id) AS seller_id,
--     if(op = 'd', before.sdr_id, after.sdr_id) AS sdr_id,
--     if(op = 'd', before.sr_id, after.sr_id) AS sr_id,
--     if(op = 'd', before.won_date, after.won_date) AS won_date,
--     if(op = 'd', before.business_segment, after.business_segment) AS business_segment,
--     if(op = 'd', before.lead_type, after.lead_type) AS lead_type,
--     if(op = 'd', before.lead_behaviour_profile, after.lead_behaviour_profile) AS lead_behaviour_profile,
--     if(op = 'd', before.has_company, after.has_company) AS has_company,
--     if(op = 'd', before.has_gtin, after.has_gtin) AS has_gtin,
--     if(op = 'd', before.average_stock, after.average_stock) AS average_stock,
--     if(op = 'd', before.business_type, after.business_type) AS business_type,
--     if(op = 'd', before.declared_product_catalog_size, after.declared_product_catalog_size) AS declared_product_catalog_size,
--     if(op = 'd', before.declared_monthly_revenue, after.declared_monthly_revenue) AS declared_monthly_revenue,
--     if(op = 'd', before.created_at, after.created_at) AS created_at,
--     if(op = 'd', before.updated_at, after.updated_at) AS updated_at,
--     if(op = 'd', before.deleted_at, after.deleted_at) AS deleted_at,
--     if(op = 'd', source.lsn, source.lsn) AS version,
--     if(op = 'd', 1, 0) AS deleted
-- FROM ecommerce_dw.cdc_closed_deals
-- WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');

CREATE TABLE IF NOT EXISTS ecommerce_dw.cdc_bridge_lead_behaviour_profiles (
    `before.mql_id` Nullable(String),
    `before.lead_behaviour_id` Nullable(UInt32),
    `before.won_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.mql_id` Nullable(String),
    `after.lead_behaviour_id` Nullable(UInt32),
    `after.won_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE DATABASE IF NOT EXISTS core_mart;
CREATE DATABASE IF NOT EXISTS ecommerce_mart;
CREATE DATABASE IF NOT EXISTS marketing_mart;