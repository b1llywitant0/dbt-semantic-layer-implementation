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