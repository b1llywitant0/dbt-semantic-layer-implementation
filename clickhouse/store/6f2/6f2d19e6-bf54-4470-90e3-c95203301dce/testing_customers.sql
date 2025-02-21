ATTACH TABLE _ UUID 'b35abcde-e879-47dc-94b7-ebd626d9f002'
(
    `customer_id` String,
    `customer_unique_id` String,
    `customer_zip_code_prefix` Int32,
    `customer_city` String,
    `customer_state` String,
    `created_at` DateTime64(6),
    `updated_at` DateTime64(6),
    `deleted_at` Nullable(DateTime64(6))
)
ENGINE = PostgreSQL('finpro-postgres:5432', 'ecommerce_db', 'customers', 'postgres', 'root')
