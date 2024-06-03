{{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
    }}


WITH stg_budget_products_update AS (
    SELECT * 
    FROM {{ source('google_sheets','budget') }}

{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}
    ),

renamed_casted AS (
    SELECT
          _row
        , month
        , quantity 
        , _fivetran_synced
    FROM stg_google_sheets__budget
    )

SELECT * FROM renamed_casted