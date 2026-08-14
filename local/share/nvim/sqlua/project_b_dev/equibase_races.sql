select * from equibase_races
order by track_id, race_date desc, race_number
limit 100;

SELECT
  id,
  track_id,
  race_date,
  race_number,
  LEFT(race_type, 25) AS race_type,
  LEFT(breed, 25) AS breed,
  LEFT(program_description, 25) AS program_desc,
  LEFT(results_description, 25) AS results_desc,
  LEFT(distance, 25) AS distance,
  distance_furlongs,
  LEFT(surface, 25) AS surface,
  LEFT(track_condition, 25) AS track_condition,
  purse_cents,
  available_money_cents,
  LEFT(weather, 25) AS weather,
  off_time,
  LEFT(start_description, 25) AS start_description,
  LEFT(final_time, 25) AS final_time,
  run_up_feet,
  LEFT(footnotes, 25) AS footnotes,
  race_status_type,
  LEFT(race_name, 25) AS race_name,
  LEFT(race_class, 25) AS race_class,
  LEFT(sex_restriction, 25) AS sex_restriction,
  LEFT(age_restriction, 25) AS age_restriction,
  post_time,
  created_at,
  updated_at
FROM equibase_races;
ORDER BY track_id, race_date, race_number;

select program_description, results_description, track_condition from equibase_races
where id in (7, 200)

select * from equibase_calls;

select count(*) as race_count from races;
select count(*) as start_cont from starts;
select count(*) as workout_count from workouts;

select count(*) as equibase_race_count from equibase_races;
select count(*) as equibase_start_count from equibase_starts ;
-- select count(*) from equibase_workouts;

select count(*) as drf_race_count from drf_races;
select count(*) as drf_start_count from drf_starts;
select count(*) as drf_workout_count from drf_workouts;

select count(*) as twinspires_race_count from twinspires_races;
select count(*) as twinspires_start_count from twinspires_starts;
select count(*) as twinspires_workout_count from twinspires_workouts;

select count(*) as tm_race_count from thoroughmanager_races;
select count(*) as tm_start_count from thoroughmanager_starts;
select count(*) as tm_workout_count from thoroughmanager_workouts;

select distinct track_code from thoroughmanager_races;
select count(*) from thoroughmanager_workouts;
select track_code, count(track_code) as workout_count from thoroughmanager_workouts
group by track_code order by workout_count desc;


select * from twinspires_races;
