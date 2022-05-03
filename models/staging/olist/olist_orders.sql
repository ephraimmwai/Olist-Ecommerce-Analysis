SELECT
  order_id,
  order_purchase_timestamp,
  order_approved_at,
  order_delivered_carrier_date,
  order_delivered_customer_date,
  order_estimated_delivery_date,
  order_status,
  customer_id
FROM
  {{ source('olist_store','olist_orders')}}