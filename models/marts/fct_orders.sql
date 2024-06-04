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
SELECT * FROM renamed