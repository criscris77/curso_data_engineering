with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select distinct
        status as status_description,
        case 
            when status='inactive' then '0'
            when status='active' then '1'
        end as id_status

    from source

)

select * from renamed
