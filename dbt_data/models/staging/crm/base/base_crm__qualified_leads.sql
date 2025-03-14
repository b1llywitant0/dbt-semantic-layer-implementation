SELECT 
    mql_id,
    landing_page_id,
    origin_id,
    created_at,
    updated_at,
    deleted
FROM {{ source('crm','mv_qualified_leads') }}
FINAL