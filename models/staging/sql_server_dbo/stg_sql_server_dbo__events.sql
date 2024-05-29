with 

source as (

    select * from {{ source('sql_server_dbo', 'events') }}

),

renamed as (

    select
        event_id,
        page_url,
        event_type,
        user_id,
        case
        when product_id ='' then md5('empty')
        else product_id
        end as product_id,
        session_id,
        created_at,
        case
        when order_id ='' then md5('empty')
        else order_id
        end as order_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
