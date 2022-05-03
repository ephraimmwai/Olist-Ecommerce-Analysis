SELECT
  customer_id,
  customer_city,
  customer_state
FROM
  {{ source('olist_store','olist_customers')}}