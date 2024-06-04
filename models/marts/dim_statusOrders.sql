with 

source as (

    select * from {{ ref('stg_sql_server_status_orders') }}

),

renamed as (

    select
        *
    from source
)

select * from renamed