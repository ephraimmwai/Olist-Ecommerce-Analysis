SELECT
  product_id,
  product_category_name,
  product_width_cm,
  product_length_cm,
  product_name_lenght,
  product_photos_qty,
  product_weight_g,
  product_height_cm,
  product_description_lenght
FROM
  {{ source('olist_store','olist_products')}}