{% snapshot snp_olist__orders %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT * FROM {{ ref('base_olist__orders') }}

{% endsnapshot %}