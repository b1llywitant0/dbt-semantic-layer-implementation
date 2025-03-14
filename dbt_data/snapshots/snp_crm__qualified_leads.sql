{% snapshot snp_crm__qualified_leads %}

{{
    config(
        target_schema='snapshots',
        unique_key='mql_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT * FROM {{ ref('base_crm__qualified_leads') }}

{% endsnapshot %}