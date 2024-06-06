{{ 
    config(
        materialized='view'
    ) 
}}

with 

source as (

    select * from {{ ref('intermediate_fct_orders') }} 

),


renamed as (

    select *
    from source
)
SELECT 
   *
FROM renamed 

