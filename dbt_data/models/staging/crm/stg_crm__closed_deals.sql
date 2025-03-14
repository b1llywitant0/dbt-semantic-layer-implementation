WITH 
closed_deals AS (
    SELECT 
        *
    FROM {{ ref('base_crm__closed_deals') }}
),

business_segments AS (
    SELECT
        business_segment_id,
        business_segment_name
    FROM {{ source('crm','lead_business_segments') }}
),


lead_types AS (
    SELECT
        lead_type_id,
        lead_type_name
    FROM {{ source('crm','lead_types') }}
),

business_types AS (
    SELECT
        business_type_id,
        business_type_name
    FROM {{ source('crm','lead_business_types') }}
)

SELECT
    closed_deals.mql_id,
    closed_deals.seller_id,
    closed_deals.sdr_id,
    closed_deals.sr_id,
    lead_types.lead_type_name AS lead_type,
    business_segments.business_segment_name AS business_segment,
    business_types.business_type_name AS business_type,
    closed_deals.has_company,
    closed_deals.has_gtin,
    closed_deals.average_stock,
    closed_deals.declared_product_catalog_size,
    closed_deals.declared_monthly_revenue,
    closed_deals.created_at,
    closed_deals.updated_at,
    closed_deals.deleted
FROM closed_deals
LEFT JOIN business_segments USING business_segment_id
LEFT JOIN lead_types USING lead_type_id
LEFT JOIN business_types USING business_type_id

