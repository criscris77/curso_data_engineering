with 

source as (

    select * from {{ ref('stg_google_sheets__budget') }}

),

renamed as (

    select
        *
    from source
)

select * from renamed