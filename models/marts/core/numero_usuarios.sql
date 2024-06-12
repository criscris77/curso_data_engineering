{{ 
    config(
        materialized='view'
    ) 
}}

with 

source as (

    select * from {{ ref('fct_orders') }} 

),


renamed as (

    select *
    from source
)
--¿Cuántos usuarios tenemos?
SELECT 
    distinct count(user_id) as num_usuarios
FROM renamed 
