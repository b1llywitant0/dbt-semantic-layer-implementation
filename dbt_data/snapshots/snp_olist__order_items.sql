{% snapshot snp_olist__order_items %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_item_sk',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT 
    order_id || '-' || order_item_id AS order_item_sk,
    * 
FROM {{ ref('base_olist__order_items') }}

{% endsnapshot %}