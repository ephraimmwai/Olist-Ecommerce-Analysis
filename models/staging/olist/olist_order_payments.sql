SELECT
  order_id,
  payment_installments,
  payment_sequential,
  payment_type,
  payment_value
FROM
  {{ source('olist_store','olist_order_payments')}}