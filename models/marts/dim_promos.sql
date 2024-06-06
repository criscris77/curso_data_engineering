with 

source as (

    select * from {{ ref('stg_sql_server_dbo__promos') }}

),

renamed as (

    select
        *
    from source A
    inner join {{ ref('dim_statusPromo') }} b
    on a.status_promo=b.id_status
)

select * from renamed