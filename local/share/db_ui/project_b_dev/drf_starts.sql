/* horse history */
-- select starts.id as start_id, starts.is_historical, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number from races, starts
select drf_starts.id as drf_start_id, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number from races, starts
where
starts.id in (
  select id from  starts where horse_id in (
    select id from horses where name = 'NAVY JACK'
  )
)
and races.id = starts.race_id
order by date desc;

select * from drf_starts where horse_id = 90267;

select drf_starts.id, drf_starts.start_id, drf_starts.is_historical, drf_races.date, drf_races.track_code, drf_races.race_number, drf_races.race_id
from drf_starts, drf_races
where drf_starts.drf_race_id = drf_races.id
and drf_starts.horse_id = 90267;

-- fix in error is-historical
update drf_starts set is_historical = false
from starts
where drf_starts.start_id = starts.id
and starts.program_number = 'SCR'

-- best beyer
select * from drf_starts order by updated_at desc
limit 100;
