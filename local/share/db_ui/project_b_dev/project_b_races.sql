select * from project_b_races limit 10;

select count(restrictions_code), restrictions_code from project_b_races group by restrictions_code order by count desc;

select count(*) from project_b_races;

select * from project_b_races where race_id in (
  select id from races where date = '2024-09-29'
)

