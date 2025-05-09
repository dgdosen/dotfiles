
select * from trakus_calls limit 100;

select count(id), interval_type from trakus_calls
  where interval_type in ('interval_finish', 'interval_7x', 'interval_start', 'interval_stretch', 'interval_3x')
  group by interval_type
  order by interval_type;

select count(id), interval_type from trakus_fractions
group by interval_typej
order by interval_type;

select distinct count(id), distance, segment_distance from trakus_calls 
group by distance, segment_distance  order by distance;

-- all calls for a race...
select distance, interval_type, position, seconds, horses.name FROM trakus_calls, starts, horses
  where starts.horse_id = horses.id
    and starts.id = trakus_calls.start_id
    and start_id in (select id from starts where race_id in (
      select id from races where date = '2024-06-28' and race_number = 7 and track_code = 'CD'
)) order by distance, horses.name;

select * from trakus_calls where start_id = 494345 order by distance;

select id, interval_type, interval_type from trakus_fractions limit 10;
select id, interval_type, interval_type from trakus_calls limit 10;
select * from trakus_fractions limit 10;

select distinct interval_type from trakus_fractions order by interval_type;
select distinct interval_type, distance from trakus_calls order by distance;
select * from trakus_calls where interval_type = 'interval_11f'
select * from trakus_calls where start_id = 420854 order by distance;

select races.id, races.date, races.track_code, races.race_number, trakus_calls.distance, avg(off_rail) from starts, trakus_calls, races
where races.id = starts.race_id
and starts.id = trakus_calls.start_id
and races.id = 109791
and trakus_calls.off_rail > 0
group by races.id, trakus_calls.distance
order by races.date, races.track_code, races.race_number, trakus_calls.distance

select races.date, races.track_code, races.race_number, trakus_calls.distance, count(off_rail) from starts, trakus_calls, races
where races.id = starts.race_id
and starts.id = trakus_calls.start_id
and trakus_calls.off_rail > 0
and trakus_calls.off_rail = 1.6
and races.track_code in ('CD')
group by races.track_code, races.date, races.race_number, trakus_calls.distance
having count(off_rail) > 5
order by races.date, races.track_code, races.race_number, trakus_calls.distance

select races.date, races.track_code, races.race_number, trakus_calls.distance, count(off_rail) from starts, trakus_calls, races
where races.id = starts.race_id
and starts.id = trakus_calls.start_id
and trakus_calls.off_rail > 0
and trakus_calls.off_rail = 1.6
and races.track_code in ('CD')
and races.id = 123080
group by races.track_code, races.date, races.race_number, trakus_calls.distance
having count(off_rail) > 5
order by races.date, races.track_code, races.race_number, trakus_calls.distance

select races.date, races.track_code, races.race_number, trakus_calls.distance, count(start_id) as start_count
from starts, trakus_calls, races
where races.id = starts.race_id
and starts.id = trakus_calls.start_id
and trakus_calls.off_rail > 0
and trakus_calls.off_rail = 1.6
and races.track_code in ('CD')
and races.date > '2021-01-01'
and races.date < '2021-12-25'
group by races.track_code, races.date, races.race_number, trakus_calls.distance
having count(start_id) > 5
order by races.date, races.track_code, races.race_number, trakus_calls.distance

select * from trakus_calls where start_id = 471429 order by interval_type;
