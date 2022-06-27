select
  order_id
  ,order_item_id
  ,price as revenue
  ,product_id
  ,freight_value
  ,seller_id
  ,shipping_limit_date
from {{ source('olist_store','olist_order_items')}}