{% snapshot snp_olist__order_payments %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_payment_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT 
    order_id || '-' || payment_type_id || '-' || payment_sequential AS order_payment_id,
    * 
FROM {{ ref('base_olist__order_payments') }}

{% endsnapshot %}