select * from trainers where name like '%BAFF%';
select * from start_trainer_overall_analysis_view where trainer_id = 173;

select * from start_trainer_traits where start_id = 627570;

select * from start_trainer_traits where trainer_id = 117
and code = 'Routes';

select * from start_trainer_overall_analysis limit 100;

-- trainers raw history:
select starts.id as start_id, starts.trainer_id, starts.is_scratched, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number from races, starts
where
starts.id in (
  select id from  starts where trainer_id in (
    select id from trainers where name = 'HARRIS ANDREW'
  )
)
and races.id = starts.race_id
order by date desc;


select * from trainers where id = 266;
select * from start_trainer_traits where trainer_id = 266;

-- trainer starts
select races.id, races.track_code, races.date, races.race_number, starts.id, starts.pp2_program_number, horses.name, calls.position from races, starts, horses, calls
where races.id = starts.race_id
and starts.horse_id = horses.id
and calls.start_id = starts.id
and races.track_code = 'SA'
and calls.call_code = 'finish_call'
and races.date < '2025-02-02'
and races.date > '2024-12-25'
and starts.trainer_id = 173
and calls.position > 0
order by date desc, race_number

-- trainer matching
select * from trainers where name = 'LEWIS CRAIG A'
select * from drf_debut_trainers where name = 'CRAIG LEWIS'
update drf_debut_trainers set trainer_id = 658 where id = 262;
