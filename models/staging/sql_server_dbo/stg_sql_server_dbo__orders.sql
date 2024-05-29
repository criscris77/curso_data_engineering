with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        case
            when shipping_service='' then 'unknown'
            else shipping_service
        end as name_shipping_service,
        case
            when shipping_service='' then md5('unknown')
            else md5(shipping_service)
        end as shipping_service_id,
        shipping_cost,
        address_id,
        created_at,
        case 
            when promo_id ='' then md5('no promo')
            else md5(promo_id)
        end as promo_id,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_synced

    from source
    where _fivetran_deleted is null

)

,
added_row AS (
    SELECT 
        md5('empty') ,
        'unknown',
        null,
        0,
        null,
        CURRENT_TIMESTAMP AS created_at,
        null,
        null,
        0,
        null,
        0,
        null,
        null,
        null,
        CURRENT_TIMESTAMP AS _fivetran_synced
)

SELECT * FROM renamed
UNION ALL
SELECT * FROM added_row
