{% snapshot snp_olist__order_reviews %}

{{
    config(
        target_schema='snapshots',
        unique_key='review_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

SELECT * FROM {{ ref('base_olist__order_reviews') }}

{% endsnapshot %}