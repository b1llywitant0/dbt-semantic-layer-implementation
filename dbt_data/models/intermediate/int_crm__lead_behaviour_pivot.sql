{{ 
    config(
        order_by='(mql_id)' 
        )
}}

{% set lead_behaviours = get_lead_behaviours() %}

WITH
bridge_lead_behaviour AS (
    SELECT
        mql_id,
        behaviour
    FROM {{ ref('stg_crm__lead_behaviours') }}
)

SELECT
    mql_id,
    {% for behaviour in lead_behaviours %}
        MAX(CASE WHEN behaviour = '{{ behaviour }}' then 1 else 0 end) as is_{{ behaviour | replace(' ', '_') }}{% if not loop.last %},{% endif %}
    {% endfor %}
from bridge_lead_behaviour
group by mql_id
