select * from interval_trip_notes order by id desc limit 500;

select * from interval_trip_notes where start_id = 573768;
select * from interval_trip_notes where start_id = 546015;
select * from interval_trip_notes where start_id = 546015 and trip_type = 'egps_trip';
select * from interval_trip_notes where trip_type = 'project_b_trip' limit 10;

select count(id), trip_type from interval_trip_notes group by trip_type;

select * from interval_trip_notes where start_id = 543323 order by trip_type, id;
delete from itnerval_
-- select * from egps_calls where start_id = 543323;

select count(id), trip_type, interval_type from interval_trip_notes where start_id in (
  select id from starts where race_id in
  (
    select id from races where track_code = 'SA' and distance = 1760
  )
)
group by trip_type, interval_type
order by trip_type, interval_type
limit 100

select count(id), interval_type from interval_trip_notes
where trip_type = 2
group by interval_type

/* TODO: run this on server */
update interval_trip_notes set interval_type = 'interval_stretch_temp'
where start_id in (
  select id from starts where race_id = 116235
)
and interval_type = 'interval_stretch'

update interval_trip_notes set interval_type = 'interval_stretch', interval_type = 8
where start_id in (
  select id from starts where race_id = 116235
)
and trip_type = 1
and interval_type = 'interval_3x'

update interval_trip_notes set interval_type = 'interval_3x', interval_type = 13
where start_id in (
  select id from starts where race_id = 116235
)
and trip_type = 1
and interval_type = 'interval_5x'


update interval_trip_notes set interval_type = 'interval_5x', interval_type = 15
where start_id in (
  select id from starts where race_id = 116235
)
and trip_type = 1
and interval_type = 'interval_6x'


update interval_trip_notes set interval_type = 'interval_6x', interval_type = 16
where start_id in (
  select id from starts where race_id = 116235
)
and trip_type = 1
and interval_type = 'interval_stretch_temp'

select starts.id, interval_trip_notes.id, races.track_code, races.date, races.race_number,
starts.program_number, horses.name, interval_trip_notes.interval_type,
interval_trip_notes.adjustment,
interval_trip_notes.comment
from races, starts, horses, interval_trip_notes
where races.id = starts.race_id
and horses.id = starts.horse_id
and interval_trip_notes.start_id = starts.id
and races.date > '2021-05-15'
and interval_trip_notes.trip_type = 1
and interval_trip_notes.comment is not null
order by races.date, races.race_number, starts.program_number, interval_trip_notes.id
