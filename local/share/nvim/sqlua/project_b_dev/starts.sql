select * from starts order by id desc limit 11;
select * from starts where id = 629192;
select * from pp_starts;

-- starts for a race
select starts.id, horses.id as horse_id, horses.name, program_number, pp2_program_number from starts, horses
  where starts.horse_id = horses.id and race_id in (
  select id from races where date = '2025-02-15'  and race_number = 4
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

select distinct official_finish_position from starts;

-- horses/start for race_id
select starts.race_id, starts.*, horses.id as horse_id, horses.name, program_number, post_position from starts, horses
  where starts.horse_id = horses.id
  and starts.race_id in (
    select id from races
    where date = '2025-03-08'
    and race_number = 3
  )
order by race_id, program_number;

select starts.race_id, horses.id as horse_id, horses.name, program_number, post_position from starts, horses
  where starts.horse_id = horses.id
  and starts.race_id = 138925
order by race_id, program_number;

/* horse history */
-- select starts.id as start_id, starts.is_historical, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number from races, starts
select starts.id as start_id, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number, starts.pp3_post_position from races, starts
where
starts.id in (
  select id from  starts where horse_id in (
    select id from horses where name = 'SUMTER'
  )
)
and races.id = starts.race_id
order by date desc;

/* trainer history */
select starts.id as start_id, starts.is_scratched, races.id as race_id, races.date, races.track_code, races.distance, races.all_source_surface_code, races.race_number, calls.position, starts.created_at from races, starts, calls
where
starts.id in (
  select id from  starts where trainer_id in (
    select id from trainers where name = 'SPACE BLUES'
  )
)
and starts.id = calls.start_id
and calls.call_code = 'finish_call'
and races.id = starts.race_id
order by date desc;

-- for a given set of race_ids:
select starts.race_id, starts.id, horses.id as horse_id, horses.name, program_number, post_position, starts.official_finish_position, starts.is_scratched from starts, horses
  where starts.horse_id = horses.id
  and starts.race_id in (
    140681
  )
order by race_id, program_number;


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
order by race_number, starts.pp2_program_number;


-- paul query
SELECT horses.id AS horse_id, races.date, races.track_code, races.race_number, drf_calls.call_code, drf_calls.position
FROM horses
JOIN starts ON horses.id = starts.horse_id
JOIN races ON races.id = starts.race_id
LEFT JOIN drf_calls ON starts.id = drf_calls.start_id
WHERE horses.id in (
  SELECT id from horses WHERE name = 'LAULNE'
)
AND (drf_calls.call_code = 'finish_call' OR drf_calls.call_code IS NULL)
AND races.track_code <> 'CHT'
AND races.date < '2025-01-12'
ORDER BY races.date desc

ON races.id = starts.race_id) ON horses.id =starts.horse_id) LEFT JOIN drf_calls ON starts.id = drf_calls.start_id
WHERE (((horses.id)=87484) AND ((races.Date)<>#1/12/2025# And (races.Date)<>#1/19/2025#) AND ((races.track_code)<>"CHT") AND ((drf_calls.call_code)="finish_call"))
ORDER BY races.Date DESC;

select count(id), pp3_state_bred_flag from starts
group by pp3_state_bred_flag
order by pp3_state_bred_flag;

-- unique pp3_post_position
select count(id), pp3_post_position, program_number from starts
group by pp3_post_position, program_number
order by pp3_post_position;
