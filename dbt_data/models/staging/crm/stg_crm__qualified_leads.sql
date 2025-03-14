WITH
origins AS (
    SELECT *
    FROM {{ source('crm','qualified_lead_origins') }}
),

qualified_leads AS (
    SELECT *
    FROM {{ ref('snp_crm__qualified_leads') }}
)

SELECT
    qualified_leads.mql_id,
    qualified_leads.landing_page_id,
    origins.origin_name AS channel,
    qualified_leads.deleted,
    qualified_leads.dbt_valid_from AS valid_from,
    COALESCE(qualified_leads.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM qualified_leads
LEFT JOIN origins 
ON qualified_leads.origin_id = origins.origin_id
