with users as (

    select * from {{ ref('stg_sql_server_dbo__users') }}

),
    
validate_phone as (

    select
        user_id
        first_name,
        last_name,
        phone_number,
        coalesce(regexp_like(phone_number, '^\\d{3}-\\d{3}-\\d{4}$') = true, false) as is_valid_phone_number
    from users

)

select * from validate_phone