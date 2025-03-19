{{ 
    config(
        order_by='(payment_method, order_creation_date, customer_id, order_id)' 
        )
}}

WITH
valid_orders AS (
    SELECT *
    FROM {{ ref("int_ecomm__valid_orders_based_on_order_items") }}
),

order_payments AS (
    SELECT
        order_id,
        payment_method,
        payment_installments,
        payment_sequential,
        payment_value,
        created_at
    FROM {{ ref('stg_olist__order_payments') }}
)

SELECT
    order_payments.order_id,
    valid_orders.customer_id,
    MIN(order_payments.created_at) AS order_creation_date,
    order_payments.payment_method,
    MAX(order_payments.payment_installments) AS payment_installments,
    COUNT(order_payments.payment_sequential) AS paid_installments,
    SUM(order_payments.payment_value) AS total_payment_value
FROM order_payments
INNER JOIN valid_orders ON valid_orders.order_id = order_payments.order_id
GROUP BY 
    order_payments.order_id, 
    valid_orders.customer_id,
    order_payments.payment_method