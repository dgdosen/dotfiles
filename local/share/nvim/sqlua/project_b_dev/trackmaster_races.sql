select * from trackmaster_races
order by track_code, date, race_number;

limit 201;

select * from trackmaster_fractions order by id;
select * from fractions where race_id = 157449;
select * from races where id = 157449;

select * from trackmaster_starts;
select * from trackmaster_jockeys;
select * from trackmaster_horses;
select * from trackmaster_trainers;
select * from trackmaster_calls order by id;

-- tm_races versus trackmaster races
select count(*) from tm_races;
select count(*) from trackmaster_races;


-- tm_races
select * from tm_races order by updated_at desc
limit 40;

select distinct fraction_code from fractions;

select * from trakus_fractions limit 20;
select distinct fraction_code from drf_fractions;

select * from calls limit 5;
select distinct call_code from calls;

select * from races where track_code = 'CD' and date = '2021-05-01' order by race_number;
select * from races where track_code = 'SA' and date = '2021-03-21' order by race_number;

select starts.id, starts.race_id, starts.official_finish_position, calls.position from starts, calls
where calls.start_id = starts.id
and calls.call_code = 'finish_call'
and official_finish_position > 0
and calls.position <> official_finish_position
order by start_id desc
limit 20;

-- completeness
select
trackmaster_races.id,
trackmaster_races.date,
trackmaster_races.race_number,
trackmaster_races.track_code,
trackmaster_starts.id,
trackmaster_starts.axcis_key,
trackmaster_horses.name
from trackmaster_races, trackmaster_starts, trackmaster_horses
where trackmaster_races.id = trackmaster_starts.trackmaster_race_id
and trackmaster_horses.id = trackmaster_starts.trackmaster_horse_id
and trackmaster_races.track_code = 'SA'
order by date desc, race_number
limit 200;


select * from trackmaster_races 
where date = '2025-06-15'
and track_code = 'SA';

select * from trackmaster_starts 
where id > 
order by trackmaster_race_id desc;

select * from trackmaster_starts where trackmaster_race_id in
(
  select id from trackmaster_races where date = '2025-06-15'
  and track_code = 'SA'
);

select * from trackmaster_starts where trackmaster_race_id > 702 and trackmaster_race_id < 715;


select count(*) from trackmaster_races;

select count(*) from trackmaster_starts;

select * from trackmaster_fractions
where trackmaster_race_id in 
(
  select id from trackmaster_races where date = '2025-06-15'
  and track_code = 'SA'
);

select count(*) from trackmaster_starts;
