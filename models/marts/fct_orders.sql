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
a.order_id,
c.product_id,
quantity ,
price,
b.status_description as promocion,
case 
    when status_description = 'inactive' then 0
    else discount_dollars
end as descuento_activo,
discount_dollars as descuento_original,
ROUND(shipping_cost / COUNT(*) OVER (PARTITION BY a.order_id),2) as shipping_cost_dividido,
shipping_cost as shipping_cost_antiguo,
quantity*price as suma_linea,
quantity*price+shipping_cost_dividido as linea_producto,
--total del pedido menos el descuento si está activo mas el shipping cost
ROUND(SUM(suma_linea) OVER (PARTITION BY a.order_id) - 
    case 
        when b.status_description = 'inactive' then 0
        else discount_dollars
    end +MAX(shipping_cost) OVER (PARTITION BY a.order_id),2) --He usado el maximo para sumar solo una vez 
    as order_cost_pedido,
order_cost as order_cost_antiguo,
ROUND(order_cost_pedido / COUNT(*) OVER (PARTITION BY a.order_id),2) as order_total_divido,


FROM renamed a
inner join {{ ref('dim_promos') }} b
on a.promo_id=b.id_promocion
inner join {{ ref('dim_products') }} c
on a.product_id=c.product_id

