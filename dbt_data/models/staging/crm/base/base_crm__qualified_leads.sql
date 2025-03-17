WITH
closed_deals AS (
    SELECT *
    FROM {{ ref('base_crm__closed_deals') }}
),

qualified_leads AS (
    SELECT 
        mql_id,
        landing_page_id,
        origin_id,
        created_at,
        updated_at,
        deleted
    FROM {{ source('crm','mv_qualified_leads') }}
    FINAL
)

SELECT
    qualified_leads.mql_id,
    qualified_leads.landing_page_id,
    qualified_leads.origin_id,
    CASE
        WHEN closed_deals.mql_id = '' THEN 'Closed'
        ELSE 'On progress'
    END AS status,
    qualified_leads.created_at,
    qualified_leads.updated_at,
    qualified_leads.deleted
FROM qualified_leads
LEFT JOIN closed_deals ON qualified_leads.mql_id = closed_deals.mql_id
    