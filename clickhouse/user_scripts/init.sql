CREATE TABLE cdc_products
(
    `before.product_id` Nullable(String),
    `before.product_category_name` Nullable(String),
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
    `after.product_category_name` Nullable(String),
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
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_geolocations (
    `before.geolocation_zip_code_prefix` Nullable(UInt64),
    `before.geolocation_lat` Nullable(Decimal256(S)),
    `before.geolocation_lng` Nullable(Decimal256(S)),
    `before.geolocation_city` Nullable(String),
    `before.geolocation_state` Nullable(String),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.geolocation_zip_code_prefix` Nullable(UInt64),
    `after.geolocation_lat` Nullable(Decimal256(S)),
    `after.geolocation_lng` Nullable(Decimal256(S)),
    `after.geolocation_city` Nullable(String),
    `after.geolocation_state` Nullable(String),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_customers (
    `before.customer_id` Nullable(String),
    `before.customer_unique_id` Nullable(String),
    `before.customer_zip_code_prefix` Nullable(UInt64),
    `before.customer_city` Nullable(String),
    `before.customer_state` Nullable(String),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.customer_id` Nullable(String),
    `after.customer_unique_id` Nullable(String),
    `after.customer_zip_code_prefix` Nullable(UInt64),
    `after.customer_city` Nullable(String),
    `after.customer_state` Nullable(String),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_sellers (
    `before.seller_id` Nullable(String),
    `before.seller_zip_code_prefix` Nullable(UInt64),
    `before.seller_city` Nullable(String),
    `before.seller_state` Nullable(String),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.seller_id` Nullable(String),
    `after.seller_zip_code_prefix` Nullable(UInt64),
    `after.seller_city` Nullable(String),
    `after.seller_state` Nullable(String),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_orders (
    `before.order_id` Nullable(String),
    `before.customer_id` Nullable(String),
    `before.order_status` Nullable(String),
    `before.order_purchase_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.order_approved_at` Nullable(DataTime64(0,'Asia/Jakarta')),
    `before.order_delivered_carrier_date` Nullable(DataTime64(0,'Asia/Jakarta')),
    `before.order_delivered_customer_date` Nullable(DataTime64(0,'Asia/Jakarta')),
    `before.order_estimated_delivery_date` Nullable(DataTime64(0,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.customer_id` Nullable(String),
    `after.order_status` Nullable(String),
    `after.order_purchase_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.order_approved_at` Nullable(DataTime64(0,'Asia/Jakarta')),
    `after.order_delivered_carrier_date` Nullable(DataTime64(0,'Asia/Jakarta')),
    `after.order_delivered_customer_date` Nullable(DataTime64(0,'Asia/Jakarta')),
    `after.order_estimated_delivery_date` Nullable(DataTime64(0,'Asia/Jakarta')),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_order_payments (
    `before.order_id` Nullable(String),
    `before.payment_sequential` Nullable(UInt8),
    `before.payment_type` Nullable(String),
    `before.payment_installments` Nullable(Decimal256(S)),
    `before.payment_value` Nullable(Decimal256(S)),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.payment_sequential` Nullable(UInt8),
    `after.payment_type` Nullable(String),
    `after.payment_installments` Nullable(Decimal256(S)),
    `after.payment_value` Nullable(Decimal256(S)),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_order_items (
    `before.order_id` Nullable(String),
    `before.order_item_id` Nullable(UInt32),
    `before.product_id` Nullable(String),
    `before.seller_id` Nullable(String),
    `before.shipping_limit_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.price` Nullable(Decimal256(S)),
    `before.freight_value` Nullable(Decimal256(S)),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.order_id` Nullable(String),
    `after.order_item_id` Nullable(UInt32),
    `after.product_id` Nullable(String),
    `after.seller_id` Nullable(String),
    `after.shipping_limit_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.price` Nullable(Decimal256(S)),
    `after.freight_value` Nullable(Decimal256(S)),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_order_reviews (
    `before.review_id` Nullable(String),
    `before.order_id` Nullable(UInt32),
    `before.review_score` Nullable(UInt8),
    `before.review_comment_title` Nullable(String),
    `before.review_comment_message` Nullable(String),
    `before.review_creation_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.review_answer_timestamp` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.review_id` Nullable(String),
    `after.order_id` Nullable(UInt32),
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
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_qualified_leads (
    `before.mql_id` Nullable(String),
    `before.first_contact_date` Nullable(Date),
    `before.landing_page_id` Nullable(String),
    `before.origin` Nullable(String),
    `before.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `after.mql_id` Nullable(String),
    `after.first_contact_date` Nullable(Date),
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
ENGINE = MergeTree
ORDER BY tuple()

CREATE TABLE cdc_closed_deals (
    `before.mql_id` Nullable(String),
    `before.seller_id` Nullable(String),
    `before.sdr_id` Nullable(String),
    `before.sr_id` Nullable(String),
    `before.won_date` Nullable(DateTime64(0,'Asia/Jakarta')),
    `before.business_segment` Nullable(String),
    `before.lead_type` Nullable(String),
    `before.lead_behaviour_profile` Nullable(String),
    `before.has_company` Nullable(Bool),
    `before.has_gtin` Nullable(Bool),
    `before.average_stock` Nullable(String),
    `before.business_type` Nullable(String),
    `before.declared_product_catalog_size` Nullable(Decimal32(S)),
    `before.declared_monthly_revenue` Nullable(Decimal32(S)),
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
    `after.lead_behaviour_profile` Nullable(String),
    `after.has_company` Nullable(Bool),
    `after.has_gtin` Nullable(Bool),
    `after.average_stock` Nullable(String),
    `after.business_type` Nullable(String),
    `after.declared_product_catalog_size` Nullable(Decimal32(S)),
    `after.declared_monthly_revenue` Nullable(Decimal32(S)),
    `after.created_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.updated_at` Nullable(DateTime64(0,'Asia/Jakarta')),
    `after.deleted_at` Nullable(DateTime64(0,'Asia/Jakarta')),

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64       
)
ENGINE = MergeTree
ORDER BY tuple()
