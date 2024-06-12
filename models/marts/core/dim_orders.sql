{{ 
    config(
        materialized='view'
    ) 
}}

with 

source as (

    select * from {{ ref('stg_sql_server_dbo__orders') }} 

),


renamed as (

    select *
    from source
)
SELECT 
   *
FROM renamed 