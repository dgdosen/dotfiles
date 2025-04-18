-- latest
select * from drf_starts order by updated_at desc
limit 100;

/* horse history */
-- select starts.id as start_id, starts.is_historical, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number from races, starts
select drf_starts.id as drf_start_id, drf_starts.is_historical, drf_races.id as drf_race_id, drf_races.date, drf_races.track_code, drf_races.distance_feet, drf_races.surface, drf_races.race_number
from drf_races, drf_starts
where
drf_starts.id in (
  select id from drf_starts where horse_id in (
    select id from horses where name = 'BROADWAY UNIONS'
  )
)
and drf_races.id = drf_starts.drf_race_id
order by date desc;

select * from drf_starts where horse_id = 90267;

select drf_starts.id, drf_starts.start_id, drf_starts.horse_id, drf_starts.is_historical, drf_races.date, drf_races.track_code, drf_races.race_number, drf_races.race_id
from drf_starts, drf_races
where drf_starts.drf_race_id = drf_races.id
and drf_starts.horse_id in (
  select id from horses where name = 'NAVY JACK'
)

-- fix in error is-historical
update drf_starts set is_historical = false
from starts
where drf_starts.start_id = starts.id
and starts.program_number = 'SCR'

-- best beyer
select * from drf_starts order by updated_at desc
limit 100;

select * from drf_starts order by id desc limit 1000;
