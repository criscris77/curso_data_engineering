{{ 
    config(
        materialized='view'
    ) 
}}

with 

source as (

    select * from {{ ref('dim_orders') }} 

),


renamed as (

    SELECT 
        DATEDIFF(hour,created_at,delivered_at) as order_time
    FROM source 
)
--En promedio, ¿cuánto tiempo tarda un pedido desde que se realiza hasta que se entrega?
SELECT 
    CONCAT(ROUND(AVG(order_time),2),' Horas') as media_tiempo
FROM renamed 
