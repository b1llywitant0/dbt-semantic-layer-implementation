WITH
payment_types AS (
    SELECT *
    FROM {{ source('olist','order_payment_methods') }}
),

order_payments AS (
    SELECT *
    FROM {{ ref('snp_olist__order_payments') }}
)

SELECT
    order_payments.order_payment_sk,
    order_payments.order_id,
    payment_types.payment_method_name AS payment_method,
    order_payments.payment_sequential,
    order_payments.payment_installments,
    order_payments.payment_value,
    order_payments.deleted,
    order_payments.dbt_valid_from AS valid_from,
    COALESCE(order_payments.dbt_valid_to, CAST('{{ var("future_proof_date") }}' AS DateTime64(6,'Asia/Jakarta'))) AS valid_to
FROM order_payments
LEFT JOIN payment_types 
ON order_payments.payment_type_id = payment_types.payment_method_id
