select
  order_id
  ,order_purchase_timestamp
  ,date(order_purchase_timestamp) as order_purchase_date
  ,order_approved_at
  ,order_delivered_carrier_date
  ,order_delivered_customer_date
  ,order_estimated_delivery_date
  ,order_status
  ,customer_id
from {{ source('olist_store','olist_orders')}}
where order_status='delivered'