with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select distinct
        case 
            when shipping_service='' then 'unknown'
            else shipping_service 
        end as shipping_service_name,
        case 
            when shipping_service='' then md5('unknown')
            else md5(shipping_service) 
        end as id_shipping_service

    from source

)

select * from renamed