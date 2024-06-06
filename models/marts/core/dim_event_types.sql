with 

source as (

    select * from {{ ref('stg_sql_server_dbo__event_type') }}

),

renamed as (

    select
        *
    from source
)

select * from renamed