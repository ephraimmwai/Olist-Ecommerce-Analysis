select
  product_category_name
  ,product_category_name_english
from {{ source('olist_store','product_category_name_translation')}}