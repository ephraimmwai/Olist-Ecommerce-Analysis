SELECT
  order_id,
  order_item_id,
  price,
  product_id,
  freight_value,
  seller_id,
  shipping_limit_date
FROM
  {{ source('olist_store','olist_order_items')}}