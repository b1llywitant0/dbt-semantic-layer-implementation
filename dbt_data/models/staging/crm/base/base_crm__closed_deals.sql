SELECT
    mql_id,
    seller_id,
    sdr_id,
    sr_id,
    business_segment_id,
    lead_type_id,
    has_company,
    has_gtin,
    average_stock,
    business_type_id,
    declared_product_catalog_size,
    declared_monthly_revenue,
    created_at,
    updated_at,
    deleted
FROM {{ source('crm','mv_closed_deals') }}
FINAL