{{
    config(
        materialized = 'table',
    )
}}

WITH
base_dates AS (
    {{
        dbt.date_spine(
            'day',
            "DATE('2000-01-01')",
            "DATE('2030-01-01')"
        )
    }}
),

final AS (
    SELECT
        CAST(date_day AS DATE) AS date_day
    FROM base_dates
)

SELECT *
FROM final
WHERE date_day > dateadd(YEAR, -20, current_date())
  AND date_day < dateadd(DAY, 30, current_date());