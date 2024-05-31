with 

source_users as (

select * from {{ source('sql_server_dbo', 'users') }}
),

ref_orders as (
    select user_id, count(*) as total_orders from {{ref('stg_sql_server_dbo__orders')}} group by user_id
),

renamed_users as (

select
    A.user_id,
    updated_at,
    address_id,
    last_name,
    created_at,
    phone_number,
    case
    when B.total_orders is null then 0
    else B.total_orders
    end as TOTAL_ORDERS,
    first_name,
    email,
    _fivetran_deleted,
    _fivetran_synced

from source_users A
left join ref_orders B
on A.user_id=B.user_id
)

select * from renamed_users
