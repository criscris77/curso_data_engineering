with 

source as (

select * from {{ source('sql_server_dbo', 'promos') }}
),

renamed as (

select
    md5(promo_id) as id_promocion,
    promo_id as promo_name,
    discount as discount_dollars,
    case 
    when status='inactive' then '0'
    when status='active' then '1'
    end as status_promo,
    _fivetran_deleted,
    _fivetran_synced
from source
)
,
added_row AS (
    SELECT 
        md5('') AS id_promocion,
        'no promotion' AS promo_name,
        0 AS discount,
        '0' AS status,
        null AS _fivetran_deleted,
        CURRENT_TIMESTAMP AS _fivetran_synced
)

SELECT * FROM renamed
UNION ALL
SELECT * FROM added_row


