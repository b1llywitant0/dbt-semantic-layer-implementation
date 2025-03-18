WITH
closed_deals AS (
    SELECT *
    FROM {{ ref('stg_crm__closed_deals') }}
),

qualified_leads AS (
    SELECT *
    FROM {{ ref('stg_crm__qualified_leads') }}
),

lead_behaviours AS (
    SELECT *
    FROM {{ ref('int_crm__lead_behaviour_pivot') }}
)

SELECT 
    qualified_leads.mql_id AS mql_id,
    qualified_leads.channel,
    qualified_leads.status,
    closed_deals.lead_type,
    closed_deals.business_segment,
    closed_deals.business_type,
    lead_behaviours.is_cat,
    lead_behaviours.is_eagle,
    lead_behaviours.is_wolf,
    lead_behaviours.is_shark,
    qualified_leads.deleted AS deleted,
    qualified_leads.valid_from,
    qualified_leads.valid_to
FROM qualified_leads
LEFT JOIN closed_deals ON qualified_leads.mql_id = closed_deals.mql_id
LEFT JOIN lead_behaviours ON qualified_leads.mql_id = lead_behaviours.mql_id
