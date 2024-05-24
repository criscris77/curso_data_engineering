{{
  config(
    materialized='view'
  )
}}
with 

source as (

    select * from {{ ref('stg_sql_server_dbo__ADDRESSES') }}

),

renamed as (

    select
        address_id,
        zipcode AS CODIGO_POSTAL,
        country,
        address AS DIRECCION,
        state AS ESTADO,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
