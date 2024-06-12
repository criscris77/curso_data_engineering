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
case
    when discount_dollars is null then 0
    else discount_dollars
end as descuento,
COUNT(*) OVER (PARTITION BY a.order_id) as num_productos_x_pedido,
ROUND(shipping_cost / COUNT(*) OVER (PARTITION BY a.order_id),2) as shipping_cost_x_product,
ROUND((quantity*price),2) as suma_linea,
ROUND((quantity*price+shipping_cost_x_product),2) as linea_producto,
--total del pedido menos el descuento mas el shipping cost
ROUND(SUM(suma_linea) OVER (PARTITION BY a.order_id) -descuento + MAX(shipping_cost) OVER (PARTITION BY a.order_id),2) as order_total,
FROM renamed a
left join {{ ref('dim_promos') }} b --left porque hay orders sin promocion
on a.promo_id=b.id_promocion
inner join {{ ref('dim_products') }} c 
on a.product_id=c.product_id
order by 1