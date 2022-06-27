select
  customer_id
  ,customer_city
  ,customer_state
from {{ source('olist_store','olist_customers')}}