with
  /* translate product category into English */	
  products as (
    select 
      p.product_id
      ,p.product_category_name
      ,t.product_category_name_english as product_category
    from {{ source('olist_store','olist_products')}} as p 
    left join {{ ref('olist_product_category_name_translation') }} as t on p.product_category_name=t.product_category_name
  )
select * 
from products
