{{ 
    config(
        materialized='view'
    ) 
}}

with 

sourceA as (

    select * from {{ ref('stg_sql_server_dbo__orders') }} 

),
sourceB as (

    select * from {{ ref('stg_sql_server_dbo__order_items') }} 

),


renamed as (

    select user_id,A.order_id,B.product_id,address_id,created_at,promo_id,shipping_cost,order_cost,order_total,status,tracking_id,quantity
    from sourceA A 
    INNER JOIN sourceB B ON A.order_id = B.order_id

)
SELECT 
a.user_id,
a.order_id,
c.product_id,
quantity ,
price,
quantity*price as total_idproducto,
b.status_description,
case 
    when status_description = 'inactive' then 0
    else discount_dollars
end as discount_dollars_active,
discount_dollars as descuento_original,
ROUND(shipping_cost / COUNT(*) OVER (PARTITION BY a.order_id),2) as shipping_cost_dividido,
shipping_cost_antiguo,
order_cost as order_cost_antiguo,
SUM(quantity * price) OVER (PARTITION BY a.order_id) - 
    case 
        when b.status_description = 'inactive' then 0
        else discount_dollars
    end as order_cost,
ROUND(order_total / COUNT(*) OVER (PARTITION BY a.order_id),2) as order_total_divido,
SUM(order_total) OVER (PARTITION BY a.order_id) / COUNT(*) OVER (PARTITION BY a.order_id) as suma,


FROM renamed a
inner join {{ ref('dim_promos') }} b
on a.promo_id=b.id_promocion
inner join {{ ref('dim_products') }} c
on a.product_id=c.product_id

