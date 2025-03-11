{% snapshot products_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='product_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT * FROM {{ ref('base_olist__products') }}

{% endsnapshot %}