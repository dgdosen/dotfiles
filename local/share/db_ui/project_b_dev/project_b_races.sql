select * from project_b_races limit 10;

select count(restrictions_code), restrictions_code from project_b_races group by restrictions_code order by count desc;

select count(*) from project_b_races;
