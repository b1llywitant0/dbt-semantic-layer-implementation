{% snapshot snp_olist__sellers %}

{{
    config(
        target_schema='snapshots',
        unique_key='seller_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT * FROM {{ ref('base_olist__sellers') }}

{% endsnapshot %}