WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__events') }}
    ),

renamed_casted AS (
    SELECT
	    a.session_id,
        a.user_id,
        b.last_name,
        b.first_name,
        b.email
        ,sum(case when event_type = 'checkout' then 1 end) as checkout_amount
        ,sum(case when event_type = 'package_shipped' then 1 end) as package_shipped_amount
        ,sum(case when event_type = 'add_to_cart' then 1 end) as add_to_cart_amount
        ,sum(case when event_type = 'page_view' then 1 end) as page_view_amount
        ,min(a.created_at) as first_event
        ,max(a.created_at) as last_event
        ,DATEDIFF(minute,first_event,last_event) as sesion_time_minutes
    FROM ALUMNO14DEV_SILVER_DB.DBT.STG_SQL_SERVER_DBO__events a
    inner join ALUMNO14DEV_SILVER_DB.DBT.STG_SQL_SERVER_DBO__USERS b
    on a.user_id = b.user_id
    group by a.user_id,a.session_id,b.last_name,b.first_name,b.email
    
    )

SELECT * FROM renamed_casted