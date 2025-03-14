WITH
lead_behaviour_profiles AS (
    SELECT *
    FROM {{ source('crm','lead_behaviour_profiles') }}
),

bridge_lead_behaviour_profiles AS (
    SELECT *
    FROM {{ source('crm','bridge_lead_behaviour_profiles') }}
)

SELECT
    bridge_lead_behaviour_profiles.mql_id,
    lead_behaviour_profiles.lead_behaviour_name AS behaviour,
    bridge_lead_behaviour_profiles.created_at,
    bridge_lead_behaviour_profiles.updated_at,
    bridge_lead_behaviour_profiles.deleted_at
FROM bridge_lead_behaviour_profiles
LEFT JOIN lead_behaviour_profiles USING lead_behaviour_id