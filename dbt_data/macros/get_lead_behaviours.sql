{% macro get_lead_behaviours() %}
    {{ return(
        dbt_utils.get_column_values(
        table=ref('stg_crm__lead_behaviours'),
        column='behaviour'
        )) 
    }}
{% endmacro %}
