WITH
current_products AS (
    SELECT *
    FROM {{ source('olist','mv_products') }}
    FINAL
)

SELECT * FROM current_products