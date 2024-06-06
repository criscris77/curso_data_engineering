with 

source as (

    select * from {{ ref('stg_sql_server_dbo__products') }}

),

renamed as (

    select
        *
    from source
)

select * from renamed