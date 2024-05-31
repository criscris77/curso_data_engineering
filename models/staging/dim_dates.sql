{{ 
    config(
        materialized='view'
    ) 
}}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="'2020-01-01'",
        end_date="'2024-12-31'"
    ) }}
)

select
    date_day as date,
    extract(year from date_day) as year,
    extract(month from date_day) as month,
    extract(day from date_day) as day,
    extract(quarter from date_day) as quarter,
    case
        when extract(dow from date_day) in (1, 7) then true
        else false
    end as is_weekend,
    to_char(date_day, 'Day') as day_name,
    to_char(date_day, 'Month') as month_name,
    to_char(date_day, 'YYYY-MM') as year_month,
    to_char(date_day, 'IYYY-IW') as iso_year_week

from date_spine
