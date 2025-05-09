-- negative fractions
select count(distinct(race_id)) from gmax_fractions where distance_feet < 0;
select count(*) from gmax_races;

select count(distinct(starts.race_id)) from gmax_calls, starts
where gmax_calls.start_id = starts.id
and distance_feet < 0

select * from gmax_calls where distance_feet < 0;

-- gmax calls for race
select gmax_calls.id, start_id, position, seconds, horses.name, distance_feet, interval_type, interval_type, gmax_calls.updated_at from gmax_calls, starts, horses, races
where starts.id = gmax_calls.start_id
and starts.race_id = races.id
and horses.id = starts.horse_id
and start_id in (
  select id from starts where race_id in (
    select id from races where date = '2024-08-31' and race_number = 10 and track_code = 'DMR'
  )
) order by interval_type, position



SELECT gmax_calls.id as gmax_call_id,
starts.id as start_id,
horses.name,
races.id as race_id,
races.track_code,
races.date,
races.race_number,
gmax_calls.distance_feet,
position, gmax_calls.seconds, half_furlong_seconds, average_speed, stride_count, average_stride_length, average_strides_per_second,
interval_type
FROM races, starts, gmax_calls, horses
where
races.id = starts.race_id
and starts.horse_id = horses.id
and gmax_calls.start_id = starts.id
and races.track_code = 'SA'
and races.date = '2023-11-04'
and races.race_number = 11
order by race_number, start_id, distance_feet
limit 10

select * from gmax_calls limit 10;

select * from gmax_fractions
order by race_id, distance_feet
limit 20;

select * from gmax_fractions where race_id = 124041

select starts.id as start_id, races.id, races.date, races.track_code, races.race_number
from races, starts, horses
where races.id = starts.race_id
and starts.horse_id = horses.id
and horses.name = 'LEOPARDESS'
order by races.date desc;

select * from gmax_calls where start_id = 566042

select distinct race_id from gmax_fractions order by race_id desc
select * from gmax_fractions where race_id = 140682

select race_number, date, track_code, id from races order by date desc, race_number desc limit 10;

select gmax_fractions.id, distance_feet, interval_type, interval_type from gmax_fractions
where race_id in (
  select id from races where date = '2020-08-28' and race_number = 3 and track_code = 'DMR'
) order by distance_feet

select * from horses where name = 'GO TIME';

/* select calls for a race */
select gmax_calls.id, start_id, position, lengths_behind, seconds, horses.name, distance_feet, interval_type, interval_type, gmax_calls.updated_at from gmax_calls, starts, horses
where starts.id = gmax_calls.start_id
and horses.id = starts.horse_id
and start_id in (
  select id from starts where race_id in (
    select id from races where date = '2025-02-08' and race_number = 10 and track_code = 'SA'
  )
) order by distance_feet, position;

select * from gmax_calls limit 10;

select distinct races.date from races, starts, gmax_calls
where races.id = starts.race_id
and starts.id = gmax_calls.start_id
order by date desc

select * from gmax_fractions order by id desc limit 10;

select * from gmax_fractions where race_id = 124151;

select distinct races.date from races order by date desc limit 10;

select id, start_id, distance_feet, interval_type, position, seconds, lengths_behind, lengths_ahead
from gmax_calls where start_id = 491480

select * from gmax_calls limit 100;
select * from calls order by id desc limit 100;
select * from trakus_calls order by id desc limit 100;

select * from gmax_fractions limit 10;

select horses.name, starts.program_number, gmax_calls.* from horses, starts, gmax_calls
where horses.id = starts.horse_id
and starts.id = gmax_calls.start_id
and gmax_calls.start_id in (select id from starts where race_id = 115791)
order by start_id, distance_feet

delete from gmax_calls where start_id in (
  select id from starts where race_id = 115835
)

select count(*) from gmax_calls;

select horses.name, starts.program_number, trakus_calls.* from horses, starts, trakus_calls
where horses.id = starts.horse_id
and starts.id = trakus_calls.start_id
and trakus_calls.start_id in (select id from starts where race_id = 115835)
order by start_id, distance

select distinct interval_type from gmax_calls;
select distinct interval_type from tra bekkkus_calls;
