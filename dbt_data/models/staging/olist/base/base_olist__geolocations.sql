WITH
source AS (
    SELECT *
    FROM {{ source('olist','geolocations') }}
),

active_geolocations AS (
    SELECT 
        geolocation_zip_code_prefix,
        geolocation_city,
        geolocation_state,
        ROW_NUMBER() OVER (PARTITION BY geolocation_zip_code_prefix ORDER BY geolocation_city, geolocation_state) AS row_num
    FROM source
    WHERE 
        deleted_at IS NULL
)

SELECT * 
FROM active_geolocations
WHERE 
    row_num = 1