with 

source as (

    select * from {{ ref('stg_sql_server_dbo__events') }}

),

renamed as (

    select distinct
        event_type,
        md5(event_type) as id_event_type
    from source
    where _fivetran_deleted is null

)

select * from renamed