WITH
geolocations AS (
    SELECT *
    FROM {{ ref('base_olist__geolocations') }}
),

customers AS (
    SELECT *
    FROM {{ ref('snp_olist__customers') }}
)

SELECT
    customers.customer_id AS account_id,
    customers.customer_unique_id AS user_id,
    geolocations.geolocation_city AS city,
    geolocations.geolocation_state AS state,
    customers.deleted,
    customers.dbt_valid_from AS valid_from,
    COALESCE(customers.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM customers
LEFT JOIN geolocations 
ON customers.customer_zip_code_prefix = geolocations.geolocation_zip_code_prefix
