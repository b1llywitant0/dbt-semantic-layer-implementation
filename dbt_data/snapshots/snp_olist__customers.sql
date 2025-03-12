{% snapshot snp_olist__customers %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT * FROM {{ ref('base_olist__customers') }}

{% endsnapshot %}