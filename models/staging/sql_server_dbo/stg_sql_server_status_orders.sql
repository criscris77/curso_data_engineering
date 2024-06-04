with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select distinct
        case 
            when status='' then 'unknown'
            else status 
        end as status_name,
        case 
            when status='' then md5('unknown')
            else md5(status) 
        end as id_status

    from source
    where _fivetran_deleted is null

)

select * from renamed