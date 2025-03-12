WITH
geolocations AS (
    SELECT *
    FROM {{ ref('base_olist__geolocations') }}
),

sellers AS (
    SELECT *
    FROM {{ ref('snp_olist__sellers') }}
)

SELECT
    sellers.seller_id AS seller_id,
    geolocations.geolocation_city AS city,
    geolocations.geolocation_state AS state,
    sellers.deleted,
    sellers.dbt_valid_from AS valid_from,
    COALESCE(sellers.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM sellers
LEFT JOIN geolocations 
ON sellers.seller_zip_code_prefix = geolocations.geolocation_zip_code_prefix
