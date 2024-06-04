with 

source as (

    select * from {{ ref('stg_sql_server_dbo__addresses') }}

),

renamed as (

    select
        *
    from source
)

select * from renamed