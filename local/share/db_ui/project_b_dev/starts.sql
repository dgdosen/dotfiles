-- starts for a race

select starts.id, horses.id as horse_id, starts.race_id, starts.version, horses.name, program_number, pp2_program_number from starts, horses

  where starts.horse_id = horses.id and race_id in (

  select id from races where date = '2023-11-04'  and race_number = 11
)

select count(id), version from starts
group by version

-- 1 horse 611859 BLUE DOG
select starts.id, horses.id as horse_id, horses.name, program_number, pp2_program_number from starts, horses
  where starts.horse_id = horses.id
  and starts.race_id = 152373
order by pp2_program_number;


-- churchill down starts?
select horses.name, starts.id, races.date, races.race_number from starts, horses, races
where races.id = starts.race_id
and horses.id = starts.horse_id
and races.track_code = 'CD'
order by races.date desc limit 10;



-- horses/start for race_id
select starts.race_id, starts.id, horses.id as horse_id, horses.name, program_number, post_position from starts, horses
  where starts.horse_id = horses.id
  and starts.race_id in (
    select id from races where date = '2024-10-26' and race_number = 5
  )
order by race_id, program_number;


/* horse history */
select starts.id as start_id, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number from races, starts
where
starts.id in (
  select id from  starts where horse_id in (
    select id from horses where name = 'DUVET DAN'
  )
)
and races.id = starts.race_id
order by date desc;

-- with a given date?
select starts.id as start_id, races.id as race_id, races.date, races.track_code, races.race_number from races, starts where races.id in (
  select race_id from starts where horse_id in (
    select horse_id from starts where race_id in (
      select id from races where date = '2020-12-27' and track_code = 'SA'
      ) and horse_id in (1
      select id from horses where name = 'CASH EQUITY'
    )
  )
  ) and starts.id in (
  select id from  starts where horse_id in (
    select id from horses where name = 'DARK HEDGES'
  )
)
and races.id = starts.race_id
order by date desc;

/* horses that were in a race wip */
select horses.id as horse_id, starts.id as start_id, horses.name,


-- start curves for start
select * from start_curves where start_id = 479862;

-- shippers: CD?
select starts.id, horses.name, races.id as race_id, races.date, races.race_number from starts, horses, races where
starts.race_id = races.id and starts.horse_id = horses.id
and races.track_code = 'CD' order by races.date desc
limit 20;

select created_at from tm_races order by id desc limit 10;


select races.date, races.track_code, races.race_number, starts.id, horses.name, starts.pp2_sex from 
races, starts, horses
where races.id = starts.race_id
and starts.horse_id = horses.id
and races.date = '2025-01-18'
order by race_number, starts.pp2_program_number
