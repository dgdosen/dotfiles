select * from equibase_races
order by track_id, race_date, race_number
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
