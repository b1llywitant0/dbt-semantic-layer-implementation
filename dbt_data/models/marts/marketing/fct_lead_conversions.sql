{{ 
    config(
        order_by='(first_contact_date, won_date, sdr_id, sr_id, mql_id)' 
        )
}}

WITH
closed_deals AS (
    SELECT *
    FROM {{ ref('stg_crm__closed_deals') }}
    WHERE deleted = 0
),

qualified_leads AS (
    SELECT *
    FROM {{ ref('stg_crm__qualified_leads') }}
    WHERE 
        valid_to = '{{var("future_proof_date")}}' AND 
        deleted = 0
)

SELECT 
    qualified_leads.mql_id AS mql_id,
    qualified_leads.landing_page_id,
    closed_deals.sdr_id,
    closed_deals.sr_id,
    qualified_leads.first_contact_date,
    closed_deals.created_at AS won_date
FROM qualified_leads
LEFT JOIN closed_deals ON qualified_leads.mql_id = closed_deals.mql_id
