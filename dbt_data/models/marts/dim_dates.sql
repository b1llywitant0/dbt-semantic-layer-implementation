{{
    config(
        materialized = 'table',
    )
}}

WITH
base_dates AS (
    {{
        dbt_utils.date_spine(
            'day',
            "DATE('2000-01-01')",
            "DATE('2030-01-01')"
        )
    }}
),

final AS (
    SELECT
        CAST(date_day AS DATE) AS date_day,
        toStartOfWeek(CAST(date_day AS DATE)) AS date_week,
        toStartOfMonth(CAST(date_day AS DATE)) AS date_month,
        toStartOfYear(CAST(date_day AS DATE)) AS date_year
    FROM base_dates
)

SELECT *
FROM final
WHERE date_day > dateadd(YEAR, -20, current_date())
  AND date_day < dateadd(DAY, 30, current_date())