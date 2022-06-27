with 
    /* filter delivered orders */
    orders as (
        select * from {{ ref('olist_orders') }}
    )

    ,order_items as (
        select * from {{ ref('olist_order_items') }}
    )

    /* translated product category into English */		
    ,products as (
        select * from {{ ref('olist_products') }}
    )

    /* join orders with order line items & product category name */   
    ,combined as (
        select 
            orders.order_purchase_date
            ,orders.order_id
            ,orders.customer_id
            ,orders.order_status 
            ,order_items.order_item_id
            ,order_items.revenue 
            ,products.product_category
        from orders
        left join order_items on orders.order_id=order_items.order_id
        left join products on order_items.product_id=products.product_id

    )

    /*  product_category_revenue = aggregated(sum) revenue by order purchase date and product category. */
    ,revenue_by_product_category as (
        select
            order_purchase_date
            ,product_category
            ,sum(revenue) as product_category_revenue
        from combined
        group by 1,2
    )

    /* product_category_revenue_perc = product_category_revenue/total daily revenue.
       rank_number = product_category rank number based on revenue per product_category. */
    ,product_category_total_revenue_perc as (
        select
            order_purchase_date
            ,product_category
            ,product_category_revenue
            ,cast(
                (
                  product_category_revenue/sum(product_category_revenue) over ( partition by order_purchase_date)
                )* 100 
              as numeric) 
            as product_category_revenue_perc
            ,row_number() over(partition by order_purchase_date order by product_category_revenue desc) as rank_number
        from revenue_by_product_category
        where product_category_revenue is not null
	)

    /*  top_3_product_categories_by_revenue = top 3 product categories by revenuez.
        top_3_product_categories_revenue_percentage = revenue percentage of the top 3 product categories by revenue. */
    ,top_product_categories_by_revenue as (
        select
            order_purchase_date
            ,string_agg(	  	
                product_category 
                order by 
                    product_category_revenue desc
            ) as top_3_product_categories_by_revenue

            ,string_agg(
                cast(
                  round(product_category_revenue_perc,2) 
                as string)
                order by 
                    product_category_revenue desc
            ) as top_3_product_categories_revenue_percentage

        from product_category_total_revenue_perc
        where rank_number<=3
        group by 1
    )

    /*  orders_count = distinct count of daily orders.
        customers_making_orders_count = distinct count of daily customers with orders.
        revenue_usd = total daily revenue.
        average_revenue_per_order_usd = total daily revenue/distinct count of daily orders.
        average_revenue_per_order_usd can also be defined as average order value (AOV) */
    ,daily_orders_aggregated as (
        select 
            order_purchase_date
            ,count(distinct order_id) as orders_count
            ,count(distinct customer_id) as customers_making_orders_count
            ,round(                
                sum(revenue)              
            ,2) as revenue_usd
            ,round(
                sum(revenue)/count(distinct order_id)
            ,2) as average_revenue_per_order_usd
            from combined
        group by 1
    )

    /*  combine all metrics on order_purchase_date grain, in descending order. */
    ,all_metrics_combined as (
        select 
            d.order_purchase_date
            ,d.orders_count
            ,d.customers_making_orders_count
            ,d.revenue_usd
            ,d.average_revenue_per_order_usd
            ,t.top_3_product_categories_by_revenue
            ,t.top_3_product_categories_revenue_percentage
        from daily_orders_aggregated as d
        left join top_product_categories_by_revenue as t on d.order_purchase_date=t.order_purchase_date
        order by order_purchase_date desc
    )

    select * 
    from all_metrics_combined

