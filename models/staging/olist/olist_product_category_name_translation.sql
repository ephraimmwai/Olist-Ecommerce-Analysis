SELECT
  product_category_name,
  product_category_name_english
FROM
  {{ source('olist_store','product_category_name_translation')}}