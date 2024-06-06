{% set event_types = obtener_valores(ref('stg_sql_server_dbo__events'),'event_type') %}
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
        b.email,
        min(a.created_at) as first_event,
        max(a.created_at) as last_event,
        DATEDIFF(minute,first_event,last_event) as sesion_time_minutes,
        {%- for event_type in event_types   %}
        sum(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    FROM stg_events a 
    inner join ALUMNO14_DEV_SILVER_DB.DBT.STG_SQL_SERVER_DBO__USERS b
    on a.user_id = b.user_id
    GROUP BY 1,2,3,4,5
    )

SELECT * FROM renamed_casted