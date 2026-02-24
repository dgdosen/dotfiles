select * from fractions limit 100;
select * from calls limit 100;

select distinct lengths_behind from calls 
order by lengths_behind;

select * from calls where start_id = 669653;

select 
  id, 
  track_id, 
  race_date, 
  race_number, 
  race_type, 
  breed, 
  distance, 
  distance_furlongs, 
  surface, 
  track_condition, 
  purse_cents, 
  available_money_cents, 
  weather, off_time, 
  start_description, 
  final_time 
from equibase_races
order by race_date desc;

select * from equibase_starts;
