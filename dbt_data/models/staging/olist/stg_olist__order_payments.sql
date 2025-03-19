WITH
order_payments AS (
    SELECT *
    FROM {{ ref("base_olist__order_payments") }}
),

order_payment_methods AS (
    SELECT *
    FROM {{ source('olist','order_payment_methods') }}
)

SELECT    
    order_payments.order_id,
    order_payments.payment_sequential,
    order_payment_methods.payment_method_name AS payment_method,
    order_payments.payment_installments,
    order_payments.payment_value,
    order_payments.created_at,
    order_payments.updated_at,
    order_payments.deleted
FROM order_payments
LEFT JOIN order_payment_methods ON order_payments.payment_type_id = order_payment_methods.payment_method_id