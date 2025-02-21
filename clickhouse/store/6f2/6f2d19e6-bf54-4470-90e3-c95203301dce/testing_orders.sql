ATTACH TABLE _ UUID '2265cf5c-cb0a-4c25-9636-ec877751a55a'
(
    `order_id` String,
    `customer_id` String,
    `order_status` String,
    `order_purchase_timestamp` DateTime64(6),
    `order_approved_at` Nullable(DateTime64(6)),
    `order_delivered_carrier_date` Nullable(DateTime64(6)),
    `order_delivered_customer_date` Nullable(DateTime64(6)),
    `order_estimated_delivery_date` Nullable(DateTime64(6)),
    `created_at` Nullable(DateTime64(6)),
    `updated_at` Nullable(DateTime64(6)),
    `deleted_at` Nullable(DateTime64(6))
)
ENGINE = PostgreSQL('finpro-postgres:5432', 'ecommerce_db', 'orders', 'postgres', 'root')
